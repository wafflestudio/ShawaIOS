//
//  AddCourseViewController.h
//  Shawa
//
//  Created by SukWon Choi on 13. 7. 8..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@protocol AddCourseViewDelegate <NSObject>

-(void)courseChanged;

@end

@interface AddCourseViewController : UIViewController

// Delegate
@property (nonatomic, weak) id <AddCourseViewDelegate> delegate;

// Data source
@property (nonatomic, strong) Course * course;

//BarButton
@property (nonatomic, strong) IBOutlet UIBarButtonItem * saveBarButtonItem;
@property (nonatomic, strong) IBOutlet UIBarButtonItem * cancelBarButtonItem;

//WeekButton
@property (nonatomic, strong) IBOutlet UIButton * monButton;
@property (nonatomic, strong) IBOutlet UIButton * tueButton;
@property (nonatomic, strong) IBOutlet UIButton * wedButton;
@property (nonatomic, strong) IBOutlet UIButton * thuButton;
@property (nonatomic, strong) IBOutlet UIButton * friButton;
@property (nonatomic, strong) IBOutlet UIButton * satButton;
@property (nonatomic, strong) IBOutlet UIButton * sunButton;

//UIPicker Button
@property (nonatomic, strong) IBOutlet UIButton *startTimeButton;
@property (nonatomic, strong) IBOutlet UIButton *endTimeButton;

//TextField
@property (nonatomic, strong) IBOutlet UITextField * courseNameTextField;
@property (nonatomic, strong) IBOutlet UITextField * locationTextField;

- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)saveButtonClicked:(id)sender;

@end
