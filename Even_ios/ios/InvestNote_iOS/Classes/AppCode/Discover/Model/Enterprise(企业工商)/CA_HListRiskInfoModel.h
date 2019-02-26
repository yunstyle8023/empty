//
//  CA_HListRiskInfoModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

@interface CA_HListRiskInfoData: CA_HBaseModel

@property (nonatomic, copy) NSString *name;//"执行裁判书",
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *id_num;//"abd32cb2de90cfab013bc772e50ca2a6", #判决书id num
@property (nonatomic, strong) NSArray *detail_list;//[
@property (nonatomic, assign) BOOL isShow;

@end

@interface CA_HListRiskInfoModel : CA_HBaseModel

@property (nonatomic, strong) NSNumber *page_size;
@property (nonatomic, strong) NSNumber *page_num;
@property (nonatomic, copy) NSString *data_type;
@property (nonatomic, strong) NSNumber *total_count;
@property (nonatomic, strong) NSNumber *total_page;
@property (nonatomic, strong) NSArray<CA_HListRiskInfoModel *> *data_list;

@end
