//
//  CA_HMoveCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/27.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HMoveCell.h"
#import "CA_HMoveListModel.h"

@interface CA_HMoveCell ()

@property (nonatomic, strong) UIImageView * chooseIcon;
@property (nonatomic, strong) UILabel *label;

@end

@implementation CA_HMoveCell

- (UILabel *)label {
    if (!_label) {
        UILabel *label = [UILabel new];
        _label = label;
        
        label.textColor = [UIColor whiteColor];
        label.font = CA_H_FONT_PFSC_Regular(20);
        label.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:label];
        label.sd_layout
        .widthIs(45*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .centerYEqualToView(self.contentView)
        .leftSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
        label.sd_cornerRadius = @(4*CA_H_RATIO_WIDTH);
    }
    return _label;
}

- (void)upView{
    [super upView];
    
    _chooseIcon = [UIImageView new];
    _chooseIcon.image = [UIImage imageNamed:@"choose"];
    _chooseIcon.hidden = YES;
    [self.contentView addSubview:_chooseIcon];
    _chooseIcon.sd_layout
    .widthIs(20*CA_H_RATIO_WIDTH)
    .heightIs(15*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.contentView)
    .rightSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
    
    [self.textLabel setTextColor:CA_H_6GRAYCOLOR];
    [self.textLabel setFont:CA_H_FONT_PFSC_Regular(16)];
    
    self.textLabel.sd_resetLayout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 80*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.textLabel setMaxNumberOfLinesToShow:1];
    [self.textLabel setSingleLineAutoResizeWithMaxWidth:255*CA_H_RATIO_WIDTH];
    
    self.imageView.sd_resetLayout
    .widthIs(45*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
    self.imageView.sd_cornerRadius = @(4*CA_H_RATIO_WIDTH);
    
    
    UIView *line = [UIView new];
    line.backgroundColor = CA_H_BACKCOLOR;
    [self.contentView addSubview:line];
    line.sd_layout
    .heightIs(CA_H_LINE_Thickness)
    .bottomEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .leftEqualToView(self.contentView);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    _chooseIcon.hidden = !selected;
}

- (void)setModel:(CA_MProjectModel *)model{
    [super setModel:model];
    
    self.textLabel.text = model.project_name;//@"滴滴出行";
    
    if (model.project_logo.length) {
        _label.hidden = YES;
        
        NSString *urlStr = model.project_logo;
        urlStr = ^{
            if ([urlStr hasPrefix:@"http://"]
                ||
                [urlStr hasPrefix:@"https://"]) {
                return urlStr;
            }
            return [NSString stringWithFormat:@"%@%@", CA_H_SERVER_API, urlStr];
        }();
        [self.imageView setImageWithURL:[NSURL URLWithString:urlStr] placeholder:[UIImage imageNamed:@"loadfail_project50"]];
    } else {
        _label.hidden = NO;
        self.imageView.image = nil;
        if (model.project_name.length) {
            self.label.text = [model.project_name substringToIndex:1];
        } else {
            self.label.text = @"";
        }
        self.label.backgroundColor = [UIColor colorWithHexString:model.project_color];
    }
    
    
    //1、首先对image付值
//    self.imageView.image = [UIImage imageNamed:@"logo_34"];
    
//    //2、调整大小
//    CGSize itemSize = CGSizeMake(45*CA_H_RATIO_WIDTH, 45*CA_H_RATIO_WIDTH);
//    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
//    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//    
//    //2、设置裁剪区域
//    UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:imageRect];
//    [path addClip];
//    
//    //3、绘制图片
//    [self.imageView.image drawInRect:imageRect];
//    
//    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
}

@end
