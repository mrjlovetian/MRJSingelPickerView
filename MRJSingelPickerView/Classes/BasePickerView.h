//
//  BasePickerView.h
//  MRJ
//
//  Created by MRJ on 2018/5/10.
//  Copyright © 2018年 MRJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasePickerView : UIView

@property (nonatomic, strong) UIView *translucentView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIButton *cancelButton;

- (instancetype)initWithViewController:(UIViewController *)vc PickerHeight:(CGFloat) pickerHeight;

- (void)startPicker;
- (void)endPicker;
- (void)titleButton:(id)send;
- (CGFloat)getPickerHeight;
- (CGFloat)getPickerBarHeight;

@end
