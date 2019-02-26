//
//  CA_MRegisterSuccessVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/8/8.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MRegisterSuccessVC.h"

@interface CA_MRegisterSuccessVC ()

@end

@implementation CA_MRegisterSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *doneImg = [[UIImageView alloc] initWithImage:kImage(@"done")];
    
    UILabel *tipLb = [UILabel new];
    tipLb.textAlignment = NSTextAlignmentCenter;
    [tipLb configText:@"注册信息已提交"
            textColor:CA_H_4BLACKCOLOR
                 font:24];
    
    UILabel *messageLb = [UILabel new];
    messageLb.textAlignment = NSTextAlignmentCenter;
    [messageLb configText:@"您的注册信息已提交，将有系统工作人员在24小时内与您取得联系后为您开设账号"
                textColor:CA_H_9GRAYCOLOR
                     font:14];
    
    UIButton *loginBtn = [UIButton new];
    [loginBtn configTitle:@"返回登录"
               titleColor:CA_H_TINTCOLOR
                     font:18];
    [loginBtn addTarget:self
                 action:@selector(loginBtnAction)
       forControlEvents:UIControlEventTouchUpInside];
    
    //
    
    [self.view addSubview:doneImg];
    doneImg.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view, 80*2*CA_H_RATIO_WIDTH)
    .widthIs(25*2*CA_H_RATIO_WIDTH)
    .heightEqualToWidth();
    
    [self.view addSubview:tipLb];
    tipLb.sd_layout
    .topSpaceToView(doneImg, 13*2*CA_H_RATIO_WIDTH)
    .centerXEqualToView(self.view)
    .autoHeightRatio(0);
    [tipLb setSingleLineAutoResizeWithMaxWidth:0];
    
    [self.view addSubview:messageLb];
    messageLb.sd_layout
    .topSpaceToView(tipLb, 10*2*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.view, 10*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.view, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    
    [self.view addSubview:loginBtn];
    loginBtn.sd_layout
    .topSpaceToView(messageLb, 30*2*CA_H_RATIO_WIDTH)
    .centerXEqualToView(self.view)
    .widthIs(37*2*CA_H_RATIO_WIDTH)
    .heightIs(12*2*CA_H_RATIO_WIDTH);
    
    
}

-(void)loginBtnAction{
    
    _pushBlock?_pushBlock():nil;
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
