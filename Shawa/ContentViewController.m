//
//  ContentViewController.m
//  Shawa
//
//  Created by SukWon Choi on 13. 7. 1..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "ContentViewController.h"
#import "AppDelegate.h"
#import "Individual.h"
#import "NSDictionary+JSONCategories.h"

@interface ContentViewController (){
    UIScrollView * timeTable;
    BOOL isGroup;
}

@end

@implementation ContentViewController

@synthesize selectedFriendsList;
@synthesize groupType;
@synthesize navItem, navTitle, navBar;
@synthesize profileImageView, titleLabel;

- (void)sendDataToServer{
    if([groupType integerValue] != 2){
        return;
    }
    NSString * individualDic = (NSString *)[Individual getNSDictionaryFromIndividual:[self.selectedFriendsList objectAtIndex:0]];
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:individualDic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@individual/%d", WEB_BASE_URL, [AppDelegate getMyIndividualId]]];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15 ];
    
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPBody:jsonData];
    
    NSURLConnection * connection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
    [connection start];
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECLeft];
}

- (IBAction)addButtonClicked:(id)sender{
    if([groupType integerValue] == MYSELF){
        [self performSegueWithIdentifier:@"Add New Course" sender:self];
    }else{
    }
}

- (IBAction)longTouchDetected:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
    }
    else if (sender.state == UIGestureRecognizerStateBegan){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"시간표를 앨범에 저장합니다" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
        [alert show];
    }
}

- (IBAction)tapTouchDetected:(UITapGestureRecognizer *)sender{
    NSLog(@"tapTouchDetected");
    [self addButtonClicked:nil];
}

- (void)saveTimeTableAsImage{
    UIImage* image = nil;
    
    UIGraphicsBeginImageContext(timeTable.contentSize);
    {
        CGPoint savedContentOffset = timeTable.contentOffset;
        CGRect savedFrame = timeTable.frame;
        
        timeTable.contentOffset = CGPointZero;
        timeTable.frame = CGRectMake(0, 0, timeTable.contentSize.width, timeTable.contentSize.height);
        
        [timeTable.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        timeTable.contentOffset = savedContentOffset;
        timeTable.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRGBHex:0x1dd69d];
    [self setNeedsStatusBarAppearanceUpdate];
    
    // has more than one individual
    isGroup = [self.selectedFriendsList count] > 1;

    // Navigation Bar
    
    // Set Profile Image View
    profileImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder"]];
    profileImageView.autoresizingMask = UIViewAutoresizingNone;
    profileImageView.frame = CGRectMake(100, 5, 33, 33);
    [self.navBar addSubview:profileImageView];
    
    // Set Title Label
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 0, 100, 44)];
    titleLabel.autoresizingMask = UIViewContentModeRight;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:21];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"최 석원";
    [self.navBar addSubview:titleLabel];
    
    //Set sideMenuButton
    UIButton *sideMenuView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 18)];
    [sideMenuView addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    [sideMenuView setBackgroundImage:[UIImage imageNamed:@"icon_list"] forState:UIControlStateNormal];
    UIBarButtonItem * sideMenuButton = [[UIBarButtonItem alloc] initWithCustomView:sideMenuView];
    [self.navigationItem setRightBarButtonItem:sideMenuButton];
    
    self.navItem.rightBarButtonItem = sideMenuButton;
    [self.navBar setBarTintColor:[UIColor colorWithRGBHex:0x1dd69d]];
    
    // Setting ScrollView
    timeTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.navBar.frame.size.height + self.navBar.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    timeTable.bounces = NO;
    timeTable.contentSize = CGSizeMake(320, 503.5);
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTouchDetected:)];
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTouchDetected:)];
    
    [timeTable addGestureRecognizer:tapGestureRecognizer];
    [timeTable addGestureRecognizer:longPressGestureRecognizer];
    timeTable.userInteractionEnabled = YES;

    // Setting Background
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timetable_bg.png"]	];
    imageView.tag = 111;
    imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y,
                                 320, 503.5);
    
    [timeTable addSubview:imageView];
    [self.view addSubview:timeTable];
    
    // Initialized selectedFriendsList as MYSELF
    
    if(self.selectedFriendsList == nil && [AppDelegate getMyIndividualId] != -1){

        Individual * individual = [Individual getIndividualFromServer:[AppDelegate getMyIndividualId]];
        self.selectedFriendsList = [NSArray arrayWithObject:individual];
        navTitle = individual.userName;
        self.groupType = [NSNumber numberWithInt:MYSELF];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;

    if(![self.slidingViewController.underRightViewController isKindOfClass:[MenuViewController class]]){
        self.slidingViewController.underRightViewController = (MenuViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    self.titleLabel.text = navTitle;
    for (id view in [timeTable subviews]){
        if([view tag] != 111){
            [view removeFromSuperview];
        }
    }
    
    [self showTimeTable];
}


// UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        // Cancel save
        return;
    }else if(buttonIndex==1){
        // Confirm save
        [self saveTimeTableAsImage];
    }else{
        
    }
}

