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

@interface ContentViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *selectedFriendsList;
@property (nonatomic) BOOL favorite;

@property (nonatomic, strong) IBOutlet UINavigationItem * navItem;
@property (nonatomic, strong) NSString * navTitle;

- (void)showTimeTable;
- (IBAction)revealMenu:(id)sender;
- (IBAction)saveButtonClicked:(id)sender;
@end
