//
//  MRJViewController.m
//  MRJSingelPickerView
//
//  Created by mrjlovetian@gmail.com on 05/14/2018.
//  Copyright (c) 2018 mrjlovetian@gmail.com. All rights reserved.
//

#import "MRJViewController.h"
#import "MRJSinglePickerView.h"

@interface MRJViewController () <SinglePickerViewDelegate> {
    NSArray *_dataSource;
}

@end

@implementation MRJViewController

#pragma mark SinglePickerViewDelegate
- (void)singlePickerView:(MRJSinglePickerView *)view indetif:(NSString *)indetif didClickedButtonAtIndex:(int)buttonIndex {
    
    UILabel *lab = [self.view viewWithTag:100];
    lab.text = _dataSource[buttonIndex];
}

#pragma mark method

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 30);
    [btn setTitle:@"click" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(100, 150, 100, 30)];
    lab.text = @"wait";
    lab.tag = 100;
    [self.view addSubview:lab];
    
    _dataSource = @[@"one", @"two", @"three"];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)clickBtn {
    MRJSinglePickerView *singPickerView = [[MRJSinglePickerView alloc] initWithViewController:self Title:@""];
    [singPickerView setData:_dataSource indetif:@"mrj" selectIndex:0];
    singPickerView.delegate = self;
    [singPickerView startPicker];
}

@end
