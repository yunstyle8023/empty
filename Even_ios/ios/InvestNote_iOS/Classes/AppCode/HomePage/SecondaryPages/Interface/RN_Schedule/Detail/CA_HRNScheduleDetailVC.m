//
//  CA_HRNScheduleDetailVC.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/11/19.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HRNScheduleDetailVC.h"

#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>

#import "CA_HRNAddScheduleVC.h"

#import "CA_HScheduleTool.h"

@interface CA_HRNScheduleDetailVC ()

@end

@implementation CA_HRNScheduleDetailVC

#pragma mark --- Action

- (void)onEdit:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    
    CA_HRNAddScheduleVC *vc = [CA_HRNAddScheduleVC new];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
    
    sender.userInteractionEnabled = YES;
}

- (void)onDelete:(UIButton *)sender {
    
    CA_H_WeakSelf(self);
    [self presentAlertTitle:nil message:CA_H_LAN(@"是否确认删除该日程？") buttons:@[CA_H_LAN(@"取消"), CA_H_LAN(@"确认")] clickBlock:^(UIAlertController *alert, NSInteger index) {
        if (index == 1) {
            CA_H_StrongSelf(self);
            [self deleteSchedule];
        }
    }];
}

#pragma mark --- Lazy

#pragma mark --- LifeCircle

- (void)dealloc
{
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [CA_HProgressHUD loading:self.view];
    [self postDetail];
    
    
}

#pragma mark --- Custom

- (void)postDetail {
    if (!self.scheduleId) {
        [CA_HProgressHUD hideHud:self.view];
        return;
    }
    CA_H_WeakSelf(self);
    [CA_HNetManager postUrlStr:CA_H_Api_Schedule parameters:@{@"id":self.scheduleId} callBack:^(CA_HNetModel *netModel) {
        CA_H_StrongSelf(self);
        if ([netModel.errcode isEqualToNumber:@(0)]) {
            if ([netModel.data isKindOfClass:[NSDictionary class]]) {
                self.model = [CA_HScheduleListModel modelWithDictionary:netModel.data];
                [self loadDetail];
            }
        }
        
        [CA_HProgressHUD hideHud:self.view];
    } progress:nil];
}

- (void)loadDetail {
    
    NSMutableDictionary *props = [NSMutableDictionary new];
    props[@"title"] = self.model.title;
    props[@"address"] = self.model.address.length?self.model.address:@"未设置地点";
    if (self.model.start_time)
        props[@"start_time"] = [[NSDate dateWithTimeIntervalSince1970:self.model.start_time.longValue] stringWithFormat:@"MM月dd日（EE）HH:mm"];
    if (self.model.end_time)
        props[@"end_time"] = [[NSDate dateWithTimeIntervalSince1970:self.model.end_time.longValue] stringWithFormat:@"MM月dd日（EE）HH:mm"];
    if (self.model.remind_time_desc.length)
        props[@"remind_time_desc"] = [NSString stringWithFormat:@"%@前提醒", self.model.remind_time_desc];
    else
        props[@"remind_time_desc"] = @"未设置提醒";
    props[@"privacy_typ"] = self.model.privacy_typ;
    props[@"content"] = self.model.content.length?self.model.content:@"未填写内容";
    
    NSMutableArray *imgs = [NSMutableArray new];
    for (NSDictionary *dic in self.model.user_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
//            NSString *urlStr = dic[@"avatar"];
//            urlStr = ^{
//                if ([urlStr hasPrefix:@"http://"]
//                    ||
//                    [urlStr hasPrefix:@"https://"]) {
//                    return urlStr;
//                }
//                return [NSString stringWithFormat:@"%@%@", CA_H_SERVER_API, urlStr];
//            }();
//            [imgs addObject:urlStr];
            NSString *name = dic[@"name"];
            name.length>0?[imgs addObject:name]:nil;
        }
    }
    props[@"user_list"] = [imgs componentsJoinedByString:@"、"];
    NSMutableArray *logs = [NSMutableArray new];
    for (NSDictionary *dic in self.model.logs) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            if (dic[@"content"])
                [logs addObject:dic[@"content"]];
        }
    }
    props[@"logs"] = logs;
    
    CA_H_DISPATCH_MAIN_THREAD(^{
        [self upView:props];
    });
}

