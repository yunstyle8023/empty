//
//  CA_HDatePicker.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/13.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HDatePicker.h"

@interface CA_HDatePicker () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, copy) void (^dateBlock)(UIDatePicker * datePicker);
@property (nonatomic, copy) void (^pickerBlock)(UIPickerView *pickerView);

@end

@implementation CA_HDatePicker

- (UIDatePicker *)datePicker{
    if (!_datePicker) {
        UIDatePicker * datePicker = [UIDatePicker new];
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        _datePicker = datePicker;
        _datePicker.minimumDate = [NSDate date];
    }
    return _datePicker;
}

- (void)presentDatePicker:(NSString *)title dateBlock:(void (^)(UIDatePicker * datePicker))dateBlock{
    
    _dateBlock = dateBlock;
    
    [self presentPicker:self.datePicker title:title];
}


- (UIPickerView *)pickerView {
    if (!_pickerView) {
        UIPickerView *pickerView = [UIPickerView new];
        _pickerView = pickerView;
        
        pickerView.showsSelectionIndicator = NO;
        
        pickerView.backgroundColor = [UIColor whiteColor];
//        pickerView.dataSource = self;
//        pickerView.delegate = self;
    }
    return _pickerView;
}

- (void)presentPickerView:(NSString *)title pickerBlock:(void (^)(UIPickerView *pickerView))pickerBlock {
    
    _pickerBlock = pickerBlock;
    
    [self presentPicker:self.pickerView title:title];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
}




- (void)presentPicker:(UIView *)view title:(NSString *)title {
    self.frame = CA_H_MANAGER.mainWindow.bounds;
    
    UIToolbar * toolBar = [UIToolbar new];
    toolBar.barStyle = UIBarStyleBlack;
    toolBar.alpha = 0.35;
    
    [self addSubview:toolBar];
    toolBar.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [CA_H_MANAGER.mainWindow addSubview:self];
    
    
    UIView * pickerView = [UIView new];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.frame = CGRectMake(0, self.mj_h, self.mj_w, 272*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight);
    [self addSubview:pickerView];
    
    UIButton * sure = [UIButton new];
    sure.tag = 101;
    sure.titleLabel.font = CA_H_FONT_PFSC_Regular(16);
    [sure setTitle:CA_H_LAN(@"确定") forState:UIControlStateNormal];
    [sure setTitleColor:CA_H_TINTCOLOR forState:UIControlStateNormal];
    [sure addTarget:self action:@selector(onSure:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * cancel = [UIButton new];
    cancel.tag = 100;
    cancel.titleLabel.font = CA_H_FONT_PFSC_Regular(16);
    [cancel setTitle:CA_H_LAN(@"取消") forState:UIControlStateNormal];
    [cancel setTitleColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(onCancel:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * label = [UILabel new];
    label.textColor = CA_H_4BLACKCOLOR;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    
    UIView *line = [UIView new];
    line.backgroundColor = CA_H_BACKCOLOR;
    
    [pickerView addSubview:line];
    [pickerView addSubview:label];
    [pickerView addSubview:cancel];
    [pickerView addSubview:sure];
    
    line.sd_layout
    .heightIs(CA_H_LINE_Thickness)
    .leftEqualToView(pickerView)
    .rightEqualToView(pickerView)
    .topSpaceToView(pickerView, 52*CA_H_RATIO_WIDTH);
    
    cancel.sd_layout
    .leftEqualToView(pickerView)
    .topEqualToView(pickerView)
    .widthIs(72*CA_H_RATIO_WIDTH)
    .heightIs(52*CA_H_RATIO_WIDTH);
    
    sure.sd_layout
    .rightEqualToView(pickerView)
    .topEqualToView(pickerView)
    .widthIs(72*CA_H_RATIO_WIDTH)
    .heightIs(52*CA_H_RATIO_WIDTH);
    
    label.sd_layout
    .leftSpaceToView(cancel, 0)
    .rightSpaceToView(sure, 0)
    .topEqualToView(pickerView)
    .heightRatioToView(cancel, 1);
    
    [pickerView addSubview:view];
    view.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(52*CA_H_RATIO_WIDTH, 0, CA_H_MANAGER.xheight, 0));
    
    [UIView animateWithDuration:0.25 animations:^{
        pickerView.mj_y = self.mj_h - pickerView.mj_h;
    }];
}

- (void)onSure:(UIButton *)sender{
    if (_dateBlock) {
        _dateBlock(self.datePicker);
    }
    
    if (_pickerBlock) {
        _pickerBlock(self.pickerView);
    }
    
    [self onCancel:nil];
}

- (void)onCancel:(UIButton *)sender{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.datePicker.superview.mj_y = self.mj_h;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self onCancel:nil];
}

#pragma mark --- Picker

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.data.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.data[component] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    id model = self.data[component][row];
    if (self.modeToStrBlock) {
        return self.modeToStrBlock(model);
    } else {
        return model;
    }
}

@end
