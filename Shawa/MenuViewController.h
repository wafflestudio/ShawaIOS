//
//  MenuViewController.h
//  Shawa
//
//  Created by SukWon Choi on 13. 7. 1..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "AddCourseViewController.h"

#import "ECSlidingViewController.h"

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>


// IBOutlets
@property (nonatomic, strong) IBOutlet UITableView * friendsListTableView;
@property (nonatomic, strong) IBOutlet UISearchBar * searchBar;

// MyselfView
@property (nonatomic, strong) IBOutlet UIView * mySelfView;
@property (nonatomic, strong) IBOutlet UIButton * checkButton;
@property (nonatomic, strong) IBOutlet UILabel * userName;

// Data
@property (nonatomic, strong) NSMutableArray * arrayWithFavorite;
@property (nonatomic, strong) NSMutableArray * arrayWithFriends;
@property (nonatomic, strong) NSMutableArray * arrayWithMyself;

@end
