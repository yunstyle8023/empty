//
//  CA_HUploadFileManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/2/7.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HUpdateFileManager.h"

#import "CA_HDownloadCenterViewModel.h"

@interface CA_HUpdateFileManager ()

@property (nonatomic, assign) BOOL isWork;

@end

@implementation CA_HUpdateFileManager

#pragma mark --- Action

#pragma mark --- Lazy

- (NSMutableArray<CA_HAddFileModel *> *)contents {
    if (!_contents) {
        _contents = [NSMutableArray new];
    }
    return _contents;
}

//- (void (^)(void))updateBlock {
//    if (!_updateBlock) {
//        CA_H_WeakSelf(self);
//        _updateBlock = ^ {
//            CA_H_StrongSelf(self);
//            if (!self.isWork) [self updateContents];
//        };
//    }
//    return _updateBlock;
//}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)updateContents {
    if (!self.contents.count) {
        _isWork = NO;
        return;
    }
    _isWork = YES;
    [self updateModel:self.contents.firstObject];
}

- (void)updateModel:(CA_HAddFileModel *)model {
    
    if (model.type!=CA_H_AddFileTypeRecord&&![self saveToTmpWithModel:model]) {
        [CA_HProgressHUD showHudStr:@"系统错误!"];
        _isWork = NO;
        return;
    }
    
    [self dataTaskWithModel:model];
}

- (void)dataTaskWithModel:(CA_HAddFileModel *)model {
    
    NSURL *url = [NSURL fileURLWithPath:model.filePath];
    NSURLSession *session = [NSURLSession sharedSession];
    
    CA_H_WeakSelf(self);
    model.dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        CA_H_StrongSelf(self);
        
        if (!response.MIMEType) {
            [CA_HProgressHUD showHudStr:@"系统错误!"];
            [self.contents removeFirstObject];
            [self updateFirstContents];
            return;
        }
        
        CA_HDataModel * dataModel = [CA_HDataModel new];
        dataModel.fileData = data;
        dataModel.name = @"file";
        dataModel.fileName = model.fileName;
        dataModel.mimeType = response.MIMEType;
        
        model.data = data;
        
        double size = [[[NSFileManager defaultManager] attributesOfItemAtPath:model.filePath error:nil] fileSize];
        
        NSString * fileSize;
        if (size < 102.4) {
            fileSize = [NSString stringWithFormat:@"%.2fB", size];
        }else if (size < 102.4*1024) {
            fileSize = [NSString stringWithFormat:@"%.2fK", size/1024.0];
        }else {
            fileSize = [NSString stringWithFormat:@"%.2fM", size/1024.0/1024.0];
        }
        model.size = @(size);
        model.fileSize = fileSize;
        
        if (size > 20*1024*1024 && model.type != CA_H_AddFileTypeRecord) {
            [CA_HProgressHUD showHudStr:@"抱歉，当前仅支持上传小于20M的文件"];
            if (model.progressBlock) {
                model.progressBlock(2);
            }
            model.dataTask = nil;
            [self.contents removeFirstObject];
            [self updateFirstContents];
            return ;
        }
        
        model.dataTask =
        [CA_HNetManager updateFile:@[dataModel] callBack:^(CA_HNetModel *netModel) {
            CA_H_StrongSelf(self);
            
            if (netModel.type == CA_H_NetTypeSuccess) {
                if (netModel.errcode.integerValue == 0) {
                    
                    if ([netModel.data isKindOfClass:[NSDictionary class]]) {
                        model.isFinish = YES;
                        model.file_id = netModel.data[@"file_id"];
                        model.file_url = netModel.data[@"file_url"];
                        model.fileName = netModel.data[@"filename"];
                        [self saveToCachesWithModel:model];
//                        if (![self saveToCachesWithModel:model]) [CA_HProgressHUD showHudStr:@"系统缓存错误!"];
                    }
                }
            }
            
            if (!model.isFinish) {
                if (netModel.error.code != -999) {
                    [CA_HProgressHUD showHudStr:netModel.errmsg?:(model.progress<1?@"文件上传失败，网络出错，请检查网络环境":@"文件上传失败，上传路径出错啦，请刷新后重试")];
                }
            }
            
            
            if (model.progressBlock) {
                model.progressBlock(2);
            }
            
            model.dataTask = nil;
            [self.contents removeFirstObject];
            [self updateFirstContents];
            
        } progress:^(NSProgress *requestProgress) {
            double progress = 1.0*requestProgress.completedUnitCount/requestProgress.totalUnitCount;
            model.progress = progress;
            if (model.progressBlock) {
                model.progressBlock(progress);
            }
        }];
    }];
    [model.dataTask resume];
}


- (BOOL)saveToTmpWithModel:(CA_HAddFileModel *)model {
    NSString *tmp = NSTemporaryDirectory();
    NSString *path;
    NSInteger i = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    do {
        NSString *parentPath = [[[NSDate date] stringWithFormat:@"yyyy-MM-dd'T'HH-mm-ss'T'"] stringByAppendingString:[NSString stringWithFormat:@"/%ld/",i++]];
        path = [tmp stringByAppendingString:parentPath];
    } while ([fileManager fileExistsAtPath:path]);
    
    [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    
    model.filePath = [path stringByAppendingString:[CA_HDownloadCenterViewModel fileName:model.fileName transcoding:YES]];
    
    return [model.file writeToFile:model.filePath atomically:YES];
}

- (BOOL)saveToCachesWithModel:(CA_HAddFileModel *)model {
    NSString *homeDocumentPath = NSHomeDirectory();
    //拼接
    NSString *cachePath = [[homeDocumentPath stringByAppendingPathComponent:(model.type==CA_H_AddFileTypeRecord?CA_H_RecordCachesDirectory:CA_H_FileCachesDirectory)] stringByAppendingString:[NSString stringWithFormat:@"/%@/", model.file_id]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *filePath = [cachePath stringByAppendingString:[CA_HDownloadCenterViewModel fileName:model.fileName transcoding:YES]];
    
//    if (model.type == CA_H_AddFileTypeDocument) {
//        return [model.data writeToFile:filePath atomically:YES];
//    } else {
//        return [fileManager moveItemAtPath:model.filePath toPath:filePath error:nil];
//    }
    
    return [fileManager moveItemAtPath:model.filePath toPath:filePath error:nil];
    
}

#pragma mark --- NEW

- (void)update:(CA_HAddFileModel *)model {
    if (model) {
        [self.contents addObject:model];
    }
    if (!self.isWork) [self updateFirstContents];
}

- (void)updateFirstContents {
    if (!self.contents.count) {
        _isWork = NO;
        return;
    }
    _isWork = YES;
    [self dataTaskWithModel:self.contents.firstObject];
}



- (void)saveToTmp:(CA_HAddFileModel *)model success:(void(^)(void))success failed:(void(^)(void))failed {
    
    if (model.type!=CA_H_AddFileTypeRecord&&![self saveToTmpWithModel:model]) {
        // 缓存失败
        if (failed) failed();
        return;
    }
    
    double size = [[[NSFileManager defaultManager] attributesOfItemAtPath:model.filePath error:nil] fileSize];
    if (size > 20*1024*1024 && model.type != CA_H_AddFileTypeRecord) {
        [CA_HProgressHUD showHudStr:@"抱歉，当前仅支持上传小于20M的文件"];
        if (failed) failed();
        return ;
    }
    if (success) success();
}

@end
