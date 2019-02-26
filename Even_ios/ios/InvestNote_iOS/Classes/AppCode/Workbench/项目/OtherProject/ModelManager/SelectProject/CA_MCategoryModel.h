//
//  CA_MCategoryModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/22.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"


@interface CA_MCategory : CA_HBaseModel
@property (nonatomic,strong) NSNumber *category_id;
@property (nonatomic,copy) NSString *category_name;
@property (nonatomic,assign,getter=isSelected) BOOL selected;
@end

@interface CA_MCategoryModel : CA_HBaseModel
@property (nonatomic,strong) NSNumber *category_id;
@property (nonatomic,copy) NSString *category_name;
@property (nonatomic,strong) NSArray<CA_MCategory*> *children;

@property (nonatomic,assign,getter=isSelected) BOOL selected;
@property (nonatomic,assign,getter=isAll) BOOL all;
@end
