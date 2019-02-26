//
//  CA_HCurrentSearchViewModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/24.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HCurrentSearchViewModel.h"

#import "CA_HDownloadCenterViewModel.h" // 下载中心

@interface CA_HCurrentSearchViewModel ()



@end

@implementation CA_HCurrentSearchViewModel

#pragma mark --- Action

#pragma mark --- Lazy

- (void)setSearchText:(NSString *)searchText {
    if (searchText.length) {
        if (![searchText isEqualToString:_searchText]) {
            _searchText = searchText;
            switch (_type) {
                case CA_H_SearchTypeDownload:
                    [self reloadDataTypeDownload];
                    break;
                case CA_H_SearchTypeFile:
                    self.fileModel.loadDataBlock(self.parentPath, searchText);
                    break;
                case CA_H_SearchTypeProject:
                    self.projectModel.page_num = @(0);
                    self.projectModel.loadMoreBlock(searchText, YES);
                    break;
                default:
                    break;
            }
        }
    } else {
        switch (_type) {
            case CA_H_SearchTypeFile:
                [self.fileModel.dataTask cancel];
                break;
            case CA_H_SearchTypeProject:
                [self.projectModel.dataTask cancel];
                break;
            default:
                break;
        }
        _searchText = nil;
        self.data = nil;
        if (self.reloadBlock) {
            self.reloadBlock(0);
        }
    }
}

- (CA_HListFileModel *)fileModel {
    if (!_fileModel) {
        CA_HListFileModel *model = [CA_HListFileModel new];
        _fileModel = model;
        
        CA_H_WeakSelf(self);
        model.finishRequestBlock = ^(BOOL success, BOOL noMore) {
            if (!success) return;
            CA_H_StrongSelf(self);
            
            NSMutableArray *mut = [NSMutableArray new];
            if (self.fileModel.page_num.integerValue != 1) {
                [mut addObjectsFromArray:self.data];
            }
            [mut addObjectsFromArray:self.fileModel.data_list];
            self.data = mut;
            
            if (self.reloadBlock) {
                if (success) {
                    if (noMore) {
                        self.reloadBlock(CA_H_RefreshTypeNomore);
                    } else {
                        self.reloadBlock(CA_H_RefreshTypeDefine);
                    }
                } else {
                    self.reloadBlock(CA_H_RefreshTypeFail);
                }
            }
        };
    }
    return _fileModel;
}

- (CA_HMoveListModel *)projectModel {
    if (!_projectModel) {
        CA_HMoveListModel *model = [CA_HMoveListModel new];
        _projectModel = model;
        
        CA_H_WeakSelf(self);
        model.finishRequestBlock = ^(CA_H_RefreshType type) {
            if (type == CA_H_RefreshTypeFail) return;
            CA_H_StrongSelf(self);
            self.data = self.projectModel.data;
            if (self.reloadBlock) {
                self.reloadBlock(type);
            }
        };
    }
    return _projectModel;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)reloadDataTypeDownload {
    NSArray *data = [CA_HDownloadCenterViewModel deleteItem:-1];
    
    NSMutableArray *mut = [NSMutableArray new];
    for (NSDictionary *dic in data) {
        NSString *text1 = dic[@"fileName"];
        NSString *text2 = dic[@"showDetail"];
        if ([text1 containsString:self.searchText]
            ||
            [text2 containsString:self.searchText]) {
            [mut addObject:dic];
        }
    }
    
    self.data = mut;
    if (self.reloadBlock) {
        self.reloadBlock(0);
    }
}

#pragma mark --- Delegate

@end
