//
//  CA_MDiscoverSponsorHeaderView.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/11.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CA_HNoteListTebleView;

@interface CA_MDiscoverSponsorHeaderView : UIView

@property (nonatomic,strong) CA_HNoteListTebleView *listTableView;

@property (nonatomic,strong) UIImageView *iconImgView;

@property (nonatomic,strong) UILabel *titleLb;

@property (nonatomic,strong) UIImageView *arrowImgView;

@property (nonatomic,strong) UIView *touchView;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,copy) dispatch_block_t jumpBlock;

@end
