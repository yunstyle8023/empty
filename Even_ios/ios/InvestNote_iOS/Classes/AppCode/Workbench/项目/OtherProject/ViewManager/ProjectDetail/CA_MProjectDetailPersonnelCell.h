//
//  CA_MProjectDetailPersonnelCell.h
//  InvestNote_iOS
//
//  Created by yezhuge on 2017/12/22.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CA_MProject_person;

@protocol CA_MProjectDetailPersonnelCellDelegate <NSObject>
@optional
- (void)didSelect:(BOOL)isAdd person:(CA_MProject_person*)model;
@end

@interface CA_MProjectDetailPersonnelCell : UITableViewCell
@property(nonatomic,weak)id<CA_MProjectDetailPersonnelCellDelegate> delegate;
@property(nonatomic,strong)NSArray* persons;
@end

