//
//  CA_MNewProjectNoTagCell.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CA_MProjectModel;
@interface CA_MNewProjectNoTagCell : UITableViewCell

@property (nonatomic,strong) UIImageView *sologImgView;

@property (nonatomic,strong) UILabel *titleLb;

@property (nonatomic,strong) UILabel *typeLb;

@property (nonatomic,strong) UILabel *detailLb;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) UILabel *iconLb;

@property (nonatomic,strong) CA_MProjectModel *model;

-(void)upView;

-(void)setConstraints;

@end
