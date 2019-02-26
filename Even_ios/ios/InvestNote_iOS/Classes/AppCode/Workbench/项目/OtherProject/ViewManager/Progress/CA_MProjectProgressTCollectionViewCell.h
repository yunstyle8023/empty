//
//  CA_MProjectProgressTCollectionViewCell.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/8.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CA_MProjectProgressModel.h"

@interface CA_MProjectProgressTCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) UIView *leftLine;
@property (nonatomic,strong) UIView *rightLine;
@property (nonatomic,strong) CA_Mprocedure_viewModel *model;
@property (nonatomic,strong) NSNumber *currentID;
@end
