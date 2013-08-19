//
//  AddCourseViewController.m
//  Shawa
//
//  Created by SukWon Choi on 13. 7. 8..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "AddCourseViewController.h"

@interface AddCourseViewController ()

@end

@implementation AddCourseViewController

@synthesize delegate;
@synthesize saveBarButtonItem, cancelBarButtonItem;
@synthesize monButton, tueButton, wedButton, thuButton, friButton, satButton, sunButton;
@synthesize startTimeButton, endTimeButton;
@synthesize courseNameTextField, locationTextField;
@synthesize course;

- (IBAction)cancelButtonClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)saveButtonClicked:(id)sender{
    [self.delegate courseChanged];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end