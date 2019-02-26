//
//  CA_HBrowseFoldersModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/1/31.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBrowseFoldersModel.h"

#import "CA_HDownloadCenterViewModel.h" // 储存到本地


@implementation CA_HFileTagModel


@end

@implementation CA_HBrowseFoldersModel

#pragma mark --- 下载

- (NSInteger)isDownLoad {
    if (_isDownLoad == 0) {
        NSString *homeDocumentPath = NSHomeDirectory();
        NSString *filePath = [[homeDocumentPath stringByAppendingPathComponent:CA_H_FileDocumentsDirectory] stringByAppendingString:[NSString stringWithFormat:@"/%@/%@", self.file_id, [CA_HDownloadCenterViewModel fileName:self.file_name transcoding:YES]]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:filePath]) {
            _isDownLoad = 1;
        } else {
            _isDownLoad = 2;
        }
    }
    return _isDownLoad;
}

- (void (^)(void))downloadBlock {
    if (!_downloadBlock) {
        CA_H_WeakSelf(self);
        _downloadBlock = ^ {
            CA_H_StrongSelf(self);
            [self downloadFile];
        };
    }
    return _downloadBlock;
}

- (void)downloadFile {
    
    if (!(self.file_id&&self.file_name.length&&self.storage_path.length)) {
        [CA_HProgressHUD showHudStr:@"系统错误!"];
        return;
    }
    
    NSString *homeDocumentPath = NSHomeDirectory();
    NSString *path = [[homeDocumentPath stringByAppendingPathComponent:CA_H_FileDocumentsDirectory] stringByAppendingString:[NSString stringWithFormat:@"/%@/", self.file_id]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *filePath = [path stringByAppendingString:[CA_HDownloadCenterViewModel fileName:self.file_name transcoding:YES]];
    
    NSString *cachePath = [[homeDocumentPath stringByAppendingPathComponent:CA_H_FileCachesDirectory] stringByAppendingString:[NSString stringWithFormat:@"/%@/%@", self.file_id, [CA_HDownloadCenterViewModel fileName:self.file_name transcoding:YES]]];
    if ([fileManager fileExistsAtPath:cachePath]) {
        [fileManager moveItemAtPath:cachePath toPath:filePath error:nil];
        _isDownLoad = 1;
        [CA_HDownloadCenterViewModel storage:self.file_id fileName:self.file_name fileIcon:self.file_icon creator:self.creator.chinese_name showDetail:self.showDetail type:CA_HDownloadCenterTypeFile];
        CA_H_DISPATCH_MAIN_THREAD(^{
            if (self.progressBlock) {
                self.progressBlock(2);
            }
        });
        
    } else {
        CA_H_WeakSelf(self);
        _dataTask = [CA_HNetManager downloadUrlStr:self.storage_path path:filePath callBack:^(CA_HNetModel *netModel) {
            CA_H_StrongSelf(self);
            if (netModel.type == CA_H_NetTypeSuccess) {
                if (!netModel.error) {
                    self.isDownLoad = 1;
                    [CA_HDownloadCenterViewModel storage:self.file_id fileName:self.file_name fileIcon:self.file_icon creator:self.creator.chinese_name showDetail:self.showDetail type:CA_HDownloadCenterTypeFile];
                    CA_H_DISPATCH_MAIN_THREAD(^{
                        if (self.progressBlock) {
                            self.progressBlock(2);
                        }
                    });
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
}


#pragma mark --- 详情展示

- (NSString *)showDetail {
    if (!_showDetail.length) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.ts_update.longValue];
        
        NSString * time = [date stringWithFormat:@"yyyy.MM.dd HH:mm"];
        
        double size = self.file_size.doubleValue;
        
        NSString * fileSize;
        if (size < 102.4) {
            fileSize = [NSString stringWithFormat:@"%.1fB", size];
        }else if (size < 102.4*1024) {
            fileSize = [NSString stringWithFormat:@"%.1fK", size/1024.0];
        } else {
            fileSize = [NSString stringWithFormat:@"%.1fM", size/(1024.0*1024.0)];
        }
        
        NSString *name = self.creator.chinese_name.length>4?[NSString stringWithFormat:@"%@…",[self.creator.chinese_name substringToIndex:3]]:self.creator.chinese_name;
        _showDetail = [NSString stringWithFormat:@"%@ %@ %@", name, time, fileSize];
    }
    return _showDetail;
}

#pragma mark --- array

- (void)setTags:(NSArray<CA_HFileTagModel *> *)tags {
    if (![tags isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dic in tags) {
        if ([dic isKindOfClass:[CA_HFileTagModel class]]) {
            [array addObject:dic];
        }else{
            [array addObject:[CA_HFileTagModel modelWithDictionary:dic]];
        }
    }
    
    _tags = array;
}

- (void)setSubdir:(CA_HListFileModel *)subdir {
    if ([subdir isKindOfClass:[CA_HListFileModel class]]) {
        _subdir = subdir;
        return;
    }
    
    if ([subdir isKindOfClass:[NSDictionary class]]) {
        _subdir = [CA_HListFileModel modelWithDictionary:(id)subdir];
    }
}


@end


@interface CA_HListFileModel ()

@end

@implementation CA_HListFileModel

#pragma mark --- Action

#pragma mark --- Lazy

- (void)setData_list:(NSArray<CA_HBrowseFoldersModel *> *)data_list {
    if (![data_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dic in data_list) {
        if ([dic isKindOfClass:[CA_HBrowseFoldersModel class]]) {
            [array addObject:dic];
        }else{
            [array addObject:[CA_HBrowseFoldersModel modelWithDictionary:dic]];
        }
    }
    
    _data_list = array;
}

- (void)setModel_list:(NSArray<CA_HBrowseFoldersModel *> *)model_list {
    if (![model_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dic in model_list) {
        if ([dic isKindOfClass:[CA_HBrowseFoldersModel class]]) {
            [array addObject:dic];
        }else{
            [array addObject:[CA_HBrowseFoldersModel modelWithDictionary:dic]];
        }
    }
    
    _model_list = array;
}

- (void)setDirectory_data:(NSArray<CA_HBrowseFoldersModel *> *)directory_data {
    if (![directory_data isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dic in directory_data) {
        if ([dic isKindOfClass:[CA_HBrowseFoldersModel class]]) {
            [array addObject:dic];
        }else{
            [array addObject:[CA_HBrowseFoldersModel modelWithDictionary:dic]];
        }
    }
    
    _directory_data = array;
}

- (void)setFile_data:(NSArray<CA_HBrowseFoldersModel *> *)file_data {
    if (![file_data isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dic in file_data) {
        if ([dic isKindOfClass:[CA_HBrowseFoldersModel class]]) {
            [array addObject:dic];
        }else{
            [array addObject:[CA_HBrowseFoldersModel modelWithDictionary:dic]];
        }
    }
    
    _file_data = array;
}

- (void (^)(NSArray *, NSString *))loadDataBlock {
    if (!_loadDataBlock) {
        CA_H_WeakSelf(self);
        _loadDataBlock = ^(NSArray *parent_path, NSString *keyword) {
            CA_H_StrongSelf(self);
            
            if (!parent_path) {
                [CA_HProgressHUD showHudStr:@"系统错误!"];
                return ;
            }
            
            self.parent_path = parent_path;
            self.keyword = keyword?:@"";
            
            NSDictionary *parameters =
            @{@"parent_path":parent_path,
              @"keyword":keyword?:@"",
              @"page_num": @1,
              @"page_size": @50
              };
            
            CA_H_WeakSelf(self);
            [self.dataTask cancel];
            
            if (!CA_H_MANAGER.getToken.length) {
                return;
            }
            
            self.dataTask =
            [CA_HNetManager postUrlStr:CA_H_Api_ListDirectoryFile
                            parameters:parameters
                              callBack:^(CA_HNetModel *netModel) {
                                  CA_H_StrongSelf(self);
                                  self.PostFinish = netModel;
                                  
                              } progress:nil];
        };
    }
    return _loadDataBlock;
}

- (void)loadMore {
    if (!self.parent_path) {
        [CA_HProgressHUD showHudStr:@"系统错误!"];
        return ;
    }
    
    NSDictionary *parameters =
    @{@"parent_path":self.parent_path,
      @"keyword":self.keyword,
      @"page_num": @(self.page_num.integerValue+1),
      @"page_size": @50
      };

    CA_H_WeakSelf(self);
    [self.dataTask cancel];
    
    if (!CA_H_MANAGER.getToken.length) {
        return;
    }
    
    self.dataTask =
    [CA_HNetManager postUrlStr:CA_H_Api_ListDirectoryFile
                    parameters:parameters
                      callBack:^(CA_HNetModel *netModel) {
                          CA_H_StrongSelf(self);
                          self.PostFinish = netModel;
                          
                      } progress:nil];
}

- (void)loadChooseData:(NSNumber *)model_id page_num:(NSNumber *)page_num {
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    [parameters setObject:@(50) forKey:@"page_size"];
    if (model_id) [parameters setObject:model_id forKey:@"model_id"];
    [parameters setObject:page_num?:@(1) forKey:@"page_num"];
    
    CA_H_WeakSelf(self);
    [CA_HNetManager postUrlStr:CA_H_Api_ListRootDirectory
                    parameters:parameters
                      callBack:^(CA_HNetModel *netModel) {
                          CA_H_StrongSelf(self);
                          self.ChooseFinish = netModel;
                          
                      } progress:nil];
}


#pragma mark --- LifeCircle

- (void)dealloc {
    [_dataTask cancel];
    _dataTask = nil;
}

#pragma mark --- Custom

- (void)setPostFinish:(CA_HNetModel *)netModel {
    if (netModel.type == CA_H_NetTypeSuccess) {
        if (netModel.errcode.integerValue == 0) {
            if ([netModel.data isKindOfClass:[NSDictionary class]]) {
                [self setValuesForKeysWithDictionary:netModel.data];
                
                if (self.finishRequestBlock) {
                    self.finishRequestBlock(YES, (self.page_count.integerValue<=self.page_num.integerValue));
                }
                return;
            }
        }
    }
    if (self.finishRequestBlock) {
        self.finishRequestBlock(NO, YES);
    }
    if (netModel.error.code != -999) {
        [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
    }
}

- (void)setChooseFinish:(CA_HNetModel *)netModel {
    if (netModel.type == CA_H_NetTypeSuccess) {
        if (netModel.errcode.integerValue == 0) {
            if ([netModel.data isKindOfClass:[NSDictionary class]]) {
                [self setValuesForKeysWithDictionary:netModel.data];
                if (self.finishRequestBlock) {
                    self.finishRequestBlock(YES, (self.page_count.integerValue<=self.page_num.integerValue));
                }
                return;
            }
        }
    }
    if (self.finishRequestBlock) {
        self.finishRequestBlock(NO, YES);
    }
    if (netModel.error.code != -999) {
        [CA_HProgressHUD showHudStr:netModel.errmsg?:@"系统错误!"];
    }
}

#pragma mark --- Delegate

@end
