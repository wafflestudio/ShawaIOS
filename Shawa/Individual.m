//
//  Individual.m
//  Shawa
//
//  Created by SukWon Choi on 13. 7. 8..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "Individual.h"


@implementation Individual

@synthesize courses;
@synthesize userName;
@synthesize idForServer;

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:courses forKey:@"courses"];
    [aCoder encodeObject:userName forKey:@"userName"];
    [aCoder encodeObject:idForServer forKey:@"idForServer"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if( self = [super init]){
        self.courses = [aDecoder decodeObjectForKey:@"courses"];
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.idForServer = [aDecoder decodeObjectForKey:@"idForServer"];
    }
    return self;
}

+ (Individual *)getIndividualFromDic:(NSDictionary *)individualDic{
    Individual * individual = [Individual new];
    
    individual.userName = [individualDic objectForKey:@"userName"];
    
    NSMutableArray *courses = [[NSMutableArray alloc] init];
    
    int courseNum = [[individualDic objectForKey:@"courses"] count];
    for(int j=0; j<courseNum; j++){
        Course * course = [Course getCourseFromDic:[[individualDic objectForKey:@"courses"] objectAtIndex:j]];
        [courses addObject:course];
    }
    individual.courses = [NSArray arrayWithArray:courses];
    return individual;
}


@end
