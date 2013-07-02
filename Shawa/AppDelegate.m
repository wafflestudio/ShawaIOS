//
//  AppDelegate.m
//  Shawa
//
//  Created by SukWon Choi on 13. 7. 1..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "AppDelegate.h"
#import "Course.h"
#import "Constant.h"
#import "Individual.h"

@implementation AppDelegate

@synthesize friendsList;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
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
    
    Individual * individual1 = [[Individual alloc] init];
    individual1.courses = [NSArray arrayWithObjects:course1, course2, course3, course4, course5, nil];
    individual1.name = @"김택민";
    
    Individual * individual2 = [[Individual alloc] init];
    individual2.courses = [NSArray arrayWithObjects:course1, course2, course3, course4, nil];
    individual2.name = @"김정은";
    
    Individual * individual3 = [[Individual alloc] init];
    individual3.courses = [NSArray arrayWithObjects:course1, course2, course3, nil];
    individual3.name = @"전재호";
    
    Individual * individual4 = [[Individual alloc] init];
    individual4.courses = [NSArray arrayWithObjects:course1, course2, nil];
    individual4.name = @"정현호";
    
    Individual * individual5 = [[Individual alloc] init];
    individual5.courses = [NSArray arrayWithObjects:course1, nil];
    individual5.name = @"최석원";
    
    self.friendsList = [NSArray arrayWithObjects:individual1, individual2, individual3, individual4, individual5, nil];
    
    return YES;
}

@end