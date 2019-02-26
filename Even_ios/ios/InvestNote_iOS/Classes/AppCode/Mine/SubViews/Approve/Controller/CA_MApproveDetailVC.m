
//
//  CA_MApproveDetailVC.m
//  InvestNote_iOS
//
//  Created by yezhuge on 2018/4/2.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MApproveDetailVC.h"
#import "CA_MInputCell.h"
#import "CA_MSelectCell.h"
#import "CA_MTypeModel.h"
#import "CA_MApproveStandardCell.h"
#import "CA_MApproveSuggestionCell.h"
#import "CA_MApproveDetailFooterView.h"
#import "CA_MApproveResultCell.h"
#import "CA_MApproveStatusCell.h"
#import "CA_MMyApproveDetailModel.h"
#import "CA_MNewProjectContentVC.h"

static NSString* const inputKey = @"CA_MInputCell";
static NSString* const selectKey = @"CA_MSelectCell";
static NSString* const standardKey = @"CA_MApproveStandardCell";
static NSString* const suggestionKey = @"CA_MApproveSuggestionCell";
static NSString* const resultKey = @"CA_MApproveResultCell";
static NSString* const statusKey = @"CA_MApproveStatusCell";

@interface CA_MApproveDetailVC ()
<UITableViewDataSource,
UITableViewDelegate,
CA_MApproveSuggestionCellDelegate,
CA_MApproveDetailFooterViewDelegate>{
    CGFloat _footerViewHeight;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) CA_MApproveDetailFooterView *footerView;
@property (nonatomic,strong) CA_MMyApproveDetailModel *approveDetailModel;
@property (nonatomic,assign) CGFloat cellHeight;
@end

@implementation CA_MApproveDetailVC

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
    
    [self.footerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(kDevice_Is_iPhoneX?-20:0);
        make.height.mas_equalTo(_footerViewHeight*CA_H_RATIO_WIDTH);
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(CA_H_SCREEN_HEIGHT - (_footerViewHeight*CA_H_RATIO_WIDTH) - (Navigation_Height));
    }];
    
}

-(void)setupUI{
    self.navigationItem.title = @"审批详情";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
}

