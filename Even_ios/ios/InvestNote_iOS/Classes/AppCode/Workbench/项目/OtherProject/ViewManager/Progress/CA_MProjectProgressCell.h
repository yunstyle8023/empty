//
//  CA_MProjectProgressCell.h
//  InvestNote_iOS
//
//  Created by yezhuge on 2017/12/21.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CA_MProjectProgressModel.h"

@protocol CA_MProjectProgressCellDelegate <NSObject>

/**
 阶段撤回
 */
-(void)stageRecallBtnClick;

/**
 进入下个阶段
 */
-(void)nextStageBtnClick;

/**
 撤销审批
 */
-(void)revocationBtnClick;
@end

/**
 项目进展cell
 */
@interface CA_MProjectProgressCell : UITableViewCell
@property (nonatomic,strong) CA_MProjectProgressModel *model;
@property(nonatomic,weak)id<CA_MProjectProgressCellDelegate> delegate;
@property (nonatomic,strong) NSNumber *member_type_id;
@end
