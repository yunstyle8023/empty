//
//  CA_MSettingPanelModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/29.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

@interface CA_MSettingPanelModel : CA_HBaseModel
//"split_pool_name": "关注项目",              # 分池名称
//"split_pool_id": 1,                         # 分池id
//"is_show": True,                            # 是否展示(True为展示，False为不展示)
//"is_edit": False

@property (nonatomic,copy) NSString *split_pool_name;
@property (nonatomic,strong) NSNumber *split_pool_id;
@property (nonatomic,assign) BOOL is_show;
@property (nonatomic,assign) BOOL is_edit;

@end
