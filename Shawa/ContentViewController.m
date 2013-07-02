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

@synthesize selectedFriendsList;

-(CGPoint)pointMakeDay:(int)day period:(double)pr{
    double x, y;
    x = 25+59*(day-1);
    y = 20+45*(pr-1);
    return CGPointMake(x, y);
}

- (void)showLecture:(Lecture *)lecture courseName:(NSString *)courseName{
    UIView * lectureView = [[UIView alloc] init];
    UIImageView * lectureImageView = [[UIImageView alloc] init];
    UILabel * lectureName = [[UILabel alloc] init];
    
    CGPoint point = [self pointMakeDay:lecture.day period:lecture.period];
    
    [lectureView setFrame:CGRectMake(point.x, point.y, 59, 45*lecture.duration)];
    [lectureImageView setFrame:CGRectMake(1, 1, 59, 45*lecture.duration)];
    [lectureImageView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:0.7 alpha:1]];
    
    CGRect rec = CGRectMake(0, 0, 59, 45*lecture.duration);
    [lectureName setFrame:rec];
    lectureName.text = courseName;
    lectureName.font = [UIFont boldSystemFontOfSize:8.0f];
    [lectureName setTextColor:[UIColor blackColor]];
    [lectureName setTextAlignment:NSTextAlignmentCenter];
    [lectureName setBackgroundColor:[UIColor clearColor]];
    
    [lectureView addSubview:lectureImageView];
    [lectureView addSubview:lectureName];
    [timeTable addSubview:lectureView];
}

- (void)showTimeTable{
    Individual * individual = [selectedFriendsList objectAtIndex:0];
    
    for(int i=0; i<[individual.courses count]; i++){
        Course * course = [[individual courses] objectAtIndex:i];
        
        for(int j=0; j<[[course lectures] count]; j++){
            [self showLecture:[course.lectures objectAtIndex:j] courseName:[course courseName]];
        }
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    timeTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 484)];
    timeTable.bounces = NO;
    timeTable.contentSize = CGSizeMake(320, 605);
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timetable_bg.png"]];
    
    [timeTable addSubview:imageView];
    [self.view addSubview:timeTable];

}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if(![self.slidingViewController.underRightViewController isKindOfClass:[MenuViewController class]]){
        self.slidingViewController.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    [self showTimeTable];
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECLeft];
}

@end
