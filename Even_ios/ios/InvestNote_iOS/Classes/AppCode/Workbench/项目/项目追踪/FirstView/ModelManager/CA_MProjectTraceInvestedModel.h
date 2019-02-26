//
//  CA_MProjectTraceInvestedModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

@interface CA_MProjectTraceInvestedModel : CA_HBaseModel
//investor_logo = "http://qichacha.oss-cn-qingdao.aliyuncs.com/Investment/logo/985e9a46e10005356bbaf194249f6856.jpg",
//ts_invested = 1527523200,
//news_title = "区块链技术研究和应用开发者链博科技完成千万级天使轮融资，已推出HubbleRating和币氪两款产品",
//invested_id = "932e81bc-ff1f-4216-85c8-9d9a3c21ca3c",
//investor_name = "启迪之星",
//investment_amount = "千万级人民币",
//invested_type = "project",
//news_url = "http://www.lieyunwang.com/archives/443317",
//investor_id = "985e9a46e10005356bbaf194249f6856",
//investor_type = "gp",
//invested_name = "链博科技",
//round = "天使轮"

@property (nonatomic,copy) NSString *invested_id;
@property (nonatomic,copy) NSString *invested_type;
@property (nonatomic,copy) NSString *invested_name;

@property (nonatomic,copy) NSString *investor_id;
@property (nonatomic,copy) NSString *investor_type;
@property (nonatomic,copy) NSString *investor_name;

@property (nonatomic,copy) NSString *investment_amount;
@property (nonatomic,copy) NSString *investor_logo;
@property (nonatomic,strong) NSNumber *ts_invested;
@property (nonatomic,copy) NSString *round;

@property (nonatomic,copy) NSString *news_title;
@property (nonatomic,copy) NSString *news_url;

@end