- (void)upView:(NSDictionary *)props {
    
    NSURL *jsCodeLocation ;//= [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"index.jsbundle" ofType:nil]];
    
//            jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
    
    
    jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/index.bundle?platform=ios"];
//    jsCodeLocation = [NSURL URLWithString:@"http://192.168.31.40:8081/index.bundle?platform=ios"];
    
    RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                        moduleName:@"zhongguancun_detail"
                                                 initialProperties:props
                                                     launchOptions:nil];
    rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];
    
    

    if (self.model.editable.integerValue == 1) {
        UIView *backView = [UIView new];
        backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:backView];
        [self addBottomView];
        CA_H_WeakSelf(rootView);
        backView.didFinishAutoLayoutBlock = ^(CGRect frame) {
            CA_H_StrongSelf(rootView);
            rootView.frame = frame;
        };
        backView.sd_layout
        .topEqualToView(self.contentView)
        .leftEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .bottomSpaceToView(self.contentView, 48*CA_H_RATIO_WIDTH);
        [backView addSubview:rootView];

        
    } else {
        [self.contentView addSubview:rootView];
        rootView.sd_layout
        .spaceToSuperView(UIEdgeInsetsZero);
    }
}

- (UIView *)addBottomView {
    
    CALayer *layer = [CALayer layer];
    
    layer.backgroundColor=[UIColor whiteColor].CGColor;//shadowColor.CGColor;
    layer.masksToBounds = NO;
    layer.shadowColor = CA_H_SHADOWCOLOR.CGColor;//shadowColor阴影颜色
    layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
    layer.shadowOpacity = 0.5;//阴影透明度，默认0
    layer.shadowRadius = 4*CA_H_RATIO_WIDTH;//阴影半径，默认3
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    
    [self.contentView.layer addSublayer:layer];
    [self.contentView addSubview:view];
    view.didFinishAutoLayoutBlock = ^(CGRect frame) {
        layer.frame = frame;
    };
    view.sd_layout
    .heightIs(48*CA_H_RATIO_WIDTH)
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView);
    
    UIButton *edit = [UIButton new];
    [edit setImage:[UIImage imageNamed:@"edit_icon"] forState:UIControlStateNormal];
    [edit addTarget:self action:@selector(onEdit:) forControlEvents:UIControlEventTouchUpInside];
    edit.imageView.size = CGSizeMake(24*CA_H_RATIO_WIDTH, 24*CA_H_RATIO_WIDTH);
    
    UIButton *delete = [UIButton new];
    [delete setImage:[UIImage imageNamed:@"delete2"] forState:UIControlStateNormal];
    [delete addTarget:self action:@selector(onDelete:) forControlEvents:UIControlEventTouchUpInside];
    delete.imageView.size = CGSizeMake(24*CA_H_RATIO_WIDTH, 24*CA_H_RATIO_WIDTH);
    
    [view addSubview:edit];
    [view addSubview:delete];
    
    edit.sd_layout
    .topEqualToView(view)
    .leftEqualToView(view)
    .bottomEqualToView(view)
    .widthRatioToView(view, 0.5);
    
    delete.sd_layout
    .topEqualToView(view)
    .rightEqualToView(view)
    .bottomEqualToView(view)
    .widthRatioToView(view, 0.5);
    
    return view;
}

- (void)deleteSchedule {
    [CA_HProgressHUD showHud:@""];
    CA_H_WeakSelf(self);
    [CA_HNetManager postUrlStr:CA_H_Api_DeleteSchedule parameters:@{@"id":self.scheduleId} callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud];
        CA_H_StrongSelf(self);
        if ([netModel.errcode isEqualToNumber:@(0)]) {
            [CA_HProgressHUD showHudStr:@"删除成功!"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"schedule_screeningChange" object: @"refresh" userInfo:@{}];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            [CA_HScheduleTool deleteEventCalendarWithId:self.model.id];
            return;
        }
        if (netModel.error.code != -999) {
            if (netModel.errmsg.length) [CA_HProgressHUD showHudStr:netModel.errmsg];
        }
    } progress:nil];
}

#pragma mark --- Delegate


@end
