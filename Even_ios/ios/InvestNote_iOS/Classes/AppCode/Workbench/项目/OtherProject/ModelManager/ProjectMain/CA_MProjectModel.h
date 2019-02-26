//
//  CA_MProjectModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/6.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

@interface CA_MProjectRisk_Tag_ListModel : CA_HBaseModel
@property (nonatomic,copy) NSString *tag_color;
@property (nonatomic,copy) NSString *tag_name;

@property (nonatomic,strong) NSNumber *tag_id;
@end

@interface CA_MProjectTotal_AmountModel : CA_HBaseModel
@property (nonatomic,copy) NSString *unit_cn;
@property (nonatomic,strong) NSNumber *num;
@property (nonatomic,copy) NSString *unit_en;
@property (nonatomic,copy) NSString *unit_sym;
@property (nonatomic,strong) NSNumber *unit_id;
@end

@interface CA_MProjectNetModel : CA_HBaseModel
@property (nonatomic,strong) NSMutableArray *category_ids;
@property (nonatomic,strong) NSMutableArray *progress_status_ids;
@property (nonatomic,strong) NSMutableArray *invest_stage_ids;
@property (nonatomic,strong) NSMutableArray *user_ids;
@property (nonatomic,strong) NSNumber *page_num;
@property (nonatomic,copy) NSString *keyword;

@property (nonatomic,strong) NSNumber *total_count;

@property (nonatomic,strong) NSArray<NSNumber *> *pool_id;
@property (nonatomic,strong) NSNumber *tag_id;
@end

@interface CA_MProjectCategoryModel : CA_HBaseModel
@property (nonatomic,copy) NSString *child_category_name;
@property (nonatomic,copy) NSString *parent_category_name;
@property (nonatomic,strong) NSNumber *parent_category_id;
@property (nonatomic,strong) NSNumber *child_category_id;
@end

@interface CA_MProjectModel : CA_HBaseModel
@property (nonatomic,copy) NSString *procedure_name;
@property (nonatomic,strong) NSNumber *member_type_id;
@property (nonatomic,copy) NSString *member_type_name;
@property (nonatomic,strong) CA_MProjectCategoryModel *category;
@property (nonatomic,copy) NSString *dt_create;
@property (nonatomic,copy) NSString *project_color;
@property (nonatomic,copy) NSString *project_name;
@property (nonatomic,copy) NSString *invest_stage;
@property (nonatomic,copy) NSString *brief_intro;
@property (nonatomic,strong) NSArray *project_area;
@property (nonatomic,copy) NSString *dt_update;
@property (nonatomic,strong) NSNumber *invest_stage_id;
@property (nonatomic,strong) NSNumber *procedure_id;
@property (nonatomic,strong) NSNumber *project_id;
@property (nonatomic,strong) NSNumber *file_id;
@property (nonatomic,copy) NSString *privacy;
@property (nonatomic,copy) NSString *project_logo;
@property (nonatomic,strong) NSArray *file_path;

@property (nonatomic,assign) BOOL is_follow;

@property (nonatomic,assign) BOOL is_relation;
@property (nonatomic,copy) NSString *project_status;
@property (nonatomic,copy) NSString *project_progress;
@property (nonatomic,strong) NSNumber *ts_update;
@property (nonatomic,strong) NSNumber *ts_create;
@property (nonatomic,copy) NSString *stock_ratio;

@property (nonatomic,copy) NSString *abandon_info;
@property (nonatomic,copy) NSString *profit;

@property (nonatomic,strong) NSArray<CA_MProjectRisk_Tag_ListModel *> *risk_tag_list;

@property (nonatomic,strong) CA_MProjectTotal_AmountModel *total_amount;


@property (nonatomic,assign,getter=isSelected) BOOL select;
@end

