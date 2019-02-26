//
//  CA_HMoveListModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/12.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

#import "CA_MProjectModel.h"

@interface CA_HNoteTypeModel : CA_HBaseModel

@property (nonatomic, strong) NSNumber *note_type_id;//": 1,
@property (nonatomic, copy) NSString *note_type_name;//": "访谈记录"

@end


@interface CA_HMoveListModel : CA_HBaseModel

@property (nonatomic, strong) NSArray *data_list;
@property (nonatomic, strong) NSNumber *page_num;//": 1,
@property (nonatomic, strong) NSNumber *page_size;//": 1,
@property (nonatomic, strong) NSNumber *total_count;//": 100,

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSMutableArray<CA_MProjectModel *> *data;
@property (nonatomic, copy) void (^finishRequestBlock)(CA_H_RefreshType type);
@property (nonatomic, copy) void (^loadMoreBlock)(NSString *keyword, BOOL isMember);

@end
