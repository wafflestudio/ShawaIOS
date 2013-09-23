//
//  SettingViewController.m
//  Shawa
//
//  Created by SukWon Choi on 13. 9. 22..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

@synthesize publishMyTimeTable, synContacts;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set Switchs
    publishMyTimeTable.tag = 1;
    [publishMyTimeTable addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];
    
    synContacts.tag = 2;
    [synContacts addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];

    // initiate switchs
    NSUserDefaults * pref = [AppDelegate getPreference];
    publishMyTimeTable.on = [pref boolForKey:@"publishMyTimeTable"];
    synContacts.on = [pref boolForKey:@"synContacts"];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 2){
        [self performSegueWithIdentifier:@"Friends" sender:self];
    }
}

#pragma Table view data source end

- (void)setState:(id)sender{
    if ([sender tag] == 1){
        [[AppDelegate getPreference] setBool:publishMyTimeTable.on forKey:@"publishMyTimeTable"];
    }else if([sender tag] == 2){
        [[AppDelegate getPreference] setBool:synContacts.on forKey:@"synContacts"];
    }
}

@end
