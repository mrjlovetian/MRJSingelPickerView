//
//  SinglePickerView.h
//  IWant
//
//  Created by tops on 2018/5/10.
//  Copyright © 2018年 want. All rights reserved.
//

#import "BasePickerView.h"

@class MRJSinglePickerView;
@protocol SinglePickerViewDelegate <NSObject>

- (void)singlePickerView:(MRJSinglePickerView *)view indetif:(NSString *)indetif didClickedButtonAtIndex:(int)buttonIndex;

@end

@interface MRJSinglePickerView : BasePickerView

- (instancetype)initWithViewController:(UIViewController *)vc Title:(NSString *)title;

@property (nonatomic, weak) id<SinglePickerViewDelegate>delegate;
@property (nonatomic, copy, readonly) NSString *indetif;

- (void)setData:(NSArray *)titles indetif:(NSString *)indetif selectIndex:(NSUInteger)buttonIndex;

- (void)setSelectIndex:(NSUInteger)buttonIndex;

@end
