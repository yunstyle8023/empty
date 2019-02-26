//
//  CA_HRNAddScheduleVC.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/11/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HRNAddScheduleVC.h"

#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>

#import "CA_HRNAddScheduleM.h"

#import "CA_HDatePicker.h" //截止时间
#import "CA_HChooseParticipantsViewController.h" //添加成员

#import "CA_HRNScheduleDetailVC.h"//日程详情

#import "CA_HScheduleTool.h"//同步日历

@interface CA_HRNAddScheduleVC ()

//提醒
@property (nonatomic, strong) NSArray *remindData;
@property (nonatomic, strong) NSArray *tagData;
    
@end

@implementation CA_HRNAddScheduleVC

#pragma mark --- Action

- (void)onSave:(UIButton *)sender {
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getRNState" object:nil userInfo:nil];
}

#pragma mark --- Lazy

- (CA_HScheduleListModel *)model {
    if (!_model) {
        CA_HScheduleListModel *model = [CA_HScheduleListModel new];
        _model = model;
        
        model.isNew = YES;
    }
    return _model;
}

#pragma mark --- LifeCircle

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToEdit:) name:@"pushToEdit" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSaveData:) name:@"getSaveData" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self upView];
    // Do any additional setup after loading the view.
    
    NSMutableDictionary *props = [NSMutableDictionary new];
    if (!self.model.isNew) {
        props[@"title"] = self.model.title;
        props[@"address"] = self.model.address;
        if (self.model.start_time)
        props[@"start_time"] = [[NSDate dateWithTimeIntervalSince1970:self.model.start_time.longValue] stringWithFormat:@"MM月dd日（EE）HH:mm"];
        if (self.model.end_time)
        props[@"end_time"] = [[NSDate dateWithTimeIntervalSince1970:self.model.end_time.longValue] stringWithFormat:@"MM月dd日（EE）HH:mm"];
        if (self.model.remind_time_desc.length)
        props[@"remind_time_desc"] = [NSString stringWithFormat:@"%@前提醒", self.model.remind_time_desc];
        props[@"privacy_typ"] = self.model.privacy_typ;
        props[@"content"] = self.model.content;
        
        NSMutableArray *imgs = [NSMutableArray new];
        for (NSDictionary *dic in self.model.user_list) {
            if ([dic isKindOfClass:[NSDictionary class]]) {
//                NSString *urlStr = dic[@"avatar"];
//                urlStr = ^{
//                    if ([urlStr hasPrefix:@"http://"]
//                        ||
//                        [urlStr hasPrefix:@"https://"]) {
//                        return urlStr;
//                    }
//                    return [NSString stringWithFormat:@"%@%@", CA_H_SERVER_API, urlStr];
//                }();
//                [imgs addObject:urlStr];
                NSString *name = dic[@"name"];
                name.length>0?[imgs addObject:name]:nil;
            }
        }
        props[@"user_list"] = [imgs componentsJoinedByString:@"、"];
    } else {
        props[@"privacy_typ"] = @(1);
    }
    
    NSURL *jsCodeLocation;// = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"index.jsbundle" ofType:nil]];
    
//            jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
    
    jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/index.bundle?platform=ios"];
//    jsCodeLocation = [NSURL URLWithString:@"http://192.168.31.40:8081/index.bundle?platform=ios"];

    RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                        moduleName:@"zhongguancun_add"
                                                 initialProperties:props
                                                     launchOptions:nil];
    rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];
    rootView.frame = self.view.bounds;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rootView];
}

#pragma mark --- Custom

