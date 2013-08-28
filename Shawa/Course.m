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

+ (NSDictionary *)getNSDictionaryFromLecture:(Lecture *)lecture{
    NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];
    
    if(lecture.day == MON){
        [dictionary setObject:@"Monday" forKey:@"day"];
    }
    if(lecture.day == TUE){
        [dictionary setObject:@"Tuesday" forKey:@"day"];
    }
    if(lecture.day == WED){
        [dictionary setObject:@"Wednesday" forKey:@"day"];
    }
    if(lecture.day == THU){
        [dictionary setObject:@"Thursday" forKey:@"day"];
    }
    if(lecture.day == FRI){
        [dictionary setObject:@"Friday" forKey:@"day"];
    }
    if(lecture.day == SAT){
        [dictionary setObject:@"Saturday" forKey:@"day"];
    }
    if(lecture.day == SUN){
        [dictionary setObject:@"Sunday" forKey:@"day"];
    }
    [dictionary setObject:[NSNumber numberWithDouble:lecture.period] forKey:@"period"];
    [dictionary setObject:[NSNumber numberWithDouble:lecture.duration] forKey:@"duration"];
    [dictionary setObject:lecture.location forKey:@"location"];
    return dictionary;
}

+ (Lecture *)getLectureFromDic:(NSDictionary *)lectureDic{
    Lecture * lecture = [[Lecture alloc] init];
    lecture.day = [self getDayFromStrimg:[lectureDic objectForKey:@"day"]];
    lecture.period = [[lectureDic objectForKey:@"period"] doubleValue];
    lecture.duration = [[lectureDic objectForKey:@"duration"] doubleValue];
    lecture.location = @"";
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
-(id)initWithDay:(int)_day period:(double)pr duration:(double)dr location:(NSString *)loc{
    if(self=[super init]){
        self.day = _day;
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

+ (NSDictionary *)getNSDictionaryFromCourse:(Course *)course{
    NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:course.courseName forKey:@"courseName"];
    
    NSMutableArray * lectureArray = [[NSMutableArray alloc] init];
    for(Lecture * lecture in [course lectures]){
        NSString * lecDic = (NSString *)[Lecture getNSDictionaryFromLecture:lecture];
        [lectureArray addObject:lecDic];
    }
    
    [dictionary setObject:lectureArray forKey:@"lectures"];
    return dictionary;
}

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

-(id)initWithCourseName:(NSString *)_courseName{
    if(self=[self init]){
        self.courseName = [NSString stringWithString:_courseName];
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
