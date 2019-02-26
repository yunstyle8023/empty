
//
//  CA_MMessageDetailVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MMessageDetailVC.h"
#import "CA_MMessageDetailModel.h"
#import "CA_MCommentCell.h"
#import "CA_MSystemCell.h"
#import "CA_MApproveCell.h"
#import "CA_MEmptyView.h"
#import "CA_MApproveDetailVC.h"
#import "CA_MMyApproveVC.h"
#import "CA_HNoteDetailController.h"
#import "CA_HTodoDetailViewController.h"
#import "CA_HBorwseFileManager.h"
#import "CA_MNewProjectContentVC.h"

static NSString* const approveKey = @"CA_MApproveCell";
static NSString* const systemKey = @"CA_MSystemCell";
static NSString* const commentKey = @"CA_MCommentCell";

@interface CA_MMessageDetailVC ()
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) CGFloat cellHeight;
@end

@implementation CA_MMessageDetailVC

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
    NSString* title = @"通知";
    if ([self.type isEqualToString:@"project"]) {
        title = @"项目通知";
    }else if ([self.type isEqualToString:@"comment"]) {
        title = @"评论通知";
    }else if ([self.type isEqualToString:@"approval"]) {
        title = @"审批通知";
    }else if ([self.type isEqualToString:@"system"]) {
        title = @"系统通知";
    }
    self.navigationItem.title = title;
    [self.view addSubview:self.tableView];
}

