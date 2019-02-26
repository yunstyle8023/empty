
//
//  CA_MAboutVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/11.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MAboutVC.h"

@interface CA_MAboutVC ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation CA_MAboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于我们";
    [self setupUI];
    [self requestData];
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

- (void)requestData {
    [CA_HProgressHUD loading:self.view];
    [CA_HNetManager postUrlStr:CA_M_Api_About parameters:@{} callBack:^(CA_HNetModel *netModel) {
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                NSString* urlStr = [NSString stringWithFormat:@"%@%@",CA_H_SERVER_API,netModel.data[@"about_url"]];
                NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
                [self.webView loadRequest:request];
            }else{
                [CA_HProgressHUD showHudStr:netModel.errmsg];
            }
        }
//        else{
//            [CA_HProgressHUD showHudStr:netModel.errmsg];
//        }
    } progress:nil];
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
    return _webView;
}

@end
