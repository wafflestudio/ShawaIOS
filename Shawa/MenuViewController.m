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

@synthesize friendsListTableView, arrayWithHashData;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // friendsListTableView Delegate 설정
    friendsListTableView.delegate = self;
    friendsListTableView.dataSource = self;
    
    // slidingView Anchor 설정
    [self.slidingViewController setAnchorLeftRevealAmount:280.0f];
    self.slidingViewController.underRightWidthLayout = ECFullWidth;
    
    self.arrayWithHashData = [self getHashDataFromServer];
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
    if(self.arrayWithHashData != nil){
        return [self.arrayWithHashData count];
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
     }
    if(self.arrayWithHashData != nil)
        cell.textLabel.text = [[self.arrayWithHashData objectAtIndex:indexPath.row] objectForKey:@"groupName"];
    else
        cell.textLabel.text = @"aaa";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ContentViewController * newContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Content"];
    
    Group * group = [Group getGroupFromServer:[[[self.arrayWithHashData objectAtIndex:indexPath.row] objectForKey:@"id"] integerValue]];
    
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
