
//
//  CA_MDiscoverProjectDetailViewModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/3.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverProjectDetailViewModel.h"
#import "CA_MDiscoverProjectDetailModel.h"

@interface CA_MDiscoverProjectDetailViewModel ()
@property (nonatomic,strong) NSMutableArray *headerTitles;
@property (nonatomic,strong) NSMutableArray *footerTitles;
@end

@implementation CA_MDiscoverProjectDetailViewModel

-(NSMutableArray *)headerTitles{
    if (!_headerTitles) {
        _headerTitles = @[].mutableCopy;
        [_headerTitles addObject:@"项目信息"];
        [_headerTitles addObject:@"融资信息"];
        [_headerTitles addObject:@"核心人员"];
        [_headerTitles addObject:@"产品"];
        [_headerTitles addObject:@"相关竞品"];
        [_headerTitles addObject:@"相关新闻"];
    }
    return _headerTitles;
}

-(NSMutableArray *)footerTitles{
    if (!_footerTitles) {
        _footerTitles = @[].mutableCopy;
        [_footerTitles addObject:@""];
        [_footerTitles addObject:@""];
        [_footerTitles addObject:@"查看更多核心人员"];
        [_footerTitles addObject:@"查看更多产品"];
        [_footerTitles addObject:@"查看更多竞品"];
        [_footerTitles addObject:@"查看更多新闻"];
    }
    return _footerTitles;
}

-(CA_MDiscoverProjectDetailModel *)detailModel{
    if (!_detailModel) {
        _detailModel = [CA_MDiscoverProjectDetailModel new];
        _finished = NO;
        [self requestData];
    }
    return _detailModel;
}

-(void)requestData{
    NSDictionary *parameters = @{@"data_type": @"project",
                                 @"data_str": self.dataID};
    if (self.loadingView) [CA_HProgressHUD loading:self.loadingView];
    [CA_HNetManager postUrlStr:CA_M_SearchFundDataDetail parameters:parameters callBack:^(CA_HNetModel *netModel) {
        if (self.loadingView) [CA_HProgressHUD hideHud:self.loadingView];
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]]
                    &&
                    [NSObject isValueableObject:netModel.data]) {
                    self.detailModel = [CA_MDiscoverProjectDetailModel modelWithDictionary:netModel.data];
                    self.detailModel.headerTitles = self.headerTitles.copy;
                    self.detailModel.footerTitles = self.footerTitles.copy;
                    _finished = YES;
                }
            }
        }
        if (self.finishedBlock) {
            self.finishedBlock();
        }
    } progress:nil];
}



@end
