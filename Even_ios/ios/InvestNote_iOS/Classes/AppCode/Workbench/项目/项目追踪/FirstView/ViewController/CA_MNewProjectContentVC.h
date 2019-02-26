//
//  CA_MNewProjectContentVC.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/3.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseViewController.h"

typedef enum : NSUInteger {
    CA_MProject_Trace,//追踪
    CA_MProject_Todo,//待办
    CA_MProject_Note,//笔记
    CA_MProject_File,//文件
    CA_MProject_Progress//进展
} ProjectLocation;

@interface CA_MNewProjectContentVC : CA_HBaseViewController
@property (nonatomic,strong) NSNumber *pId;
@property (nonatomic,strong) void(^refreshBlock)(NSNumber *ids);
@property (nonatomic,assign) ProjectLocation location;
@end
