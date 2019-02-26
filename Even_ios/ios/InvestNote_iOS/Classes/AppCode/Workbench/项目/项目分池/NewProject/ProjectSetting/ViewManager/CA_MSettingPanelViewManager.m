//
//  CA_MSettingPanelViewManager.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MSettingPanelViewManager.h"
#import "CA_MSettingPanelDefaultCell.h"
#import "CA_MSettingPanelEditCell.h"
#import "JXMovableCellTableView.h"

@implementation CA_MSettingPanelViewManager

-(NSString *)title{
    return @"项目面板设置";
}

-(JXMovableCellTableView *)tableView{
    if (!_tableView) {
        _tableView = [JXMovableCellTableView newTableViewGrouped];
        _tableView.rowHeight = 26*2*CA_H_RATIO_WIDTH;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[CA_MSettingPanelDefaultCell class] forCellReuseIdentifier:@"SettingPanelDefaultCell"];
        [_tableView registerClass:[CA_MSettingPanelEditCell class] forCellReuseIdentifier:@"SettingPanelEditCell"];
    }
    return _tableView;
}

-(void)rightBtnAction:(UIButton *)sender{
    if (self.rightBlock) self.rightBlock();
}

-(UIBarButtonItem *)rightBarBtn{
    if (!_rightBarBtn) {
        UIButton *rightBtn = [UIButton new];
        [rightBtn configTitle:@"完成"
                   titleColor:CA_H_TINTCOLOR
                         font:16];
        [rightBtn sizeToFit];
        [rightBtn addTarget:self
                     action:@selector(rightBtnAction:)
           forControlEvents:UIControlEventTouchUpInside];
        _rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    }
    return _rightBarBtn;
}

@end
