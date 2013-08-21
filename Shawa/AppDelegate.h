//
//  AppDelegate.h
//  Shawa
//
//  Created by SukWon Choi on 13. 7. 1..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constant.h"
#import "Group.h"
#import "Individual.h"
#import "Course.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+(NSString *)getUuidString;

@end
