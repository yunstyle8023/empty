//
//  CA_HBusinessInformationModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/25.
//  Copyright © 2018年 韩云智. All rights reserved.
// 工商信息

#import "CA_HBaseModel.h"

@interface CA_HBusinessInformationContentModel : CA_HBaseModel

//股东
@property (nonatomic, copy) NSString *stock_name;//"股东名称",
@property (nonatomic, copy) NSString *stock_percent;//"持股比例",
@property (nonatomic, copy) NSString *stock_type;//"股东类型",
@property (nonatomic, copy) NSString *should_capi;//"认缴出资额（万元）",
@property (nonatomic, copy) NSString *should_date;//认缴出资日期 #时间戳

//主要成员
@property (nonatomic, copy) NSString *name;//"邹慧平", # 姓名
@property (nonatomic, copy) NSString *title;//"监事" # 职务

//变更记录
@property (nonatomic, copy) NSString *item_name;//"变更记录名称",
@property (nonatomic, copy) NSString *change_date;//变更时间, # 时间戳
@property (nonatomic, copy) NSString *before_change;//"变更之前",
@property (nonatomic, copy) NSString *after_change;//"变更之后"

//分支机构
//"name": "分支名称", # 跳转的时候，该字段为跳转的data_str
@property (nonatomic, copy) NSString *data_type;//"enterprisebusinessinfo" # 跳转的时候，该字段为跳转的data_type

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *countStr;

@end

@interface CA_HBusinessInformationModel : CA_HBaseModel

@property (nonatomic, copy) NSString *data_type;//"enterprise",
@property (nonatomic, copy) NSString *enterprise_name;//"企业名称",
@property (nonatomic, copy) NSString *keyno;//"企业keyNo",
@property (nonatomic, strong) NSArray<CA_HBusinessInformationContentModel *> *basic_info_list;//[

@property (nonatomic, strong) NSNumber *partners_data_count;//1, # 股东数量
@property (nonatomic, strong) NSArray<CA_HBusinessInformationContentModel *> *partners_list;//[
@property (nonatomic, strong) NSNumber *main_member_data_count;//8, # 主要成员数量
@property (nonatomic, strong) NSArray<CA_HBusinessInformationContentModel *> *main_member_list;//[
@property (nonatomic, strong) NSNumber *change_data_count;//9, # 变更记录数量
@property (nonatomic, strong) NSArray<CA_HBusinessInformationContentModel *> *change_list;//[
@property (nonatomic, strong) NSArray<CA_HBusinessInformationContentModel *> *branch_list;//[


@end
