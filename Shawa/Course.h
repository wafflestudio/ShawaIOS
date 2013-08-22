//
//  Course.h
//  Timetable
//
//  Created by SukWon Choi on 12. 10. 7..
//  Copyright (c) 2012년 SukWon Choi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"

//수업에 대한 정보를 담고 있는 클래스
@interface Lecture : NSObject <NSCoding>{
    //day :요일, period :교시, duration :수업시간
    int day;
    double period;
    double duration;
    NSString * location;
}
@property (nonatomic) int day;
@property (nonatomic) double period;
@property (nonatomic) double duration;
@property (nonatomic) NSString * location;

+ (Lecture *)getLectureFromDic:(NSDictionary *)lectureDic;
+ (NSDictionary *)getNSDictionaryFromLecture:(Lecture *)lecture;

- (id)initWithDay:(int)day period:(double)pr duration:(double)dr location:(NSString*)loc;

@end

//특정 과목에 대한 정보를 담고 있는 클래스
@interface Course : NSObject <NSCoding>{
    NSString * courseName;
    NSMutableArray * lectures;
}
@property (nonatomic) NSString * courseName;
@property (nonatomic) NSMutableArray * lectures;

-(id)initWithCourseName:(NSString*)courseName;
-(void)addNewLecture:(int)day period:(double)pr duration:(double)dr;

+ (Course *)getCourseFromDic:(NSDictionary *)courseDic;
+ (NSDictionary *)getNSDictionaryFromCourse:(Course *)course;

@end
