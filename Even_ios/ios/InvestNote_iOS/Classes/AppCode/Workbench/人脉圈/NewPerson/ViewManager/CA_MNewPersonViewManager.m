//
//  CA_MNewPersonViewManager.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewPersonViewManager.h"
#import "CA_MProjectSelectResultView.h"
#import "CA_MProjectSearchView.h"
#import "CA_MProjectPersonCell.h"
#import "CA_MEmptyView.h"

@interface CA_MNewPersonViewManager ()

@end

@implementation CA_MNewPersonViewManager

-(CA_MEmptyView *)emptyView{
    if (!_emptyView) {
        CA_H_WeakSelf(self)
        _emptyView = [CA_MEmptyView newTitle:@"当前还没有任何人脉" buttonTitle:nil top:137*CA_H_RATIO_WIDTH onButton:^{
            CA_H_StrongSelf(self);
            
        } imageName:@"empty_search"];
    }
    return _emptyView;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView newTableViewPlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.searchView;
        _tableView.rowHeight = 70*CA_H_RATIO_WIDTH;
        _tableView.backgroundView = ({
            UIView *view = [UIView new];
            [view addSubview:self.emptyView];
            self.emptyView.sd_layout
            .spaceToSuperView(UIEdgeInsetsZero);
            view;
        });
        _tableView.backgroundView.hidden = YES;
        [_tableView registerClass:[CA_MProjectPersonCell class] forCellReuseIdentifier:@"ProjectPersonCell"];
    }
    return _tableView;
}

-(CA_MProjectSelectResultView *)resultView{
    if (!_resultView) {
        _resultView = [CA_MProjectSelectResultView new];
        _resultView.hidden = YES;
    }
    return _resultView;
}

-(CA_MProjectSearchView *)searchView{
    if (!_searchView) {
        _searchView = [[CA_MProjectSearchView alloc] initWithFrame:CGRectMake(0, 0, CA_H_SCREEN_WIDTH, 60)];
    }
    return _searchView;
}

-(void)clickTitleViewBtnAction:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    self.titleBlock?self.titleBlock(sender):nil;
}

-(void)clickLeftBarBtnAction:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    self.leftBlock?self.leftBlock():nil;
}

-(void)clickRightBarBtnAction:(UIButton *)sender{
    self.rightBlock?self.rightBlock():nil;
}

-(UIBarButtonItem *)leftBarBtn{
    if (!_leftBarBtn) {
        UIButton *leftButton = [UIButton new];
        [leftButton setImage:kImage(@"icons_screen") forState:UIControlStateNormal];
        [leftButton setImage:kImage(@"project_selected") forState:UIControlStateSelected];
        leftButton.selected = NO;
        [leftButton sizeToFit];
        [leftButton addTarget: self
                       action: @selector(clickLeftBarBtnAction:)
             forControlEvents: UIControlEventTouchUpInside];
        _leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    }
    return _leftBarBtn;
}
-(UIBarButtonItem *)rightBarBtn{
    if (!_rightBarBtn) {
        UIButton *rightButton = [UIButton new];
        [rightButton configTitle:@"添加人脉" titleColor:CA_H_TINTCOLOR font:16];
        [rightButton sizeToFit];
        [rightButton addTarget: self
                        action: @selector(clickRightBarBtnAction:)
              forControlEvents: UIControlEventTouchUpInside];
        _rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    }
    return _rightBarBtn;
}

-(UIButton *)titleViewBtn{
    if (!_titleViewBtn) {
        _titleViewBtn = [UIButton new];
        [_titleViewBtn configTitle:@"人脉圈"
                        titleColor:CA_H_4BLACKCOLOR
                              font:17];
        [_titleViewBtn setImage:kImage(@"details_down") forState:UIControlStateNormal];
        [_titleViewBtn setImage:kImage(@"details_up") forState:UIControlStateSelected];
        [self changeTitleSpace:@"人脉圈"];
        [_titleViewBtn sizeToFit];
        [_titleViewBtn addTarget:self action:@selector(clickTitleViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _titleViewBtn.selected = NO;
    }
    return _titleViewBtn;
}

-(void)changeTitleSpace:(NSString*)item{
    CGFloat spacing = 5.0;
    CGFloat imageWidth = kImage(@"details_up").size.width;
    self.titleViewBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageWidth * 2 - spacing, 0.0, 0.0);
    CGFloat titleWidth = [item widthForFont:CA_H_FONT_PFSC_Regular(17)];
    self.titleViewBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - titleWidth * 2 - spacing);
}

@end


