- (void)upView {
    UIButton * button = [UIButton new];
    
    [button setTitle:CA_H_LAN(@"保存") forState:UIControlStateNormal];
    [button setTitleColor:CA_H_TINTCOLOR forState:UIControlStateNormal];
    [button setTitleColor:CA_H_4DISABLEDCOLOR forState:UIControlStateDisabled];
    [button.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16]];
    
    button.titleLabel.sd_resetLayout
    .centerYEqualToView(button)
    .rightEqualToView(button)
    .autoHeightRatio(0);
    button.titleLabel.numberOfLines = 1;
    [button.titleLabel setMaxNumberOfLinesToShow:1];
    [button.titleLabel setSingleLineAutoResizeWithMaxWidth:70];
    
    button.frame = CGRectMake(0, 0, 70, 44);
    
    [button addTarget:self action:@selector(onSave:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)save {
    NSMutableArray *ids = [NSMutableArray new];
    for (NSDictionary *dic in self.model.user_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            id value = dic[@"id"];
            if (value) [ids addObject:value];
        }
    }
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"id"] = self.model.id;
    parameters[@"title"] = self.model.title;
    parameters[@"address"] = self.model.address;
    parameters[@"start_time"] = self.model.start_time;
    parameters[@"end_time"] = self.model.end_time;
    parameters[@"remind_time"] = self.model.remind_time;
    parameters[@"privacy_typ"] = self.model.privacy_typ;
    parameters[@"content"] = self.model.content;
    parameters[@"user_ids"] = ids;
    
    NSString *url = self.model.isNew?CA_H_Api_CreateSchedule:CA_H_Api_UpdateSchedule;
    
    [CA_HNetManager postUrlStr:url parameters:parameters callBack:^(CA_HNetModel *netModel) {
        if ([netModel.errcode isEqualToNumber:@(0)]) {
            [CA_HProgressHUD showHudStr:self.model.isNew?@"创建成功!":@"编辑成功!"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"schedule_screeningChange" object: @"refresh" userInfo:@{}];
            
            NSNumber *scheduleId = [netModel.data valueForKey:@"id"];
            CA_HRNScheduleDetailVC *vc = [CA_HRNScheduleDetailVC new];
            vc.scheduleId = scheduleId?scheduleId:self.model.id;
            
            [self.navigationController pushViewController:vc animated:YES];
            
            NSMutableArray *arr = self.navigationController.viewControllers.mutableCopy;
            if (!self.model.isNew) {
                NSInteger index = [arr indexOfObject:self];
                [arr removeObjectAtIndex:index-1];
            }
            [arr removeObject:self];
            [self.navigationController setViewControllers:arr animated:YES];
            
            if (self.model.isNew) {
                self.model.id = vc.scheduleId;
                [CA_HScheduleTool createEventCalendarWithModel:self.model];
            } else {
//                'is_participate': 1, # 1为当前用户参与了此日程；0为当前用户未参与此日程
                if ([[netModel.data valueForKey:@"is_participate"] integerValue] == 1) {
                    [CA_HScheduleTool editEventCalendarWithModel:self.model];
                } else if ([[netModel.data valueForKey:@"is_participate"] integerValue] == 0) {
                    [CA_HScheduleTool deleteEventCalendarWithId:self.model.id];
                }
            }
            return;
        }
        
        if (netModel.error.code != -999) {
            if (netModel.errmsg.length) [CA_HProgressHUD showHudStr:netModel.errmsg];
        }
        
    } progress:nil];
}

- (void)pushToPeople:(CA_HRNAddScheduleM *)manager {
    
    //    请先选择参与人
    CA_HChooseParticipantsViewController *vc = [CA_HChooseParticipantsViewController new];
    vc.title = CA_H_LAN(@"选择参与人");
    
    NSMutableArray *selectId = [NSMutableArray new];
    for (NSDictionary *dic in self.model.user_list) {
        id value = dic[@"id"];
        if (value) [selectId addObject:value];
    }
    vc.viewModel.selectId = selectId;
    vc.viewModel.projectId = @(0);
    vc.viewModel.isAll = NO;
    CA_H_WeakSelf(self);
    vc.viewModel.backBlock = ^(NSArray *peoples) {
        CA_H_StrongSelf(self);
        NSMutableArray *mut = [NSMutableArray new];
        NSMutableArray *imgs = [NSMutableArray new];
        for (CA_HParticipantsModel *mod in peoples) {
            if ([mod isKindOfClass:[CA_HParticipantsModel class]]) {
                [mut addObject:@{
                                 @"id":mod.user_id,
                                 @"name":mod.chinese_name,
                                 @"avatar":mod.avatar,
                                 }];
//                NSString *urlStr = mod.avatar;
//                urlStr = ^{
//                    if ([urlStr hasPrefix:@"http://"]
//                        ||
//                        [urlStr hasPrefix:@"https://"]) {
//                        return urlStr;
//                    }
//                    return [NSString stringWithFormat:@"%@%@", CA_H_SERVER_API, urlStr];
//                }();
//                [imgs addObject:urlStr];
                NSString *name = mod.chinese_name;
                name.length>0?[imgs addObject:name]:nil;
            }
        }
        
        self.model.user_list = mut;
        manager.callBack(@[[NSNull null], @{@"user_list":[imgs componentsJoinedByString:@"、"]}]);
    };
    
    [self.navigationController presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:^{
        
    }];
}
- (void)pushToDate:(CA_HRNAddScheduleM *)manager index:(NSNumber *)index {
    CA_H_WeakSelf(self);
    CA_HDatePicker *datePicker = [CA_HDatePicker new];
    datePicker.datePicker.minimumDate = nil;
    [datePicker presentDatePicker:CA_H_LAN([index isEqualToNumber:@(0)]?@"开始时间":@"截止时间") dateBlock:^(UIDatePicker *datePicker) {
        CA_H_StrongSelf(self);
        
        NSString *key = [index isEqualToNumber:@(0)]?@"start_time":@"end_time";
        [self.model setValue:@(datePicker.date.timeIntervalSince1970) forKey:key];
        NSString *time = [datePicker.date stringWithFormat:@"MM月dd日（EE）HH:mm"];
        manager.callBack(@[[NSNull null], @{key: time}]);
    }];
}
- (void)pushToRemind:(CA_HRNAddScheduleM *)manager {
    
    
    if (!self.remindData) {
        [CA_HProgressHUD showHud:nil];
        CA_H_WeakSelf(self);
        [self loadParams:^(BOOL success) {
            CA_H_StrongSelf(self);
            [CA_HProgressHUD hideHud];
            if (self.remindData) {
                [self pushToRemind:manager];
            }
        }];
        return;
    }
    
    CA_HDatePicker *picker = [CA_HDatePicker new];
    picker.modeToStrBlock = ^NSString *(NSDictionary *model) {
        NSString *text = model[@"remind_time_value"];
        if (text.length) {
            return [NSString stringWithFormat:@"%@前", text];
        } else {
            return @"";
        }
    };
    picker.data = @[self.remindData];
    CA_H_WeakSelf(self);
    [picker presentPickerView:@"设置提醒" pickerBlock:^(UIPickerView *pickerView) {
        CA_H_StrongSelf(self);
        NSInteger item = [pickerView selectedRowInComponent:0];
        
        self.model.remind_time = self.remindData[item][@"remind_time"];
        self.model.remind_time_desc = self.remindData[item][@"remind_time_value"];
        manager.callBack(@[[NSNull null], @{@"remind_time_desc": [NSString stringWithFormat:@"%@前提醒", self.remindData[item][@"remind_time_value"]]}]);
    }];
}
- (void)loadParams:(void (^)(BOOL success))block {
    CA_H_WeakSelf(self);
    [CA_HTodoNetModel listTaskParams:^(CA_HNetModel *netModel) {
        CA_H_StrongSelf(self);
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]]) {
                    
                    self.remindData = netModel.data[@"remind_data"];
                    self.tagData = netModel.data[@"tag_data"];
                    
                    if (block) block(YES);
                    return;
                }
            }
        }
        
        if (block) block(NO);
        
        if (netModel.error.code != -999) {
            if (netModel.errmsg.length) [CA_HProgressHUD showHudStr:netModel.errmsg];
        }
    }];
}

