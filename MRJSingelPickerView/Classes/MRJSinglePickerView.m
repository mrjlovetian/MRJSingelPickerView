//
//  SinglePickerView.m
//  MRJ
//
//  Created by MRJ on 2018/5/10.
//  Copyright © 2018年 MRJ. All rights reserved.
//

#import "MRJSinglePickerView.h"
#import "Macro.h"
#import "UIColor+MRJAdditions.h"
#import "UIView+MRJFrame.h"

static CGFloat const kScrollViewItemHeight = 36.0f;

@interface MRJSinglePickerView() <UIScrollViewDelegate>
{
    NSInteger selectIndex;
    NSMutableArray *_labels;
}

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic, copy) NSString *indetif;

@end


@implementation MRJSinglePickerView

- (instancetype)initWithViewController:(UIViewController *)vc Title:(NSString *)title {
    self = [super initWithViewController:vc PickerHeight:250];
    if (self) {
        [self.contentView addSubview:self.scrollView];
        if (title) {
            self.labelTitle.text = title;
        }
    }
    return self;
}

- (void)setData:(NSArray *)titles indetif:(NSString *)indetif selectIndex:(NSUInteger)buttonIndex {
    _indetif = [indetif copy];
    _dataArray = titles;
    [self buildSelectorLabels];
    [self setSelectIndex:buttonIndex];
}

- (void)setSelectIndex:(NSUInteger)buttonIndex {
    selectIndex = buttonIndex;
    [self highlightLabelInArray:_labels atIndex:selectIndex];
    [self setScrollView:self.scrollView atIndex:selectIndex animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int index = [self getIndexForScrollViewPosition:scrollView];
    selectIndex = index;
    [self highlightLabelInArray:_labels atIndex:index];
}

- (void)highlightLabelInArray:(NSMutableArray*)labels atIndex:(NSInteger)index {
    if (!labels)
        return;
    if (index > labels.count)
        return;
    if (index < 0)
        return;
    
    for (int i = 0; i < labels.count; i++) {
        UILabel *label = (UILabel *)[labels objectAtIndex:i];
        if (i != index) {
            label.textColor = [UIColor colorWithHexString:@"999999"];
            label.font = [UIFont systemFontOfSize:16];
        } else {
            label.textColor = [UIColor colorWithHexString:@"333333"];
            label.font = [UIFont systemFontOfSize:20];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    int index = [self getIndexForScrollViewPosition:scrollView];
    selectIndex = index;
    [self setScrollView:scrollView atIndex:index animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int index = [self getIndexForScrollViewPosition:scrollView];
    selectIndex = index;
    [self setScrollView:scrollView atIndex:index animated:YES];
}

- (void)buildSelectorLabels{
    CGFloat offsetContentScrollView = (_scrollView.height - kScrollViewItemHeight) / 2.0;
    
    if (_labels && _labels.count > 0) {
        for (UILabel *label in _labels) {
            [label removeFromSuperview];
        }
    }
    
    _labels = [[NSMutableArray alloc] init];
    for (int i = 0; i < _dataArray.count; i++) {
        
        NSString *txt = (NSString*)[_dataArray objectAtIndex:i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, (i * kScrollViewItemHeight) + offsetContentScrollView, _scrollView.width, kScrollViewItemHeight)];
        label.text = txt;
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithHexString:@"999999"];
        label.backgroundColor = [UIColor clearColor];
        [_labels addObject:label];
        [_scrollView addSubview:label];
    }
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width, (kScrollViewItemHeight * _dataArray.count) + (offsetContentScrollView * 2));
}

- (void)singleTapGestureYearsCaptured:(UITapGestureRecognizer *)gesture {
    CGPoint touchPoint = [gesture locationInView:self];
    CGFloat touchY = touchPoint.y;
    
    NSInteger minYear = 0;
    CGFloat offsetContentScrollView = (_scrollView.height - kScrollViewItemHeight) / 2.0;
    if (touchY < offsetContentScrollView) {
        if (selectIndex > minYear) {
            selectIndex -= 1;
            [self setScrollView:_scrollView atIndex:selectIndex animated:YES];
        }
    } else if (touchY > (offsetContentScrollView + kScrollViewItemHeight)) {
        if (selectIndex < (_dataArray.count + (minYear - 1))) {
            selectIndex += 1;
            [self setScrollView:_scrollView atIndex:selectIndex animated:YES];
        }
    }
}

- (void)setScrollView:(UIScrollView*)scrollView atIndex:(NSInteger)index animated:(BOOL)animated {
    if (!scrollView) return;
    if (animated) {
        [UIView beginAnimations:@"ScrollViewAnimation" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.4f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    }
    
    scrollView.contentOffset = CGPointMake(0.0, (index * kScrollViewItemHeight));
    
    if (animated) {
        [UIView commitAnimations];
    }
}

- (int)getIndexForScrollViewPosition:(UIScrollView *)scrollView {
    CGFloat offetY = scrollView.contentOffset.y;
    CGFloat index = floorf(offetY / kScrollViewItemHeight);
    return index;
}


- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [self getPickerBarHeight], ScreenSzie.width, [self getPickerHeight] - [self getPickerBarHeight])];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureYearsCaptured:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [_scrollView addGestureRecognizer:singleTap];
    }
    return _scrollView;
}

- (void)titleButton:(id)send {
    [super titleButton:send];
    UIButton *button = (UIButton *)send;
    if (button.tag == 2) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(singlePickerView:indetif:didClickedButtonAtIndex:)]) {
            [self.delegate singlePickerView:self indetif:self.indetif didClickedButtonAtIndex:(int)selectIndex];
            [self endPicker];
        } else {
            [self endPicker];
        }
    }
}

@end
