//
//  CA_HAddFileModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/2/8.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

typedef enum : NSUInteger {
    CA_H_AddFileTypeDocument = 0,
    CA_H_AddFileTypeImage,
    CA_H_AddFileTypeData,
    CA_H_AddFileTypeRecord
} CA_H_AddFileType;

@interface CA_HAddFileModel : CA_HBaseModel

@property (nonatomic, assign) CA_H_AddFileType type;
@property (nonatomic, strong) NSData *file;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, copy) NSString *fileSize;
@property (nonatomic, strong) NSNumber *size;

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, assign) BOOL isFinish;
@property (nonatomic, assign) double progress;
@property (nonatomic, copy) void (^progressBlock)(double progress);

@property (nonatomic, strong) NSArray *tags;

@property (nonatomic, strong) NSNumber *parent_id;//":parentId,
@property (nonatomic, strong) NSArray *parent_path;//":parentPath,
@property (nonatomic, strong) NSNumber *file_id;//": 551,
@property (nonatomic, copy) NSString *file_url;//": "/web/v1/api/attachment/551/hello%E4%BD%A0%E5%A5%BD.txt",
//"filename": "hello你好.txt"

@property (nonatomic, strong) NSDate *createDate;


@end