- (void)requestData {
    [CA_HProgressHUD loading:self.view];
    [CA_HNetManager postUrlStr:CA_M_ListObjectNotify parameters:@{@"category":self.type} callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud:self.view];
        if (netModel.type == CA_H_NetTypeSuccess) {
            //刷新前页面小红点
            if (self.block) {
                self.block();
            }
            
            if (netModel.errcode.intValue == 0) {
                if ([netModel.data isKindOfClass:[NSArray class]] &&
                    [NSObject isValueableObject:netModel.data]) {
                    for (NSDictionary* dic in netModel.data) {
                        CA_MMessageDetailModel* model = [CA_MMessageDetailModel modelWithDictionary:dic];
                        [self.dataSource addObject:model];
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
    tableView.backgroundView.hidden = self.dataSource.count>0;
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.type isEqualToString:@"system"]) {//系统通知
        CA_MSystemCell* systemCell = [tableView dequeueReusableCellWithIdentifier:systemKey];
        if ([NSObject isValueableObject:self.dataSource]) {
            CA_MMessageDetailModel* model = self.dataSource[indexPath.row];
            systemCell.model = model;
        }
        return systemCell;
    }else if ([self.type isEqualToString:@"comment"] ||
              [self.type isEqualToString:@"project"]) {//评论通知 项目通知
        CA_MCommentCell* commentCell = [tableView dequeueReusableCellWithIdentifier:commentKey];
        if ([NSObject isValueableObject:self.dataSource]) {
            CA_MMessageDetailModel* model = self.dataSource[indexPath.row];
            self.cellHeight = [commentCell configCell:model];
        }
        return commentCell;
    }else if ([self.type isEqualToString:@"approval"]) {//审批通知
        CA_MApproveCell* approveCell = [tableView dequeueReusableCellWithIdentifier:approveKey];
        if ([NSObject isValueableObject:self.dataSource]) {
            CA_MMessageDetailModel* model = self.dataSource[indexPath.row];
            self.cellHeight = [approveCell configCell:model];
        }
        return approveCell;
    }
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    self.cellHeight = 0.f;
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CA_MMessageDetailModel* model = self.dataSource[indexPath.row];
    if (!model.body.check_detail) {//# 是否跳转，0 可以跳转，1 不能跳转
        
        if ([model.category isEqualToString:@"system"]) {//系统通知
            return;
        }
        
        NSLog(@"model.body.notify_type == %@",model.body.notify_type);
        
        if ([model.category isEqualToString:@"approval"]) {//审批通知
            if([model.body.notify_type isEqualToString:@"approval"]){
                CA_MApproveDetailVC *approvelDetailVC = [CA_MApproveDetailVC new];
                approvelDetailVC.approveID = model.body.notify_id;
                [self.navigationController pushViewController:approvelDetailVC animated:YES];
            }else if([model.body.notify_type isEqualToString:@"approval_list"]){
                CA_MMyApproveVC *approvelVC = [CA_MMyApproveVC new];
                [self.navigationController pushViewController:approvelVC animated:YES];
            }
        }
        
        if ([model.category isEqualToString:@"comment"]) {//评论通知
            if([model.body.notify_type isEqualToString:@"note"]){//笔记
                CA_HNoteDetailController *vc = [CA_HNoteDetailController new];
                vc.noteId = model.body.notify_id;
                vc.modelManager.commentId = model.body.related_id;
                [self.navigationController pushViewController:vc animated:YES];
            }else if([model.body.notify_type isEqualToString:@"task"]){//待办
                CA_HTodoDetailViewController *vc = [CA_HTodoDetailViewController new];
                NSDictionary *dic = @{@"todo_id":model.body.notify_id,
                                      @"object_id":model.body.object_id.integerValue?model.body.object_id:@"pass"};
                vc.dic = dic;
                vc.viewModel.commentId = model.body.related_id;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        
        if ([model.category isEqualToString:@"project"]) {//项目通知
            if([model.body.notify_type isEqualToString:@"note"]){//笔记
                CA_HNoteDetailController *vc = [CA_HNoteDetailController new];
                vc.noteId = model.body.notify_id;
                [self.navigationController pushViewController:vc animated:YES];
            }else if([model.body.notify_type isEqualToString:@"task"]){//待办
                CA_HTodoDetailViewController *vc = [CA_HTodoDetailViewController new];
                NSDictionary *dic = @{@"todo_id":model.body.notify_id,
                  @"object_id":model.body.object_id.integerValue?model.body.object_id:@"pass"};
                vc.dic = dic;
                [self.navigationController pushViewController:vc animated:YES];
            }else if([model.body.notify_type isEqualToString:@"file"]){//文件预览页
                [CA_HBorwseFileManager browseCachesFile:model.body.notify_id fileName:model.body.file_name fileUrl:model.body.file_path controller:self];
            }else if([model.body.notify_type isEqualToString:@"dir"]){//文件夹
                CA_MNewProjectContentVC* projectDetailVC = [CA_MNewProjectContentVC new];
                projectDetailVC.pId = model.body.notify_id;
                projectDetailVC.location = CA_MProject_File;
                [self.navigationController pushViewController:projectDetailVC animated:YES];
            }else if([model.body.notify_type isEqualToString:@"project"]){//项目
                CA_MNewProjectContentVC* projectDetailVC = [CA_MNewProjectContentVC new];
                projectDetailVC.pId = model.body.notify_id;
                [self.navigationController pushViewController:projectDetailVC animated:YES];
            }else if([model.body.notify_type isEqualToString:@"procedure"]){//项目进展页
                CA_MNewProjectContentVC* projectDetailVC = [CA_MNewProjectContentVC new];
                projectDetailVC.pId = model.body.notify_id;
                projectDetailVC.location = CA_MProject_Progress;
                [self.navigationController pushViewController:projectDetailVC animated:YES];
            }
            
        }
        
    }else{
        [CA_HProgressHUD showHudStr:@"暂无详情查看"];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.type isEqualToString:@"system"]) {
        return 139*CA_H_RATIO_WIDTH;
    }
    return self.cellHeight;
}

#pragma mark - getter and setter
-(UITableView *)tableView{
    if (_tableView) {
        return _tableView;
    }
    _tableView = [UITableView newTableViewPlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 5;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[CA_MCommentCell class] forCellReuseIdentifier:commentKey];
    [_tableView registerClass:[CA_MApproveCell class] forCellReuseIdentifier:approveKey];
    [_tableView registerClass:[CA_MSystemCell class] forCellReuseIdentifier:systemKey];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    CA_H_WeakSelf(self);
    _tableView.backgroundView = [CA_MEmptyView newTitle:@"暂无通知" buttonTitle:@"" top:137*CA_H_RATIO_WIDTH onButton:^{
        CA_H_StrongSelf(self);
        
    } imageName:@"empty_search"];
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
