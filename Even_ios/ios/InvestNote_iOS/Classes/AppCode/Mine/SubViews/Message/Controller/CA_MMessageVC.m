//
//  CA_MMessageViewController.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/2.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MMessageVC.h"
#import "CA_MMessageCell.h"
#import "CA_MMessageModel.h"
#import "CA_MMessageDetailVC.h"

static NSString* const messageKey = @"CA_MMessageCell";

@interface CA_MMessageVC ()
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) CA_MMessageModel *messageModel;
@end

@implementation CA_MMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    //简单暴力刷新 跳转的详情页太多了
    if ([NSObject isValueableObject:self.dataSource]) {
        [self requestData];
    }
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
        make.edges.mas_equalTo(self.view);
    }];
}

-(void)setupUI{
    self.navigationItem.title = @"消息通知";
    [self.view addSubview:self.tableView];
}

-(void)requestData{
    [CA_HProgressHUD loading:self.view];
    [CA_HNetManager postUrlStr:CA_M_ListNotify parameters:@{} callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud:self.view];
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]] &&
                    [NSObject isValueableObject:netModel.data]) {
                    
                    [self.dataSource removeAllObjects];
                    
                    self.messageModel = [CA_MMessageModel modelWithDictionary:netModel.data];
                    
                    CA_MMessage* projectModel = self.messageModel.project;
                    projectModel.imageName = @"head_project";
                    projectModel.projectName = @"项目通知";
                    projectModel.type = @"project";
                    if (projectModel) {
                        [self.dataSource addObject:projectModel];
                    }
                    
                    CA_MMessage* commentModel = self.messageModel.comment;
                    commentModel.imageName = @"head_consult";
                    commentModel.projectName = @"评论通知";
                    commentModel.type = @"comment";
                    if (commentModel) {
                       [self.dataSource addObject:commentModel];
                    }
                    
                    CA_MMessage* approvalModel = self.messageModel.approval;
                    approvalModel.imageName = @"head_follow";
                    approvalModel.projectName = @"审批通知";
                    approvalModel.type = @"approval";
                    if (approvalModel) {
                       [self.dataSource addObject:approvalModel];
                    }
                    

                    CA_MMessage* systemModel = self.messageModel.system;
                    systemModel.imageName = @"head_service";
                    systemModel.projectName = @"系统通知";
                    systemModel.type = @"system";
                    if (systemModel) {
                       [self.dataSource addObject:systemModel];
                    }
                    
                    [self.tableView reloadData];
                }
            }else{
                [CA_HProgressHUD showHudStr:netModel.errmsg];
            }
        }
//        else{
//            [CA_HProgressHUD showHudStr:netModel.errmsg];
//        }
    } progress:nil];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_MMessageCell* messageCell = [tableView dequeueReusableCellWithIdentifier:messageKey];
    if ([NSObject isValueableObject:self.dataSource]) {
        CA_MMessage *model = self.dataSource[indexPath.row];
        messageCell.model = model;
    }
    return messageCell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CA_MMessageDetailVC* messageDetailVC = [CA_MMessageDetailVC new];
    CA_MMessage *model = self.dataSource[indexPath.row];
    messageDetailVC.type = model.type;
    CA_H_WeakSelf(self);
    messageDetailVC.block = ^{
        CA_H_StrongSelf(self);
        [self requestData];
    };
    [self.navigationController pushViewController:messageDetailVC animated:YES];
}

#pragma mark - getter and setter
-(UITableView *)tableView{
    if (_tableView) {
        return _tableView;
    }
    _tableView = [UITableView newTableViewGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 70*CA_H_RATIO_WIDTH;
    _tableView.sectionHeaderHeight = 5;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[CA_MMessageCell class] forCellReuseIdentifier:messageKey];
    return _tableView;
}
-(NSMutableArray *)dataSource{
    if (_dataSource) {
        return _dataSource;
    }
    _dataSource = @[].mutableCopy;
    return _dataSource;
}
@end
