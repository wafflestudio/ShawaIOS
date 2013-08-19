//
//  MenuViewController.m
//  Shawa
//
//  Created by SukWon Choi on 13. 7. 1..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "MenuViewController.h"
#import "ContentViewController.h"
#import "AppDelegate.h"
#import "Individual.h"

#import "NSDictionary+JSONCategories.h"


@interface MenuViewController (){
    NSArray * friendsList;
}

@end

@implementation MenuViewController

@synthesize friendsListTableView;


/*
- (void)saveData{
    Course * course1 = [[Course alloc] initWithCourseName:@"시스템프로그래밍"];
    [course1 addNewLecture:MON period:1 duration:1.5];
    [course1 addNewLecture:WED period:1 duration:1.5];
    
    Course * course2 = [[Course alloc] initWithCourseName:@"산업조직론"];
    [course2 addNewLecture:TUE period:1 duration:1.5];
    [course2 addNewLecture:THU period:1 duration:1.5];
    
    Course * course3 = [[Course alloc] initWithCourseName:@"논리설계실험"];
    [course3 addNewLecture:MON period:11 duration:3];
    [course3 addNewLecture:WED period:11 duration:3];
    
    Course * course4 = [[Course alloc] initWithCourseName:@"논리설계"];
    [course4 addNewLecture:TUE period:3 duration:1.5];
    [course4 addNewLecture:THU period:3 duration:1.5];
    
    Course * course5 = [[Course alloc] initWithCourseName:@"게임이론 및 정치"];
    [course5 addNewLecture:TUE period:7.5  duration:1.5];
    [course5 addNewLecture:THU period:7.5 duration:1.5];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Individual" inManagedObjectContext:self.managedObjectContext];
    
    Group * group1 = [NSEntityDescription insertNewObjectForEntityForName:@"Group" inManagedObjectContext:self.managedObjectContext];
    Individual * individual1 = [[Individual alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
    individual1.userName = @"최 석원";
    individual1.courses = [NSArray arrayWithObjects:course1, course2, course3, course4, course5, nil];
    [group1 addIndividuals_in_group:[NSSet setWithObject:individual1]];
    group1.groupName = individual1.userName;
    group1.groupType = [NSNumber numberWithInt:MYSELF];
    
    Group * group2 = [NSEntityDescription insertNewObjectForEntityForName:@"Group" inManagedObjectContext:self.managedObjectContext];
    Individual * individual2 = [[Individual alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
    individual2.userName = @"김 택민";
    individual2.courses = [NSArray arrayWithObjects:course1, course2, course3, course4, nil];
    [group2 addIndividuals_in_group:[NSSet setWithObject:individual2]];
    group2.groupName = individual2.userName;
    group2.groupType = [NSNumber numberWithInt:FAVORITE];
    
    Group * group3 = [NSEntityDescription insertNewObjectForEntityForName:@"Group" inManagedObjectContext:self.managedObjectContext];
    Individual * individual3 = [[Individual alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
    individual3.userName = @"전 재호";
    individual3.courses = [NSArray arrayWithObjects:course1, course2, course3, nil];
    [group3 addIndividuals_in_group:[NSSet setWithObject:individual3]];
    group3.groupName = individual3.userName;
    group3.groupType = [NSNumber numberWithInt:FAVORITE];
    
    Group * group4 = [NSEntityDescription insertNewObjectForEntityForName:@"Group" inManagedObjectContext:self.managedObjectContext];
    Individual * individual4 = [[Individual alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
    individual4.userName = @"김 진억";
    individual4.courses = [NSArray arrayWithObjects:course1, course2, nil];
    [group4 addIndividuals_in_group:[NSSet setWithObject:individual4]];
    group4.groupName = individual4.userName;
    group4.groupType = [NSNumber numberWithInt:OTHERS];
    
    Group * group5 = [NSEntityDescription insertNewObjectForEntityForName:@"Group" inManagedObjectContext:self.managedObjectContext];
    Individual * individual5 = [[Individual alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
    individual5.userName = @"정 현호";
    individual5.courses = [NSArray arrayWithObjects:course1, nil];
    [group5 addIndividuals_in_group:[NSSet setWithObject:individual5]];
    group5.groupName = individual5.userName;
    group5.groupType = [NSNumber numberWithInt:OTHERS];
    
    [self.managedObjectContext save:nil];  // write to database
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // friendsListTableView Delegate 설정
    friendsListTableView.delegate = self;
    friendsListTableView.dataSource = self;
    
    // slidingView Anchor 설정
    [self.slidingViewController setAnchorLeftRevealAmount:280.0f];
    self.slidingViewController.underRightWidthLayout = ECFullWidth;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

#pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"서버";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
     }
    cell.textLabel.text = @"서버";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ContentViewController * newContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Content"];
    
    Group * group = [Group new];
    
    newContentViewController.selectedFriendsList = [group.individuals copy];
    
    newContentViewController.navTitle = group.groupName;
    newContentViewController.groupType = group.groupType;
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECLeft animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newContentViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}   

#pragma mark - Table View Delegate End.

#pragma mark - AddCourseViewController Delegate Start
- (void)courseChanged{
    
}
#pragma mark - AddCourseViewController Delegate End.
@end
