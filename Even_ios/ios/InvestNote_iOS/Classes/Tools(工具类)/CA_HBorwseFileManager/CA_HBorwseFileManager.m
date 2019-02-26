//
//  CA_HBorwseFileManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBorwseFileManager.h"

#import "CA_HDownloadCenterViewModel.h"

@implementation CA_HBorwseFileManager

+ (void)browseReport:(CA_HFoundReportData *)model controller:(UIViewController *)controller {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *homeDocumentPath = NSHomeDirectory();
    
    NSString *path = [[homeDocumentPath stringByAppendingPathComponent:CA_H_ReportDocumentsDirectory] stringByAppendingString:[NSString stringWithFormat:@"/%@/", model.report_id]];
    
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *fileUrl = model.report_url;
    NSString *fileName = model.report_name_attributedText.string;
    
    NSArray *suffixArray = [[fileUrl componentsSeparatedByString:@"/"].lastObject componentsSeparatedByString:@"."];
    if (suffixArray.count > 1) {
        NSString *suffix = suffixArray.lastObject;
        if (![fileName hasSuffix:suffix]) {
            fileName = [NSString stringWithFormat:@"%@.%@", fileName, suffix];
        }
    }
    
    NSString *filePath = [path stringByAppendingString:[CA_HDownloadCenterViewModel fileName:fileName transcoding:YES]];
    
    
    if ([fileManager fileExistsAtPath:filePath]) {
        [CA_H_MANAGER browseDocument:[NSURL fileURLWithPath:filePath] viewController:controller noShare:NO];
    } else {
        [CA_HProgressHUD showHud:@""];
        [CA_HNetManager downloadUrlStr:fileUrl path:filePath callBack:^(CA_HNetModel *netModel) {
            [CA_HProgressHUD hideHud];
            if (netModel.type == CA_H_NetTypeSuccess) {
                if (!netModel.error) {
                    [CA_H_MANAGER browseDocument:[NSURL fileURLWithPath:filePath] viewController:controller noShare:NO];
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.report_date.doubleValue];
                    
                    NSString *report_size = model.report_size;
                    if (!report_size.length) {
                        double size = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
                        
                        if (size < 102.4) {
                            report_size = [NSString stringWithFormat:@"%.2fB", size];
                        }else if (size < 102.4*1024) {
                            report_size = [NSString stringWithFormat:@"%.2fK", size/1024.0];
                        }else {
                            report_size = [NSString stringWithFormat:@"%.2fM", size/1024.0/1024.0];
                        }
                    }
                    
                    NSString *showDetail = [NSString stringWithFormat:@"%@ %@ %@", [date stringWithFormat:@"yyyy.MM.dd"], report_size, model.reseacher_attributedText.string?:@""];
                    [CA_HDownloadCenterViewModel storage:model.report_id fileName:fileName fileIcon:model.file_icon creator:@"" showDetail:showDetail type:CA_HDownloadCenterTypeReport];
                    [model checkSaved];
                    return ;
                }
            }
            
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            if (netModel.error.code != -999) {
                [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
            }
        } progress:nil];
    }
}

+ (void)browseCachesFile:(NSNumber *)fileId fileName:(NSString *)fileName fileUrl:(NSString *)fileUrl controller:(UIViewController *)controller {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *homeDocumentPath = NSHomeDirectory();
    
    NSString *path = [[homeDocumentPath stringByAppendingPathComponent:CA_H_FileCachesDirectory] stringByAppendingString:[NSString stringWithFormat:@"/%@/", fileId]];
    
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *filePath = [path stringByAppendingString:[CA_HDownloadCenterViewModel fileName:fileName transcoding:YES]];
    
    
    if ([fileManager fileExistsAtPath:filePath]) {
        [CA_H_MANAGER browseDocument:[NSURL fileURLWithPath:filePath] viewController:controller noShare:NO];
    } else {
        [CA_HProgressHUD showHud:@""];
        [CA_HNetManager downloadUrlStr:fileUrl path:filePath callBack:^(CA_HNetModel *netModel) {
            [CA_HProgressHUD hideHud];
            if (netModel.type == CA_H_NetTypeSuccess) {
                if (!netModel.error) {
                    [CA_H_MANAGER browseDocument:[NSURL fileURLWithPath:filePath] viewController:controller noShare:NO];
                    return ;
                }
            }
            
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            if (netModel.error.code != -999) {
                [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
            }
        } progress:nil];
    }
}


+ (void)browseCachesRecord:(NSNumber *)fileId recordName:(NSString *)fileName fileUrl:(NSString *)fileUrl controller:(UIViewController *)controller {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *homeDocumentPath = NSHomeDirectory();
    
    NSString *path = [[homeDocumentPath stringByAppendingPathComponent:CA_H_RecordCachesDirectory] stringByAppendingString:[NSString stringWithFormat:@"/%@/", fileId]];
    
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *filePath = [path stringByAppendingString:[CA_HDownloadCenterViewModel fileName:fileName transcoding:YES]];
    
    
    if ([fileManager fileExistsAtPath:filePath]) {
        [CA_H_MANAGER playRecord:[NSURL fileURLWithPath:filePath] viewController:controller];
    } else {
        [CA_HProgressHUD showHud:@""];
        [CA_HNetManager downloadUrlStr:fileUrl path:filePath callBack:^(CA_HNetModel *netModel) {
            [CA_HProgressHUD hideHud];
            if (netModel.type == CA_H_NetTypeSuccess) {
                if (!netModel.error) {
                    [CA_H_MANAGER playRecord:[NSURL fileURLWithPath:filePath] viewController:controller];
                    return ;
                }
            }
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            if (netModel.error.code != -999) {
                [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
            }
        } progress:nil];
    }
}

@end
