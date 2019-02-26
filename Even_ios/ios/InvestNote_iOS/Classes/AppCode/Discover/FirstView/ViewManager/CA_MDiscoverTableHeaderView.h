//
//  CA_MDiscoverTableHeaderView.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/23.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CA_MModuleModel;

@interface CA_MDiscoverTableHeaderView : UIView
@property (nonatomic,strong) NSArray<CA_MModuleModel *> *dataList;
@property (nonatomic,copy) void(^pushBlock)(NSIndexPath *indexPath,CA_MModuleModel *model);
@end
