//
//  CA_HDownloadCenterViewModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/21.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HDownloadCenterViewModel.h"

@interface CA_HDownloadCenterViewModel ()

@end

@implementation CA_HDownloadCenterViewModel

+ (NSString *)fileName:(NSString *)fileName transcoding:(BOOL)transcoding {
    if (!fileName) {
        return @"(null)";
    }
    if (transcoding) {
        return [fileName stringByReplacingOccurrencesOfString:@"/"withString:@"\:"];
    } else {
        return [fileName stringByReplacingOccurrencesOfString:@"\:"withString:@"/"];
    }
}

+ (NSString *)filePath:(NSDictionary *)dic {
    NSString *homeDocumentPath = NSHomeDirectory();
    NSString *fileDirectory;
    
    NSNumber *type = dic[@"type"];
    
    switch (type.integerValue) {
        case CA_HDownloadCenterTypeReport:
            fileDirectory = [homeDocumentPath stringByAppendingPathComponent:CA_H_ReportDocumentsDirectory];
            break;
        case CA_HDownloadCenterTypeEnterpriseReport:
            fileDirectory = [homeDocumentPath stringByAppendingPathComponent:CA_H_EnterpriseReportDocumentsDirectory];
            break;
        default:
            fileDirectory = [homeDocumentPath stringByAppendingPathComponent:CA_H_FileDocumentsDirectory];
            break;
    }
    NSString *filePath = [fileDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@/%@", dic[@"fileId"], [CA_HDownloadCenterViewModel fileName:dic[@"fileName"] transcoding:YES]]];
    
    return filePath;
}

+ (void)browseFile:(NSDictionary *)dic controller:(UIViewController *)controller {
    
    NSString *filePath = [self filePath:dic];
    [CA_H_MANAGER browseDocument:[NSURL fileURLWithPath:filePath] viewController:controller noShare:NO/*([dic[@"type"] integerValue]>0)*/];
}

+ (void)shareFile:(NSDictionary *)dic controller:(UIViewController *)controller {
    
    NSString *filePath = [self filePath:dic];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:@[[NSURL fileURLWithPath:filePath]] applicationActivities:nil];
    //给activityVC的属性completionHandler写一个block。
    //用以UIActivityViewController执行结束后，被调用，做一些后续处理。
    UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(UIActivityType activityType, BOOL completed, NSArray * returnedItems, NSError * activityError)
    {
        NSLog(@"activityType :%@", activityType);
        if (completed)
        {
            NSLog(@"completed");
        }
        else
        {
            NSLog(@"cancel");
        }
    };
    
    // 初始化completionHandler，当post结束之后（无论是done还是cancell）该blog都会被调用
    activityVC.completionWithItemsHandler = myBlock;
    
    [controller presentViewController:activityVC animated:YES completion:nil];
}

+ (void)storage:(id)fileId fileName:(NSString *)fileName fileIcon:(NSString *)fileIcon creator:(NSString *)creator showDetail:(NSString *)showDetail type:(CA_HDownloadCenterType)type{
    
    NSDictionary *dic = @{@"fileId":fileId?:@"(null)",
                          @"fileName":fileName?:@"",
                          @"fileIcon":fileIcon?:@"",
                          @"showDetail":showDetail?:@"",
                          @"type":@(type)
                          };
    
    NSArray *downloads = [CA_H_UserDefaults objectForKey:CA_H_DownloadCenter];
    
    NSMutableArray *mut = [NSMutableArray arrayWithArray:downloads];
    [mut addObject:dic];
    
    [CA_H_UserDefaults setObject:mut forKey:CA_H_DownloadCenter];
    [CA_H_UserDefaults synchronize];
}

+ (void)deleteAll {
    NSArray *downloads = [CA_H_UserDefaults objectForKey:CA_H_DownloadCenter];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (NSDictionary *dic in downloads) {
        NSString *filePath = [self filePath:dic];
        [fileManager removeItemAtPath:filePath error:nil];
    }
    
    [CA_H_UserDefaults setObject:nil forKey:CA_H_DownloadCenter];
    [CA_H_UserDefaults synchronize];
}

+ (NSArray *)deleteItem:(NSInteger)item {
    
    NSArray *downloads = [CA_H_UserDefaults objectForKey:CA_H_DownloadCenter];
    
    if (item >= 0) {
        NSMutableArray *mut = [NSMutableArray arrayWithArray:downloads];
        NSDictionary *dic = mut[item];
        [mut removeObjectAtIndex:item];
        
        NSString *filePath = [self filePath:dic];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
        
        [CA_H_UserDefaults setObject:mut forKey:CA_H_DownloadCenter];
        [CA_H_UserDefaults synchronize];
        
        downloads = mut;
    }
    
    return downloads;
}

#pragma mark --- Action

#pragma mark --- Lazy

- (NSString *)title {
    return CA_H_LAN(@"下载中心");
}

- (NSArray *)data {
    if (!_data) {
        _data = [CA_HDownloadCenterViewModel deleteItem:-1];
    }
    return _data;
}

- (NSMutableArray *)reportData {
    if (!_reportData) {
        _reportData = [NSMutableArray new];
    }
    return _reportData;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)loadMore {
    
    CA_H_WeakSelf(self);
    [CA_HNetManager postUrlStr:CA_H_Api_SendToDownloadCenter parameters:@{} callBack:^(CA_HNetModel *netModel) {
        CA_H_StrongSelf(self);
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0
                &&
                [netModel.data isKindOfClass:[NSArray class]]) {
                
                [self.reportData removeAllObjects];
                for (NSDictionary *dic in netModel.data) {
                    CA_HDownloadCenterReportModel *model = [CA_HDownloadCenterReportModel modelWithDictionary:dic];
                    CA_H_WeakSelf(self);
                    model.deleteBlock = ^(CA_HDownloadCenterReportModel *deleteModel) {
                        CA_H_StrongSelf(self);
                        [self deleteModel:deleteModel];
                    };
                    [self.reportData addObject:model];
                }
                
                if (self.finishBlock) self.finishBlock(YES);
                return;
            }
        }
        
        if (self.finishBlock) self.finishBlock(NO);
        if (netModel.error.code != -999) {
            if (netModel.errmsg) [CA_HProgressHUD showHudStr:netModel.errmsg];
        }
    } progress:nil];
}

- (void)deleteModel:(CA_HDownloadCenterReportModel *)deleteModel {
    
    if (!deleteModel.report_id) {
        [CA_HProgressHUD showHudStr:@"系统错误!"];
        return;
    }
    
    NSDictionary *parameters = @{@"report_id":deleteModel.report_id};
    
    CA_H_WeakSelf(self);
    [CA_HNetManager postUrlStr:CA_H_Api_DeleteFromDownloadCenter parameters:parameters callBack:^(CA_HNetModel *netModel) {
        CA_H_StrongSelf(self);
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0) {
                
                [CA_HDownloadCenterViewModel storage:deleteModel.report_id fileName:deleteModel.report_name fileIcon:deleteModel.file_icon creator:@"" showDetail:deleteModel.showDetail type:CA_HDownloadCenterTypeEnterpriseReport];
                self.data = [CA_HDownloadCenterViewModel deleteItem:-1];
                [self.reportData removeObject:deleteModel];
                
                if (self.finishBlock) self.finishBlock(YES);
                return;
            }
        }
        
        if (netModel.error.code != -999) {
            if (netModel.errmsg) [CA_HProgressHUD showHudStr:netModel.errmsg];
        }
    } progress:nil];
}


#pragma mark --- Delegate

@end
