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

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView * friendsListTableView;
@property (nonatomic, strong) IBOutlet UISearchBar * searchBar;

// Data
@property (nonatomic, strong) NSArray * arrayWithHashData;

@end
