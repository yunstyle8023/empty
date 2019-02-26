//
//  CA_HCurrentSearchViewManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/24.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HCurrentSearchViewManager.h"

@interface CA_HCurrentSearchViewManager ()

@end

@implementation CA_HCurrentSearchViewManager

#pragma mark --- Action

#pragma mark --- Lazy

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (UIBarButtonItem *)rightBarButtonItem:(id)target action:(SEL)action {
    UIButton * rightBtn = [UIButton new];
    rightBtn.frame = CGRectMake(0, 0, 32, 44);
    
    [rightBtn setTitle:CA_H_LAN(@"取消") forState:UIControlStateNormal];
    [rightBtn setTitleColor:CA_H_4BLACKCOLOR forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16]];
    [rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    rightBtn.titleLabel.sd_resetLayout
    .centerYEqualToView(rightBtn)
    .rightEqualToView(rightBtn)
    .autoHeightRatio(0);
    
    return [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}

- (UITextField *)titleView {
    if (!_titleView) {
        UITextField *textField = [UITextField new];
        _titleView = textField;
        
        textField.frame = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, 20);
        
        textField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        textField.textColor = CA_H_4BLACKCOLOR;
        textField.placeholder = CA_H_LAN(@"搜索");
        textField.returnKeyType = UIReturnKeySearch;
        textField.clearButtonMode = UITextFieldViewModeAlways;
        
        textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15*CA_H_RATIO_WIDTH, 20)];
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _titleView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [UITableView newTableViewGrouped];
        _tableView = tableView;
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, CA_H_MANAGER.xheight, 0);
    }
    return _tableView;
}

#pragma mark --- Delegate

@end
