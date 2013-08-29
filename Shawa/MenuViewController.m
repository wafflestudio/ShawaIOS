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

@synthesize friendsListTableView, searchBar;
@synthesize arrayWithFavorite, arrayWithFriends, arrayWithMyself;
@synthesize arrayWithSelectedIndividualIds;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRGBHex:0x6a6a6a]];
    
    // initialize arrays
    arrayWithMyself = [[NSMutableArray alloc] init];
    arrayWithFavorite = [[NSMutableArray alloc] init];
    arrayWithFriends = [[NSMutableArray alloc] init];
    arrayWithSelectedIndividualIds = [[NSMutableArray alloc] init];
    
    // set arrays
    NSArray * arrayWithHashData = [self getHashDataFromServer];
    [self parseHashData:arrayWithHashData];
    
    // friendsListTableView Delegate 설정
    friendsListTableView.delegate = self;
    friendsListTableView.dataSource = self;
    
    friendsListTableView.backgroundColor = [UIColor colorWithRGBHex:0xcfcfcf];
    
    
    // searchBar 설정
    [searchBar addCompleteButton];
    searchBar.delegate = self;
    searchBar.customSearchBarDelegate = self;
    searchBar.backgroundImage = [UIColor image1x1WithColor:[UIColor colorWithRGBHex:0x6a6a6a]];
    
    // slidingView Anchor 설정
    [self.slidingViewController setAnchorLeftRevealAmount:280.0f];
    self.slidingViewController.underRightWidthLayout = ECFullWidth;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [arrayWithSelectedIndividualIds removeAllObjects];
    [self.friendsListTableView reloadData];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) return [self.arrayWithMyself count];
    if(section == 1) return [self.arrayWithFavorite count];
    if(section == 2) return [self.arrayWithFriends count];
    
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
     CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray * tmpArray;
        tmpArray = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:nil options:nil];
        cell = [tmpArray objectAtIndex:0];
        cell.delegate = self;
     }

    if(indexPath.section == 0){
        NSDictionary * dic = [self.arrayWithMyself objectAtIndex:indexPath.row];
        cell.userName.text = [dic objectForKey:@"groupName"];
    }else if(indexPath.section == 1){
        NSDictionary * dic = [self.arrayWithFavorite objectAtIndex:indexPath.row];
        cell.userName.text = [dic objectForKey:@"groupName"];
    }else if(indexPath.section == 2){
        NSDictionary * dic = [self.arrayWithFriends objectAtIndex:indexPath.row];
        cell.userName.text = [dic objectForKey:@"groupName"];
    }
    cell.backgroundColor = [UIColor colorWithRGBHex:0xcfcfcf];
    cell.tag = indexPath.section * 10 + indexPath.row + 1000;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0) return 0;
    else return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) return nil;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [headerView setBackgroundColor:[UIColor colorWithRGBHex:0x6a6a6a]];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 20)];
    label.textColor = [UIColor colorWithRGBHex:0xcfcfcf];
    if(section == 1){
        label.text= @"favorite";
    }else if(section == 2){
        label.text = @"friends";
    }
    [headerView addSubview:label];
    
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ContentViewController * newContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Content"];
    
    Group * group;
    if(indexPath.section == 0){
        group = [Group getGroupFromServer:[[[self.arrayWithMyself objectAtIndex:indexPath.row] objectForKey:@"id"] integerValue]];
    }else if(indexPath.section == 1){
        group = [Group getGroupFromServer:[[[self.arrayWithFavorite objectAtIndex:indexPath.row]objectForKey:@"id"] integerValue]];
    }else if(indexPath.section == 2){
        group = [Group getGroupFromServer:[[[self.arrayWithFriends objectAtIndex:indexPath.row]objectForKey:@"id"] integerValue]];
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

#pragma Custom Search Bar Delegate Start
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)_searchBar{
    [_searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar{
    [_searchBar resignFirstResponder];
    [_searchBar setShowsCancelButton:NO animated:YES];
}
- (void)completeButtonClicked:(id)sender{
    ContentViewController * newContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Content"];
    
    Group * group = [[Group alloc] init];
    group.groupName = @"그룹";
    group.groupType = nil;
    group.idForServer = nil;
    for(NSNumber * number in arrayWithSelectedIndividualIds){
        Individual * individual = [Individual getIndividualFromServer:[number integerValue]];
        [group.individuals addObject:individual];
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
#pragma Custom Search Bar Delegate End.

#pragma Custom Cell Delegate
- (void)buttonStateHasChanged:(id)sender{
    int section = ([sender tag] - 1000)/10;
    int index = ([sender tag] - 1000)%10;
    
    BOOL isSelected = NO;
    int individual_id;
    
    if(section == 0){
        isSelected = [sender isSelected];
        individual_id = [[[arrayWithMyself objectAtIndex:index] objectForKey:@"individual_ids"] integerValue];
    }else if(section == 1){
        isSelected = [sender isSelected];
        individual_id = [[[arrayWithFavorite objectAtIndex:index] objectForKey:@"individual_ids"] integerValue];
    }else if(section == 2){
        isSelected = [sender isSelected];
        individual_id = [[[arrayWithFriends objectAtIndex:index] objectForKey:@"individual_ids"] integerValue];
    }
    
    if(isSelected){
        [arrayWithSelectedIndividualIds addObject:[NSNumber numberWithInt:individual_id]];
    }else{
        for(NSNumber * number in arrayWithSelectedIndividualIds){
            if([number integerValue] == individual_id){
                [arrayWithSelectedIndividualIds removeObject:number];
            }
        }
    }
}
#pragma Custom Cell Delegate End.

@end
