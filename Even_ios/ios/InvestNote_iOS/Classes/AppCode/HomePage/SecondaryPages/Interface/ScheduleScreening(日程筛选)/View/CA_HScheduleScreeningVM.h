//
//  CA_HScheduleScreeningVM.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/11/14.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HUserScreeningCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ScreeningTypeTime = 0,
    ScreeningTypeUesr,
} ScreeningType;

@interface CA_HScheduleScreeningVM : NSObject

@property (nonatomic, assign) ScreeningType type;
@property (nonatomic, strong) UIView *screeningView;

@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIButton *resetBtn;

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
