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
#import "CustomSearchBar.h"
#import "CustomCell.h"


#import "AddCourseViewController.h"

#import "ECSlidingViewController.h"

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate, CustomSearchBarDelegate, CustomCellDelegate>


// IBOutlets
@property (nonatomic, strong) IBOutlet UITableView * friendsListTableView;
@property (nonatomic, strong) IBOutlet CustomSearchBar * searchBar;

// Data
@property (nonatomic, strong) NSMutableArray * arrayWithFavorite;
@property (nonatomic, strong) NSMutableArray * arrayWithFriends;
@property (nonatomic, strong) NSMutableArray * arrayWithMyself;

@property (nonatomic, strong) NSMutableArray * arrayWithSelectedIndividualIds;

@end
