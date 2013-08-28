//
//  CustomCell.h
//  Shawa
//
//  Created by SukWon Choi on 13. 8. 27..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomCellDelegate <NSObject>
- (void)buttonStateHasChanged:(id)sender;
@end

@interface CustomCell : UITableViewCell

@property (nonatomic, weak) id <CustomCellDelegate> delegate;

@property (nonatomic, strong) IBOutlet UILabel * userName;
@property (nonatomic, strong) IBOutlet UIButton * checkButton;

- (IBAction)checkButtonClicked:(id)sender;

@end
