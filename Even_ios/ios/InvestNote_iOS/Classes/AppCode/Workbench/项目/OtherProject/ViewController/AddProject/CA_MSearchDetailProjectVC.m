//
//  CA_MProjectProgressVC.m
//  InvestNote_iOS
//  Created by yezhuge on 2017/12/15.
//  God bless me without no bugs.
//

#import "CA_MSearchDetailProjectVC.h"
#import "CA_MSearchDetailHeaderView.h"
#import "CA_MSearchDetailSectionHeaderView.h"
#import "CA_MSearchDetailIntroduceCell.h"
#import "CA_MSearchDetailInformationBeginCell.h"
#import "CA_MSearchDetailInformationMiddleCell.h"
#import "CA_MSearchDetailInformationEndCell.h"
#import "CA_MSelectModelDetail.h"
#import "CA_MAddProjectVC.h"
#import "CA_MTabBarController.h"
#import "CA_MNavigationController.h"

static NSString* const introduceKey = @"CA_MSearchDetailintroduceCell";
static NSString* const beginKey = @"CA_MSearchDetailInformationBeginCell";
static NSString* const middleKey = @"CA_MSearchDetailInformationMiddleCell";
static NSString* const endKey = @"CA_MSearchDetailInformationEndCell";

@interface CA_MSearchDetailProjectVC ()
<UITableViewDataSource,
UITableViewDelegate>


/// 灰色的背景
@property(nonatomic,strong)UIView* bgView;
/// tableview的背景
@property(nonatomic,strong)UIView* tableBgView;
/// 列表table
@property(nonatomic,strong)UITableView* tableView;
/// headerView
@property(nonatomic,strong)CA_MSearchDetailHeaderView* headerView;
/// 右上角关闭按钮
@property(nonatomic,strong)UIButton* closeBtn;
/// 底部的一键收录
@property(nonatomic,strong)CA_HSetButton* includeBtn;
///
@property(nonatomic,assign)CGFloat cellHeight;

@property (nonatomic,strong) CA_MSelectModelDetail *detailModel;

@property (nonatomic,assign) CGFloat headerHeight;
@end

@implementation CA_MSearchDetailProjectVC

#pragma mark - LifeCycle

-(instancetype)init{
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor clearColor];
        self.providesPresentationContextTransitionStyle = YES;
        self.definesPresentationContext = YES;
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.contentView.hidden = YES;
        self.headerHeight = 170*CA_H_RATIO_WIDTH;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableBgView).offset(14);
        make.trailing.mas_equalTo(self.tableBgView).offset(-14);
    }];

    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.tableBgView);
        make.top.mas_equalTo(self.tableBgView);
        make.width.mas_equalTo(295*CA_H_RATIO_WIDTH);
        make.height.mas_equalTo(self.headerHeight);
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.leading.mas_equalTo(self.tableBgView);
        make.trailing.mas_equalTo(self.tableBgView);
        make.bottom.mas_equalTo(self.tableBgView).offset(-42);
    }];

    [self.includeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom);
        make.leading.trailing.mas_equalTo(self.tableView);
        make.bottom.mas_equalTo(self.tableBgView);
    }];
}

- (void)setupUI{
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.tableBgView];
    [self.tableBgView addSubview:self.headerView];
    [self.tableBgView addSubview:self.tableView];
    [self.tableBgView addSubview:self.closeBtn];
    [self.tableBgView addSubview:self.includeBtn];
}

-(void)setModel:(CA_MSelectModel *)model{
    _model = model;
    [self requestData];
}

-(void)requestData{
    
    NSDictionary* parameters = @{@"data_id":self.model.data_id,
                                 @"data_type":@"project"
                                 };
//    [CA_HProgressHUD loading:self.view];
    [CA_HNetManager postUrlStr:CA_M_Api_SearchDataDetail parameters:parameters callBack:^(CA_HNetModel *netModel) {
//        [CA_HProgressHUD hideHud:self.view];
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]] &&
                    [NSObject isValueableObject:netModel.data]) {
                    self.detailModel = [CA_MSelectModelDetail modelWithDictionary:netModel.data];
                    self.headerView.model = self.detailModel;
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

- (void)closeBtnAction{
    [self dismissViewControllerAnimated:NO completion:nil];
}


/**
 一键收录
 */
- (void)includeBtnAction{

    if (!self.self.detailModel) {
        [CA_HProgressHUD showHudStr:@"暂无数据"];
        return;
    }
    
    [self dismissViewControllerAnimated:NO completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            CA_MAddProjectVC* addProjectVC = [[CA_MAddProjectVC alloc] init];
            addProjectVC.detailModel = self.detailModel;
            
            CA_MTabBarController* tabbar = (CA_MTabBarController*)CA_H_MANAGER.mainWindow.rootViewController;
            CA_MNavigationController* navi = tabbar.selectedViewController;
            [navi pushViewController:addProjectVC animated:YES];
        });
    }];
    
}


