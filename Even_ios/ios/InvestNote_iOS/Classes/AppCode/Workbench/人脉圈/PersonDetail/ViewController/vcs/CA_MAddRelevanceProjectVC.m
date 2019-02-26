
//
//  CA_MAddRelevanceProjectVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/14.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MAddRelevanceProjectVC.h"
#import "CA_MAddRelevancCell.h"
#import "CA_MProjectSearchView.h"
#import "CA_MProjectProgressMaskView.h"

static NSString* const addRelevanceKey = @"CA_MAddRelevancCell";

@interface CA_MAddRelevanceProjectVC ()
<UITableViewDataSource,
UITableViewDelegate,
CA_MProjectSearchViewDelegate
>

@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)CA_MProjectSearchView* headerView;
@property(nonatomic,strong)NSMutableArray* dataSource;
@end

@implementation CA_MAddRelevanceProjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self upNavigationButtonItem];
    [self setupUI];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.2];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
}

- (void)upNavigationButtonItem{
    self.navigationItem.title = @"选择关联项目";
}

- (void)setupUI{
    [self.contentView addSubview:self.tableView];
}

- (void)requestData{
    
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_MAddRelevancCell* cell = [tableView dequeueReusableCellWithIdentifier:addRelevanceKey];
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CA_MProjectProgressMaskView* maskView = [[CA_MProjectProgressMaskView alloc] initWithFrame:CA_H_MANAGER.mainWindow.bounds];
    maskView.title = @"关联关系";
    maskView.placeHolder = @"请填写人与项目的关联关系";
    maskView.confirmString = @"完成";
    [maskView showMaskView];
    maskView.confirmClick = ^(NSString*content){
        NSLog(@"%@",content);
    };
}

#pragma mark - CA_MProjectSearchViewDelegate

-(void)jump2SearchPage{
    
}

#pragma mark - getter and setter

-(CA_MProjectSearchView *)headerView{
    if (_headerView) {
        return _headerView;
    }
    _headerView = [[CA_MProjectSearchView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    _headerView.delegate = self;
    return _headerView;
}

-(UITableView *)tableView{
    if (_tableView) {
        return _tableView;
    }
    _tableView = [UITableView newTableViewPlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 71*CA_H_RATIO_WIDTH;
    _tableView.tableHeaderView = self.headerView;
    [_tableView registerClass:[CA_MAddRelevancCell class] forCellReuseIdentifier:addRelevanceKey];
    return _tableView;
}

@end
