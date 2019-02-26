//
//  CA_MSettingModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

@interface CA_MSettingListModel :CA_HBaseModel
@property (nonatomic,copy) NSString *mod_name;
@property (nonatomic,copy) NSString *mod_type;
@property (nonatomic,copy) NSString *mod_img;
@property (nonatomic,assign,getter=isSelected) BOOL selected;
@end

@interface CA_MSettingAvaterModel :CA_HBaseModel
@property (nonatomic,strong) NSNumber *user_id;
@property (nonatomic,copy) NSString *chinese_name;
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString *avatar_color;
@property (nonatomic,copy) NSString *role;
@end

@interface CA_MSettingModel : CA_HBaseModel
@property (nonatomic,strong) CA_MSettingAvaterModel *avatar;
@property (nonatomic,strong) NSArray<CA_MSettingListModel*> *mod_list;
@end
