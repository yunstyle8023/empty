//
//  CA_HDownloadCenterReportModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/6/12.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HDownloadCenterReportModel.h"

#import "CA_HDownloadCenterViewModel.h"

@interface CA_HDownloadCenterReportModel ()

@end

@implementation CA_HDownloadCenterReportModel

#pragma mark --- Action

#pragma mark --- Lazy

#pragma mark --- LifeCircle

- (void)dealloc {
    _progressBlock = nil;
    _deleteBlock = nil;
    [_dataTask cancel];
    _dataTask = nil;
}

#pragma mark --- Custom

- (void)cancel {
    [_dataTask cancel];
    _dataTask = nil;
    self.status = @(1);
}
- (void)suspend:(BOOL)suspend {
    if (suspend) {
        [_dataTask suspend];
    } else {
        [_dataTask resume];
    }
}

- (void)download {
    
    self.status = @(2);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *homeDocumentPath = NSHomeDirectory();
    
    NSString *path = [[homeDocumentPath stringByAppendingPathComponent:CA_H_EnterpriseReportDocumentsDirectory] stringByAppendingString:[NSString stringWithFormat:@"/%@/", self.report_id]];
    
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSArray *suffixArray = [[self.report_url componentsSeparatedByString:@"/"].lastObject componentsSeparatedByString:@"."];
    if (suffixArray.count > 1) {
        NSString *suffix = suffixArray.lastObject;
        if (![self.report_name hasSuffix:suffix]) {
            self.report_name = [NSString stringWithFormat:@"%@.%@", self.report_name, suffix];
        }
    }
    
    NSString *filePath = [path stringByAppendingString:[CA_HDownloadCenterViewModel fileName:self.report_name transcoding:YES]];
    
    CA_H_WeakSelf(self);
    _dataTask =
    [CA_HNetManager downloadUrlStr:self.report_url path:filePath callBack:^(CA_HNetModel *netModel) {
        CA_H_StrongSelf(self);
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (!netModel.error) {
                
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.report_date.doubleValue];
                
                double size = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
                
                NSString *report_size;
                if (size < 102.4) {
                    report_size = [NSString stringWithFormat:@"%.2fB", size];
                }else if (size < 102.4*1024) {
                    report_size = [NSString stringWithFormat:@"%.2fK", size/1024.0];
                }else {
                    report_size = [NSString stringWithFormat:@"%.2fM", size/1024.0/1024.0];
                }
                
                self.showDetail = [NSString stringWithFormat:@"%@ %@", [date stringWithFormat:@"yyyy.MM.dd"], report_size];

                if (self.deleteBlock) {
                    self.deleteBlock(self);
                }
                
                return ;
            }
        }
        
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        if (netModel.error.code != -999) {
            [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
        }
    } progress:^(NSProgress *requestProgress) {
        CA_H_StrongSelf(self);
        if (self.progressBlock) {
            double progress = 1.0*requestProgress.completedUnitCount/requestProgress.totalUnitCount;
            self.progress = progress;
            self.progressBlock(progress);
        }
    }];
    
}

#pragma mark --- Delegate

@end
