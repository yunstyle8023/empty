
//
//  CA_MDiscoverProjectH5VC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/31.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverProjectH5VC.h"

@interface CA_MDiscoverProjectH5VC ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation CA_MDiscoverProjectH5VC

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [CA_HProgressHUD hideHud:self.webView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [CA_HProgressHUD hideHud:self.webView];
}
-(UIWebView *)webView{
    if (_webView) {
        return _webView;
    }
    _webView = [[UIWebView alloc] init];
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    _webView.backgroundColor = kColor(@"#FFFFFF");
    [CA_HProgressHUD loading:_webView];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [_webView loadRequest:request];
    return _webView;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.absoluteString hasPrefix:@"itms-appss://"]) {
        [CA_HProgressHUD hideHud:self.webView];
        [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(NO) afterDelay:0.25];
    }
    return YES;
}

@end
