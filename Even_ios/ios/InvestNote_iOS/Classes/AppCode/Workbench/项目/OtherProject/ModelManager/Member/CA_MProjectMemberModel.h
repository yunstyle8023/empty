//
//  CA_MProjectMemberModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/9.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

@interface CA_MMemberModel :CA_HBaseModel
@property (nonatomic,copy) NSString *abatar_color;
@property (nonatomic,strong) NSNumber *member_type_id;
@property (nonatomic,copy) NSString *chinese_name;
@property (nonatomic,copy) NSString *member_type_name;
@property (nonatomic,strong) NSNumber *user_id;
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,assign,getter=isSelected) BOOL select;
@end

@interface CA_MProjectMemberModel : CA_HBaseModel
@property (nonatomic,strong) NSMutableArray<CA_MMemberModel*> *member_list;
@property (nonatomic,strong) NSMutableArray<CA_MMemberModel*> *manager_list;
@property (nonatomic,strong) NSNumber *member_type_id;
@end
