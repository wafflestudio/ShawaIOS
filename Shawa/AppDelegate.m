//
//  AppDelegate.m
//  Shawa
//
//  Created by SukWon Choi on 13. 7. 1..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "AppDelegate.h"
#import "SSKeychain.h"

@implementation AppDelegate

+ (void)setUuidAndIndividualId{
    // Set Uuid
    NSString *retrieveuuid = [SSKeychain passwordForService:@"com.wafflestudio.shawa" account:@"user"];
    
    if([retrieveuuid length]>0){
        my_uuid = retrieveuuid;
    }else{
        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        CFStringRef identifier = CFUUIDCreateString(NULL, uuidRef);
        CFRelease(uuidRef);
        my_uuid = CFBridgingRelease(identifier);
        [SSKeychain setPassword:my_uuid forService:@"com.wafflestudio.shawa" account:@"user"];
    }
    // Set My Individual Id
    NSString * uuid = [AppDelegate getUuidString];
    NSString * JSONURLString = [NSString stringWithFormat:@"%@user/%@", WEB_BASE_URL, uuid];
    
    NSArray *jsonArray = (NSArray *)[NSDictionary dictionaryWithContentsOfJSONURLString:JSONURLString];
    
    if([jsonArray count] != 0){
        NSDictionary * jsonDic = [jsonArray objectAtIndex:0];
        my_individual_id = [[jsonDic objectForKey:@"my_individual_id"] integerValue];
    }else{
        NSLog(@"error getting my_individual_id");
        my_individual_id = -1;
    }
}

+(NSString *)getUuidString{
    return my_uuid; 
}
+(int)getMyIndividualId{
    return my_individual_id;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [AppDelegate setUuidAndIndividualId];
    NSLog(@"uuid : %@", [AppDelegate getUuidString]);
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    return YES;
}

@end
