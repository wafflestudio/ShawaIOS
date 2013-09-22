//
//  NSDate+DATEHelperCategories.m
//  Shawa
//
//  Created by SukWon Choi on 13. 9. 22..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "NSDate+DATEHelperCategories.h"

@implementation NSDate(DATEHelperCategories)
+ (NSString *)dateStringWithHour:(int)hour minute:(int)minute{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setHour:hour];
    [comps setMinute:minute];
    
    NSDate * myDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"a hh:mm"];
    
    NSString *stringFromDate = [formatter stringFromDate:myDate];
    
    return stringFromDate;
}

@end
