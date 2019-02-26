//
//  CA_MProjectCell.h
//  InvestNote_iOS
//  Created by yezhuge on 2017/12/6.
//  God bless me without no bugs.
//

#import <UIKit/UIKit.h>
@class CA_MProjectTagView;
@class CA_MProjectModel;
@interface CA_MProjectCell : UITableViewCell
/// 头像
@property(nonatomic,strong)UIImageView* iconImgView;
@property(nonatomic,strong)UILabel* iconLb;
/// 名称
@property(nonatomic,strong)UILabel* titleLb;
/// 标签
@property(nonatomic,strong)CA_MProjectTagView* tagView;
/// 类型
@property(nonatomic,strong)UILabel* typeLb;
/// 介绍
@property(nonatomic,strong)UILabel* detailLb;
/// 小灰条
@property(nonatomic,strong)UIView* lineView;
@property(nonatomic,strong)CA_MProjectModel* model;
@end
