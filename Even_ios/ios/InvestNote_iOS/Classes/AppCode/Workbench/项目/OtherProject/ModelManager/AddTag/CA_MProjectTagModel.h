//
//  CA_MProjectTagModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/20.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

@interface CA_MProjectTagModel : CA_HBaseModel
@property (nonatomic,strong) NSNumber *human_tag_id;
@property (nonatomic,copy) NSString *tag_name;
@property(nonatomic,assign,getter=isSelect)BOOL select;
@end