-(void)requestData{
    [CA_HProgressHUD loading:self.view];
    [CA_HNetManager postUrlStr:CA_M_Api_QueryApproval parameters:@{@"approval_id":self.approveID} callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud:self.view];
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]] &&
                    [NSObject isValueableObject:netModel.data]) {
                    self.approveDetailModel = [CA_MMyApproveDetailModel modelWithDictionary:netModel.data];
                    self.footerView.hidden = !self.approveDetailModel.need_approval;
                    _footerViewHeight = self.footerView.isHidden ? 0:58;
                    [self viewDidLayoutSubviews];
                    [self handleData];
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

/**
 handleData
 */
-(void)handleData{
    
    [self.dataSource removeAllObjects];
    
    CA_MTypeModel* timeModel = [CA_MTypeModel new];
    timeModel.title = @"申请时间";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.approveDetailModel.ts_approval.longValue];
    NSString* time = [date stringWithFormat:@"yyyy.MM.dd HH:mm:ss"];
    timeModel.value = time;
    timeModel.type = Input;
    
    CA_MTypeModel* eventModel = [CA_MTypeModel new];
    eventModel.title = @"申请事件";
    eventModel.value = self.approveDetailModel.approval_title;
    eventModel.type = Input;
    
    CA_MTypeModel* projectModel = [CA_MTypeModel new];
    projectModel.title = @"关联项目";
    projectModel.value = self.approveDetailModel.approval_project_info.project_name;
    projectModel.type = Select;
    
    CA_MTypeModel* applyModel = [CA_MTypeModel new];
    applyModel.title = @"申请人";
    applyModel.value = self.approveDetailModel.approval_create_user.chinese_name;
    applyModel.type = Input;
    
    CA_MTypeModel* approveModel = [CA_MTypeModel new];
    approveModel.title = @"审批人";
    NSMutableString* attStr = [NSMutableString new];
    for (int i=0;i<self.approveDetailModel.approval_member.count;i++) {
        CA_MApproval_member* model = self.approveDetailModel.approval_member[i];
        [attStr appendString:model.user_name];
        if (i != self.approveDetailModel.approval_member.count-1) {
            [attStr appendString:@"、"];
        }
    }
    approveModel.value = attStr.copy;
    approveModel.type = Input;
    
    CA_MTypeModel* standardModel = [CA_MTypeModel new];
    standardModel.title = @"审批标准";
    standardModel.values = self.approveDetailModel.approval_standard.mutableCopy;
    standardModel.type = Other;
    
    CA_MTypeModel* suggestModel = [CA_MTypeModel new];
    suggestModel.title = @"审批意见";
    suggestModel.value = @"";
    suggestModel.placeHolder = @"请输入审批意见";
    suggestModel.type = Introduce;
    
    CA_MTypeModel* resultModel = [CA_MTypeModel new];
    resultModel.values = @[self.approveDetailModel.approval_conclude_sub_title,
                           self.approveDetailModel.approval_status_color].mutableCopy;
    resultModel.type = Tag;
    
    CA_MTypeModel* detailModel = [CA_MTypeModel new];
    detailModel.values = self.approveDetailModel.result_detail.mutableCopy;
    detailModel.type = ChooseIcon;
    
    if (self.approveDetailModel.need_approval) {
        [self.dataSource addObjectsFromArray:@[timeModel,eventModel,projectModel,
                                           approveModel]];
        if ([NSObject isValueableObject:standardModel.values]) {
            [self.dataSource addObject:standardModel];
        }
        [self.dataSource addObject:suggestModel];
    }else{
        if ([NSString isValueableString:applyModel.value]) {
            [self.dataSource addObjectsFromArray:@[timeModel,eventModel,projectModel,applyModel,
                                               approveModel]];
            if ([NSObject isValueableObject:standardModel.values]) {
                [self.dataSource addObject:standardModel];
            }
            [self.dataSource addObject:resultModel];
            if ([NSObject isValueableObject:self.approveDetailModel.result_detail]) {
                [self.dataSource addObject:detailModel];
            }
        }else{
            [self.dataSource addObjectsFromArray:@[timeModel,eventModel,projectModel,
                                               approveModel]];
            if ([NSObject isValueableObject:standardModel.values]) {
                [self.dataSource addObject:standardModel];
            }
            [self.dataSource addObject:resultModel];
            if ([NSObject isValueableObject:self.approveDetailModel.result_detail]) {
                [self.dataSource addObject:detailModel];
            }
        }
    }
}

#pragma mark - CA_MApproveSuggestionCellDelegate

-(void)textDidChange:(NSString*)content{
    CA_MTypeModel* model = (CA_MTypeModel*)[self.dataSource objectAtIndex:5];
    model.value = content;
}

-(void)textLengthDidMax{
    [CA_HProgressHUD showHudStr:@"已达到最大字数限制"];
}

#pragma mark - CA_MApproveDetailFooterViewDelegate

