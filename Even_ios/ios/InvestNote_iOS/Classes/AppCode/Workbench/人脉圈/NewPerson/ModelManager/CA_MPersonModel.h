//
//  CA_MPersonModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/19.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

@interface CA_MPersonTagModel : CA_HBaseModel
@property (nonatomic,strong) NSNumber *human_tag_id;
@property (nonatomic,copy) NSString *tag_name;
@end

@interface CA_MPersonModel : CA_HBaseModel
@property (nonatomic,strong) NSNumber *human_id;
@property (nonatomic,copy) NSString *chinese_name;
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString *avatar_color;
@property (nonatomic,strong) NSArray<CA_MPersonTagModel*> *tag_data;

@property (nonatomic, strong) NSNumber *file_id;// = 55,
@property (nonatomic, strong) NSArray *file_path;// = (

@property (nonatomic, copy) NSString *phone;

@property (nonatomic,assign,getter=isSelected) BOOL select;
@property (nonatomic,assign,getter=isAll) BOOL all;
@end
