//
//  CA_MNewSelectProjectViewManager.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/21.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewSelectProjectViewManager.h"
#import "CA_MNewSelectProjectOuterCell.h"
#import "CA_MNewSelectProjectInnerCell.h"

@interface CA_MNewSelectProjectViewManager ()

@end

@implementation CA_MNewSelectProjectViewManager

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = kColor(@"#F8F8F8");
    }
    return _lineView;
}

-(UITableView *)outerTableView{
    if (!_outerTableView) {
        _outerTableView = [UITableView newTableViewPlain];
        _outerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_outerTableView registerClass:[CA_MNewSelectProjectOuterCell class] forCellReuseIdentifier:@"OuterCell"];
    }
    return _outerTableView;
}

-(UITableView *)innerTableView{
    if (!_innerTableView) {
        _innerTableView = [UITableView newTableViewPlain];
        _innerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _innerTableView.backgroundColor = kColor(@"#F8F8F8");
        [_innerTableView registerClass:[CA_MNewSelectProjectInnerCell class] forCellReuseIdentifier:@"InnerCell"];
    }
    return _innerTableView;
}

-(void)resetBtnAction{
    if (self.resetBlock) {
        self.resetBlock();
    }
}

-(void)finishedBtnAction{
    if (self.finishedBlock) {
        self.finishedBlock();
    }
}

-(UIButton *)resetBtn{
    if (!_resetBtn) {
        _resetBtn = [UIButton new];
        [_resetBtn setBackgroundColor:kColor(@"#F9F9F9")];
        [_resetBtn configTitle:@"重置"
                    titleColor:CA_H_9GRAYCOLOR
                          font:16];
        [_resetBtn addTarget:self action:@selector(resetBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetBtn;
}

-(UIButton *)finishedBtn{
    if (!_finishedBtn) {
        _finishedBtn = [UIButton new];
        [_finishedBtn setBackgroundColor:CA_H_TINTCOLOR];
        [_finishedBtn configTitle:@"完成"
                       titleColor:kColor(@"#FFFFFF")
                          font:16];
        [_finishedBtn addTarget:self action:@selector(finishedBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishedBtn;
}

@end
