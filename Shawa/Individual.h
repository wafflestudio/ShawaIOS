//
//  Individual.h
//  Shawa
//
//  Created by SukWon Choi on 13. 7. 5..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Individual : NSManagedObject

@property (nonatomic, retain) NSNumber * userType;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSArray * courses;

@end
