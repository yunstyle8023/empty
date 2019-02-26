//
//  CA_MProjectDetailVC.m
//  InvestNote_iOS
//  Created by yezhuge on 2017/12/8.
//  God bless me without no bugs.
//

#import "CA_MProjectDetailVC.h"
#import "CA_MProjectDetailHeaderView.h"
#import "CA_MProjectDetailSectionHeaderView.h"
#import "CA_MProjectDetailProjectInfoCell.h"
#import "CA_MProjectDetailPersonnelCell.h"
#import "CA_MProjectDetailDisplayCell.h"
#import "CA_MProjectDetailHistoryBeginCell.h"
#import "CA_MProjectDetailHistoryProgressCell.h"
#import "CA_MProjectDetailHistoryEndCell.h"
#import "CA_MProjectInfoVC.h"
#import "CA_MProjectBaseInfoVC.h"
#import "CA_MAddRelatedMemberVC.h"
#import "CA_MAddRelatedMemberVC.h"
#import "CA_MProjectModel.h"
#import "CA_MProjectDetailModel.h"
#import "CA_MPersonDetailVC.h"
#import "CA_HLongViewController.h"
#import "ButtonLabel.h"
#import "CA_HBusinessDetailsController.h"
#import "CA_MDiscoverRelatedPersonVC.h"
#import "CA_MDiscoverProjectDetailTagVC.h"

static NSString* const informationKey = @"CA_MProjectDetailProjectInfoCell";
static NSString* const personnelKey = @"CA_MProjectDetailPersonnelCell";
static NSString* const displayKey = @"CA_MProjectDetailDisplayCell";
static NSString* const beginKey = @"CA_MProjectDetailHistoryBeginCell";
static NSString* const progressKey = @"CA_MProjectDetailHistoryProgressCell";
static NSString* const endKey = @"CA_MProjectDetailHistoryEndCell";

@interface CA_MProjectDetailVC ()
<UITableViewDataSource,
UITableViewDelegate,
CA_MProjectDetailSectionHeaderViewDelegate,
CA_MProjectDetailPersonnelCellDelegate,
UIScrollViewDelegate>{
    NSArray* _baseInfo;
    NSArray* _companyInfo;
    NSInteger _sections;
}

/// 右barButtonItem
@property(nonatomic,strong)UIBarButtonItem* rightBarBtnItem;
@property (nonatomic,strong) UIScrollView *scrollView;
/// tableView
@property(nonatomic,strong)UITableView* tableView;
/// headerView
@property(nonatomic,strong)CA_MProjectDetailHeaderView* headerView;
/// dataSource
@property(nonatomic,strong)CA_MProjectDetailModel* detailModel;

@property (nonatomic,strong) UIButton *titleView;

@property (nonatomic,copy) NSString *enterprise_name;
@property (nonatomic,assign) CGFloat infoHeight;
@property (nonatomic,assign) CGFloat investHeight;
@end

@implementation CA_MProjectDetailVC

#pragma mark - LifeCycle

-(void)dealloc{
    [self.tableView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self initParameters];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    //    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.edges.mas_equalTo(self.view);
    //    }];
}

#pragma mark - public

#pragma mark - private

- (void)upNavigationButtonItem{
    if (self.detailModel.member_type_id.intValue != 0) {
        self.navigationItem.rightBarButtonItem = self.rightBarBtnItem;
    }
    self.navigationItem.titleView = self.titleView;
}

- (void)setupUI{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.tableView];
}

- (void)initParameters{
    _baseInfo = @[@"项目来源",@"介绍人",@"目前估值（万元）",@"币种",@"估值方式",@"项目进展"];
    _companyInfo = @[@"工商全称",@"法人代表",@"成立日期",@"注册资本（万元）",@"相关网站",@"微信公众号"];
}

-(NSString*)getBaseStr:(NSString*)str{//currency_cn
    if ([str isEqualToString:@"项目来源"]) {
        return self.detailModel.basic_info.source.source_name;
    }else if ([str isEqualToString:@"介绍人"]) {
        return self.detailModel.basic_info.contact;
    }else if ([str isEqualToString:@"目前估值（万元）"]) {
        return [NSString stringWithFormat:@"%.2f", self.detailModel.basic_info.valuation.amount.doubleValue/10000.0];
    }else if ([str isEqualToString:@"币种"]) {
        return self.detailModel.basic_info.valuation.currency_cn;
    }else if ([str isEqualToString:@"估值方式"]) {
        return self.detailModel.basic_info.valuation_method.valuation_method_name;
    }else if ([str isEqualToString:@"项目进展"]) {
        return self.detailModel.basic_info.procedure_status.procedure_status_name;
    }
    return @"";
}

