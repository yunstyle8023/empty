//
//  CA_MPersonDetailFileVC.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MPersonDetailCommonVC.h"

#import "CA_HBrowseFoldersViewModel.h"
#import "CA_MPersonModel.h"

@interface CA_MPersonDetailFileVC : CA_MPersonDetailCommonVC

@property (nonatomic, copy) CA_HBaseViewController *(^pushBlock)(NSString * classStr, NSDictionary * kvcDic);
@property (nonatomic, strong) CA_HBrowseFoldersViewModel *viewModel;

//
@property (nonatomic,strong) NSNumber *fileID;
@property (nonatomic,strong) NSArray *filePath;

- (void)scroll:(UIScrollView *)scrollView;

@end
