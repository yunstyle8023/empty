//
//  CA_HFinancialDataViewManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/11.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HFinancialDataViewManager.h"

@interface CA_HFinancialDataViewManager ()

@property (nonatomic, strong) UIView *chooseView;

@end

@implementation CA_HFinancialDataViewManager

#pragma mark --- Action

- (void)onButton:(UIButton *)sender {
    
    if (sender.selected) {
        return;
    }
    
    for (UIButton *button in sender.superview.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            if (button != sender) {
                button.selected = NO;
            }
        }
    }
    sender.selected = YES;
    CA_H_WeakSelf(self);
    [UIView animateWithDuration:0.25 animations:^{
        CA_H_StrongSelf(self);
        self.chooseView.center = sender.center;
    }];
    
    
    if (self.chooseBlock) {
        self.chooseBlock(sender.tag-100);
    }
}

#pragma mark --- Lazy

- (UIView *)topView {
    if (!_topView) {
        UIView *view = [UIView new];
        _topView = view;
        
        view.backgroundColor = [UIColor whiteColor];
        
        [view addSubview:self.topButton];
        self.topButton.sd_layout
        .spaceToSuperView(UIEdgeInsetsMake(0, 100*CA_H_RATIO_WIDTH, 0, 100*CA_H_RATIO_WIDTH));
    }
    return _topView;
}

- (UIButton *)topButton {
    if (!_topButton) {
        UIButton *button = [UIButton new];
        _topButton = button;
        
        [button setImage:[UIImage imageNamed:@"shape3"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"shape4"] forState:UIControlStateSelected];
        [button setTitleColor:CA_H_4BLACKCOLOR forState:UIControlStateNormal];
        [button setTitleColor:CA_H_TINTCOLOR forState:UIControlStateSelected];
        
        button.titleLabel.font = CA_H_FONT_PFSC_Regular(14);
        
        button.titleLabel.sd_resetLayout
        .centerYEqualToView(button.titleLabel.superview)
        .centerXEqualToView(button.titleLabel).offset(-11*CA_H_RATIO_WIDTH)
        .autoHeightRatio(0);
        
        button.imageView.sd_resetLayout
        .widthIs(12*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .centerYEqualToView(button.imageView.superview)
        .leftSpaceToView(button.titleLabel, 5*CA_H_RATIO_WIDTH);
    }
    return _topButton;
}

- (UIView *)buttonView {
    if (!_buttonView) {
        UIView *view = [UIView new];
        _buttonView = view;
        
        view.backgroundColor = CA_H_F8COLOR;
        [view addSubview:self.chooseView];
        
        NSArray *titles = @[@"资产负债表",@"利润表",@"现金流量表"];
        
        CGFloat width = 335*CA_H_RATIO_WIDTH/titles.count;
        for (NSInteger i=0; i<titles.count; i++) {
            UIButton *button = [UIButton new];
            button.tag = 100+i;
            button.frame = CGRectMake(i*width, 0, width, 36*CA_H_RATIO_WIDTH);
            [view addSubview:button];
            
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button setTitleColor:CA_H_TINTCOLOR forState:UIControlStateSelected];
            [button setTitleColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
            button.titleLabel.font = CA_H_FONT_PFSC_Regular(14);
            
            [button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
            
            if (i==0) {
                button.selected = YES;
            }
        }
        
    }
    return _buttonView;
}

- (UIView *)chooseView {
    if (!_chooseView) {
        UIView *view = [UIView new];
        _chooseView = view;
        
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 4*CA_H_RATIO_WIDTH;
        view.layer.masksToBounds = YES;
        view.frame = CGRectMake(2*CA_H_RATIO_WIDTH, 2*CA_H_RATIO_WIDTH, 109*CA_H_RATIO_WIDTH, 32*CA_H_RATIO_WIDTH);
    }
    return _chooseView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [UITableView newTableViewGrouped];
        _tableView = tableView;
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.contentInset = UIEdgeInsetsMake(0, 0, CA_H_MANAGER.xheight, 0);
        
        UIView * view = [UIView new];
        view.frame = CGRectMake(0, 0, CA_H_RATIO_WIDTH, 10*CA_H_RATIO_WIDTH);
        tableView.tableHeaderView = view;
        tableView.tableFooterView = [self footerView];
        
        [tableView registerClass:[CA_HFinancialDataCell class] forCellReuseIdentifier:@"cell"];

    }
    return _tableView;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (UIView *)footerView{
    UIView * view = [UIView new];
    view.frame = CGRectMake(0, 0, CA_H_RATIO_WIDTH, 60*CA_H_RATIO_WIDTH);
    
    UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(14) color:CA_H_9GRAYCOLOR];
    
    [view addSubview:label];
    label.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(10*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH, 10*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH));
    label.text = @"注：根据该上市公司的定期报告所披露的数据展示";
    
    return view;
}

#pragma mark --- Delegate

@end
