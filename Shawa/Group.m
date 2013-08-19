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

+ (Group *)getGroupFromServer{
    NSDictionary * jsonDic =  [NSDictionary dictionaryWithContentsOfJSONURLString:@"http://services.snu.ac.kr:3332/test"];
    
    Group * groupFromServer = [Group new];
    
    groupFromServer.groupName = [jsonDic objectForKey:@"groupName"];
    
    NSMutableArray * individuals = [[NSMutableArray alloc] init];
    
    int individualNum = [[jsonDic objectForKey:@"individuals"] count];
    for(int i=0; i< individualNum; i++){
        NSDictionary * individualDic = (NSDictionary *)[[jsonDic objectForKey:@"individuals"] objectAtIndex:i];
        
        Individual * individual = [Individual getIndividualFromDic:individualDic];
        
        [individuals addObject:individual];
    }
    groupFromServer.individuals = individuals;
    return groupFromServer;
}

@end
