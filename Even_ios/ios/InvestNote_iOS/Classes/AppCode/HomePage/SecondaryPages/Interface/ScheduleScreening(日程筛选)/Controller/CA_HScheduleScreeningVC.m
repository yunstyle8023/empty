//
//  CA_HScheduleScreeningVC.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/11/14.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HScheduleScreeningVC.h"

#import "CA_HScheduleScreeningMM.h"
#import "CA_HScheduleScreeningVM.h"

@interface CA_HScheduleScreeningVC () <UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CA_HScheduleScreeningMM *modelM;
@property (nonatomic, strong) CA_HScheduleScreeningVM *viewM;

@end

@implementation CA_HScheduleScreeningVC

#pragma mark --- Action

- (void)onClose:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"schedule_screeningChange" object: @"close" userInfo:@{}];
    [self close];
}

- (void)onReset:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"schedule_screeningChange" object: @"reset" userInfo:@{}];
    [self close];
}

- (void)onSure:(UIButton *)sender {
    
    NSInteger row = [self.viewM.pickerView selectedRowInComponent:0];
    if (row == 0) {
        self.modelM.startDate = self.viewM.datePicker.date;
    } else if (row == 1){
        self.modelM.endDate = self.viewM.datePicker.date;
    }
    
    if (self.modelM.startDate&&self.modelM.endDate) {
        NSTimeInterval start = [self.modelM.startDate timeIntervalSince1970];
        NSTimeInterval end = [self.modelM.endDate timeIntervalSince1970];
        if (start <= end) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"schedule_screeningChange" object: @"sure" userInfo:@{@"start":self.modelM.startDate, @"end":self.modelM.endDate}];
            [self close];
            return;
        }
        [CA_HProgressHUD showHudStr:@"截止时间不得早于开始时间!"];
        return;
    }
    [CA_HProgressHUD showHudStr:@"请选择筛选的起止时间!"];
}

- (void)close {
    [UIView animateWithDuration:0.25 animations:^{
        self.viewM.screeningView.top = self.view.bottom;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (void)onUserSure:(UIButton *)sender {
    NSMutableArray *userIds = [NSMutableArray new];
    for (NSIndexPath *indexPath in self.viewM.tableView.indexPathsForSelectedRows) {
        [userIds addObject:self.modelM.data[indexPath.row]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"schedule_screeningChange" object: @"user_sure" userInfo:@{@"user_ids":userIds}];
    [self close];
}

#pragma mark --- Lazy

- (CA_HScheduleScreeningMM *)modelM {
    if (!_modelM) {
        CA_HScheduleScreeningMM *object = [CA_HScheduleScreeningMM new];
        _modelM = object;
    }
    return _modelM;
}

- (CA_HScheduleScreeningVM *)viewM {
    if (!_viewM) {
        CA_HScheduleScreeningVM *object = [CA_HScheduleScreeningVM new];
        _viewM = object;
        
        if ([self.modelM.objectString isEqualToString:@"time_screening"]) {
            
            object.type = ScreeningTypeTime;
            
            object.pickerView.dataSource = self;
            object.pickerView.delegate = self;
        } else if ([self.modelM.objectString isEqualToString:@"user_screening"]) {
            
            object.type = ScreeningTypeUesr;
            
            object.tableView.dataSource = self;
            object.tableView.delegate = self;
            
            [CA_HProgressHUD showHud:object.tableView text:nil];
            CA_H_WeakSelf(self);
            [self.modelM postlistCompanyUser:^(CA_HNetModel * _Nonnull netModel) {
                if (netModel.type == CA_H_NetTypeSuccess) {
                    if (netModel.errcode.integerValue == 0) {
                        if ([netModel.data isKindOfClass:[NSArray class]]) {
                            NSMutableArray *selects = [NSMutableArray new];
                            [self.modelM.data removeAllObjects];
                            for (NSDictionary *dic in netModel.data) {
                                CA_HParticipantsModel *model = [CA_HParticipantsModel modelWithDictionary:dic];
                                if (self.modelM.userIds) {
                                    if ([self.modelM.userIds containsObject:model.user_id]) {
                                        [selects addObject:[NSIndexPath indexPathForRow:self.modelM.data.count inSection:0]];
                                    }
                                }
                                [self.modelM.data addObject:model];
                            }
                            
                            CA_H_DISPATCH_MAIN_THREAD(^{
                                CA_H_StrongSelf(self);
                                [self.viewM.tableView reloadData];
                                for (NSIndexPath *indexPath in selects) {
                                    [self.viewM.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                                }
                            });
                        }
                    }
                }
                [CA_HProgressHUD hideHud:object.tableView];
            }];
        }
    }
    return _viewM;
}

#pragma mark --- LifeCircle

- (instancetype)initWithObjectString:(NSString *)objectString userIds:(nonnull NSArray *)userIds
{
    self = [super init];
    if (self) {
        [self upConfig];
        self.modelM.objectString = objectString;
        self.modelM.userIds = userIds;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self upView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIView animateWithDuration:0.25 animations:^{
        self.viewM.screeningView.bottom = self.view.bottom;
    }];
}

#pragma mark --- Custom

- (void)setStart:(NSNumber *)start end:(NSNumber *)end {
    
}

- (void)upConfig {
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
}

- (void)upView {
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
    [self.view addSubview:self.viewM.screeningView];
    self.viewM.screeningView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(378*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight);
    self.viewM.screeningView.top = self.view.bottom;
    
    [self.viewM.cancelBtn addTarget:self action:@selector(onClose:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.modelM.objectString isEqualToString:@"time_screening"]) {
        [self.viewM.sureBtn addTarget:self action:@selector(onSure:) forControlEvents:UIControlEventTouchUpInside];
        [self.viewM.resetBtn addTarget:self action:@selector(onReset:) forControlEvents:UIControlEventTouchUpInside];
    } else if ([self.modelM.objectString isEqualToString:@"user_screening"]) {
        [self.viewM.sureBtn addTarget:self action:@selector(onUserSure:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

#pragma mark --- Picker

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 2;
}

// returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return CA_H_SCREEN_WIDTH/2;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 52*CA_H_RATIO_WIDTH;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (row == 0) {
        return @"开始时间";
    }
    return @"结束时间";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row == 1) {
        self.modelM.startDate = self.viewM.datePicker.date;
        self.viewM.datePicker.minimumDate = self.modelM.startDate;
        if (self.modelM.endDate) {
            self.viewM.datePicker.date = self.modelM.endDate;
        }
    } else {
        self.modelM.endDate = self.viewM.datePicker.date;
        self.viewM.datePicker.minimumDate = nil;
        if (self.modelM.startDate) {
            self.viewM.datePicker.date = self.modelM.startDate;
        }
    }
}

#pragma mark --- Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelM.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CA_HUserScreeningCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = self.modelM.data[indexPath.row];
    return cell;
}

@end
