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
#import "SBJson.h"

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, AddCourseViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView * friendsListTableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
