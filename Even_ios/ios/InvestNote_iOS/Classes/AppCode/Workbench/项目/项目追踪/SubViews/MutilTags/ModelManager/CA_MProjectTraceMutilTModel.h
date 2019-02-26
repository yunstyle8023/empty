//
//  CA_MProjectTraceMutilTModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/17.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"
@class CA_MDiscoverCompatible_project_list;

@interface CA_MProjectTraceMutiltRequestModel : CA_HBaseModel

@property (nonatomic,strong) NSNumber *project_id;

@property (nonatomic,copy) NSString *tag_name;

@property (nonatomic,strong) NSNumber *page_num;

@property (nonatomic,strong) NSNumber *page_size;

@end

@interface CA_MProjectTraceMutilTModel : CA_HBaseModel
//"data_list": [                                              # 具体数据与listtrackhome返回的数据一样
//              {
//                  "data_type": "project",
//                  "data_id": "xxxx",
//                  "project_name": "竞品名称",
//                  "project_logo": "竞品logo URL",
//                  "project_last_round": "竞品项目融资轮次",
//                  "project_start_date": 948124800,
//                  "project_tag_list": ["xx", "xx"... ], # 竞品标签
//                  "project_brief": "竞品项目简介",
//                  "project_location": "竞品项目地址"
//              }
//              ],
//"tag_list": [
//             "标签1", "标签2"
//             ]
//"page_count": 1,
//"page_num": 1,
//"page_size": 50,
//"total_count": 1

@property (nonatomic,strong) NSMutableArray<CA_MDiscoverCompatible_project_list *> *data_list;

@property (nonatomic,strong) NSArray *tag_list;

@property (nonatomic,strong) NSNumber *page_count;

@property (nonatomic,strong) NSNumber *page_num;

@property (nonatomic,strong) NSNumber *page_size;

@property (nonatomic,strong) NSNumber *total_count;

@end
