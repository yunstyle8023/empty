//
//  CA_MProcedure_statusModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/22.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

@interface CA_MProcedure_statusModel : CA_HBaseModel
//procedure_status_id = 1,
//procedure_status_name = "入库"
@property (nonatomic,strong) NSNumber *procedure_status_id;
@property (nonatomic,copy) NSString *procedure_status_name;

@property (nonatomic,assign,getter=isSelected) BOOL selectd;
@property (nonatomic,assign,getter=isAll) BOOL all;
@end

