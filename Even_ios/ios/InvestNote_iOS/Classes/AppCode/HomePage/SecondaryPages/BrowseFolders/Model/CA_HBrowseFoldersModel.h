//
//  CA_HBrowseFoldersModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/1/31.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

#import "CA_HParticipantsModel.h"


@interface CA_HFileTagModel : CA_HBaseModel

@property (nonatomic, strong) NSNumber *tag_id;//": 1,
@property (nonatomic, copy) NSString *tag_name;//": "tag_1"

@end;

@class CA_HListFileModel;
@interface CA_HBrowseFoldersModel : CA_HBaseModel

@property (nonatomic, strong) CA_HParticipantsModel *creator;
@property (nonatomic, strong) NSNumber *ts_create;//1520000000,
@property (nonatomic, strong) NSNumber *ts_update;//1520000000,
@property (nonatomic, strong) NSNumber *file_size;//":0
@property (nonatomic, copy) NSString *file_icon;//@""
@property (nonatomic, copy) NSString *file_type;//": "directory",
@property (nonatomic, strong) NSNumber *file_id;//": 42,
@property (nonatomic, copy) NSString *file_name;//": "test_rename_dir3",
@property (nonatomic, strong) NSArray *file_path;
@property (nonatomic, strong) NSNumber *parent_id;//": 1
@property (nonatomic, strong) NSArray *parent_path;//": [ "/", "项目文件夹", "test_rename_dir3"],
@property (nonatomic, copy) NSString *preview_path;//": null,
@property (nonatomic, copy) NSString *storage_path;//": null,
@property (nonatomic, strong) NSArray<CA_HFileTagModel *> *tags;//": []
@property (nonatomic, strong) NSArray *path_option;//": ["preview", "handle"]  # 对于目录，"preview"可读，"handle"可处理(处理代表 建/删/改) "create"子文件可创建
@property (nonatomic, copy) NSString *null_msg;
@property (nonatomic, strong) CA_HListFileModel *subdir;

@property (nonatomic, strong) NSNumber *page_num;


@property (nonatomic, copy) NSString *showDetail;

// 下载时用到
@property (nonatomic, assign) NSInteger isDownLoad;//0:未处理, 1:已下载, 2:未下载, 3:下载中, 4暂停中;
@property (nonatomic, strong) NSURLSessionDownloadTask *dataTask;
@property (nonatomic, assign) double progress;
@property (nonatomic, copy) void (^progressBlock)(double progress);
@property (nonatomic, copy) void (^downloadBlock)(void);
@end


@interface CA_HListFileModel : CA_HBaseModel

@property (nonatomic, strong) NSArray<CA_HBrowseFoldersModel *> *directory_data;//: [
@property (nonatomic, strong) NSArray<CA_HBrowseFoldersModel *> *file_data;//: [


#pragma mark --- 外部
@property (nonatomic, copy) void (^finishRequestBlock)(BOOL success, BOOL noMore);
#pragma mark --- 内部
@property (nonatomic, copy) void (^loadDataBlock)(NSArray *parent_path, NSString *keyword);

@property (nonatomic, copy) NSURLSessionDataTask *dataTask;


@property (nonatomic, copy) NSArray *parent_path;
@property (nonatomic, copy) NSString *keyword;
- (void)loadMore;
@property (nonatomic, strong) NSArray<CA_HBrowseFoldersModel *> *data_list;//: [
@property (nonatomic, strong) NSNumber *page_count;//": 1,
@property (nonatomic, strong) NSNumber *page_num;//": 1,
@property (nonatomic, strong) NSNumber *page_size;//": 50,
@property (nonatomic, strong) NSNumber *total_count;//": 1


//choose
@property (nonatomic, strong) NSNumber *current_dir_id;//": 2                                                         # 当前目录的id，对应model_list中对象的model_id
@property (nonatomic, strong) NSArray<CA_HBrowseFoldersModel *> *model_list;//": [
- (void)loadChooseData:(NSNumber *)model_id page_num:(NSNumber *)page_num;

@end
