//
//  CA_MPersonDetailInfoVC.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MPersonDetailInfoVC.h"
#import "CA_MPersonDetailInfoHeaderView.h"
#import "CA_MPersonDetailBaseCell.h"
#import "CA_MPersonDetailRelevanceCell.h"
#import "CA_MPersonDetailAddRelevanceCell.h"
#import "CA_MPersonDetailBaseInfoCell.h"
#import "CA_MPersonDetailRecordCell.h"
#import "CA_MTabBarController.h"
#import "CA_MNavigationController.h"
#import "CA_MAddRelevanceProjectVC.h"
#import "CA_MProjectProgressMaskView.h"
#import "CA_MTypeModel.h"
#import "CA_MProjectModel.h"
#import "CA_HMoveListViewController.h"

static NSString* const relKey = @"CA_MPersonDetailRelevanceCell";
static NSString* const addKey = @"CA_MPersonDetailAddRelevanceCell";
static NSString* const infoKey = @"CA_MPersonDetailBaseCell";
static NSString* const baseKey = @"CA_MPersonDetailBaseInfoCell";
static NSString* const recordKey = @"CA_MPersonDetailRecordCell";


@interface CA_MPersonDetailInfoVC ()
@property (nonatomic,strong) NSMutableArray *titles;
@property (nonatomic,strong) CA_MPersonDetailModel *detailModel;
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,strong) NSMutableArray *baseInfoArr;
@end

@implementation CA_MPersonDetailInfoVC

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[CA_MPersonDetailBaseCell class] forCellReuseIdentifier:infoKey];
    [self.tableView registerClass:[CA_MPersonDetailRelevanceCell class] forCellReuseIdentifier:relKey];
    [self.tableView registerClass:[CA_MPersonDetailAddRelevanceCell class] forCellReuseIdentifier:addKey];
    [self.tableView registerClass:[CA_MPersonDetailBaseInfoCell class] forCellReuseIdentifier:baseKey];
    [self.tableView registerClass:[CA_MPersonDetailRecordCell class] forCellReuseIdentifier:recordKey];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHumanList:) name:CA_M_RefreshHumanListNotification object:nil];
}

-(void)setHumanID:(NSNumber *)humanID{
    _humanID = humanID;
    [self queryHumanResource];
}

-(void)refreshHumanList:(NSNotification*)noti{
    self.humanID = noti.object[@"id"];
    [self queryHumanResource];
}

-(void)queryHumanResource{
    [CA_HNetManager postUrlStr:CA_M_Api_QueryHumanResource parameters:@{@"human_id":self.humanID} callBack:^(CA_HNetModel *netModel) {
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]] &&
                    [NSObject isValueableObject:netModel.data]) {
                    self.detailModel = [CA_MPersonDetailModel modelWithDictionary:netModel.data];
                    [self updateBaseInfo];
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

-(void)updateBaseInfo{
    if (self.block) {
        self.block(self.detailModel);
    }
    
    CA_MTypeModel* bornModel = [CA_MTypeModel new];
    bornModel.title = @"出生日期";
    if (self.detailModel.human_detail.ts_born.longValue <= -2208988800) {
        bornModel.value = @"暂无";
    }else{
        NSDate *bornDate = [NSDate dateWithTimeIntervalSince1970:self.detailModel.human_detail.ts_born.longValue];
        NSString* bornDateStr = [bornDate stringWithFormat:@"yyyy.MM.dd"];//@"2017.12.12"
        bornModel.value = bornDateStr;
    }
    
    CA_MTypeModel* telModel = [CA_MTypeModel new];
    telModel.title = @"联系电话";
    telModel.value = self.detailModel.human_detail.phone;
    
    CA_MTypeModel* emailModel = [CA_MTypeModel new];
    emailModel.title = @"邮箱";
    emailModel.value = self.detailModel.human_detail.email;
    
    CA_MTypeModel* addressModel = [CA_MTypeModel new];
    addressModel.title = @"家庭住址";
    addressModel.value = self.detailModel.human_detail.address;
    [self.baseInfoArr removeAllObjects];
    [self.baseInfoArr addObjectsFromArray:@[bornModel,telModel,emailModel,addressModel]];
}

-(void)editRelation:(NSNumber*)contact_id position:(NSString*)position{
    [CA_HProgressHUD loading:self.view];
    [CA_HNetManager postUrlStr:CA_M_Api_UpdateObjectHuman parameters:@{@"contact_id":contact_id,@"job_position":position} callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud:self.view];
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]] &&
                    [NSObject isValueableObject:netModel.data]) {
                    self.detailModel = [CA_MPersonDetailModel modelWithDictionary:netModel.data];
                    [self updateBaseInfo];
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

-(void)relieveRelation:(NSNumber*)contact_id{
    [CA_HProgressHUD loading:self.view];
    [CA_HNetManager postUrlStr:CA_M_Api_DeleteObjectHuman parameters:@{@"contact_id":contact_id} callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud:self.view];
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]] &&
                    [NSObject isValueableObject:netModel.data]) {
                    self.detailModel = [CA_MPersonDetailModel modelWithDictionary:netModel.data];
                    [self updateBaseInfo];
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

-(void)createObjectHuman:(CA_MProjectModel*)projectModel position:(NSString*)position{
    NSDictionary* parameters = @{@"object_id":projectModel.project_id,
                   @"object_type":@"project",
                   @"human_id":self.humanID,
                   @"job_position":position
                   };
    [CA_HProgressHUD loading:self.view];
    [CA_HNetManager postUrlStr:CA_M_Api_CreateObjectHuman parameters:parameters callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud:self.view];
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                [self queryHumanResource];
            }else{
                [CA_HProgressHUD showHudStr:netModel.errmsg];
            }
        }
