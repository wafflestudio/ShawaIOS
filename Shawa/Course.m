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

+ (Lecture *)getLectureFromDic:(NSDictionary *)lectureDic{
    Lecture * lecture = [[Lecture alloc] init];
    lecture.day = [self getDayFromStrimg:[lectureDic objectForKey:@"day"]];
    lecture.period = [[lectureDic objectForKey:@"period"] doubleValue];
    lecture.duration = [[lectureDic objectForKey:@"duration"] doubleValue];
    
    return lecture;
}

+ (int)getDayFromStrimg:(NSString *)dayString{
    if([dayString isEqualToString:@"Monday"]) return MON;
    else if([dayString isEqualToString:@"Tuesday"]) return TUE;
    else if([dayString isEqualToString:@"Wednesday"]) return WED;
    else if([dayString isEqualToString:@"Thursday"]) return THU;
    else if([dayString isEqualToString:@"Friday"]) return FRI;
    else if([dayString isEqualToString:@"Saturday"]) return SAT;
    else if([dayString isEqualToString:@"Sunday"]) return SUN;
    else {
        NSLog(@"No matching Day for string");
        return -1;
    }
}
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


- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInt:day forKey:@"day"];
    [aCoder encodeDouble:period forKey:@"period"];
    [aCoder encodeDouble:duration forKey:@"duration"];
    [aCoder encodeObject:location forKey:@"location"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if( self = [super init]){
        self.day = [aDecoder decodeIntForKey:@"day"];
        self.period = [aDecoder decodeDoubleForKey:@"period"];
        self.duration = [aDecoder decodeDoubleForKey:@"duration"];
        self.location = [aDecoder decodeObjectForKey:@"location"];
    }
    return self;
}
@end


//Cource 구현
@implementation Course
@synthesize courseName, lectures;


+ (Course *)getCourseFromDic:(NSDictionary *)courseDic{
    Course * course = [[Course alloc] init];
    
    course.courseName = [courseDic objectForKey:@"courseName"];
    
    int lectureNum = [[courseDic objectForKey:@"lectures"] count];
    for(int i=0; i<lectureNum; i++){
        
        Lecture * lecture = [Lecture getLectureFromDic:[[courseDic objectForKey:@"lectures"] objectAtIndex:i]];
        
        [course.lectures addObject:lecture];
    }
    return course;
}


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

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:courseName forKey:@"courseName"];
    [aCoder encodeObject:lectures forKey:@"lectures"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if( self = [super init]){
        self.courseName = [aDecoder decodeObjectForKey:@"courseName"];
        self.lectures = [aDecoder decodeObjectForKey:@"lectures"];
    }
    return self;
}
@end