-(NSString*)getCompanyStr:(NSString*)str{
    if ([str isEqualToString:@"工商全称"]) {
        return self.detailModel.company_info.company_name;
    }else if ([str isEqualToString:@"法人代表"]) {
        return self.detailModel.company_info.legal_person;
    }else if ([str isEqualToString:@"成立日期"]) {
        
        if (self.detailModel.company_info.found_time.longValue<=-2208988800) {
            return @"暂无";
        }
        NSDate *bornDate = [NSDate dateWithTimeIntervalSince1970:self.detailModel.company_info.found_time.longValue];
        NSString *found_time = [NSString stringWithFormat:@"%ld年%ld月%ld日",(long)bornDate.year,(long)bornDate.month,(long)bornDate.day];
        return found_time;
    }else if ([str isEqualToString:@"注册资本（万元）"]) {
        return self.detailModel.company_info.register_capital;
    }else if ([str isEqualToString:@"相关网站"]) {
        return self.detailModel.company_info.company_website;
    }else if ([str isEqualToString:@"微信公众号"]) {
        return self.detailModel.company_info.company_wechat;
    }
    return @"";
}

- (void)requestData{
    
    NSDictionary* parameters = @{@"project_id":self.model.project_id};
    [CA_HProgressHUD loading:self.view];
    [CA_HNetManager postUrlStr:CA_M_Api_GetDetail parameters:parameters callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud:self.view];
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]]) {
                    self.detailModel = [CA_MProjectDetailModel modelWithDictionary:netModel.data];
                    self.headerView.model = self.detailModel.header_info;
                    [self.titleView setTitle:self.detailModel.header_info.project_name forState:UIControlStateNormal];
                    [self.tableView reloadData];
                    //
                    [self upNavigationButtonItem];
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    id oldName = [change objectForKey:NSKeyValueChangeOldKey];
    id newName = [change objectForKey:NSKeyValueChangeNewKey];
    //当界面要消失的时候,移除kvo
    CGSize size = [newName CGSizeValue];
    if (size.height > 0) {
        self.tableView.size = size;
        self.scrollView.contentSize = size;
    }
}

/**
 截图到相册
 */
