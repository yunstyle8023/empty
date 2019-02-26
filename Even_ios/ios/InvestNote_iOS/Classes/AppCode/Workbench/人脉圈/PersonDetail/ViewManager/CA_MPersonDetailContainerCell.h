//
//  CA_MPersonDetailContainerCell.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseTableCell.h"
#import "CA_MPersonDetailModel.h"
#import "CA_MPersonDetailLogVC.h"
#import "CA_MPersonDetailFileVC.h"

@protocol CA_MPersonDetailContainerCellDelegate <NSObject>
@optional
- (void)mmtdOptionalScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)mmtdOptionalScrollViewDidEndDecelerating:(UIScrollView *)scrollView;
@end

@interface CA_MPersonDetailContainerCell : CA_HBaseTableCell
@property (nonatomic,weak) id <CA_MPersonDetailContainerCellDelegate> delegate;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL objectCanScroll;
@property (nonatomic, assign) BOOL isSelectIndex;
@property (nonatomic,copy) void(^block)(CA_MPersonDetailModel* detailModel);

@property (nonatomic,strong) NSNumber *humanID;
//
@property (nonatomic,strong) NSNumber *fileID;
@property (nonatomic,strong) NSArray *filePath;

-(void)configChildVC;

@property (nonatomic, copy) CA_HBaseViewController *(^pushBlock)(NSString * classStr, NSDictionary * kvcDic);
@property (nonatomic, strong) CA_MPersonDetailLogVC *twoVC;
@property (nonatomic, strong) CA_MPersonDetailFileVC *threeVC;

@end
