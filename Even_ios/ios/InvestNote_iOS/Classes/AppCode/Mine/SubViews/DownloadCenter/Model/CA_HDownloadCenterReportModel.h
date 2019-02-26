//
//  CA_HDownloadCenterReportModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/6/12.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

@interface CA_HDownloadCenterReportModel : CA_HBaseModel

@property (nonatomic, strong) id report_id;
@property (nonatomic, strong) NSNumber *report_date;
@property (nonatomic, copy) NSString *report_name;
@property (nonatomic, copy) NSString *report_url;
@property (nonatomic, copy) NSString *file_icon;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *failure;

@property (nonatomic, copy) NSString *showDetail;

@property (nonatomic, assign) double progress;
@property (nonatomic, copy) void (^progressBlock)(double progress);
@property (nonatomic, copy) void (^deleteBlock)(CA_HDownloadCenterReportModel *deleteModel);

@property (nonatomic, strong) NSURLSessionDownloadTask *dataTask;
- (void)download;
- (void)cancel;
- (void)suspend:(BOOL)suspend;

@end
