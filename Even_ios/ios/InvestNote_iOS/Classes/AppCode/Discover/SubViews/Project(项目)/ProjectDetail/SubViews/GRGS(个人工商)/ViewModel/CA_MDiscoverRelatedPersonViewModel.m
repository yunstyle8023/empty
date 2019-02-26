//
//  CA_MDiscoverRelatedPersonViewModel.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/24.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverRelatedPersonViewModel.h"
#import "CA_MDiscoverRelatedPersonModel.h"

@interface CA_MDiscoverRelatedPersonViewModel ()

@property (nonatomic,strong) CA_MDiscoverRelatedPersonRequestModel *requestModel;
@end

@implementation CA_MDiscoverRelatedPersonViewModel

-(NSMutableArray *)itemNames{
    if (!_itemNames) {
        _itemNames = @[].mutableCopy;
        [_itemNames addObjectsFromArray:@[CA_H_LAN(@"全部"),
                                           CA_H_LAN(@"担任法人"),
                                           CA_H_LAN(@"投资的公司"),
                                           CA_H_LAN(@"任职的公司")]
         ];
    }
    return _itemNames;
}

-(CA_MDiscoverRelatedPersonRequestModel *)requestModel{
    if (!_requestModel) {
        _requestModel = [CA_MDiscoverRelatedPersonRequestModel new];
        _requestModel.enterprise_str = @"";
        _requestModel.person_name = self.personName;
        _requestModel.position_type = @"all";
        _requestModel.page_num = @1;
        _requestModel.page_size = @10;
    }
    return _requestModel;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
        [self requestData];
    }
    return _dataSource;
}

-(void)requestData{
    
    [CA_HNetManager postUrlStr:CA_M_PersonInfoList parameters:[self.requestModel dictionaryFromModel] callBack:^(CA_HNetModel *netModel) {
        
    } progress:nil];
    
//    for (int i=0; i<5; i++) {
//        [self.dataSource addObject:@"dataSource"];
//    }
//    if (_finishedBlock) {
//        _finishedBlock();
//    }
}

@end
