//
//  CA_MSelectProjectNetModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/24.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

@interface CA_MSelectProjectNetModel : CA_HBaseModel
@property (nonatomic,strong) NSNumber *page_num;
@property (nonatomic,strong) NSNumber *page_size;
@property (nonatomic,copy) NSString *data_type;
@property (nonatomic,copy) NSString *search_str;
@property (nonatomic,copy) NSString *search_type;
@end