#pragma mark --- Delegate

- (void)pushToEdit:(NSNotification *)notification {
    NSString *nameString = [notification name];
    id object = [notification object];
    NSDictionary *dictionary = [notification userInfo];//为nil要有这行代码哦
    // 当你拿到这些数据的时候你可以去做一些操作
    
    NSNumber *index = dictionary[@"index"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (index.integerValue) {
            case 0:
            case 1:
                [self pushToDate:object index:index];
                break;
            case 2:
                [self pushToPeople:object];
                break;
            case 3:
                [self pushToRemind:object];
                break;
            default:
                break;
        }
    });
    
}

- (void)getSaveData:(NSNotification *)notification {
    NSString *nameString = [notification name];
    id object = [notification object];
    NSDictionary *dictionary = [notification userInfo];//为nil要有这行代码哦
    // 当你拿到这些数据的时候你可以去做一些操作
    
    NSString *title = dictionary[@"title"];
    if (!title.length) {
        [CA_HProgressHUD showHudStr:@"请输入日程标题!"];
        return;
    }
    if (title.length > 20) {
        [CA_HProgressHUD showHudStr:@"日程标题限定20字!"];
        return;
    }
    self.model.title = title;
    
    if (!self.model.start_time||!self.model.end_time) {
        [CA_HProgressHUD showHudStr:@"请设定起止时间!"];
        return;
    }
    
    if (self.model.start_time.doubleValue>self.model.end_time.doubleValue) {
        [CA_HProgressHUD showHudStr:@"截止时间不得早于开始时间!"];
        return;
    }
    
//    if (!self.model.user_list.count) {
//        [CA_HProgressHUD showHudStr:@"请选择参与人!"];
//        return;
//    }
    
    NSString *address = dictionary[@"address"];
    if (address.length > 20) {
        [CA_HProgressHUD showHudStr:@"地点限定20字!"];
        return;
    }
    self.model.address = address;
    
    NSString *content = dictionary[@"content"];
    if (content.length >300) {
        [CA_HProgressHUD showHudStr:@"内容限定300字!"];
        return;
    }
    self.model.content = content;
    
    NSNumber *privacy_typ = dictionary[@"privacy_typ"];
    if ([privacy_typ isKindOfClass:[NSNumber class]])
        self.model.privacy_typ = privacy_typ;
    
    
    [self save];
}

@end
