//
//  CA_MProjectProgressView.m
//  InvestNote_iOS
//  Created by yezhuge on 2017/12/12.
//  God bless me without no bugs.
//

#import "CA_MProjectProgressView.h"
#import "CA_MSettingHeaderView.h"
#import "CA_MProjectProgressCell.h"
#import "CA_MProjectRecordCell.h"
#import "CA_MProjectProgressSuccessCell.h"
#import "CA_MProjectProgressStageCell.h"
#import "CA_HSelectMenuView.h"
#import "CA_MProjectProgressMaskView.h"
#import "CA_MProjectProgressModel.h"
#import "CA_MSelectDataVC.h"
#import "CA_MTabBarController.h"
#import "CA_MNavigationController.h"


static NSString* const progressKey = @"CA_MProjectProgressCell";
static NSString* const recordKey = @"CA_MProjectRecordCell";
static NSString* const successKey = @"CA_MProjectProgressSuccessCell";
static NSString* const stageKey = @"CA_MProjectProgressStageCell";

@interface CA_MProjectProgressView()
<UITableViewDataSource,
UITableViewDelegate,
CA_MProjectProgressCellDelegate>{
    NSNumber* _nextNode_id;
//    CA_Mprocedure_viewModel* _currenModel;
}

@property(nonatomic,assign)CGFloat cellHeight;
@property (nonatomic,strong) CA_MProjectProgressModel *progressModel;
@end

@implementation CA_MProjectProgressView

#pragma mark - Init

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self configTableView];
    }
    return self;
}

-(void)configTableView{
    self.dataSource = self;
    self.delegate = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self registerClass:[CA_MProjectProgressCell class] forCellReuseIdentifier:progressKey];
    [self registerClass:[CA_MProjectRecordCell class] forCellReuseIdentifier:recordKey];
    [self registerClass:[CA_MProjectProgressSuccessCell class] forCellReuseIdentifier:successKey];
    [self registerClass:[CA_MProjectProgressStageCell class] forCellReuseIdentifier:stageKey];
    [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark - requestData

-(void)setProject_id:(NSNumber *)project_id{
    _project_id = project_id;
    [self requestData];
}

- (void)requestData{
    
    NSDictionary* parameters = @{@"project_id":self.project_id};
    [CA_HNetManager postUrlStr:CA_M_Api_QueryProcedure parameters:parameters callBack:^(CA_HNetModel *netModel) {
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue==0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]]) {
                    self.progressModel = [CA_MProjectProgressModel modelWithDictionary:netModel.data];
                    [self reloadData];
                    return ;
                }
            }
        }
        [CA_HProgressHUD showHudStr:netModel.errmsg];
    } progress:nil];
}

#pragma mark - CA_MProjectProgressCellDelegate

/**
 进入下一阶段
 */
-(void)nextStageBtnClick{
    
    if (![NSObject isValueableObject:self.progressModel.procedure_view]) {
        [CA_HProgressHUD showHudStr:@"暂无数据"];
        return;
    }
    
//    CA_Mprocedure_viewModel* lastModel = [self.progressModel.procedure_view lastObject];
//    if (self.progressModel.current_node_id.intValue+1 > lastModel.procedure_id.intValue) {
//        [CA_HProgressHUD showHudStr:@"已经是最后一步"];
//        return;
//    }
    
    NSString* procedure_name = @"";
    for (CA_Mprocedure_viewModel* model in self.progressModel.procedure_view) {
        if ((self.progressModel.current_node_id.intValue+1) == model.procedure_id.intValue) {
//            _currenModel = model;
            _nextNode_id = model.procedure_id;
            procedure_name = model.procedure_name;
            break;
        }
    }
    
    [self chooseStage:[NSString stringWithFormat:@"即将进入%@阶段",procedure_name] confirmString:@"确认进入"];
}

/**
 阶段撤回
 */
-(void)stageRecallBtnClick{
    
    if (![NSObject isValueableObject:self.progressModel.procedure_view]) {
        [CA_HProgressHUD showHudStr:@"暂无数据"];
        return;
    }
    
//    if (self.progressModel.current_node_id == [self.progressModel.procedure_view firstObject].procedure_id) {
//        [CA_HProgressHUD showHudStr:@"已经是第一步,无法撤回"];
//        return;
//    }
    
    NSMutableArray* tmpArr = @[].mutableCopy;
    for (CA_Mprocedure_viewModel* model in self.progressModel.procedure_view) {
        if (self.progressModel.current_node_id.intValue > model.procedure_id.intValue) {
            [tmpArr addObject:model];
        }
    }
    
    CA_H_WeakSelf(self);
    CGRect rect = CGRectMake(0, CA_H_SCREEN_HEIGHT - 272*CA_H_RATIO_WIDTH , CA_H_SCREEN_WIDTH, 272*CA_H_RATIO_WIDTH);
    CA_MSelectDataVC* dataVC = [[CA_MSelectDataVC alloc] initWithShowFrame:rect ShowStyle:MYPresentedViewShowStyleFromBottomSpreadStyle callback:^(CA_Mprocedure_viewModel* selectModel) {
        CA_H_StrongSelf(self);
        if (selectModel) {
//            _currenModel = selectModel;
            _nextNode_id = selectModel.procedure_id;
            [self chooseStage:[NSString stringWithFormat:@"即将撤回至%@阶段",selectModel.procedure_name] confirmString:@"确认撤回"];
        }
    }];
    dataVC.progress = YES;
    dataVC.dataSource = tmpArr;
    dataVC.className = @"CA_Mprocedure_viewModel";
    dataVC.key = @"procedure_name";
    dispatch_async(dispatch_get_main_queue(), ^{
        CA_MTabBarController* tabbar = (CA_MTabBarController*)CA_H_MANAGER.mainWindow.rootViewController;
         CA_MNavigationController* navi = tabbar.selectedViewController;
        [navi.topViewController presentViewController:dataVC animated:YES completion:nil];
    });
    
}


