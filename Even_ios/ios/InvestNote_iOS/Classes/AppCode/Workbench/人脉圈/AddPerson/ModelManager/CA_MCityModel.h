//
//  CA_MCityModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/21.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

@interface CA_MCity : CA_HBaseModel
@property (nonatomic,strong) NSNumber *area_id;
@property (nonatomic,copy) NSString *area_name;
@property (nonatomic,assign,getter=isSelected) BOOL selected;
@end

@interface CA_MCityModel : CA_HBaseModel
@property (nonatomic,strong) NSNumber *area_id;
@property (nonatomic,copy) NSString *area_name;
@property (nonatomic,strong) NSArray<CA_MCity*> *children;
@property (nonatomic,assign,getter=isSelected) BOOL selected;
@end
