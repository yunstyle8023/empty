//
//  CA_HScheduleScreeningVM.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/11/14.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HScheduleScreeningVM.h"

@interface CA_HScheduleScreeningVM ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation CA_HScheduleScreeningVM

#pragma mark --- Action

#pragma mark --- Lazy

- (UIView *)screeningView {
    if (!_screeningView) {
        UIView *view = [UIView new];
        _screeningView = view;
        
        view.backgroundColor = [UIColor whiteColor];
        
        [view addSubview:self.cancelBtn];
        self.cancelBtn.sd_layout
        .widthIs(72*CA_H_RATIO_WIDTH)
        .heightIs(50*CA_H_RATIO_WIDTH)
        .topEqualToView(view)
        .leftEqualToView(view);
        
        [view addSubview:self.sureBtn];
        self.sureBtn.sd_layout
        .widthIs(72*CA_H_RATIO_WIDTH)
        .heightIs(50*CA_H_RATIO_WIDTH)
        .topEqualToView(view)
        .rightEqualToView(view);
        
        [view addSubview:self.titleLabel];
        self.titleLabel.sd_layout
        .topEqualToView(view)
        .heightRatioToView(self.cancelBtn, 1)
        .leftSpaceToView(self.cancelBtn, 10*CA_H_RATIO_WIDTH)
        .rightSpaceToView(self.sureBtn, 10*CA_H_RATIO_WIDTH);
        
        UIView *tLine = [UIView new];
        tLine.backgroundColor = CA_H_BACKCOLOR;
        [view addSubview:tLine];
        tLine.sd_layout
        .topSpaceToView(self.titleLabel, 0)
        .leftEqualToView(view)
        .rightEqualToView(view)
        .heightIs(CA_H_LINE_Thickness);
        
        switch (_type) {
            case ScreeningTypeUesr:{
                [view addSubview:self.tableView];
                self.tableView.sd_layout
                .topSpaceToView(tLine, 0)
                .leftEqualToView(view)
                .rightEqualToView(view)
                .bottomEqualToView(view);
            }break;
                
            default:{
                [view addSubview:self.resetBtn];
                self.resetBtn.sd_layout
                .heightIs(30*CA_H_RATIO_WIDTH)
                .topSpaceToView(tLine, 14*CA_H_RATIO_WIDTH)
                .leftSpaceToView(view, 20*CA_H_RATIO_WIDTH)
                .rightSpaceToView(view, 20*CA_H_RATIO_WIDTH);
                
                UIView *line = [UIView new];
                line.backgroundColor = CA_H_BACKCOLOR;
                [view addSubview:line];
                line.sd_layout
                .topSpaceToView(self.resetBtn, 16*CA_H_RATIO_WIDTH)
                .leftEqualToView(view)
                .rightEqualToView(view)
                .heightIs(CA_H_LINE_Thickness);
                
                [view addSubview:self.pickerView];
                self.pickerView.sd_layout
                .widthIs(CA_H_SCREEN_WIDTH/2-CA_H_LINE_Thickness)
                .heightIs(264*CA_H_RATIO_WIDTH)
                .topSpaceToView(line, 0)
                .leftEqualToView(view);
                
                UIView *vLine = [UIView new];
                vLine.backgroundColor = CA_H_BACKCOLOR;
                [view addSubview:vLine];
                vLine.sd_layout
                .topSpaceToView(line, 0)
                .leftSpaceToView(self.pickerView, 0)
                .bottomEqualToView(view)
                .widthIs(CA_H_LINE_Thickness);
                
                [view addSubview:self.datePicker];
                self.datePicker.sd_layout
                .widthIs(CA_H_SCREEN_WIDTH)
                .heightIs(264*CA_H_RATIO_WIDTH)
                .topSpaceToView(line, 0)
                .leftSpaceToView(vLine,0);
            }break;
        }
    }
    return _screeningView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        UIButton *btn = [UIButton new];
        _cancelBtn = btn;
        
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn setTitleColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
        btn.titleLabel.font = CA_H_FONT_PFSC_Regular(16);
    }
    return _cancelBtn;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        UIButton *btn = [UIButton new];
        _sureBtn = btn;
        
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [btn setTitleColor:CA_H_TINTCOLOR forState:UIControlStateNormal];
        btn.titleLabel.font = CA_H_FONT_PFSC_Regular(16);
    }
    return _sureBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [UILabel new];
        _titleLabel = label;
        
        label.textAlignment = NSTextAlignmentCenter;
        label.font = CA_H_FONT_PFSC_Regular(16);
        label.textColor = CA_H_9GRAYCOLOR;
        switch (_type) {
            case ScreeningTypeUesr:
                label.text = @"筛选参与人";
                break;
            default:
                label.text = @"筛选时间";
                break;
        }
    }
    return _titleLabel;
}

- (UIButton *)resetBtn {
    if (!_resetBtn) {
        UIButton *btn = [UIButton new];
        _resetBtn = btn;
        
        [btn setTitle:@"重置" forState:UIControlStateNormal];
        [btn setTitleColor:UIColorHex(0x9E9E9E) forState:UIControlStateNormal];
        btn.titleLabel.font = CA_H_FONT_PFSC_Regular(14);
        
        btn.layer.borderWidth = CA_H_LINE_Thickness;
        btn.layer.borderColor = CA_H_BACKCOLOR.CGColor;
        btn.layer.cornerRadius = 4*CA_H_RATIO_WIDTH;
        btn.layer.masksToBounds = true;
    }
    return _resetBtn;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        UIPickerView *picker = [UIPickerView new];
        _pickerView = picker;
    }
    return _pickerView;
}

- (UIDatePicker *)datePicker{
    if (!_datePicker) {
        UIDatePicker * datePicker = [UIDatePicker new];
        _datePicker = datePicker;
        
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        //设置地区: zh-中国
        datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
//        _datePicker.minimumDate = [NSDate date];
        //监听DataPicker的滚动
        
    }
    return _datePicker;
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [UITableView newTableViewPlain];
        _tableView = tableView;
        
        [tableView registerClass:[CA_HUserScreeningCell class] forCellReuseIdentifier:@"cell"];
        
        tableView.allowsMultipleSelection = YES;
        tableView.rowHeight = 52*CA_H_RATIO_WIDTH;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.contentInset = UIEdgeInsetsMake(0, 0, CA_H_MANAGER.xheight, 0);
    }
    return _tableView;
}
#pragma mark --- LifeCircle

#pragma mark --- Custom

#pragma mark --- Delegate


@end
