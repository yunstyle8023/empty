//
//  CA_HParticipantsModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/5.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

@interface CA_HParticipantsModel : CA_HBaseModel

@property (nonatomic, strong) NSNumber *user_id;//": 1,
@property (nonatomic, copy) NSString *chinese_name;//": "中文名",
@property (nonatomic, copy) NSString *avatar;//": "http://example.com/avatar.jpg",
@property (nonatomic, copy) NSString *avatar_color;//": "#fff",

@end
