//
//  CA_MProjectPersonCell.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/1.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CA_MPersonModel.h"
#import "CA_MProjectModel.h"

@interface CA_MProjectPersonCell : UITableViewCell
@property (nonatomic,strong) CA_MPersonModel *model;
@property (nonatomic,strong) CA_MProjectModel *projectModel;
@property (nonatomic,copy) dispatch_block_t block;
@end
