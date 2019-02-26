//
//  CA_MPersonDetailVC.m
//  InvestNote_iOS
//
//  Created by yezhuge on 2018/3/5.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MPersonDetailVC.h"
#import "CA_MPersonDetailHeaderView.h"
#import "CA_MPersonDetailSectionView.h"
#import "CA_MPersonDetailBottomView.h"
#import "CA_MPersonDetailUITableView.h"
#import "CA_MPersonDetailContainerCell.h"
#import "CA_MAddPersonVC.h"
#import "CA_MPersonDetailModel.h"

@interface CA_MPersonDetailVC ()
<UITableViewDelegate,
UITableViewDataSource,
CA_MPersonDetailContainerCellDelegate,
CA_MPersonDetailBottomViewDelegate>

@property (nonatomic, strong) CA_MPersonDetailUITableView *tableView;

@property (nonatomic, strong) CA_MPersonDetailHeaderView *headerView;

@property (nonatomic, strong) CA_MPersonDetailSectionView *sectionView;

@property (nonatomic, strong) CA_MPersonDetailContainerCell *containerCell;

@property (nonatomic, assign) BOOL canScroll;

@property (nonatomic,strong) CA_MPersonDetailBottomView *bottomView;

@property (nonatomic,strong) UIBarButtonItem *rightBarBtnItem;

@property (nonatomic,strong) UIButton *titleView;

@end

@implementation CA_MPersonDetailVC

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [CA_HShadow dropShadowWithView:self.navigationController.navigationBar
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.canScroll = YES;
    [self upNavigationItem];
    [self setupUI];
    [self addNotification];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView);
        make.trailing.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
    }];
}

-(void)upNavigationItem{
    self.navigationItem.titleView = self.titleView;
    self.navigationItem.rightBarButtonItem = self.rightBarBtnItem;
}

-(void)setupUI{
    [self.contentView addSubview:self.tableView];
}