- (void)clickRightBarBtnAction{
    UIImage *image = [self.tableView snapshotImage];
    CA_HLongViewController* longViewVC = [CA_HLongViewController new];
    longViewVC.image = image;
    [self.navigationController pushViewController:longViewVC animated:YES];
    //    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

/**
 错误回调
 
 @param image <#image description#>
 @param error <#error description#>
 @param contextInfo <#contextInfo description#>
 */
//- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
//    if (error) {
//        [CA_HProgressHUD showHudStr:@"保存到相册失败"];
//    } else {
//        [CA_HProgressHUD showHudStr:@"保存到相册成功"];
//    }
//}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat alpha = scrollView.contentOffset.y / 155*CA_H_RATIO_WIDTH;
    
    self.titleView.titleLabel.alpha = alpha;
    
    if (scrollView.contentOffset.y >= 155*CA_H_RATIO_WIDTH) {
        [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                                offset:CGSizeMake(0, 3)
                                radius:3
                                 color:CA_H_SHADOWCOLOR
                               opacity:0.2];
    }else{
        [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                                offset:CGSizeMake(0, 3)
                                radius:3
                                 color:CA_H_SHADOWCOLOR
                               opacity:0.];
    }
    
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.detailModel.invest_history count] > 0) {
        _sections = 5;
    }else{
        _sections = 4;
    }
    return _sections;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 1;
    }else if (_sections==5 && section == 3) {
        return self.detailModel.invest_history.count;
    }else if (section == _sections - 1) {
        return 6;
    }
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {// 相关人员
        CA_MProjectDetailPersonnelCell* personnelCell = [tableView dequeueReusableCellWithIdentifier:personnelKey];
        personnelCell.delegate = self;
        personnelCell.persons = self.detailModel.project_person;
        return personnelCell;
    }else if (indexPath.section == 2) {// 基本资料
        CA_MProjectDetailDisplayCell* displayCell = [tableView dequeueReusableCellWithIdentifier:displayKey];
        NSString* valueStr = [self getBaseStr:_baseInfo[indexPath.row]];
        [displayCell configCell:_baseInfo[indexPath.row] value:valueStr];
        displayCell.valueLb.textColor = CA_H_4BLACKCOLOR;
        return displayCell;
    }else if (indexPath.section == 3) {
        if (_sections==5) {// 融资历史
            if (indexPath.row == 0) {
                CA_MProjectDetailHistoryBeginCell* beginCell = [tableView dequeueReusableCellWithIdentifier:beginKey];
//                beginCell.model = self.detailModel.invest_history[indexPath.row];
                self.investHeight = [beginCell configCell:self.detailModel.invest_history[indexPath.row]];
                return beginCell;
            }else if (indexPath.row == self.detailModel.invest_history.count-1) {
                CA_MProjectDetailHistoryEndCell* endCell = [tableView dequeueReusableCellWithIdentifier:endKey];
//                endCell.model = self.detailModel.invest_history[indexPath.row];
                self.investHeight = [endCell configCell:self.detailModel.invest_history[indexPath.row]];
                return endCell;
            }
            CA_MProjectDetailHistoryProgressCell* progressCell = [tableView dequeueReusableCellWithIdentifier:progressKey];
//            progressCell.model = self.detailModel.invest_history[indexPath.row];
            self.investHeight = [progressCell configCell:self.detailModel.invest_history[indexPath.row]];
            return progressCell;
        }else{
            // 工商信息
            CA_MProjectDetailDisplayCell* displayCell = [tableView dequeueReusableCellWithIdentifier:displayKey];
            NSString* valueStr = [self getCompanyStr:_companyInfo[indexPath.row]];
            [displayCell configCell:_companyInfo[indexPath.row] value:valueStr];
            if ([_companyInfo[indexPath.row] isEqualToString:@"工商全称"] ||
                [_companyInfo[indexPath.row] isEqualToString:@"法人代表"]) {
                displayCell.valueLb.textColor = [NSString isValueableString:valueStr]?CA_H_TINTCOLOR:CA_H_4BLACKCOLOR;
            }else {
                displayCell.valueLb.textColor = CA_H_4BLACKCOLOR;
            }
            if ([_companyInfo[indexPath.row] isEqualToString:@"工商全称"]) {
                self.enterprise_name = valueStr;
            }
            
            __weak NSString *titleValueStr = _companyInfo[indexPath.row];
            __weak NSString *weakValueStr = valueStr;
            CA_H_WeakSelf(self)
            displayCell.valueLb.didSelect = ^(ButtonLabel *sender) {
                CA_H_StrongSelf(self)
                if ([titleValueStr isEqualToString:@"工商全称"] ||
                    [titleValueStr isEqualToString:@"法人代表"] ) {
                    if ([NSString isValueableString:weakValueStr]) {
                        if ([titleValueStr isEqualToString:@"工商全称"]) {
                            CA_HBusinessDetailsController *vc = [CA_HBusinessDetailsController new];
                            vc.modelManager.dataStr = weakValueStr;
                            [self.navigationController pushViewController:vc animated:YES];
                        }else {
                            CA_MDiscoverRelatedPersonVC *relatedPersonVC = [CA_MDiscoverRelatedPersonVC new];
                            relatedPersonVC.enterprise_str = self.enterprise_name;
                            relatedPersonVC.personName = weakValueStr;
                            [self.navigationController pushViewController:relatedPersonVC animated:YES];
                        }
                    }
                }
            };
            return displayCell;
        }
    }
    if (_sections == 5) {
        if (indexPath.section == 4) {// 工商信息
            CA_MProjectDetailDisplayCell* displayCell = [tableView dequeueReusableCellWithIdentifier:displayKey];
            NSString* valueStr = [self getCompanyStr:_companyInfo[indexPath.row]];
            [displayCell configCell:_companyInfo[indexPath.row] value:valueStr];
            if ([_companyInfo[indexPath.row] isEqualToString:@"工商全称"] ||
                [_companyInfo[indexPath.row] isEqualToString:@"法人代表"]) {
                displayCell.valueLb.textColor = [NSString isValueableString:valueStr]?CA_H_TINTCOLOR:CA_H_4BLACKCOLOR;
            }else {
                displayCell.valueLb.textColor = CA_H_4BLACKCOLOR;
            }
            
            if ([_companyInfo[indexPath.row] isEqualToString:@"工商全称"]) {
                self.enterprise_name = valueStr;
            }
            
            __weak NSString *titleValueStr = _companyInfo[indexPath.row];
            __weak NSString *weakValueStr = valueStr;
            CA_H_WeakSelf(self)
            displayCell.valueLb.didSelect = ^(ButtonLabel *sender) {
                CA_H_StrongSelf(self)
                if ([titleValueStr isEqualToString:@"工商全称"] ||
                    [titleValueStr isEqualToString:@"法人代表"] ) {
                    if ([NSString isValueableString:weakValueStr]) {
                        if ([titleValueStr isEqualToString:@"工商全称"]) {
                            CA_HBusinessDetailsController *vc = [CA_HBusinessDetailsController new];
                            vc.modelManager.dataStr = weakValueStr;
                            [self.navigationController pushViewController:vc animated:YES];
                        }else {
                            CA_MDiscoverRelatedPersonVC *relatedPersonVC = [CA_MDiscoverRelatedPersonVC new];
                            relatedPersonVC.enterprise_str = self.enterprise_name;
                            relatedPersonVC.personName = weakValueStr;
                            [self.navigationController pushViewController:relatedPersonVC animated:YES];
                        }
                    }
                }
            };
            return displayCell;
        }
    }
    
    CA_MProjectDetailProjectInfoCell* infoCell = [tableView dequeueReusableCellWithIdentifier:informationKey];
    self.infoHeight = [infoCell configCell:self.detailModel.project_info];
    CA_H_WeakSelf(self)
    infoCell.pushBlock = ^(NSString *tagName) {
        CA_H_StrongSelf(self)
        CA_MDiscoverProjectDetailTagVC *tagVC = [CA_MDiscoverProjectDetailTagVC new];
        tagVC.tagName = tagName;
        [self.navigationController pushViewController:tagVC animated:YES];
    };
    return infoCell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return self.infoHeight;
    }else if (indexPath.section == 1) {//相关人员
        return 166 * CA_H_RATIO_WIDTH;
    }else if (_sections==5&&indexPath.section == 3) {//融资历史
//        return 67 * CA_H_RATIO_WIDTH;
        return self.investHeight;
    }
    return 37 * CA_H_RATIO_WIDTH;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CA_MProjectDetailSectionHeaderView* headerView = [[CA_MProjectDetailSectionHeaderView alloc] init];
    headerView.delegate = self;
    if (section == 0) {
        [headerView configTitle:@"项目信息" isHiddenEditBtn:self.detailModel.member_type_id.intValue==0?YES:NO];
    }else if (section == 1) {
        [headerView configTitle:@"相关人员" isHiddenEditBtn:YES];
    }else if (section == 2) {
        [headerView configTitle:@"基本资料" isHiddenEditBtn:self.detailModel.member_type_id.intValue==0?YES:NO];
    }else if (section == 3) {
        if (_sections == 5) {
            [headerView configTitle:@"历史融资" isHiddenEditBtn:YES];
        }else{
            [headerView configTitle:@"工商信息" isHiddenEditBtn:YES];
        }
    }
    
    if (_sections == 5) {
        if (section == 4) {
            [headerView configTitle:@"工商信息" isHiddenEditBtn:YES];
        }
    }
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 65 * CA_H_RATIO_WIDTH;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark - CA_MProjectDetailPersonnelCellDelegate

