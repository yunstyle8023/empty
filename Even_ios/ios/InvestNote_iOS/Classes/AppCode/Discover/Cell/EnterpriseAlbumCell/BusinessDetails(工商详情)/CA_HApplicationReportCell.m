//
//  CA_HApplicationReportCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/9.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HApplicationReportCell.h"

#import "CA_HEnterpriseBusinessInfoModel.h"
#import "CA_HCustomAlert.h"//申请报告

@interface CA_HApplicationReportCell ()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *alertView;

@end

@implementation CA_HApplicationReportCell

#pragma mark --- Action

- (void)setModel:(CA_HEnterpriseCreditreport *)model {
    [super setModel:model];
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    [text appendString:@"（今天还剩  次机会）"];
    text.color = UIColorHex(0x414042);
    
    NSMutableAttributedString *countText = [NSMutableAttributedString new];
    [countText appendString:(model.collect_count.stringValue)];
    countText.color = CA_H_TINTCOLOR;
    
    [text insertAttributedString:countText atIndex:6];
    text.font = CA_H_FONT_PFSC_Regular(14);
    text.alignment = NSTextAlignmentCenter;
    
    self.label.attributedText = text;
    
    self.button.enabled = model.collect_count.boolValue;
}

- (void)onButton:(UIButton *)sender {
    
    CA_HEnterpriseCreditreport *model = self.model;
    NSDictionary *parameters =
    @{@"enterprise_id": model.enterprise_id?:@"",
      @"enterprise_name": model.enterprise_name?:@"",
      @"order_no": model.order_no?:@""};
    [CA_HProgressHUD showHud:nil];
    CA_H_WeakSelf(self);
    [CA_HNetManager postUrlStr:CA_H_Api_SendCreditReport parameters:parameters callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud];
        CA_H_StrongSelf(self);
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0
                &&
                [netModel.data isKindOfClass:[NSDictionary class]]) {
                
                [self.model modelSetWithDictionary:netModel.data];
                self.model = self.model;
                
                [CA_HCustomAlert alertView:self.alertView];
                return;
            }
        }
        
        if (netModel.error.code != -999) {
            if (netModel.errmsg) [CA_HProgressHUD showHudStr:netModel.errmsg];
        }
    } progress:nil];
}

- (void)onJump:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    [CA_HCustomAlert hide:YES];
    if (self.block) {
        self.block();
    }
    sender.userInteractionEnabled = YES;
}

#pragma mark --- Lazy

- (UIView *)alertView {
    if (!_alertView) {
        UIView *view = [UIView new];
        _alertView = view;
        
        view.frame = CGRectMake(0, 0, 275*CA_H_RATIO_WIDTH, 184*CA_H_RATIO_WIDTH);
        
        UILabel *titleLabel = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Medium(20) color:CA_H_4BLACKCOLOR];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"报告申请成功";
        [view addSubview:titleLabel];
        titleLabel.sd_layout
        .heightIs(28*CA_H_RATIO_WIDTH)
        .topSpaceToView(view, 30*CA_H_RATIO_WIDTH)
        .leftEqualToView(view)
        .rightEqualToView(view);
        
        UILabel *contentLabel = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(16) color:CA_H_4BLACKCOLOR];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.text = @"请到下载中心查看报告状态。";
        [view addSubview:contentLabel];
        contentLabel.sd_layout
        .heightIs(22*CA_H_RATIO_WIDTH)
        .topSpaceToView(titleLabel, 15*CA_H_RATIO_WIDTH)
        .leftEqualToView(view)
        .rightEqualToView(view);
        
        UIButton *button = [UIButton new];
        [button addTarget:self action:@selector(onJump:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor:CA_H_TINTCOLOR];
        button.layer.cornerRadius = 4*CA_H_RATIO_WIDTH;
        button.layer.masksToBounds = YES;
        [button setTitle:@"去看看" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = CA_H_FONT_PFSC_Regular(15);
        [view addSubview:button];
        button.sd_layout
        .widthIs(96*CA_H_RATIO_WIDTH)
        .heightIs(39*CA_H_RATIO_WIDTH)
        .centerXEqualToView(view)
        .topSpaceToView(contentLabel, 30*CA_H_RATIO_WIDTH);
    }
    return _alertView;
}

- (UIButton *)button {
    if (!_button) {
        UIButton *button = [UIButton new];
        _button = button;
        
        [button setBackgroundImage:[UIImage imageWithColor:CA_H_TINTCOLOR] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:CA_H_BACKCOLOR] forState:UIControlStateDisabled];
        [button setTitle:@"申请报告" forState:UIControlStateNormal];
        button.titleLabel.font = CA_H_FONT_PFSC_Regular(16);
        [button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UILabel *)label {
    if (!_label) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(14) color:UIColorHex(0x414042)];
        _label = label;
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)upView {
    [super upView];
    
    UILabel *titleLabel = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(18) color:UIColorHex(0x414042)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"企业信用决策报告";
    [self.backView addSubview:titleLabel];
    titleLabel.sd_layout
    .heightIs(25*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.backView, 15*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.backView, 15*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.backView, 15*CA_H_RATIO_WIDTH);
    
    
    UILabel *textLabel = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(14) color:CA_H_4BLACKCOLOR];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.numberOfLines = 0;
    textLabel.isAttributedContent = YES;
    [self.backView addSubview:textLabel];
    textLabel.sd_layout
    .heightIs(78*CA_H_RATIO_WIDTH)
    .widthIs(305*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.backView, 50*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.backView, 15*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.backView, 15*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    [text appendString:@"点击“申请报告”获取第三方提供的企业信用报告，多维度企业评级评分，以可视化图表方式呈现全方位的企业信用决策报告信息。"];
    text.lineSpacing = 6*CA_H_RATIO_WIDTH;
    text.color = CA_H_4BLACKCOLOR;
    text.font = CA_H_FONT_PFSC_Regular(14);
    text.alignment = NSTextAlignmentCenter;
    textLabel.attributedText = text;
    
    [self.backView addSubview:self.button];
    self.button.sd_layout
    .widthIs(114*CA_H_RATIO_WIDTH)
    .heightIs(42*CA_H_RATIO_WIDTH)
    .bottomSpaceToView(self.backView, 45*CA_H_RATIO_WIDTH)
    .centerXEqualToView(self.backView);
    self.button.sd_cornerRadius = @(4*CA_H_RATIO_WIDTH);
    
    [self.backView addSubview:self.label];
    self.label.sd_layout
    .heightIs(20*CA_H_RATIO_WIDTH)
    .bottomSpaceToView(self.backView, 15*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.backView, 15*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.backView, 15*CA_H_RATIO_WIDTH);
}

#pragma mark --- Delegate

@end
