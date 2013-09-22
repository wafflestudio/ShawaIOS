//
//  SettingViewController.m
//  Shawa
//
//  Created by SukWon Choi on 13. 9. 22..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 2){
        [self performSegueWithIdentifier:@"Friends" sender:self];
    }
}

@end