-(void)didSelect:(BOOL)isAdd person:(CA_MProject_person *)model{
    
    if (self.detailModel.member_type_id.intValue==0) {
        [CA_HProgressHUD showHudStr:@"暂无操作权限"];
        return;
    }
    
    if (!self.detailModel) {
        [CA_HProgressHUD showHudStr:@"暂无数据"];
        return;
    }
    
    if (isAdd) {// 添加按钮
        CA_H_WeakSelf(self);
        CA_MAddRelatedMemberVC* addMemberVC = [[CA_MAddRelatedMemberVC alloc] init];
        addMemberVC.model = self.model;
        addMemberVC.block = ^(){
            CA_H_StrongSelf(self);
            [self requestData];
        };
        [self.navigationController pushViewController:addMemberVC animated:YES];
    }else{// 普通人员 跳转人脉圈详情
        CA_MPersonDetailVC* personVC = [[CA_MPersonDetailVC alloc] init];
        personVC.fileID = model.file_id;
        personVC.filePath = model.file_path;
        personVC.humanID = model.hr_id;
        
        [self.navigationController pushViewController:personVC animated:YES];
    }
}

#pragma mark - CA_MProjectDetailSectionHeaderViewDelegate

-(void)editClick:(NSString *)title{
    
    if (!self.detailModel) {
        [CA_HProgressHUD showHudStr:@"暂无数据"];
        return;
    }
    
    if ([title isEqualToString:@"项目信息"]) {
        CA_H_WeakSelf(self);
        CA_MProjectInfoVC* infoVC = [[CA_MProjectInfoVC alloc] init];
        infoVC.model = self.detailModel;
        infoVC.block = ^{
            CA_H_StrongSelf(self);
            [self requestData];
        };
        [self.navigationController pushViewController:infoVC animated:YES];
    }else if ([title isEqualToString:@"基本资料"]) {
        CA_MProjectBaseInfoVC* baseInfoVC = [[CA_MProjectBaseInfoVC alloc] init];
        baseInfoVC.model = self.detailModel;
        CA_H_WeakSelf(self);
        baseInfoVC.block = ^{
            CA_H_StrongSelf(self);
            [self requestData];
        };
        [self.navigationController pushViewController:baseInfoVC animated:YES];
    }
}

