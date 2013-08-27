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
#import "CustomCell.h"

#import "NSDictionary+JSONCategories.h"


@interface MenuViewController (){
    NSArray * friendsList;
}

@end

@implementation MenuViewController

@synthesize friendsListTableView, searchBar;
@synthesize arrayWithFavorite, arrayWithFriends, arrayWithMyself;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRGBHex:0x6a6a6a]];
    
    // initialize arrays
    arrayWithMyself = [[NSMutableArray alloc] init];
    arrayWithFavorite = [[NSMutableArray alloc] init];
    arrayWithFriends = [[NSMutableArray alloc] init];
    
    // friendsListTableView Delegate 설정
    friendsListTableView.delegate = self;
    friendsListTableView.dataSource = self;
    
    friendsListTableView.backgroundColor = [UIColor colorWithRGBHex:0xcfcfcf];
    
    // searchBar 설정
    searchBar.backgroundImage = [UIColor image1x1WithColor:[UIColor colorWithRGBHex:0x6a6a6a]];
    
    // slidingView Anchor 설정
    [self.slidingViewController setAnchorLeftRevealAmount:280.0f];
    self.slidingViewController.underRightWidthLayout = ECFullWidth;
    
    NSArray * arrayWithHashData = [self getHashDataFromServer];
    [self parseHashData:arrayWithHashData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (NSArray *)getHashDataFromServer{
    NSString * uuid = [AppDelegate getUuidString];
    NSString * JSONURLString = [NSString stringWithFormat:@"%@user/%@", WEB_BASE_URL, uuid];
    
    NSArray *jsonArray = (NSArray *)[NSDictionary dictionaryWithContentsOfJSONURLString:JSONURLString];
    
    if([jsonArray count] != 0){
        NSDictionary * jsonDic = [jsonArray objectAtIndex:0];
        return [jsonDic objectForKey:@"groups"];
    }else{
        return nil;
    }
}

- (void)parseHashData:(NSArray *)hashData{
    for(NSDictionary * groupDic in hashData){
        if([[groupDic objectForKey:@"groupType"] integerValue] == 2){
            [arrayWithMyself addObject:groupDic];
        }else if([[groupDic objectForKey:@"groupType"] integerValue] == 1){
            [arrayWithFavorite addObject:groupDic];
        }else{
            [arrayWithFriends addObject:groupDic];
        }
    }
}
#pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"서버";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) return [self.arrayWithFavorite count];
    if(section == 1) return [self.arrayWithFriends count];
    
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
     CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray * tmpArray;
        tmpArray = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:nil options:nil];
        cell = [tmpArray objectAtIndex:0];
     }
    
    if(indexPath.section == 0){
        cell.userName.text = [[self.arrayWithFavorite objectAtIndex:indexPath.row] objectForKey:@"groupName"];
    }else if(indexPath.section == 1){
        cell.userName.text = [[self.arrayWithFriends objectAtIndex:indexPath.row] objectForKey:@"groupName"];
    }else{
        cell.userName.text = @"error";
    }
    cell.backgroundColor = [UIColor colorWithRGBHex:0xcfcfcf];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [headerView setBackgroundColor:[UIColor colorWithRGBHex:0x6a6a6a]];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 20)];
    label.textColor = [UIColor colorWithRGBHex:0xcfcfcf];
    if(section == 0){
        label.text= @"favorite";
    }else{
        label.text = @"friends";
    }
    [headerView addSubview:label];
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ContentViewController * newContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Content"];
    
    Group * group;
    
    if(indexPath.section == 0){
        group = [Group getGroupFromServer:[[[self.arrayWithFavorite objectAtIndex:indexPath.row] objectForKey:@"id"] integerValue]];
    }else if(indexPath.section == 1){
        group = [Group getGroupFromServer:[[[self.arrayWithFriends objectAtIndex:indexPath.row] objectForKey:@"id"] integerValue]];
    }
    
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

@end
