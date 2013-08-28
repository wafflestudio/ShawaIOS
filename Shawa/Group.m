//
//  Group.m
//  Shawa
//
//  Created by SukWon Choi on 13. 7. 15..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "Group.h"
#import "NSDictionary+JSONCategories.h"


@implementation Group

@synthesize groupName;
@synthesize groupType;
@synthesize idForServer;
@synthesize individuals;

+ (Group *)getGroupFromServer:(int)group_id{
    NSString * url = [NSString stringWithFormat:@"%@group/%d", WEB_BASE_URL, group_id];
    NSDictionary * jsonDic =  [NSDictionary dictionaryWithContentsOfJSONURLString:url];
    
    Group * groupFromServer = [Group new];
    
    groupFromServer.groupName = [jsonDic objectForKey:@"groupName"];
    
    groupFromServer.groupType = [NSNumber numberWithInteger:[[jsonDic objectForKey:@"groupType"] integerValue] ];
    
    NSMutableArray * individuals = [[NSMutableArray alloc] init];
    
    NSArray * individual_ids = [[jsonDic objectForKey:@"individual_ids"] componentsSeparatedByString:@" "];
    
    for(NSString *individual_id in individual_ids){
        Individual * individual = [Individual getIndividualFromServer:[individual_id integerValue]];
        [individuals addObject:individual];
    }
    groupFromServer.individuals = individuals;
    return groupFromServer;
}

- (id)init{
    self = [super init];
    if(self != nil){
        groupName = @"Default Group Name";
        individuals = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
