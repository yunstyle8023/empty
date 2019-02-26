
//
//  CA_MDiscoverRelatedPersonTableView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/24.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverRelatedPersonTableView.h"
#import "CA_MDiscoverRelatedPersonCell.h"
#import "CA_MDiscoverRelatedPersonModel.h"
#import "CA_MDiscoverRelatedPersonHeadereView.h"
#import "ButtonLabel.h"
#import "CA_HNullView.h"

@interface CA_MDiscoverRelatedPersonTableView ()
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic,strong) CA_MDiscoverRelatedPersonModel *detailModel;
@property (nonatomic,strong) CA_MDiscoverRelatedPersonRequestModel *requestModel;

@property (nonatomic,assign,getter=isLoadMore) BOOL loadMore;
@end

@implementation CA_MDiscoverRelatedPersonTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.dataSource = self;
        self.delegate = self;
//        self.showsVerticalScrollIndicator = NO;
//        self.showsHorizontalScrollIndicator = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerClass:[CA_MDiscoverRelatedPersonCell class]
         forCellReuseIdentifier:@"RelatedPersonCell"];
        self.loadMore = NO;
        CA_H_WeakSelf(self)
        self.mj_header = [CA_HDIYHeader headerWithRefreshingBlock:^{
            CA_H_StrongSelf(self);
            self.loadMore = NO;
            [self refreshData];
        }];
        self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            CA_H_StrongSelf(self);
            self.loadMore = YES;
            [self loadMoreData];
        }];
        
        self.backgroundView = [CA_HNullView newTitle:@"暂无个人工商信息" buttonTitle:nil top:136*CA_H_RATIO_WIDTH onButton:nil imageName:@"empty_search"];
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.backgroundView.hidden = [NSObject isValueableObject:self.detailModel.data_list];
    self.mj_footer.hidden = ![NSObject isValueableObject:self.detailModel.data_list];
    return self.detailModel.data_list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CA_MDiscoverRelatedPersonCell *relatedCell = [tableView dequeueReusableCellWithIdentifier:@"RelatedPersonCell"];
    CA_MDiscoverRelatedPersonData_list *model = self.detailModel.data_list[indexPath.row];
    relatedCell.model = model;
    CA_H_WeakSelf(self)
    relatedCell.companyLb.didSelect = ^(ButtonLabel *sender) {
        CA_H_StrongSelf(self)
        if (self.pushBlock) {
            self.pushBlock(model);
        }
    };
    [relatedCell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return relatedCell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView cellHeightForIndexPath:indexPath model:self.detailModel.data_list[indexPath.row] keyPath:@"model" cellClass:[CA_MDiscoverRelatedPersonCell class] contentViewWidth:CA_H_SCREEN_WIDTH]+5*2*CA_H_RATIO_WIDTH;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return ({
        CA_MDiscoverRelatedPersonHeadereView *headerView = [CA_MDiscoverRelatedPersonHeadereView new];
        headerView.title = [NSString stringWithFormat:@"%@",self.detailModel.total_count];
        headerView.hidden = self.detailModel.total_count.intValue > 0 ? NO : YES;
        headerView;
    });
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 24*2*CA_H_RATIO_WIDTH;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}


-(void)requestData{
    __block BOOL isAdd = YES;
    [CA_HProgressHUD loading:self];
    [CA_HNetManager postUrlStr:CA_M_PersonInfoList parameters:[self.requestModel dictionaryFromModel] callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud:self];
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]] &&
                    [NSObject isValueableObject:netModel.data]) {
                    CA_MDiscoverRelatedPersonModel *detailModel =  [CA_MDiscoverRelatedPersonModel modelWithDictionary:netModel.data];
                    if (detailModel) {
                        if (!self.isLoadMore) {
                            self.detailModel = detailModel;
                        }else {
                            [self.detailModel.data_list addObjectsFromArray:detailModel.data_list];
                        }
                        
                        if (!self.isLoadMore) {
                            [self.mj_header endRefreshing];
                        }
                        
                        BOOL isHasData = (self.requestModel.page_num.intValue != self.detailModel.total_page.intValue)
                        &&
                        (self.detailModel.total_page);

                        if (!isHasData) {
                            [self.mj_footer endRefreshingWithNoMoreData];
                        }else{
                            [self.mj_footer endRefreshing];
                        }
                        
                        [self reloadData];
                        
                        //
                        isAdd = NO;
                    }
                }
            }
        }
        
        if (isAdd && self.isLoadMore) {//请求失败页数减1
            self.requestModel.page_num = @(self.requestModel.page_num.intValue - 1);
        }
        
    } progress:nil];
}

-(void)refreshData{
    self.requestModel.page_num = @1;
    [self.detailModel.data_list removeAllObjects];
    [self requestData];
}

-(void)loadMoreData{
    self.requestModel.page_num = @(self.requestModel.page_num.intValue + 1);
    [self requestData];
}

#pragma mark - getter and setter

-(CA_MDiscoverRelatedPersonRequestModel *)requestModel{
    if (!_requestModel) {
        _requestModel = [CA_MDiscoverRelatedPersonRequestModel new];
        _requestModel.enterprise_str = self.enterprise_str;
        _requestModel.person_name = self.person_name;
        _requestModel.position_type = self.position_type;
        _requestModel.page_num = @1;
        _requestModel.page_size = @10;
    }
    return _requestModel;
}


@end
