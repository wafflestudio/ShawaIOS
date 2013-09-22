//
//  ContentViewController.h
//  Shawa
//
//  Created by SukWon Choi on 13. 7. 1..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "AppDelegate.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"

@interface ContentViewController : UIViewController <UIAlertViewDelegate, AddCourseViewDelegate>

@property (nonatomic, strong) NSArray *selectedFriendsList;
@property (nonatomic) NSNumber * groupType;

@property (nonatomic, strong) IBOutlet UIBarButtonItem * rightBarButtonItem;

@property (nonatomic, strong) IBOutlet UIButton * settingButton;

@property (nonatomic, strong) NSString * barTitle;
@property (nonatomic, strong) IBOutlet UILabel * titleLabel;
@property (nonatomic, strong) IBOutlet UIImageView * profileImageView;


- (void)showTimeTable;
- (void)sendDataToServer;
- (IBAction)revealMenu:(id)sender;
- (IBAction)addButtonClicked:(id)sender;
- (IBAction)settingButtonClicked:(id)sender;
- (IBAction)longTouchDetected:(UILongPressGestureRecognizer *)sender;
- (IBAction)tapTouchDetected:(UITapGestureRecognizer *)sender;
@end