-(void)operationClick:(NSInteger)index{
    
    CA_MTypeModel* model = (CA_MTypeModel*)[self.dataSource objectAtIndex:5];
    if (![NSString isValueableString:model.value]) {
        [CA_HProgressHUD showHudStr:@"请填写审批意见"];
        return;
    }
    NSString *result = @"";
    if (index == 1) {//通过
        result = @"positive";
    }else if (index == 2) {//驳回
        result = @"negative";
    }else if (index == 3) {//弃权
        result = @"abstenting";
    }
    
    NSDictionary* parameters = @{@"project_id": self.approveDetailModel.approval_project_id,
                                 @"procedure_approval_id": self.approveDetailModel.approval_id,  //# 需要审批流程的id
                                 @"result": result,
                                 @"reason": model.value};
    [CA_HNetManager postUrlStr:CA_M_Api_SubmitProcedure parameters:parameters callBack:^(CA_HNetModel *netModel) {
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                [self requestData];
                if (self.block) {
                    self.block();
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
    CA_MTypeModel* model = self.dataSource[indexPath.row];
    if (model.type == Input) {
        CA_MInputCell* inputCell = [tableView dequeueReusableCellWithIdentifier:inputKey];
        inputCell.enabled = NO;
        [inputCell configCell:model.title text:model.value placeholder:model.placeHolder];
        return inputCell;
    }else if (model.type == Select) {//关联项目
        CA_MSelectCell* selectCell = [tableView dequeueReusableCellWithIdentifier:selectKey];
        [selectCell configCell:model.title :model.value];
        selectCell.selectLb.textColor = CA_H_TINTCOLOR;
        return selectCell;
    }else if (model.type == Other) {//审批标准
        CA_MApproveStandardCell* standardCell = [tableView dequeueReusableCellWithIdentifier:standardKey];
        if ([NSObject isValueableObject:model.values]) {
            self.cellHeight = [standardCell configCellTitle:model.title values:model.values];
        }
        return standardCell;
    }else if (model.type == Introduce) {//审批意见
        CA_MApproveSuggestionCell* suggestionCell = [tableView dequeueReusableCellWithIdentifier:suggestionKey];
        suggestionCell.delegate = self;
        [suggestionCell configCellTitle:model.title text:model.value placeholder:model.placeHolder];
        return suggestionCell;
    }else if (model.type == Tag){//此次审批通过人数超过50%，审批通过
        CA_MApproveResultCell* resultCell = [tableView dequeueReusableCellWithIdentifier:resultKey];
        self.cellHeight = [resultCell configCell:model.values];
        return resultCell;
    }
    //审批情况
    CA_MApproveStatusCell* statusCell = [tableView dequeueReusableCellWithIdentifier:statusKey];
    self.cellHeight = [statusCell configCell:model.values.copy];
    return statusCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CA_MTypeModel* model = self.dataSource[indexPath.row];
    if (model.type == Select) {
        CA_MNewProjectContentVC *projectDetailVC = [CA_MNewProjectContentVC new];
        projectDetailVC.pId = self.approveDetailModel.approval_project_id;
        CA_H_WeakSelf(self);
        projectDetailVC.refreshBlock = ^(NSNumber*ids){
            CA_H_StrongSelf(self);
        };
        [self.navigationController pushViewController:projectDetailVC animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_MTypeModel* model = self.dataSource[indexPath.row];
    if (model.type == Input ||
        model.type == Select) {
        return 52*CA_H_RATIO_WIDTH;
    }
//    else if (model.type == Other) {//审批标准
//        return 114*CA_H_RATIO_WIDTH;
//    }
    else if (model.type == Introduce) {//审批意见
        return 133*CA_H_RATIO_WIDTH;
    }
    return self.cellHeight;
}

#pragma mark - getter and setter
-(CA_MApproveDetailFooterView *)footerView{
    if (_footerView) {
        return _footerView;
    }
    _footerView = [CA_MApproveDetailFooterView new];
    _footerView.delegate = self;
    _footerView.hidden = YES;
    return _footerView;
}
-(UITableView *)tableView{
    if (_tableView) {
        return _tableView;
    }
    _tableView = [UITableView newTableViewPlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.sectionHeaderHeight = 5;
    [_tableView registerClass:[CA_MInputCell class] forCellReuseIdentifier:inputKey];
    [_tableView registerClass:[CA_MSelectCell class] forCellReuseIdentifier:selectKey];
    [_tableView registerClass:[CA_MApproveStandardCell class] forCellReuseIdentifier:standardKey];
    [_tableView registerClass:[CA_MApproveSuggestionCell class] forCellReuseIdentifier:suggestionKey];
    [_tableView registerClass:[CA_MApproveResultCell class] forCellReuseIdentifier:resultKey];
    [_tableView registerClass:[CA_MApproveStatusCell class] forCellReuseIdentifier:statusKey];
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
