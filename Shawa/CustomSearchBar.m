//
//  CustomSearchBar.m
//  Shawa
//
//  Created by SukWon Choi on 13. 8. 28..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "CustomSearchBar.h"

@implementation CustomSearchBar

@synthesize customSearchBarDelegate;

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.autoresizesSubviews = YES;
    
    UIView * firstView = [self.subviews objectAtIndex:0];
    for(UIView * view in [firstView subviews]){
        if([view isKindOfClass:[UITextField class]]){
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width - 35, view.frame.size.height)];
        }
        if([view isKindOfClass:[UIButton class]]){
            if(view.tag == 2) continue;
            UIButton * cancelButton = (UIButton *)view;
            [cancelButton setTitle:@"취소" forState:UIControlStateNormal];
            [view setFrame:CGRectMake(view.frame.origin.x - 40, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
        }
    }
}

- (void)addCompleteButton{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(240, 4, 35, 35);
    [button setTitle:@"완료" forState:UIControlStateNormal];
    button.tag = 2;
    [button addTarget:self action:@selector(customButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)customButtonClicked:(id)sender{
    [self.customSearchBarDelegate completeButtonClicked:sender];
}

@end
