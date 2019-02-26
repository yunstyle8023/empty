//
//  CA_HSearchReportViewManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/18.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HSearchReportViewManager.h"

#import "CA_HNullView.h"

@interface CA_HSearchReportViewManager ()

@property (nonatomic, strong) UIView *chooseView;

@end

@implementation CA_HSearchReportViewManager

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

- (UITextField *)titleView {
    if (!_titleView) {
        UITextField *textField = [UITextField new];
        _titleView = textField;
        
        textField.frame = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, 20);
        
        textField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        textField.textColor = CA_H_4BLACKCOLOR;
        textField.placeholder = @"请输入关键字";
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
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.contentInset = UIEdgeInsetsMake(0, 0, CA_H_MANAGER.xheight, 0);
        tableView.rowHeight = 65*CA_H_RATIO_WIDTH;
        tableView.backgroundView = [CA_HNullView newTitle:@"没有搜索到相关报告" buttonTitle:nil top:136*CA_H_RATIO_WIDTH onButton:nil imageName:nil];
        
        [tableView registerClass:NSClassFromString(@"CA_HFoundReportCell") forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (UIView *)buttonView {
    if (!_buttonView) {
        UIView *view = [UIView new];
        _buttonView = view;
        
        view.backgroundColor = CA_H_F8COLOR;
        [view addSubview:self.chooseView];
        
        NSArray *titles = @[@"精选报告",@"海量报告"];
        
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
        view.frame = CGRectMake(2*CA_H_RATIO_WIDTH, 2*CA_H_RATIO_WIDTH, 165*CA_H_RATIO_WIDTH, 32*CA_H_RATIO_WIDTH);
    }
    return _chooseView;
}

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

- (UITableViewHeaderFooterView *)searchHeader:(NSString *)text {
    UITableViewHeaderFooterView *header = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (!header) {
        header = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"header"];
        UILabel *label = [UILabel new];
        label.tag = 101;
        [header addSubview:label];
        label.sd_layout
        .widthIs(200*CA_H_RATIO_WIDTH)
        .heightIs(17*CA_H_RATIO_WIDTH)
        .topSpaceToView(header, 15*CA_H_RATIO_WIDTH)
        .leftSpaceToView(header, 20*CA_H_RATIO_WIDTH);
        [CA_HFoundFactoryPattern lineWithView:header left:20*CA_H_RATIO_WIDTH right:0];
    }
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[text dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    attrStr.font = CA_H_FONT_PFSC_Regular(12);
    
    UILabel *label = [header viewWithTag:101];
    label.attributedText = attrStr;
    
    return header;
}

@end
