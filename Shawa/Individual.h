//
//  Individual.h
//  Shawa
//
//  Created by SukWon Choi on 13. 7. 8..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Individual : NSManagedObject <NSCoding>

@property (nonatomic, retain) id courses;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSNumber * idForServer;

@end
