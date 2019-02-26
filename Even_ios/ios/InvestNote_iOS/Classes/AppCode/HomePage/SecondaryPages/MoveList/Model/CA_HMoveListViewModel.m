//
//  CA_HMoveListViewModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/27.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HMoveListViewModel.h"

#import "CA_HMoveCell.h"

#import "CA_HSelectMenuView.h"

#import "CA_MProjectProgressMaskView.h"

@interface CA_HMoveListViewModel () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSNumber *selectItem;

@property (nonatomic, strong) CA_HMoveListModel *model;

@end

@implementation CA_HMoveListViewModel

#pragma mark --- Action

- (void)onSearch:(UIButton *)sender {
    if (self.onSearchBlock) {
        self.onSearchBlock();
    }
}

#pragma mark --- Action

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self upConfig];
    }
    return self;
}

- (void)upConfig{
    _defaultSelected = @(0);
    _type = CA_HProjeceTypeMove;
}

#pragma mark --- Lazy

- (CA_HMoveListModel *)model {
    if (!_model) {
        CA_HMoveListModel *model = [CA_HMoveListModel new];
        _model = model;
        
        CA_H_WeakSelf(self);
        model.finishRequestBlock = ^(CA_H_RefreshType type) {
            CA_H_StrongSelf(self);
            if (self.hudView) {
                [CA_HProgressHUD hideHud:self.hudView];
            }
            self.FinishRequestType = type;
        };
        
        if (self.hudView) {
            [CA_HProgressHUD loading:self.hudView];
        }
        model.loadMoreBlock(@"", YES);
    }
    return _model;
}

- (NSString *)title{
    switch (_type) {
        case CA_HProjeceTypeMove:
            return CA_H_LAN(@"选择移动位置");
        case CA_HProjeceTypeChoose:
        case CA_HProjeceTypeChooseToJump:
            return CA_H_LAN(@"选择关联");
        default:
            return @"";
    }
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView newTableViewGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [self customSearchView];
        [_tableView registerClass:[CA_HMoveCell class] forCellReuseIdentifier:@"move"];
        _tableView.rowHeight = 65*CA_H_RATIO_WIDTH;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        CA_H_WeakSelf(self);
        _tableView.mj_header = [CA_HDIYHeader headerWithRefreshingBlock:^{
            CA_H_StrongSelf(self);
            self.model.page_num = @(0);
            self.model.loadMoreBlock(@"", YES);
        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            CA_H_StrongSelf(self);
            self.model.loadMoreBlock(@"", YES);
        }];
    }
    return _tableView;
}


#pragma mark --- Custom

