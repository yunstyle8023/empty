//
//  CA_MNewProjectListModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/30.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"
@class CA_MProjectModel;
@class CA_MProjectRisk_Tag_ListModel;
@class CA_MNewSelectProjectConditionsDataListModel;

@interface CA_MNewProjectListModel : CA_HBaseModel
//
@property (nonatomic,strong) NSMutableArray<CA_MNewSelectProjectConditionsDataListModel *> *split_pool_list;

@property (nonatomic,strong) NSMutableArray<CA_MProjectRisk_Tag_ListModel *> *project_tag_list;

@property (nonatomic,strong) NSMutableArray<CA_MProjectModel *> *data_list;

@property (nonatomic,strong) NSNumber *page_count;

@property (nonatomic,strong) NSNumber *page_num;

@property (nonatomic,strong) NSNumber *page_size;

@property (nonatomic,strong) NSNumber *total_count;

@end
