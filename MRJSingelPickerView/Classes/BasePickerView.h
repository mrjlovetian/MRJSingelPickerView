//
//  BasePickerView.h
//  IWant
//
//  Created by tops on 2018/5/10.
//  Copyright © 2018年 want. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
#import "UIColor+MRJAdditions.h"
#import "UIView+MRJFrame.h"

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