-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatus) name:CA_M_LeaveTopNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recoverTableViewScrollStatus) name:CA_M_RecoverTableViewNotification object:nil];
}
-(void)clickRightBarBtnAction{
    if (!self.headerView.model) {
        [CA_HProgressHUD showHudStr:@"暂无数据"];
        return;
    }
    CA_MAddPersonVC* addPersonVC = [[CA_MAddPersonVC alloc] init];
    addPersonVC.naviTitle = @"编辑人脉";
    addPersonVC.model = self.headerView.model.human_detail;
    CA_H_WeakSelf(self);
    addPersonVC.block = ^(CA_MPersonDetailModel* obj){
        CA_H_StrongSelf(self);
        [[NSNotificationCenter defaultCenter] postNotificationName:CA_M_RefreshHumanListNotification object:@{@"id":obj.human_detail.human_id}];
        [self.titleView setTitle:obj.human_detail.chinese_name forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:addPersonVC animated:YES];
}

#pragma mark - CA_MPersonDetailBottomViewDelegate
-(void)wechatClick{
    NSString* wechat = self.headerView.model.human_detail.wechat;
    if (![NSString isValueableString:wechat]) {
        [CA_HProgressHUD showHudStr:@"暂未收录该联系人微信号"];
        return;
    }
    if ([wechat isEqualToString:@"暂无"]) {
        [CA_HProgressHUD showHudStr:@"暂未收录该联系人微信号"];
        return;
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = wechat;
    [CA_HProgressHUD showHudStr:@"微信号码已复制"];
}

-(void)mssageClick{
    if (![NSString isValueableString:self.headerView.model.human_detail.phone]) {
        [CA_HProgressHUD showHudStr:@"暂未收录该联系人手机号"];
        return;
    }
    NSString* url = [NSString stringWithFormat:@"sms://%@",self.headerView.model.human_detail.phone];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
}

-(void)telClick{
    if (![NSString isValueableString:self.headerView.model.human_detail.phone]) {
        [CA_HProgressHUD showHudStr:@"暂未收录该联系人手机号"];
        return;
    }
    NSString* url = [NSString stringWithFormat:@"tel://%@",self.headerView.model.human_detail.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

#pragma mark - Notification

- (void)changeScrollStatus {
    self.canScroll = YES;
    self.containerCell.objectCanScroll = NO;
}

-(void)recoverTableViewScrollStatus{
    self.tableView.scrollEnabled = YES;
    [self scrollViewDidScroll:self.tableView];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        
        CGFloat bottomCellOffset = [self.tableView rectForSection:0].origin.y;// + 24;
        bottomCellOffset = floorf(bottomCellOffset);
        
        if (scrollView.contentOffset.y >= bottomCellOffset) {
            if (self.tableView.isScrollEnabled) {
               scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
            }
            if (self.canScroll) {
                self.canScroll = NO;
                self.containerCell.objectCanScroll = YES;
                //
                self.titleView.titleLabel.alpha = scrollView.contentOffset.y / 155*CA_H_RATIO_WIDTH;
            }
        }else{
            //子视图没到顶部
            if (!self.canScroll) {
                scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
            }else{
                if (scrollView.contentOffset.y >= 0) {
                    self.tableView.scrollEnabled = YES;
                }else if(scrollView.contentOffset.y < 0){
                    if (self.canScroll) {
                        self.tableView.scrollEnabled = NO;
                    }
                }
            }
            //
            self.titleView.titleLabel.alpha = scrollView.contentOffset.y / 155*CA_H_RATIO_WIDTH;
            
        }
        
        [self.containerCell.twoVC scroll:scrollView];
        [self.containerCell.threeVC scroll:scrollView];
    }
}

#pragma mark - CA_MPersonDetailContainerCellDelegate

- (void)mmtdOptionalScrollViewDidScroll:(UIScrollView *)scrollView {
    self.tableView.scrollEnabled = NO;
    [self.sectionView changeLineView:scrollView.contentOffset.x];
}

- (void)mmtdOptionalScrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int page = scrollView.contentOffset.x/CA_H_SCREEN_WIDTH;
    [self.sectionView changeButton:page];
    self.tableView.scrollEnabled = YES;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CA_MPersonDetailContainerCell* containerCell = [tableView dequeueReusableCellWithIdentifier:@"containerCell"];
    CA_H_WeakSelf(self);
    containerCell.pushBlock = ^CA_HBaseViewController *(NSString *classStr, NSDictionary *kvcDic) {
        CA_H_StrongSelf(self);
        if (classStr) {
            UIViewController * vc = [NSClassFromString(classStr) new];
            [vc setValuesForKeysWithDictionary:kvcDic];
            [self.navigationController pushViewController:vc animated:YES];
        }
        return self;
    };
    containerCell.humanID = self.humanID;
    containerCell.fileID = self.fileID;
    containerCell.filePath = self.filePath;
    [containerCell configChildVC];
    
    self.containerCell = containerCell;
    containerCell.delegate = self;
    containerCell.block = ^(CA_MPersonDetailModel *detailModel) {
        CA_H_StrongSelf(self);
        self.headerView.model = detailModel;
        [self.titleView setTitle:detailModel.human_detail.chinese_name forState:UIControlStateNormal];
    };
    return containerCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = CA_H_SCREEN_HEIGHT - (40*CA_H_RATIO_WIDTH+3) - 48*CA_H_RATIO_WIDTH;
    if (kDevice_Is_iPhoneX) {
        height = height - 88 - 34;
    }else{
        height = height - 64;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40*CA_H_RATIO_WIDTH+3;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return self.bottomView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 48*CA_H_RATIO_WIDTH;
}

#pragma mark - Init Views
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
-(CA_MPersonDetailBottomView *)bottomView{
    if (_bottomView) {
        return _bottomView;
    }
    _bottomView = [[CA_MPersonDetailBottomView alloc] init];
    _bottomView.delegate = self;
    return _bottomView;
}
-(CA_MPersonDetailHeaderView *)headerView{
    if (_headerView) {
        return _headerView;
    }
    CGRect rect = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, 155*CA_H_RATIO_WIDTH);
    _headerView = [[CA_MPersonDetailHeaderView alloc] initWithFrame:rect];
    return _headerView;
}
- (CA_MPersonDetailUITableView *)tableView {
    if (_tableView) {
        return _tableView;
    }
    _tableView = [CA_MPersonDetailUITableView newTableViewPlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = self.headerView;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView registerClass:[CA_MPersonDetailContainerCell class] forCellReuseIdentifier:@"containerCell"];
    return _tableView;
}

- (CA_MPersonDetailSectionView *)sectionView {
    if (_sectionView) {
       return _sectionView;
    }
    _sectionView = [[CA_MPersonDetailSectionView alloc] init];
    CA_H_WeakSelf(self);
    _sectionView.changeBlock = ^(NSInteger index){
        CA_H_StrongSelf(self);
        self.containerCell.isSelectIndex = YES;
        [self.containerCell.scrollView setContentOffset:CGPointMake(index*CA_H_SCREEN_WIDTH, 0) animated:YES];
    };
    return _sectionView;
}
-(UIBarButtonItem *)rightBarBtnItem{
    if (_rightBarBtnItem) {
        return _rightBarBtnItem;
    }
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:kImage(@"edit_icon") forState:UIControlStateNormal];
    [rightButton setImage:kImage(@"edit_icon") forState:UIControlStateHighlighted];
    [rightButton sizeToFit];
    [rightButton addTarget: self action: @selector(clickRightBarBtnAction) forControlEvents: UIControlEventTouchUpInside];
    _rightBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    return _rightBarBtnItem;
}

@end