#pragma mark - Getter and Setter
-(CA_MProjectDetailHeaderView *)headerView{
    if (_headerView) {
        return _headerView;
    }
    _headerView = [[CA_MProjectDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, CA_H_SCREEN_WIDTH, 155 * CA_H_RATIO_WIDTH)];
    [CA_HShadow dropShadowWithView:_headerView
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.2];
    return _headerView;
}
-(UIScrollView *)scrollView{
    if (_scrollView) {
        return _scrollView;
    }
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = kColor(@"#FFFFFF");
    _scrollView.delegate = self;
    return _scrollView;
}
-(UITableView *)tableView{
    if (_tableView) {
        return _tableView;
    }
    _tableView = [UITableView newTableViewGrouped];
    _tableView.frame = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, CA_H_SCREEN_HEIGHT);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableHeaderView = self.headerView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = NO;
    
    _tableView.backgroundColor = kColor(@"#FFFFFF");
    //
    [_tableView registerClass:[CA_MProjectDetailProjectInfoCell class] forCellReuseIdentifier:informationKey];
    [_tableView registerClass:[CA_MProjectDetailPersonnelCell class] forCellReuseIdentifier:personnelKey];
    [_tableView registerClass:[CA_MProjectDetailDisplayCell class] forCellReuseIdentifier:displayKey];
    [_tableView registerClass:[CA_MProjectDetailHistoryBeginCell class] forCellReuseIdentifier:beginKey];
    [_tableView registerClass:[CA_MProjectDetailHistoryProgressCell class] forCellReuseIdentifier:progressKey];
    [_tableView registerClass:[CA_MProjectDetailHistoryEndCell class] forCellReuseIdentifier:endKey];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    //
    [_tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    return _tableView;
}
-(UIBarButtonItem *)rightBarBtnItem{
    if (_rightBarBtnItem) {
        return _rightBarBtnItem;
    }
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:kImage(@"pic_share") forState:UIControlStateNormal];
    [rightButton sizeToFit];
    [rightButton addTarget: self action: @selector(clickRightBarBtnAction) forControlEvents: UIControlEventTouchUpInside];
    _rightBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    return _rightBarBtnItem;
}
-(UIButton *)titleView{
    if (_titleView) {
        return _titleView;
    }
    _titleView = [UIButton buttonWithType:UIButtonTypeCustom];
    [_titleView configTitle:@"" titleColor:CA_H_4BLACKCOLOR font:17];
    _titleView.frame = CGRectMake(0, 0, 200*CA_H_RATIO_WIDTH, 44);
    _titleView.titleLabel.alpha = 0.01f;
    return _titleView;
}
@end

