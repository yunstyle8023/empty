//
//  CA_MChangeNumberVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/25.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MChangeNumberVC.h"
#import "CA_MBandingNumberVC.h"

@interface CA_MChangeNumberVC ()
@property (nonatomic,strong) UITextField *txtField;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIButton* changeBtn;
@end

@implementation CA_MChangeNumberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"绑定手机";
    [self.view addSubview:self.txtField];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.changeBtn];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.txtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(20);
        make.trailing.mas_equalTo(self.view).offset(-20);
        make.top.mas_equalTo(self.view);
        make.height.mas_equalTo(60);
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.txtField);
        make.trailing.mas_equalTo(self.txtField);
        make.top.mas_equalTo(self.txtField.mas_bottom);
        make.height.mas_equalTo(CA_H_LINE_Thickness);
    }];

    [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(20);
        make.trailing.mas_equalTo(self.view).offset(-20);
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(40);
        make.height.mas_equalTo(48);
    }];
    
}


-(void)changeNumberAction{
    CA_MBandingNumberVC* bandingVC = [CA_MBandingNumberVC new];
    bandingVC.navigationTitle = @"绑定手机";
    bandingVC.buttonTitle = @"绑定新号码";
    bandingVC.changeNumber = YES;
    CA_H_WeakSelf(self)
    bandingVC.block = ^{
        CA_H_StrongSelf(self)
      [self.navigationController popViewControllerAnimated:NO];
    };
    [self.navigationController pushViewController:bandingVC animated:YES];
}



-(UITextField *)txtField{
    if (_txtField) {
        return _txtField;
    }
    _txtField = [[UITextField alloc] init];
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:self.numberStr];
    [attrString addAttribute:NSForegroundColorAttributeName value:CA_H_9GRAYCOLOR range:NSMakeRange(0, attrString.length)];
    [attrString addAttribute:NSFontAttributeName value:CA_H_FONT_PFSC_Regular(16) range:NSMakeRange(0, attrString.length)];
    _txtField.attributedPlaceholder = attrString;
    _txtField.textColor = CA_H_4BLACKCOLOR;
    _txtField.font = CA_H_FONT_PFSC_Regular(16);
    _txtField.enabled = NO;
    return _txtField;
}
-(UIView *)lineView{
    if (_lineView) {
        return _lineView;
    }
    _lineView = [UIView new];
    _lineView.backgroundColor = CA_H_BACKCOLOR;
    return _lineView;
}
-(UIButton *)changeBtn{
    if (_changeBtn) {
        return _changeBtn;
    }
    _changeBtn = [[UIButton alloc] init];
    [_changeBtn configTitle:@"更改手机号" titleColor:kColor(@"#FFFFFF") font:18];
    _changeBtn.backgroundColor = CA_H_TINTCOLOR;
    _changeBtn.layer.cornerRadius = 4;
    _changeBtn.layer.masksToBounds = YES;
    [_changeBtn addTarget:self action:@selector(changeNumberAction) forControlEvents:UIControlEventTouchUpInside];
    return _changeBtn;
}
@end
