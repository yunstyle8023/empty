
//
//  CA_MTryH5VC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/26.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MTryH5VC.h"

@interface CA_MTryH5VC ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webView;

@end

@implementation CA_MTryH5VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"申请试用";
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.2];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)setupUI{
    [self.view addSubview:self.webView];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [CA_HProgressHUD loading:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [CA_HProgressHUD hideHud:self.view];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [CA_HProgressHUD hideHud:self.view];
}

-(UIWebView *)webView{
    if (_webView) {
        return _webView;
    }
    _webView = [[UIWebView alloc] init];
    _webView.delegate = self;
    _webView.backgroundColor = kColor(@"#FFFFFF");
    NSString* urlStr = @"https://cn.mikecrm.com/OmmOAMl";
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [_webView loadRequest:request];
    return _webView;
}

@end
