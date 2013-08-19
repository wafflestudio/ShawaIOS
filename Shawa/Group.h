//
//  Group.h
//  Shawa
//
//  Created by SukWon Choi on 13. 7. 15..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Individual.h"

@interface Group : NSObject

@property (nonatomic, retain) NSString * groupName;
@property (nonatomic, retain) NSNumber * groupType;
@property (nonatomic, retain) NSNumber * idForServer;
@property (nonatomic, retain) NSMutableArray *individuals;

+ (Group *)getGroupFromServer;

@end
