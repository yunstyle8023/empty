
//
//  CA_MSettingProjectVC.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/1.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MSettingProjectVC.h"
#import "CA_MTabBarController.h"
#import "CA_MNavigationController.h"
#import "CA_MSettingProjectNoLimitsView.h"
#import "CA_MSettingProjectView.h"
#import "CA_MChangeWorkSpace.h"
#import "CA_MSettingType.h"
#import "CA_MNewProjectVC.h"
#import "CA_MNewPersonVC.h"

@interface CA_MSettingProjectVC ()
<CA_MSettingProjectViewDelegate>

@property(nonatomic,strong)CA_MSettingProjectNoLimitsView* noProjectView;

@property(nonatomic,strong)CA_MSettingProjectView* projectView;

@end

@implementation CA_MSettingProjectVC

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setConstraint];
    [self requestData];
    [self addNotifation];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
}

-(void)setupUI{
    self.view.backgroundColor = kColor(@"#F8F8F8");
    [self.view addSubview:self.noProjectView];
    [self.view addSubview:self.projectView];
}

-(void)setConstraint{
    [self.noProjectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.projectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

-(void)addNotifation{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:CA_M_RefreshWorkbenchNotification object:nil];
}

-(void)requestData{
    [CA_HNetManager postUrlStr:CA_M_Api_ListWorkTable parameters:@{} callBack:^(CA_HNetModel *netModel) {
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]] &&
                    [NSObject isValueableObject:netModel.data]) {
                    //
                    self.projectView.hidden = NO;
                    self.noProjectView.hidden = YES;
                    
                    CA_MSettingModel* model = [CA_MSettingModel modelWithDictionary:netModel.data];
                    for (int i=0; i<model.mod_list.count; i++) {
                        CA_MSettingListModel* listModel = model.mod_list[i];
                        if (i == 0) {
                            listModel.selected = YES;
                        }else{
                            listModel.selected = NO;
                        }
                    }
                    //保存默认的选择
                    [CA_H_MANAGER saveDefaultItemKey:[model.mod_list firstObject].mod_type];
                    [CA_H_MANAGER saveDefaultItem:[model.mod_list firstObject].mod_name];
                    
                    self.projectView.model = model;
                }
            }else if(netModel.errcode.integerValue == 12003){
                self.projectView.hidden = YES;
                self.noProjectView.hidden = NO;
                self.noProjectView.message = @"抱歉，当前您没有权限查看。如有疑问请联系管理人员更改您的角色权限";
            }
        }
//        else{
//            [CA_HProgressHUD showHudStr:netModel.errmsg];
//        }
    } progress:nil];
}

#pragma mark - CA_MSettingProjectViewDelegate
-(void)changeWorkSpace{
    [CA_H_MANAGER saveDefaultSetting];
    
    UIViewController *vc = [[CA_H_MANAGER defaultItemKey] isEqualToString:SettingType_Project] ? [CA_MNewProjectVC new] : [CA_MNewPersonVC new];
    [CA_MChangeWorkSpace changeWorkSpace:vc];
}

-(CA_MSettingProjectNoLimitsView *)noProjectView{
    if (_noProjectView) {
        return _noProjectView;
    }
    _noProjectView = [[CA_MSettingProjectNoLimitsView alloc] init];
    _noProjectView.hidden = YES;
    return _noProjectView;
}
-(CA_MSettingProjectView *)projectView{
    if (_projectView) {
        return _projectView;
    }
    _projectView = [[CA_MSettingProjectView alloc] init];
    _projectView.delegate = self;
    _projectView.hidden = YES;
    return _projectView;
}

@end

