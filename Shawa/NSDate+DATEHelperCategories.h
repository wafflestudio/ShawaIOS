//
//  NSDate+DATEHelperCategories.h
//  Shawa
//
//  Created by SukWon Choi on 13. 9. 22..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(DATEHelperCategories)
+ (NSString *)dateStringWithHour:(int)hour minute:(int)minute;

@end

@interface UIColor(COLORCategories)
+ (UIColor *)colorWithRGBHex:(UInt32)hex;
+ (UIImage *)image1x1WithColor:(UIColor *)color;

@end
