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

@interface ContentViewController (){
    UIScrollView * timeTable;
}

@end

@implementation ContentViewController

@synthesize selectedFriendsList, navItem;
@synthesize navTitle;
@synthesize groupType;

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECLeft];
}

- (IBAction)saveButtonClicked:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"시간표를 앨범에 저장합니다" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
    [alert show];
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
    
    [timeTable addSubview:imageView];
    [self.view addSubview:timeTable];
    
    // Initialized selectedFriendsList as MYSELF
    if(self.selectedFriendsList == nil){
        
        AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
        
        NSString *entityName = @"Group";
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
//        request.predicate = [NSPredicate predicateWithFormat:@"groupType == %@",[NSNumber numberWithInt:MYSELF]];

        NSSortDescriptor * userTypeDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"groupType" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
                
        request.sortDescriptors = [NSArray arrayWithObjects:userTypeDescriptor, nil];
        
        NSFetchedResultsController * fetchedResultsController;
        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:delegate.managedObjectContext sectionNameKeyPath:@"groupType" cacheName:nil];
        
        [fetchedResultsController performFetch:nil];
        
        if([[fetchedResultsController fetchedObjects] count] != 0){
            Group * group = [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            self.selectedFriendsList = [group.individuals_in_group allObjects];
            self.navTitle = group.groupName;
        }
         
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
    NSLog(@"changeCourse");
}


@end
