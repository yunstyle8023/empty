//
//  CA_MNewSearchProjectViewManager.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/12.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewSearchProjectViewManager.h"
#import "CA_MSettingHeaderView.h"
#import "CA_MCustomTextFieldView.h"
#import "CA_MAddProjectCell.h"
#import "CA_MNoSearchDataView.h"
#import "CA_MProjectNotFoundView.h"
#import "CA_HNullView.h"

@implementation CA_MNewSearchProjectViewManager

-(void)leftBarButtonAction:(UIButton *)sender{
    self.leftBarButtonBlock?self.leftBarButtonBlock(sender):nil;
}

-(UIBarButtonItem *)leftBarButton{
    if (!_leftBarButton) {
        UIButton *button = [UIButton new];
        [button configTitle:@"取消" titleColor:CA_H_TINTCOLOR font:16];
        [button sizeToFit];
        [button addTarget:self action:@selector(leftBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _leftBarButton;
}

-(CA_MSettingHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [CA_MSettingHeaderView new];
        _headerView.backgroundColor = kColor(@"#FFFFFF");
        _headerView.notFoundBtnHidden = NO;
        _headerView.title = @"请选择您想关联的项目";
        _headerView.titleColor = @"#999999";
        _headerView.font = 14;
        _headerView.hidden = YES;
    }
    return _headerView;
}

-(CA_MNoSearchDataView *)noSearchDataView{
    if (!_noSearchDataView) {
        _noSearchDataView = [CA_MNoSearchDataView new];
    }
    return _noSearchDataView;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView newTableViewPlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = kColor(@"#FFFFFF");
        _tableView.rowHeight = 73 * CA_H_RATIO_WIDTH;
        _tableView.backgroundView = [CA_HNullView newTitle:@"没有搜索到相关项目" buttonTitle:nil top:136*CA_H_RATIO_WIDTH onButton:nil imageName:@"empty_search"];
        _tableView.backgroundView.hidden = YES;
        [_tableView registerClass:[CA_MAddProjectCell class] forCellReuseIdentifier:@"AddProjectCell"];
    }
    return _tableView;
}

-(CA_MCustomTextFieldView *)txtFieldView{
    if (!_txtFieldView) {
        _txtFieldView = [CA_MCustomTextFieldView new];
    }
    return _txtFieldView;
}

-(UIView *)txtFieldBgView{
    if (!_txtFieldBgView) {
        _txtFieldBgView = [UIView new];
        _txtFieldBgView.backgroundColor = kColor(@"#FFFFFF");
    }
    return _txtFieldBgView;
}

-(CA_MProjectNotFoundView *)notFoundView{
    if (!_notFoundView) {
        _notFoundView = [CA_MProjectNotFoundView new];
    }
    return _notFoundView;
}

@end