#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    if ([NSObject isValueableObject:self.detailModel.invest_history_list]) {
        return self.detailModel.invest_history_list.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {// 项目介绍
        CA_MSearchDetailIntroduceCell* introduceCell = [tableView dequeueReusableCellWithIdentifier:introduceKey];
        self.cellHeight = [introduceCell configCell:[NSString isValueableString:self.detailModel.project_intro]?self.detailModel.project_intro:@""];
        return introduceCell;
    }
    //融资历史
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            CA_MSearchDetailInformationBeginCell* beginCell = [tableView dequeueReusableCellWithIdentifier:beginKey];
            if ([NSObject isValueableObject:self.detailModel.invest_history_list]) {
                CA_MInvest_history* model = self.detailModel.invest_history_list[indexPath.row];
                self.cellHeight = [beginCell configCell:model];
            }
            return beginCell;
        }
        
        if (indexPath.row == self.detailModel.invest_history_list.count - 1) {
            CA_MSearchDetailInformationEndCell* endCell = [tableView dequeueReusableCellWithIdentifier:endKey];
            if ([NSObject isValueableObject:self.detailModel.invest_history_list]) {
                CA_MInvest_history* model = self.detailModel.invest_history_list[indexPath.row];
                self.cellHeight = [endCell configCell:model];
            }
            return endCell;
        }
    }
    
    CA_MSearchDetailInformationMiddleCell* middleCell = [tableView dequeueReusableCellWithIdentifier:middleKey];
    if ([NSObject isValueableObject:self.detailModel.invest_history_list]) {
        CA_MInvest_history* model = self.detailModel.invest_history_list[indexPath.row];
        self.cellHeight = [middleCell configCell:model];
    }
    return middleCell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CA_MSearchDetailSectionHeaderView* headerView = [[CA_MSearchDetailSectionHeaderView alloc] init];
    if (section == 0) {
        headerView.title = @"项目介绍";
    }else if (section == 1) {
        headerView.title = @"融资历史";
    }
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark - Getter and Setter
-(CA_HSetButton *)includeBtn{
    if (_includeBtn) {
        return _includeBtn;
    }
    _includeBtn = [[CA_HSetButton alloc] init];
    [_includeBtn configTitle:@"一键收录" titleColor:kColor(@"#FFFFFF") font:16];
    _includeBtn.backgroundColor = CA_H_TINTCOLOR;
    [_includeBtn addTarget:self action:@selector(includeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    return _includeBtn;
}
-(UIButton *)closeBtn{
    if (_closeBtn) {
        return _closeBtn;
    }
    _closeBtn = [[UIButton alloc] init];
    [_closeBtn setImage:kImage(@"close_icon") forState:UIControlStateNormal];
    [_closeBtn setImage:kImage(@"close_icon") forState:UIControlStateHighlighted];
    [_closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    return _closeBtn;
}
-(CA_MSearchDetailHeaderView *)headerView{
    if (_headerView) {
        return _headerView;
    }
    _headerView = [[CA_MSearchDetailHeaderView alloc] init];
    CA_H_WeakSelf(self);
    _headerView.block = ^(NSInteger row) {
        CA_H_StrongSelf(self);
        if (row>=2) {
            self.headerHeight = self.headerHeight + 24 + 10;
            [self.view layoutIfNeeded];
        }
    };
    return _headerView;
}
-(UITableView *)tableView{
    if (_tableView) {
        return _tableView;
    }
    _tableView = [UITableView newTableViewGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[CA_MSearchDetailIntroduceCell class] forCellReuseIdentifier:introduceKey];
    [_tableView registerClass:[CA_MSearchDetailInformationBeginCell class] forCellReuseIdentifier:beginKey];
    [_tableView registerClass:[CA_MSearchDetailInformationMiddleCell class] forCellReuseIdentifier:middleKey];
    [_tableView registerClass:[CA_MSearchDetailInformationEndCell class] forCellReuseIdentifier:endKey];
    return _tableView;
}
-(UIView *)tableBgView{
    if (_tableBgView) {
        return _tableBgView;
    }
    _tableBgView = [[UIView alloc] initWithFrame:CGRectMake(40*CA_H_RATIO_WIDTH, kDevice_Is_iPhoneX?100:50* CA_H_RATIO_WIDTH, 295*CA_H_RATIO_WIDTH, 565*CA_H_RATIO_WIDTH)];
    _tableBgView.layer.cornerRadius = 10;
    _tableBgView.layer.masksToBounds = YES;
    return _tableBgView;
}
-(UIView *)bgView{
    if (_bgView) {
        return _bgView;
    }
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = kColor(@"#04040F");
    _bgView.alpha = 0.5;
    return _bgView;
}
@end
