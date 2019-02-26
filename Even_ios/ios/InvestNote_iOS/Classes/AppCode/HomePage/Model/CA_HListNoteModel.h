//
//  CA_HListNoteModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/1/18.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"
#import "CA_HParticipantsModel.h"

@interface CA_HListNoteContentModel : CA_HBaseModel

@property (nonatomic, strong) NSNumber *object_id;//': 1,
@property (nonatomic, copy) NSString *object_name;//": "\u6ef4\u6ef4\u6253\u4eba",
@property (nonatomic, copy) NSString *object_type;// = "project",

@property (nonatomic, strong) NSNumber *note_id;//': 1,
@property (nonatomic, strong) NSNumber *note_type_id;//': 3,
@property (nonatomic, copy) NSString *note_type_name;// = "投资点评",
@property (nonatomic, copy) NSString *note_title;//': 'note_title',
@property (nonatomic, strong) NSNumber *ts_create;//': '2017-01-01T00:00:00Z',    # 笔记创建时间
@property (nonatomic, strong) NSNumber *ts_update;//': '2017-01-01T00:00:00Z',    # 笔记更新时间
@property (nonatomic, copy) NSString *content;//': '纯文本content, 换行以\n 分割',
@property (nonatomic, strong) NSNumber *comment_count;// = "",

@property (nonatomic, strong) CA_HParticipantsModel *creator;



@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, copy) NSString *time;

@end

@interface CA_HListNoteModel : CA_HBaseModel

@property (nonatomic, strong) NSNumber *total_count;//': 100,
@property (nonatomic, strong) NSNumber *page_size;//': 1,
@property (nonatomic, strong) NSNumber *page_num;//': 1,
@property (nonatomic, strong) NSNumber *page_count;//': 100,
@property (nonatomic, strong) NSArray *data_list;//': [
@property (nonatomic, strong) NSDate *lastUpdate;

@property (nonatomic, strong) NSNumber *objectId;
@property (nonatomic, copy) NSString *objectType;
@property (nonatomic, assign) BOOL noShow;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@property (nonatomic, strong) NSMutableArray<NSMutableArray<CA_HListNoteContentModel *> *> *data;
@property (nonatomic, strong) NSMutableArray<CA_HListNoteContentModel *> *allData;
@property (nonatomic, copy) void (^finishRequestBlock)(CA_H_RefreshType type);
@property (nonatomic, copy) CA_HListNoteModel *(^loadMoreBlock)(NSString *keyword);
@property (nonatomic, copy) NSString *keyword;

@end
