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
}

@end

@implementation ContentViewController

@synthesize selectedFriendsList, navItem;
@synthesize navTitle;
@synthesize groupType;

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
    
    [self performSegueWithIdentifier:@"Add New Course" sender:self];
}

- (IBAction)longTouchDetected:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
    }
    else if (sender.state == UIGestureRecognizerStateBegan){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"시간표를 앨범에 저장합니다" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
        [alert show];
    }
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
    
    // Setting ScrollView
    timeTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44)];
    timeTable.bounces = NO;
    timeTable.contentSize = CGSizeMake(320, 605);
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timetable_bg.png"]];
    imageView.tag = 111;
    
    [timeTable addSubview:imageView];
    [self.view addSubview:timeTable];
    
    // Initialized selectedFriendsList as MYSELF
    if(self.selectedFriendsList == nil && [AppDelegate getMyIndividualId] != -1){

        Individual * individual = [Individual getIndividualFromServer:[AppDelegate getMyIndividualId]];
        self.selectedFriendsList = [NSArray arrayWithObject:individual];
        self.navTitle = individual.userName;
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
    
    self.navItem.title = navTitle;
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
    Individual * individual = [selectedFriendsList objectAtIndex:0];
    for(int i=0; i<[individual.courses count]; i++){
        Course * course = [[individual courses] objectAtIndex:i];
        [self showLectures:course];
    }
}

- (void)showLectures:(Course *)course{
    for(int i=0; i<[course.lectures count]; i++){
        Lecture * lecture = [course.lectures objectAtIndex:i];
        
        UIView * lectureView = [[UIView alloc] init];
        UIImageView * lectureImageView = [[UIImageView alloc] init];
        UILabel * lectureName = [[UILabel alloc] init];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGPoint point = [self pointMakeDay:lecture.day period:lecture.period];
        
        [lectureView setFrame:CGRectMake(point.x, point.y, 59, 45*lecture.duration)];
        [lectureImageView setFrame:CGRectMake(1, 1, 59, 45*lecture.duration)];
        [lectureImageView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:0.7 alpha:1]];
        
        CGRect rec = CGRectMake(0, 0, 59, 45*lecture.duration);
        [lectureName setFrame:rec];
        lectureName.text = course.courseName;
        lectureName.font = [UIFont boldSystemFontOfSize:8.0f];
        [lectureName setTextColor:[UIColor blackColor]];
        [lectureName setTextAlignment:NSTextAlignmentCenter];
        [lectureName setBackgroundColor:[UIColor clearColor]];
        
        [lectureView addSubview:lectureImageView];
        [lectureView addSubview:lectureName];
        [timeTable addSubview:lectureView];
        
        //Adding buttons to lectureView
        if([groupType integerValue] == MYSELF){
            [button setFrame:lectureView.frame];
            button.tag =[[[selectedFriendsList objectAtIndex:0] courses] indexOfObject:course];
            [button addTarget:self action:@selector(changeCourse:) forControlEvents:UIControlEventTouchUpInside];
            [timeTable addSubview:button];
            self.navItem.rightBarButtonItem.enabled = YES;
        }else{
            self.navItem.rightBarButtonItem.enabled = NO;
        }
    }
}

-(CGPoint)pointMakeDay:(int)day period:(double)pr{
    double x, y;
    x = 25+59*(day-1);
    y = 20+45*(pr-1);
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

@end
