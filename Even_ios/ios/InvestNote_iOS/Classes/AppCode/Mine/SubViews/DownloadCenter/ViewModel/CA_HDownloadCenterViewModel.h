//
//  CA_HDownloadCenterViewModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/21.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HDownloadCenterReportModel.h"

typedef enum : NSUInteger {
    CA_HDownloadCenterTypeFile = 0,
    CA_HDownloadCenterTypeReport,
    CA_HDownloadCenterTypeEnterpriseReport,
} CA_HDownloadCenterType;

@interface CA_HDownloadCenterViewModel : NSObject

+ (NSString *)fileName:(NSString *)fileName transcoding:(BOOL)transcoding;

+ (void)browseFile:(NSDictionary *)dic controller:(UIViewController *)controller;
+ (void)shareFile:(NSDictionary *)dic controller:(UIViewController *)controller;
+ (void)storage:(id)fileId fileName:(NSString *)fileName fileIcon:(NSString *)fileIcon creator:(NSString *)creator showDetail:(NSString *)showDetail type:(CA_HDownloadCenterType)type;
+ (void)deleteAll;
+ (NSArray *)deleteItem:(NSInteger)item;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray *data;


@property (nonatomic, strong) NSMutableArray *reportData;
@property (nonatomic, copy) void (^finishBlock)(BOOL success);
- (void)loadMore;


@end
