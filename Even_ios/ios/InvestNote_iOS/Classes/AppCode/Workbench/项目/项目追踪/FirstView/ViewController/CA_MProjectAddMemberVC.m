//
//  CA_MProjectAddMemberVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/2/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectAddMemberVC.h"
#import "CA_MAddMemberCell.h"
#import "CA_MProjectSearchView.h"
#import "CA_MProjectMemberModel.h"

static NSString* const addMemberKey = @"CA_MAddMemberCell";

@interface CA_MProjectAddMemberVC ()
<UITableViewDataSource,
UITableViewDelegate,
CA_MProjectSearchViewDelegate
>
/// 右barButtonItem
@property(nonatomic,strong)UIBarButtonItem* leftBarBtnItem;
@property(nonatomic,strong)UIBarButtonItem* rightBarBtnItem;
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)CA_MProjectSearchView* headerView;
@property(nonatomic,strong)NSMutableArray* dataSource;
@end

@implementation CA_MProjectAddMemberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self upNavigationButtonItem];
    [self setupUI];
    [self requestData];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
}

- (void)upNavigationButtonItem{
    self.navigationItem.title = @"添加成员";
    self.navigationItem.leftBarButtonItem = self.leftBarBtnItem;
    self.navigationItem.rightBarButtonItem = self.rightBarBtnItem;
}

- (void)setupUI{
    [self.contentView addSubview:self.tableView];
}

- (void)requestData{
    
    NSDictionary* parameters = @{@"project_id":self.project_id,
                                 @"member_type":self.member_type
                                 };
    [CA_HProgressHUD loading:self.view];
    [CA_HNetManager postUrlStr:CA_M_Api_SureaddMember parameters:parameters callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud:self.view];
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                if ([netModel.data isKindOfClass:[NSArray class]] &&
                    [NSObject isValueableObject:netModel.data]) {
                    for (NSDictionary* dic in netModel.data) {
                        CA_MMemberModel* memberModel = [CA_MMemberModel modelWithDictionary:dic];
                        memberModel.select = YES;
                        [self.dataSource addObject:memberModel];
                    }
                    [self.tableView reloadData];
                }
            }
        }
    } progress:nil];
}

- (void)clickLeftBarBtnAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickRightBarBtnAction{
    
    NSMutableArray* temp = @[].mutableCopy;
    for (CA_MMemberModel* model in self.dataSource) {
        if (!model.isSelected) {
            [temp addObject:model];
        }
    }
    
    if ([temp count] <= 0) {
        [CA_HProgressHUD showHudStr:@"添加成员不能为空"];
    }else{
        NSMutableArray* user_id_list = @[].mutableCopy;
        for (CA_MMemberModel* model in temp) {
            [user_id_list addObject:model.user_id];
        }
        NSDictionary* parameters = @{@"project_id": self.project_id,
                                     @"user_id_list": user_id_list,
                                     @"member_type_id": self.isAddManage?@2:@3
                                     };
        [CA_HProgressHUD loading:self.view];
        [CA_HNetManager postUrlStr:CA_M_Api_AddMember parameters:parameters callBack:^(CA_HNetModel *netModel) {
            [CA_HProgressHUD hideHud:self.view];
            if (netModel.type == CA_H_NetTypeSuccess) {
                if (netModel.errcode.intValue == 0) {
                   [CA_HProgressHUD showHudStr:@"添加成功"];
                    if (self.block) {
                        self.block();
                    }
                }else{
                    [CA_HProgressHUD showHudStr:netModel.errmsg];
                }
            }else if(netModel.type == CA_H_NetTypeFailure){
                [CA_HProgressHUD showHudStr:@"添加失败"];
            }else{
                [CA_HProgressHUD showHudStr:@"网络出现故障"];
            }
            [self clickLeftBarBtnAction];
        } progress:nil];
    }
    
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_MAddMemberCell* cell = [tableView dequeueReusableCellWithIdentifier:addMemberKey];
    if([NSObject isValueableObject:self.dataSource]){
        CA_MMemberModel* model = self.dataSource[indexPath.row];
        cell.model = model;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CA_MMemberModel* model = self.dataSource[indexPath.row];
    model.select = !model.isSelected;
    [tableView reloadData];
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
    [_tableView registerClass:[CA_MAddMemberCell class] forCellReuseIdentifier:addMemberKey];
    return _tableView;
}

-(UIBarButtonItem *)leftBarBtnItem{
    if (_leftBarBtnItem) {
        return _leftBarBtnItem;
    }
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton configTitle:@"取消" titleColor:CA_H_TINTCOLOR font:16];
    [leftButton sizeToFit];
    [leftButton addTarget: self action: @selector(clickLeftBarBtnAction) forControlEvents: UIControlEventTouchUpInside];
    _leftBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    return _leftBarBtnItem;
}
-(UIBarButtonItem *)rightBarBtnItem{
    if (_rightBarBtnItem) {
        return _rightBarBtnItem;
    }
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton configTitle:@"完成" titleColor:CA_H_TINTCOLOR font:16];
    [rightButton sizeToFit];
    [rightButton addTarget: self action: @selector(clickRightBarBtnAction) forControlEvents: UIControlEventTouchUpInside];
    _rightBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    return _rightBarBtnItem;
}

-(NSMutableArray *)dataSource{
    if (_dataSource) {
        return _dataSource;
    }
    _dataSource = @[].mutableCopy;
    return _dataSource;
}
@end