- (void)showMenu:(CA_MProjectModel *)model {
    if (_typeData) {
        CA_HSelectMenuView * selectMenuView = [CA_HSelectMenuView new];
        selectMenuView.frame = CA_H_MANAGER.mainWindow.bounds;
        
        NSMutableArray *data = [NSMutableArray new];
        [data addObject:CA_H_LAN(@"选择笔记类型")];
        for (CA_HNoteTypeModel *typeModel in self.typeData) {
            [data addObject:typeModel.note_type_name];
        }
        
        CA_H_WeakSelf(selectMenuView);
        CA_H_WeakSelf(self);
        selectMenuView.clickBlock = ^(NSInteger item) {
            CA_H_StrongSelf(selectMenuView);
            CA_H_StrongSelf(self);
            
            if (item > 0) {
                if (self.noteTypeBlock) {
                    self.noteTypeBlock(model, self.typeData[item-1]);
                }
            }
            
            [selectMenuView hideMenu:YES];
        };
        selectMenuView.data = data;
        [CA_H_MANAGER.mainWindow addSubview:selectMenuView];
        [selectMenuView showMenu:YES];
    } else {
        [CA_HProgressHUD showHud:nil];
        CA_H_WeakSelf(self);
        [CA_HNetManager postUrlStr:CA_H_Api_ListNoteType parameters:@{} callBack:^(CA_HNetModel *netModel) {
            [CA_HProgressHUD hideHud];
            if (netModel.type == CA_H_NetTypeSuccess) {
                if (netModel.errcode.integerValue == 0) {
                    if ([netModel.data isKindOfClass:[NSArray class]]) {
                        CA_H_StrongSelf(self);
                        NSMutableArray *data = [NSMutableArray new];
                        for (NSDictionary *dic in netModel.data) {
                            [data addObject:[CA_HNoteTypeModel modelWithDictionary:dic]];
                        }
                        self.typeData = data;
                        [self showMenu:model];
                        return;
                    }
                }
            }
            if (netModel.error.code != -999) {
                [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
            }
        } progress:nil];
    }
}

- (void)setFinishRequestType:(CA_H_RefreshType)type {
    switch (type) {
        case CA_H_RefreshTypeNomore:
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            break;
        case CA_H_RefreshTypeFirst:
            [self.tableView.mj_footer resetNoMoreData];
        default:
            [self.tableView.mj_footer endRefreshing];
            break;
    }
    [self.tableView.mj_header endRefreshing];
    
    CA_H_WeakSelf(self);
    CA_H_DISPATCH_MAIN_THREAD(^{
        CA_H_StrongSelf(self);
        [self.tableView reloadData];
    });
}

// 搜索栏
- (UIView *)customSearchView{
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, 50*CA_H_RATIO_WIDTH);
    
    UIButton * searchButton = [UIButton new];
    
    searchButton.backgroundColor = CA_H_F8COLOR;
    [searchButton setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateHighlighted];
    searchButton.titleLabel.font = CA_H_FONT_PFSC_Regular(14);
    [searchButton setTitleColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
    [searchButton setTitle:CA_H_LAN(@" 搜索") forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(onSearch:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:searchButton];
    searchButton.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(15*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH, 5*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH));
    searchButton.sd_cornerRadiusFromHeightRatio = @(0.2);
    
    return view;
}

- (NSNumber *)selectItem{
    NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath) {
        CA_MProjectModel *model = self.model.data[indexPath.row];
        return model.project_id;
    }else{
        return _defaultSelected;
    }
}

#pragma mark --- table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    tableView.mj_footer.hidden = (self.model.data.count==0);
    return self.model.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_HMoveCell * cell = [tableView dequeueReusableCellWithIdentifier:@"move"];
    
    cell.model = self.model.data[indexPath.row];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_MProjectModel *model = self.model.data[indexPath.row];
    if ([model.project_id isEqualToNumber:self.selectItem]) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CA_HBaseTableCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    CA_MProjectModel *model = (id)cell.model;
    if (tableView != self.tableView) {
        CA_MProjectModel *newModel = model.modelCopy;
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[newModel.project_name dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        newModel.project_name = attrStr.string;
        model = newModel;
    }
    
    switch (_type) {
        case CA_HProjeceTypeMove:{
            if (![model.project_id isEqualToNumber:self.defaultSelected]) {
                if (self.alertBlock) {
                    self.alertBlock(model);
                }
            }
        }break;
        case CA_HProjeceTypeChoose:{
            [self showMenu:model];
        }break;
        case CA_HProjeceTypeChooseToJump:{
            if (_backBlock) {
                _backBlock(model);
            }
        }break;
        case CA_HProjeceTypeInput:{
            CA_H_WeakSelf(self);
            CA_MProjectProgressMaskView* maskView = [[CA_MProjectProgressMaskView alloc] initWithFrame:CA_H_MANAGER.mainWindow.bounds];
            maskView.title = @"关联关系";
            maskView.placeHolder = @"请填写人与项目的关联关系";
            maskView.confirmString = @"完成";
            [maskView showMaskView];
            maskView.confirmClick = ^(NSString* content){
                CA_H_StrongSelf(self);
                if (![NSString isValueableString:content]) {
                    [CA_HProgressHUD showHudStr:@"请填写人与项目的关联关系"];
                    return;
                }
                if (self.addBlock) {
                    self.addBlock(model, content);
                }
            };
        }break;
        default:
            break;
    }
}

@end
