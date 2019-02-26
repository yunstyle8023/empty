//
//  CA_HShowWebViewController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HShowWebViewController.h"

@interface CA_HShowWebViewController () <UIWebViewDelegate>

@end

@implementation CA_HShowWebViewController

#pragma mark --- Action

#pragma mark --- Lazy

- (UIWebView *)webView {
    if (!_webView) {
        UIWebView *webView = [UIWebView new];
        _webView = webView;
        
        webView.delegate = self;
        webView.backgroundColor = CA_H_BACKCOLOR;
        webView.scalesPageToFit = YES;
        
        webView.scrollView.contentInset = UIEdgeInsetsMake(15*CA_H_RATIO_WIDTH, 15*CA_H_RATIO_WIDTH, 15*CA_H_RATIO_WIDTH+CA_H_MANAGER.xheight, 15*CA_H_RATIO_WIDTH);
        
        [self.view addSubview:webView];
    }
    return _webView;
}

#pragma mark --- LifeCircle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self upView];
}

#pragma mark --- Custom

- (void)upView {
//    self.view.backgroundColor = CA_H_BACKCOLOR;
    self.webView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

#pragma mark --- WebView

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [CA_HProgressHUD hideHud:self.view];
}

@end
