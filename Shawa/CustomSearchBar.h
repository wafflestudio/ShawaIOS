//
//  CustomSearchBar.h
//  Shawa
//
//  Created by SukWon Choi on 13. 8. 28..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomSearchBarDelegate <UISearchBarDelegate>
- (void)completeButtonClicked:(id)sender;
@end

@interface CustomSearchBar : UISearchBar

// Delegate
@property (nonatomic, weak) id <CustomSearchBarDelegate> customSearchBarDelegate;

- (void)addCompleteButton;
- (void)customButtonClicked:(id)sender;

@end
