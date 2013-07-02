//
//  InitialSlidingViewController.m
//  Shawa
//
//  Created by SukWon Choi on 13. 7. 1..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "InitialSlidingViewController.h"

@interface InitialSlidingViewController ()

@end

@implementation InitialSlidingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    }
    self.topViewController = [storyboard instantiateViewControllerWithIdentifier:@"Content"];
}

@end
