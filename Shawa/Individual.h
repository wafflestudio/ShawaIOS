//
//  Individual.h
//  Shawa
//
//  Created by SukWon Choi on 13. 7. 8..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Course.h"

@interface Individual : NSObject <NSCoding>

@property (nonatomic, retain) NSMutableArray * courses;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSNumber * idForServer;

+ (Individual *)getIndividualFromDic:(NSDictionary *)individualDic;

@end
