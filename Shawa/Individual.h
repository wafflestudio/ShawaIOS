//
//  Individual.h
//  Shawa
//
//  Created by SukWon Choi on 13. 7. 2..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Individual : NSObject{
    NSString * name;
    NSArray * courses;
}

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSArray * courses;

@end
