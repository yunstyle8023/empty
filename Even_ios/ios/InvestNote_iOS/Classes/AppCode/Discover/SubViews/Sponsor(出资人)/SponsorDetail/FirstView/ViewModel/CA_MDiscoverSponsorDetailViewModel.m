//
//  CA_MDiscoverSponsorDetailViewModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/9.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverSponsorDetailViewModel.h"
#import "CA_MDiscoverSponsorDetailModel.h"

@interface CA_MDiscoverSponsorDetailViewModel ()
@property (nonatomic,strong) NSMutableArray *headerTitles;
@end

@implementation CA_MDiscoverSponsorDetailViewModel

-(NSMutableArray *)headerTitles{
    if (!_headerTitles) {
        _headerTitles = @[].mutableCopy;
        [_headerTitles addObject:@""];
        [_headerTitles addObject:@"基本信息"];
        [_headerTitles addObject:@"国有背景详情"];
        [_headerTitles addObject:@"描述信息"];
        [_headerTitles addObject:@"主要成员"];
    }
    return _headerTitles;
}

-(CA_MDiscoverSponsorDetailModel *)detailModel{
    if (!_detailModel) {
        _detailModel = [CA_MDiscoverSponsorDetailModel new];
        _finished = NO;
        [self requestData];
    }
    return _detailModel;
}

-(void)requestData{
    NSDictionary *parameters = @{@"data_type": @"lp",
                                 @"data_str": self.data_id};
    [CA_HProgressHUD loading:self.loadingView];
    [CA_HNetManager postUrlStr:CA_M_SearchFundDataDetail parameters:parameters callBack:^(CA_HNetModel *netModel) {
        [CA_HProgressHUD hideHud:self.loadingView];
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.intValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]]
                    &&
                    [NSObject isValueableObject:netModel.data]) {
                    self.detailModel = [CA_MDiscoverSponsorDetailModel modelWithDictionary:netModel.data];
                    self.detailModel.headerTitles = self.headerTitles.copy;
                    self.detailModel.base_info.state_background_unfold = NO;
                    self.detailModel.base_info.lp_desc_unfold = NO;
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
