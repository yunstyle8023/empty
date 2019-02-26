//
//  CA_HCurrentSearchViewModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/24.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HBrowseFoldersModel.h" //文件模型
#import "CA_HMoveListModel.h" //项目模型

typedef enum : NSUInteger {
    CA_H_SearchTypeDownload = 0,
    CA_H_SearchTypeFile,
    CA_H_SearchTypeProject,
} CA_H_SearchType;

@interface CA_HCurrentSearchViewModel : NSObject

@property (nonatomic, strong) NSArray *parentPath;
@property (nonatomic, assign) CA_H_SearchType type;

@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, strong) NSArray *data;

@property (nonatomic, copy) void (^didSelectRowBlock)(NSIndexPath *indexPath);

// Download这两个方法必须实现
@property (nonatomic, copy) CGFloat (^heightForRowBlock)(UITableView *tableView, NSIndexPath *indexPath);
@property (nonatomic, copy) UITableViewCell * (^cellForRowBlock)(UITableView *tableView, NSIndexPath *indexPath);


@property (nonatomic, copy) void (^reloadBlock)(CA_H_RefreshType type);

@property (nonatomic, strong) CA_HListFileModel *fileModel;
@property (nonatomic, strong) CA_HMoveListModel *projectModel;

@end
