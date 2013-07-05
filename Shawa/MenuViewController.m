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

@interface MenuViewController (){
    NSArray * friendsList;
}
@end

@implementation MenuViewController

@synthesize friendsListTableView;

- (void)setupFetchedResultsController
{
    NSString *entityName = @"Individual"; // Put your entity name here
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    // - Filter it if you want
    //request.predicate = [NSPredicate predicateWithFormat:@"Role.name = Blah"];
    
    NSSortDescriptor * userNameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"userName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    NSSortDescriptor * userTypeDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"userType" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    
    
    request.sortDescriptors = [NSArray arrayWithObjects:userTypeDescriptor, userNameDescriptor, nil];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"userType" cacheName:nil];
    
    [self.fetchedResultsController performFetch:nil];
    [self.friendsListTableView reloadData];
}

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
    
    Individual * individual1 = [NSEntityDescription insertNewObjectForEntityForName:@"Individual" inManagedObjectContext:self.managedObjectContext];
    individual1.userName = @"최 석원";
    individual1.userType = [NSNumber numberWithInt:MYSELF];
    individual1.courses = [NSArray arrayWithObjects:course1, course2, course3, course4, course5, nil];
    
    Individual * individual2 = [NSEntityDescription insertNewObjectForEntityForName:@"Individual" inManagedObjectContext:self.managedObjectContext];
    individual2.userName = @"김 택민";
    individual2.userType = [NSNumber numberWithInt:FAVORITE];
    individual2.courses = [NSArray arrayWithObjects:course1, course2, course3, course4, nil];
    
    Individual * individual3 = [NSEntityDescription insertNewObjectForEntityForName:@"Individual" inManagedObjectContext:self.managedObjectContext];
    individual3.userName = @"전 재호";
    individual3.userType = [NSNumber numberWithInt:FAVORITE];
    individual3.courses = [NSArray arrayWithObjects:course1, course2, course3, nil];
    
    Individual * individual4 = [NSEntityDescription insertNewObjectForEntityForName:@"Individual" inManagedObjectContext:self.managedObjectContext];
    individual4.userName = @"김 진억";
    individual4.userType = [NSNumber numberWithInt:OTHERS];
    individual4.courses = [NSArray arrayWithObjects:course1, course2, nil];
    
    Individual * individual5 = [NSEntityDescription insertNewObjectForEntityForName:@"Individual" inManagedObjectContext:self.managedObjectContext];
    individual5.userName = @"정 현호";
    individual5.userType = [NSNumber numberWithInt:OTHERS];
    individual5.courses = [NSArray arrayWithObjects:course1, nil];
    
    [self.managedObjectContext save:nil];  // write to database
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // friendsListTableView Delegate 설정
    friendsListTableView.delegate = self;
    friendsListTableView.dataSource = self;
    
    // slidingView Anchor 설정
    [self.slidingViewController setAnchorLeftRevealAmount:280.0f];
    self.slidingViewController.underRightWidthLayout = ECFullWidth;
    
    // managedobjectContext 초기화
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    NSLog(@"%@", delegate.managedObjectContext);
    self.managedObjectContext = delegate.managedObjectContext;
    
    
//    [self saveData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self setupFetchedResultsController];
}

#pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return [[self.fetchedResultsController sections] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == MYSELF){
        return nil;
    }else if(section == FAVORITE){
        return @"즐겨찾기";
    }else if(section == OTHERS){
        return @"친구";
    }
    else return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
     }
    Individual * individual = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = individual.userName;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ContentViewController * newContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Content"];
 
    Individual * individual = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    newContentViewController.selectedFriendsList = [NSArray arrayWithObject:individual];
                             
    [self.slidingViewController anchorTopViewOffScreenTo:ECLeft animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newContentViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}   

#pragma mark - Table View Delegate End.

@end