// Making TimeTable View

- (void)showTimeTable{
    for(Individual * individual in selectedFriendsList){
        for(int i=0; i<[individual.courses count]; i++){
            Course * course = [[individual courses] objectAtIndex:i];
            [self showLectures:course];
        }
    }
}

- (void)showLectures:(Course *)course{
    UIColor * lectureColor = [COLOR objectAtIndex:arc4random()%5];
    for(int i=0; i<[course.lectures count]; i++){
        Lecture * lecture = [course.lectures objectAtIndex:i];
        
        if(lecture.day == SUN) continue;
        
        // Setting lectureView
        CGPoint point = [self pointMakeDay:lecture.day period:lecture.period];
        
        UIView * lectureView = [[UIView alloc] init];
        [lectureView setBackgroundColor:lectureColor];
        [lectureView setFrame:CGRectMake(point.x, point.y, 47.5, 42.5*lecture.duration)];
        
        // Setting lectureImageView
        UIImageView * lectureImageView = [[UIImageView alloc] init];
        [lectureImageView setFrame:CGRectMake(0, 5, 47.5, 42.5*lecture.duration - 5)];
        [lectureImageView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
        
        // Setting lectureName Label
        CGRect rec = CGRectMake(5, -5, 37.5, 42.5*lecture.duration);
        
        UILabel * lectureName = [[UILabel alloc] init];
        [lectureName setFrame:rec];
        lectureName.text = course.courseName;
        lectureName.font = [UIFont fontWithName:@"Helvetica Neue" size:8.0f];
        [lectureName setTextColor:[UIColor blackColor]];
        [lectureName setTextAlignment:NSTextAlignmentCenter];
        [lectureName setBackgroundColor:[UIColor clearColor]];
        [lectureName setNumberOfLines:2];
        [lectureName setLineBreakMode:NSLineBreakByWordWrapping];
        
        // Setting location Label
        UILabel * location = [[UILabel alloc] init];
        [location setFrame:CGRectMake(5, 10, 37.5, 42.5*lecture.duration)];
        location.text = lecture.location;
        location.font = [UIFont fontWithName:@"Helvetica Neue" size:8.0f];
        [location setTextColor:[UIColor blackColor]];
        [location setTextAlignment:NSTextAlignmentCenter];
        [location setBackgroundColor:[UIColor clearColor]];
        [location setNumberOfLines:2];
        [location setLineBreakMode:NSLineBreakByWordWrapping];
        
        [lectureView addSubview:lectureImageView];
        [lectureView addSubview:lectureName];
        [lectureView addSubview:location];
        [timeTable addSubview:lectureView];
        
        //Adding buttons to lectureView
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        if([groupType integerValue] == MYSELF){
            [button setFrame:lectureView.frame];
            button.tag =[[[selectedFriendsList objectAtIndex:0] courses] indexOfObject:course];
            [button addTarget:self action:@selector(changeCourse:) forControlEvents:UIControlEventTouchUpInside];
            [timeTable addSubview:button];
        }
        
        // if it has more than one individual
        if(isGroup){
            [lectureView setBackgroundColor:[UIColor clearColor]];
            [lectureImageView setFrame:CGRectMake(0, 0, 47.5, 42.5*lecture.duration)];
            [lectureImageView setBackgroundColor:[UIColor grayColor]];
            lectureImageView.alpha = 0.9;
            lectureName.text = @"";
            location.text = @"";
        }
    }
}

-(CGPoint)pointMakeDay:(int)day period:(double)pr{
    double x, y;
    x = 32+(47.5)*(day-1);
    y = 27+42.5*(pr-1) + 2;
    return CGPointMake(x, y);
}

//Timetable Clicked
- (void)changeCourse:(id)sender{
    self.view.tag = [sender tag];
    [self performSegueWithIdentifier:@"Edit Existing Course" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    AddCourseViewController * addCourseViewController = [segue destinationViewController];
    addCourseViewController.delegate = self;
    if([segue.identifier isEqualToString:@"Add New Course"]){
        addCourseViewController.course = nil;
        addCourseViewController.isNewCourse = YES;
        
    }else{
        int courseIndex = [[sender view] tag];
        Course * course = [[[selectedFriendsList objectAtIndex:0] courses] objectAtIndex:courseIndex];
        addCourseViewController.course = course;
        addCourseViewController.isNewCourse = NO;
    }
}

#pragma AddcourseViewDelegate 
- (void)addNewCourse:(Course *)course{
    [[[self.selectedFriendsList objectAtIndex:0] courses] addObject:course];
    [self sendDataToServer];
}
- (void)updateCourse:(Course *)course{
    [self sendDataToServer];
}
- (void)deleteCourse:(Course *)course{
    [[[self.selectedFriendsList objectAtIndex:0] courses] removeObject:course];
    [self sendDataToServer];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
