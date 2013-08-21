//
//  NSDictionary+JSONCategories.m
//  Shawa
//
//  Created by SukWon Choi on 13. 8. 7..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "NSDictionary+JSONCategories.h"

@implementation NSDictionary(JSONCategories)
+(NSDictionary*)dictionaryWithContentsOfJSONURLString:
(NSString*)urlAddress
{
    NSURL *myURL = [[NSURL alloc]initWithString:urlAddress];
    NSData *myData = [[NSData alloc]initWithContentsOfURL:myURL];
    
    if(myData == nil){
        NSLog(@"Error receiving data from server");
        return nil;
    }
    
    id jsonDictionary = [NSJSONSerialization JSONObjectWithData:myData options:NSJSONReadingMutableContainers error:nil];
    
    return (NSDictionary *)jsonDictionary;
}

-(NSData*)toJSON
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self
                                                options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}
@end

