//
//  BasePickerView.m
//  IWant
//
//  Created by tops on 2018/5/10.
//  Copyright © 2018年 want. All rights reserved.
//

#import "BasePickerView.h"
#import "Macro.h"
#import "UIColor+MRJAdditions.h"
#import "UIView+MRJFrame.h"

@interface BasePickerView() {
    CGFloat _pickerHeight;
    UIViewController *_currentVC;
}

@end

@implementation BasePickerView

- (instancetype)initWithViewController:(UIViewController *)vc PickerHeight:(CGFloat) pickerHeight {
    self = [super initWithFrame:CGRectMake(0, 0, ScreenSzie.width, ScreenSzie.height)];
    if (self) {
        _currentVC = vc;
        _pickerHeight = pickerHeight;
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
        [self addSubview:self.translucentView];
        [self addSubview:self.contentView];
    }
    return self;
}

- (CGFloat)getPickerHeight {
    return _pickerHeight;
}

- (CGFloat)getPickerBarHeight {
    return 55;
}

- (UIView *)translucentView
{
    if (nil == _translucentView) {
        _translucentView = [[UIView alloc]initWithFrame:self.frame];
        _translucentView.backgroundColor = [UIColor blackColor];
        _translucentView.alpha = 0.5;
        UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endPicker)];
        [_translucentView addGestureRecognizer:mTap];
    }
    return _translucentView;
}

- (UIView *)contentView {
    if (nil == _contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenSzie.height, ScreenSzie.width, _pickerHeight)];
        _contentView.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, [self getPickerBarHeight] - 0.5, ScreenSzie.width, 0.5)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
        [_contentView addSubview:lineView];
        
        _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake((ScreenSzie.width-200)/2, ([self getPickerBarHeight] - 20)/2, 200, 20)];
        _labelTitle.font = [UIFont systemFontOfSize:16];
        _labelTitle.textAlignment = NSTextAlignmentCenter;
        _labelTitle.textColor = [UIColor colorWithHexString:@"33333"];
        [_contentView addSubview:_labelTitle];
        
        _doneButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenSzie.width - 64, ([self getPickerBarHeight] - 44)/2, 64, 44)];
        _doneButton.tag = 2;
        _doneButton.backgroundColor = [UIColor clearColor];
        [_doneButton setTitle:@"确定" forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_doneButton setTitleColor:[UIColor colorWithHexString:@"0091e8"] forState:UIControlStateNormal];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_doneButton addTarget:self action:@selector(titleButton:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_doneButton];
        
        _cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, ([self getPickerBarHeight] - 44)/2, 64, 44)];
        _cancelButton.tag = 1;
        _cancelButton.backgroundColor = [UIColor clearColor];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelButton addTarget:self action:@selector(titleButton:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_cancelButton];
    }
    return _contentView;
}

- (void)titleButton:(id)send {
    UIButton *button = (UIButton *)send;
    switch (button.tag) {
        case 1:
            [self endPicker];
            break;
        case 2:{
        } break;
        default: break;
    }
}

- (void)animateWithView:(UIView *)view frame:(CGRect)rect {
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending ) {
        [UIView animateWithDuration: 0.45
                              delay:0
             usingSpringWithDamping:10
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             view.frame = rect;
                         } completion:nil];
        
    } else {
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             view.frame = rect;
                         }
                         completion:nil];
    }
}

- (void)startPicker {
    self.hidden = NO;
    if (_currentVC) {
        [_currentVC.view addSubview:self];
    } else {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    MRJWeakSelf(self);
    [self animateWithView:_contentView
                    frame:CGRectMake(0, ScreenSzie.height - _pickerHeight, ScreenSzie.width, _pickerHeight)];
    [UIView animateWithDuration:0.3 animations:^{
        weakself.translucentView.alpha = 0.5;
    }];
}

- (void)endPicker {
    [self animateWithView:_contentView
                    frame:CGRectMake(0,ScreenSzie.height, ScreenSzie.width, _pickerHeight)];
    MRJWeakSelf(self);
    [UIView animateWithDuration:0.4 animations:^{
        weakself.translucentView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}

@end
