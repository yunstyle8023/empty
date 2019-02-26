//
//  CA_MNewProjectSectionView.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/27.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CA_MNewProjectSplitPoolListModel;
@interface CA_MNewProjectSectionView : UICollectionReusableView
@property (nonatomic,strong) CA_MNewProjectSplitPoolListModel *model;
@property (nonatomic,copy) dispatch_block_t lookMoreBlock;
@end
