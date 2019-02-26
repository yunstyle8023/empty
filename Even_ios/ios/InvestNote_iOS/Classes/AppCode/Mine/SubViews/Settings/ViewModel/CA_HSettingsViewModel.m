//
//  CA_HSettingsViewModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/29.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HSettingsViewModel.h"

@interface CA_HSettingsViewModel ()

@end

@implementation CA_HSettingsViewModel

//清除缓存
+ (void)clearCache {
    NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:CA_H_FileCachesDirectory];
    [[NSFileManager defaultManager] removeItemAtPath:cacheFilePath error:nil];
    NSString *cacheRecordPath = [NSHomeDirectory() stringByAppendingPathComponent:CA_H_RecordCachesDirectory];
    [[NSFileManager defaultManager] removeItemAtPath:cacheRecordPath error:nil];
    [[YYImageCache sharedCache].diskCache removeAllObjects];
}

//获取文件夹下所有文件的大小
+ (long long)folderSizeAtPath:(NSString *)folderPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *filesEnumerator = [[fileManager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName;
    long long folerSize = 0;
    while ((fileName = [filesEnumerator nextObject]) != nil) {
        NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
        
        BOOL isDir;
        if ( !([fileManager fileExistsAtPath:filePath isDirectory:&isDir] && isDir) ) {
            folerSize += [self fileSizeAtPath:filePath];//见方法3
        } else {
            folerSize += [self folderSizeAtPath:filePath];
        }
    }
    return folerSize;
}

//获取文件大小
+ (long long)fileSizeAtPath:(NSString *)filePath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:filePath]) {
        return 0;
    } else {
        return [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
}

#pragma mark --- Action

#pragma mark --- Lazy

- (NSString *)title {
    return CA_H_LAN(@"设置");
}

- (NSArray *)data {
    return @[CA_H_LAN(@"修改密码"),
//             CA_H_LAN(@"绑定微信"),
             CA_H_LAN(@"绑定手机"),
             CA_H_LAN(@"关于我们"),
             CA_H_LAN(@"帮助与反馈"),
             CA_H_LAN(@"清除缓存"),
             CA_H_LAN(@"日历同步")];
}


#pragma mark --- LifeCircle

#pragma mark --- Custom

#pragma mark --- Delegate

@end
