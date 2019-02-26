//
//  CA_MNewProjectSingleViewManager.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewProjectSingleViewManager.h"
#import "CA_MNewProjectNoTagCell.h"
#import "CA_MNewProjectTagCell.h"
#import "CA_MNewProjectPlanItemCell.h"
#import "CA_MNewProjectAlreadyItemCell.h"
#import "CA_MNewProjectAbandonCell.h"
#import "CA_MNewProjectQuitCell.h"
#import "CA_MEmptyView.h"

@interface CA_MNewProjectSingleViewManager ()
@property (nonatomic,strong) UIBarButtonItem *searchBarBtn;
@property (nonatomic,strong) UIBarButtonItem *selectBarBtn;
@end

@implementation CA_MNewProjectSingleViewManager

-(CA_MEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [CA_MEmptyView newTitle:@"当前您还没有参与任何项目" buttonTitle:nil top:136*CA_H_RATIO_WIDTH onButton:nil imageName:@"empty_project"];
    }
    return _emptyView;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView newTableViewPlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundView = self.emptyView;
        _tableView.backgroundView.hidden = YES;
        [_tableView registerClass:[CA_MNewProjectNoTagCell class] forCellReuseIdentifier:@"NewProjectNoTagCell"];
        [_tableView registerClass:[CA_MNewProjectTagCell class] forCellReuseIdentifier:@"NewProjectTagCell"];
        [_tableView registerClass:[CA_MNewProjectPlanItemCell class] forCellReuseIdentifier:@"NewProjectPlanItemCell"];
        [_tableView registerClass:[CA_MNewProjectAlreadyItemCell class] forCellReuseIdentifier:@"NewProjectAlreadyItemCell"];
        [_tableView registerClass:[CA_MNewProjectAbandonCell class] forCellReuseIdentifier:@"NewProjectAbandonCell"];
        [_tableView registerClass:[CA_MNewProjectQuitCell class] forCellReuseIdentifier:@"NewProjectQuitCell"];
    }
    return _tableView;
}

-(void)searchBarBtnAction:(UIButton *)sender{
    self.searchBlock?self.searchBlock():nil;
}

-(void)selectBarBtnAction:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    self.selectBlock?self.selectBlock():nil;
}

-(NSArray *)rightBarButtonItems{
    if (!_rightBarButtonItems) {
        UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = 20;
        _rightBarButtonItems = @[self.selectBarBtn,spaceItem,self.searchBarBtn];
    }
    return _rightBarButtonItems;
}

-(UIBarButtonItem *)searchBarBtn{
    if (!_searchBarBtn) {
        UIButton *searchBtn = [UIButton new];
        [searchBtn setImage:kImage(@"search2") forState:UIControlStateNormal];
        [searchBtn sizeToFit];
        [searchBtn addTarget: self
                      action: @selector(searchBarBtnAction:)
             forControlEvents: UIControlEventTouchUpInside];
        _searchBarBtn = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    }
    return _searchBarBtn;
}

-(UIBarButtonItem *)selectBarBtn{
    if (!_selectBarBtn) {
        UIButton *selectBtn = [UIButton new];
        [selectBtn setImage:kImage(@"icons_screen") forState:UIControlStateNormal];
        [selectBtn setImage:kImage(@"project_selected") forState:UIControlStateSelected];
        selectBtn.selected = NO;
        [selectBtn sizeToFit];
        [selectBtn addTarget: self
                      action: @selector(selectBarBtnAction:)
              forControlEvents: UIControlEventTouchUpInside];
        _selectBarBtn = [[UIBarButtonItem alloc] initWithCustomView:selectBtn];
    }
    return _selectBarBtn;
}

@end
