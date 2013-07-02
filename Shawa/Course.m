//
//  Course.m
//  Timetable
//
//  Created by SukWon Choi on 12. 10. 7..
//  Copyright (c) 2012년 SukWon Choi. All rights reserved.
//

#import "Course.h"
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


//Lecture 구현
@implementation Lecture
@synthesize day, period, duration, location;

//Lecture 초기화
-(id)initWithDay:(int)day period:(double)pr duration:(double)dr location:(NSString *)loc{
    if(self=[super init]){
        self.day = day;
        self.period = pr;
        self.duration = dr;
        self.location = [NSString stringWithString:loc];
    }
    return self;
}

@end


//Cource 구현
@implementation Course
@synthesize courseName, lectures;

//Cource 초기화
-(id)init{
    if(self=[super init]){
        courseName = nil;
        lectures = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

-(id)initWithCourseName:(NSString *)courseName{
    if(self=[self init]){
        self.courseName = [NSString stringWithString:courseName];
        lectures = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}
-(void)addNewLecture:(int)day period:(double)pr duration:(double)dr{
    Lecture * lecture;
    lecture = [[Lecture alloc] initWithDay:day period:pr duration:dr location:@""];
    [lectures addObject:lecture];
}

@end
