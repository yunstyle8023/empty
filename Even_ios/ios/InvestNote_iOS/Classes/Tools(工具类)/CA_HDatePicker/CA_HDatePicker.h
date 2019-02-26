//
//  CA_HDatePicker.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/13.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CA_HDatePicker : UIView

@property (nonatomic, strong) UIDatePicker * datePicker;

- (void)presentDatePicker:(NSString *)title dateBlock:(void (^)(UIDatePicker * datePicker))dateBlock;


@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, copy) NSString *(^modeToStrBlock)(id model);

- (void)presentPickerView:(NSString *)title pickerBlock:(void (^)(UIPickerView *pickerView))pickerBlock;

@end