/**
 撤销审批
 */
-(void)revocationBtnClick{
//    [self stageRecallBtnClick];
    for (CA_Mprocedure_viewModel* model in self.progressModel.procedure_view) {
        if ((self.progressModel.current_node_id.intValue-1) == model.procedure_id.intValue) {
            _nextNode_id = model.procedure_id;
            [self chooseStage:[NSString stringWithFormat:@"即将撤回至%@阶段",model.procedure_name] confirmString:@"确认撤回"];
            break;
        }
    }
    
}

-(void)chooseStage:(NSString*)title confirmString:(NSString*)confirmString{
    CA_MProjectProgressMaskView* maskView = [[CA_MProjectProgressMaskView alloc] initWithFrame:CA_H_MANAGER.mainWindow.bounds];
    maskView.title = title;
    maskView.confirmString = confirmString;
    [maskView showMaskView];
    maskView.confirmClick = ^(NSString* content){
        if (![NSString isValueableString:content]) {
            [CA_HProgressHUD showHudStr:@"请填写理由和备忘"];
            return;
        }
        
        if ([confirmString isEqualToString:@"确认进入"]) {
            [self operationProcedureUrl:CA_M_Api_ForwardProcedure content:content];
        }else{
            [self operationProcedureUrl:CA_M_Api_BackwardProcedure content:content];
        }
    };
}

-(void)operationProcedureUrl:(NSString*)url content:(NSString*)content{
    NSDictionary* parameters = @{@"project_id": self.project_id,
                                 @"procedure_id": _nextNode_id,
                                 @"reason": content};
    [CA_HProgressHUD loading:CA_H_MANAGER.mainWindow];
    [CA_HNetManager postUrlStr:url parameters:parameters callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud:CA_H_MANAGER.mainWindow];
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                //刷新项目列表
                [[NSNotificationCenter defaultCenter] postNotificationName:CA_M_RefreshProjectListNotification object:nil];
                [self requestData];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    if ([NSObject isValueableObject:self.progressModel.procedure_log]) {
        return self.progressModel.procedure_log.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {//项目进展
        CA_MProjectProgressCell* progressCell = [tableView dequeueReusableCellWithIdentifier:progressKey];
        progressCell.delegate = self;
        if (self.progressModel) {
            progressCell.model = self.progressModel;
        }
        progressCell.member_type_id = self.member_type_id;
        return progressCell;
    }
    
    if ([NSObject isValueableObject:self.progressModel.procedure_log]) {//进展记录
        CA_MProcedure_logModel* model = self.progressModel.procedure_log[indexPath.row];
        if (([model.procedure_status isEqualToString:@"success"] &&
                   ![NSString isValueableString:model.procedure_comment]) || //项目进入到 xx 阶段
                  [model.procedure_status isEqualToString:@"revoke"] ||//项目撤回 xx 阶段
                  [model.procedure_status isEqualToString:@"archive"] ||//放弃项目
                  [model.procedure_status isEqualToString:@"reactivate"]){//项目激活 进入 xx 阶段
            CA_MProjectRecordCell* recordCell = [tableView dequeueReusableCellWithIdentifier:recordKey];
            self.cellHeight = [recordCell configCell:model
                                           indexPath:indexPath
                                            totalRow:self.progressModel.procedure_log.count];
            return recordCell;
        }else if (([model.procedure_status isEqualToString:@"success"] &&
                   [NSString isValueableString:model.procedure_comment]) ||//审批通过，进行 xx 阶段
                  [model.procedure_status isEqualToString:@"fail"]) {//审批不通过，无法进入 xx 阶段
            
            CA_MProjectProgressSuccessCell* successCell = [tableView dequeueReusableCellWithIdentifier:successKey];
            self.cellHeight = [successCell configCell:model
                                            indexPath:indexPath
                                             totalRow:self.progressModel.procedure_log.count];
            return successCell;
        }else if ([model.procedure_status isEqualToString:@"pending"]) {//申请进入 xx 阶段
            CA_MProjectProgressStageCell* stageCell = [tableView dequeueReusableCellWithIdentifier:stageKey];
            self.cellHeight = [stageCell configCell:model
                                            indexPath:indexPath
                                             totalRow:self.progressModel.procedure_log.count];
            return stageCell;
        }
    }
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    self.cellHeight = 0.;
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 174*CA_H_RATIO_WIDTH;
    }
    return self.cellHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return ({
            UIView* view = [UIView new];
            view.backgroundColor = kColor(@"#FFFFFF");
            UILabel* title = [UILabel new];
            [title configText:@"项目进展" textColor:CA_H_4BLACKCOLOR font:16];
            [view addSubview:title];
            [title mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(view).offset(20);
                make.bottom.mas_equalTo(view);
            }];
            view;
        });
    }
    CA_MSettingHeaderView* header = [CA_MSettingHeaderView new];
    header.backgroundColor = kColor(@"#FFFFFF");
    header.titleColor = @"#444444";
    header.font = 16;
    header.title = @"进展记录";
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 42;
    }
    return 62;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark - Public

#pragma mark - Private

@end
