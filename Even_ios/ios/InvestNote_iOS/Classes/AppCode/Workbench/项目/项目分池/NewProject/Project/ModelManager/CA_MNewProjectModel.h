//
//  CA_MNewProjectModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/29.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"
#import "CA_MProjectModel.h"

@interface CA_MNewProjectSplitPoolListModel : CA_HBaseModel
@property (nonatomic,strong) NSNumber *pool_id;
@property (nonatomic,copy) NSString *pool_name;
@property (nonatomic,strong) NSMutableArray<CA_MProjectModel *> *pool_list;
@end

@interface CA_MNewProjectSplitPoolModel : CA_HBaseModel
@property (nonatomic,strong) NSNumber *pool_id;
@property (nonatomic,copy) NSString *pool_name;
@property (nonatomic,strong) NSNumber *pool_count;
@end

@interface CA_MNewProjectModel : CA_HBaseModel

@property (nonatomic,strong) NSMutableArray<CA_MNewProjectSplitPoolModel *> *split_pool_count;

@property (nonatomic,strong) NSMutableArray<CA_MNewProjectSplitPoolListModel *> *split_pool_list;

@end
