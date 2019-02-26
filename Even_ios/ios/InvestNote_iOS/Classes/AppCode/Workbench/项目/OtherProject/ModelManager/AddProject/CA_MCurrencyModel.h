//
//  CA_MCurrencyModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/23.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

@interface CA_MCurrencyModel : CA_HBaseModel
//"unit_cn": "美元",
//"unit_en": "USD",
//"unit_id": 1,
//"unit_sym": "$"
@property (nonatomic,copy) NSString *unit_cn;
@property (nonatomic,copy) NSString *unit_en;
@property (nonatomic,strong) NSNumber *unit_id;
@property (nonatomic,copy) NSString *unit_sym;
@end
