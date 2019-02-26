//
//  CA_MFiltrateItemViewManager.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MFiltrateItemViewManager.h"
#import "CA_MFiltrateItemPanelView.h"
#import "CA_MFiltrateItemChooseView.h"
//#import "CA_MFiltrateItemUITableView.h"
#import "CA_MFiltrateItemCell.h"

@interface CA_MFiltrateItemViewManager ()

@end

@implementation CA_MFiltrateItemViewManager

-(void)setDelegate:(UIViewController *)vc{
    self.outsideTableView.dataSource = vc;
    self.outsideTableView.delegate = vc;
    
    self.centerTableView.dataSource = vc;
    self.centerTableView.delegate = vc;
    
    self.insideTableView.dataSource = vc;
    self.insideTableView.delegate = vc;
}

-(UIView *)maskView{
    if (!_maskView) {
        _maskView = [UIView new];
        _maskView.backgroundColor = [UIColor whiteColor];
    }
    return _maskView;
}

-(CA_MFiltrateItemPanelView *)panelView{
    if (!_panelView) {
        _panelView = [CA_MFiltrateItemPanelView new];
    }
    return _panelView;
}

-(CA_MFiltrateItemChooseView *)chooseView{
    if (!_chooseView) {
        _chooseView = [CA_MFiltrateItemChooseView new];
    }
    return _chooseView;
}

-(UITableView *)outsideTableView{
    if (!_outsideTableView) {
        _outsideTableView = [UITableView newTableViewGrouped];
        _outsideTableView.backgroundColor = kColor(@"#FFFFFF");
        _outsideTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _outsideTableView.showsVerticalScrollIndicator = NO;
        _outsideTableView.showsHorizontalScrollIndicator = NO;
        [_outsideTableView registerClass:[CA_MFiltrateItemCell class] forCellReuseIdentifier:@"FiltrateItemCell"];
    }
    return _outsideTableView;
}

-(UITableView *)centerTableView{
    if (!_centerTableView) {
        _centerTableView = [UITableView newTableViewGrouped];
        _centerTableView.backgroundColor = kColor(@"#FAFAFA");
        _centerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _centerTableView.showsVerticalScrollIndicator = NO;
        _centerTableView.showsHorizontalScrollIndicator = NO;
        [_centerTableView registerClass:[CA_MFiltrateItemCell class] forCellReuseIdentifier:@"FiltrateItemCell"];
    }
    return _centerTableView;
}

-(UITableView *)insideTableView{
    if (!_insideTableView) {
        _insideTableView = [UITableView newTableViewGrouped];
        _insideTableView.backgroundColor = kColor(@"#F8F8F8");
        _insideTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _insideTableView.showsVerticalScrollIndicator = NO;
        _insideTableView.showsHorizontalScrollIndicator = NO;
        [_insideTableView registerClass:[CA_MFiltrateItemCell class] forCellReuseIdentifier:@"FiltrateItemCell"];
    }
    return _insideTableView;
}

@end









