//
//  Group.h
//  Shawa
//
//  Created by SukWon Choi on 13. 7. 8..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Individual;

@interface Group : NSManagedObject

@property (nonatomic, retain) id individuals;
@property (nonatomic, retain) NSString * groupName;
@property (nonatomic, retain) NSNumber * groupType;
@property (nonatomic, retain) NSSet *individuals_in_group;
@end

@interface Group (CoreDataGeneratedAccessors)

- (void)addIndividuals_in_groupObject:(Individual *)value;
- (void)removeIndividuals_in_groupObject:(Individual *)value;
- (void)addIndividuals_in_group:(NSSet *)values;
- (void)removeIndividuals_in_group:(NSSet *)values;

@end
