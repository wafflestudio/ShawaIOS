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

+(NSString *)getUuidString{
    NSString *retrieveuuid = [SSKeychain passwordForService:@"com.wafflestudio.shawa" account:@"user"];
    
    if([retrieveuuid length]>0){
        return retrieveuuid;
    }
    
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef identifier = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    
    NSString *uuidString = CFBridgingRelease(identifier);
    [SSKeychain setPassword:uuidString forService:@"com.wafflestudio.shawa" account:@"user"];
    
    return uuidString;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"uuid : %@", [AppDelegate getUuidString]);
    return YES;
}


@end
