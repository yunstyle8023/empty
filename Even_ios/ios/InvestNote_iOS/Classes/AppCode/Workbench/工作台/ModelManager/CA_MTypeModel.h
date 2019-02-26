//
//  CA_MTypeModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/19.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

typedef enum : NSUInteger {
    Select,//选择类型的cell
    Input,//输入类型的cell
    Introduce,//介绍类型Cell
    ChooseIcon,//选择头像Cell
    Tag,//标签类型Cell
    Other
} CA_MType;

@interface CA_MTypeModel : CA_HBaseModel
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *value;
@property (nonatomic,copy) NSString *placeHolder;
@property (nonatomic,strong) NSMutableArray *values;
@property (nonatomic,assign) CA_MType type;
@end

