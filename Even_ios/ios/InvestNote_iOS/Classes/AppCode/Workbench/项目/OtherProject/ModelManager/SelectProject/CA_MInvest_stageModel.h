//
//  CA_MInvest_stageModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/22.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

@interface CA_MInvest_stageModel : CA_HBaseModel
//invest_stage_id = 1,
//invest_stage_name = "尚未获投"
@property (nonatomic,strong) NSNumber *invest_stage_id;
@property (nonatomic,copy) NSString *invest_stage_name;

@property (nonatomic,assign,getter=isSelected) BOOL selectd;
@property (nonatomic,assign,getter=isAll) BOOL all;
@end

