//
//  CA_MDiscoverInvestmentDetailViewModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/23.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverInvestmentDetailViewModel.h"
#import "CA_MDiscoverInvestmentDetailModel.h"
#import "CA_MDiscoverInvestmentDetailModel.h"

@interface CA_MDiscoverInvestmentDetailViewModel ()

@end

@implementation CA_MDiscoverInvestmentDetailViewModel

-(NSMutableArray *)headerTitles{
    if (!_headerTitles) {
        _headerTitles = @[].mutableCopy;
        [_headerTitles addObject:@""];
        [_headerTitles addObject:@"工商追踪"];
        [_headerTitles addObject:@"描述信息"];
        [_headerTitles addObject:@"机构成员"];
    }
    return _headerTitles;
}

-(CA_MDiscoverInvestmentDetailModel *)detailModel{
    if (!_detailModel) {
        _detailModel = ({
            CA_MDiscoverInvestmentDetailModel *detailModel = [CA_MDiscoverInvestmentDetailModel new];
            [self requestData];
            detailModel;
        });
    }
    return _detailModel;
}

-(void)requestData{
    NSDictionary *parameters = @{@"data_type": @"gp",
                                 @"data_str": self.data_id};
    [CA_HProgressHUD loading:self.loadingView];
    [CA_HNetManager postUrlStr:CA_M_SearchFundDataDetail parameters:parameters callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud:self.loadingView];
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]]
                    &&
                    [NSObject isValueableObject:netModel.data]) {
                    self.detailModel = [CA_MDiscoverInvestmentDetailModel modelWithDictionary:netModel.data];
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