//        else{
//            [CA_HProgressHUD showHudStr:netModel.errmsg];
//        }
    } progress:nil];
}
#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return self.detailModel.contact_project.count+1;
    }else if (section == 2){
        return 4;
    }
    return self.detailModel.job_experience.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == self.detailModel.contact_project.count) {//添加关联项目
            CA_MPersonDetailAddRelevanceCell * addRelevanceCell = [tableView dequeueReusableCellWithIdentifier:addKey];
            return addRelevanceCell;
        }
        CA_MPersonDetailRelevanceCell * relevanceCell = [tableView dequeueReusableCellWithIdentifier:relKey];//关联项目
        if ([NSObject isValueableObject:self.detailModel.contact_project]) {
            relevanceCell.model = self.detailModel.contact_project[indexPath.row];
        }
        return relevanceCell;
    }else if (indexPath.section == 2){//基本资料
        CA_MPersonDetailBaseInfoCell* baseCell = [tableView dequeueReusableCellWithIdentifier:baseKey];
        if ([NSObject isValueableObject:self.baseInfoArr]) {
            self.cellHeight = [baseCell configCell:self.baseInfoArr[indexPath.row]];
        }
        return baseCell;
    }else if (indexPath.section == 3){//工作履历
        CA_MPersonDetailRecordCell* recordCell = [tableView dequeueReusableCellWithIdentifier:recordKey];
        if ([NSObject isValueableObject:self.detailModel.job_experience]) {
            CA_MJob_experience* model = self.detailModel.job_experience[indexPath.row];
            self.cellHeight = [recordCell configCell:model
                         indexPath:indexPath
                          totalRow:self.detailModel.job_experience.count];
        }
        return recordCell;
    }
    //基本信息
    CA_MPersonDetailBaseCell *baseCell = [tableView dequeueReusableCellWithIdentifier:infoKey];
    if (self.detailModel) {
        self.cellHeight = [baseCell configCell:self.detailModel];
    }
    return baseCell;
}

#pragma mark - TableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        if (indexPath.row != self.detailModel.contact_project.count) {//编辑关联项目
            if (![NSObject isValueableObject:self.detailModel.contact_project]) {
                [CA_HProgressHUD showHudStr:@"暂无数据"];
                return;
            }
            CA_MContact_project* contactModel = self.detailModel.contact_project[indexPath.row];
            __weak CA_MContact_project* weakContactModel = contactModel;
            UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                CA_MProjectProgressMaskView* maskView = [[CA_MProjectProgressMaskView alloc] initWithFrame:CA_H_MANAGER.mainWindow.bounds];
                maskView.title = @"关联关系";
                maskView.placeHolder = @"请填写人与项目的关联关系";
                maskView.confirmString = @"完成";
                [maskView showMaskView];
                maskView.confirmClick = ^(NSString*content){
                    if (![NSString isValueableString:content]) {
                        [CA_HProgressHUD showHudStr:@"请填写人与项目的关联关系"];
                        return;
                    }
                    [self editRelation:weakContactModel.contact_id position:content];
                };
            }];
            UIAlertAction *delAction = [UIAlertAction actionWithTitle:@"解除关系" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //解除关系
                [self relieveRelation:contactModel.contact_id];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"取消");
            }];
            
            UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [actionSheetController addAction:editAction];
            [actionSheetController addAction:delAction];
            [actionSheetController addAction:cancelAction];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:actionSheetController animated:YES completion:nil];
            });
        }else{//添加关联项目
            CA_H_WeakSelf(self);
            CA_MTabBarController* tabbar = (CA_MTabBarController*)CA_H_MANAGER.mainWindow.rootViewController;
            CA_MNavigationController* navi = tabbar.selectedViewController;
            CA_HMoveListViewController *vc = [CA_HMoveListViewController new];
            vc.naviTitle = @"添加关联项目";
            vc.type = @(3);
            vc.addBlock = ^(CA_MProjectModel *model, NSString *content) {
                CA_H_StrongSelf(self);
                [self createObjectHuman:model position:content];
            };
            [navi pushViewController:vc animated:YES];
        }
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 65*CA_H_RATIO_WIDTH;
    }
    return self.cellHeight;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return ({
        CA_MPersonDetailInfoHeaderView* view = [[CA_MPersonDetailInfoHeaderView alloc]
                                                initWithTitle:self.titles[section][@"title"]
                                                hidden:[self.titles[section][@"hidden"] boolValue] message:self.titles[section][@"message"]];
        view;
    });
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 65*CA_H_RATIO_WIDTH;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(NSMutableArray *)baseInfoArr{
    if (_baseInfoArr) {
        return _baseInfoArr;
    }
    _baseInfoArr = @[].mutableCopy;
    return _baseInfoArr;
}

-(NSMutableArray *)titles{
    if (_titles) {
        return _titles;
    }
    _titles = @[].mutableCopy;
    NSArray* tmp = @[@{@"title":@"基本信息",@"hidden":@"1",@"message":@""},
                     @{@"title":@"关联项目",@"hidden":@"0",@"message":@""},
                     @{@"title":@"基本资料",@"hidden":@"0",@"message":@""},
                     @{@"title":@"工作履历",@"hidden":@"0",@"message":@"请前往网页版编辑"}];
    [_titles addObjectsFromArray:tmp];
    return _titles;
}

@end
