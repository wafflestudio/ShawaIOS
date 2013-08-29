//
//  CustomCell.m
//  Shawa
//
//  Created by SukWon Choi on 13. 8. 27..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

@synthesize userName, checkButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [checkButton setBackgroundImage:[UIImage imageNamed:@"icon_plus"] forState:UIControlStateNormal];
        [checkButton setBackgroundImage:[UIImage imageNamed:@"icon_checked"] forState:UIControlStateSelected];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)checkButtonClicked:(id)sender{
    UIButton * button = (UIButton *)sender;
    button.tag = self.tag;
    [checkButton setSelected:!checkButton.selected];
    
    NSLog(@"%d", [checkButton isSelected]);
    
    [self.delegate buttonStateHasChanged:checkButton];
}

@end
