//
//  CA_HMineInfoCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/29.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HMineInfoCell.h"

#import "CA_HMineModel.h"

@interface CA_HMineInfoCell ()

@property (nonatomic, strong) CALayer *textLayer;
@property (nonatomic, strong) CALayer *detailLayer;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *roleLabel;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImageView *requestImageView;

@end

@implementation CA_HMineInfoCell

#pragma mark --- Action

- (void)setModel:(CA_HMineUserInfoModel *)model {
    [super setModel:model];
    
    if (model) {
        NSString *urlStr = model.avatar;
        urlStr = ^{
            if ([urlStr hasPrefix:@"http://"]
                ||
                [urlStr hasPrefix:@"https://"]) {
                return urlStr;
            }
            return [NSString stringWithFormat:@"%@%@", CA_H_SERVER_API, urlStr];
        }();
        
        [self.requestImageView cancelCurrentImageRequest];
        CA_H_WeakSelf(self);
        [self.requestImageView setImageWithURL:[NSURL URLWithString:urlStr] placeholder:nil options:0 completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            CA_H_DISPATCH_MAIN_THREAD(^{
                CA_H_StrongSelf(self);
                self.avatarImageView.image = image?:[UIImage imageNamed:@"head65"];
                self.textLayer.hidden = YES;
                self.detailLayer.hidden = YES;
                self.nameLabel.text = model.chinese_name;
                self.roleLabel.text = model.role_name;
            })
        }];
        
//        CA_H_WeakSelf(self);
//        CA_H_DISPATCH_GLOBAL_QUEUE_DEFAULT(^{
//            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
//            CA_H_DISPATCH_MAIN_THREAD(^{
//                CA_H_StrongSelf(self);
//                self.avatarImageView.image = data?[UIImage imageWithData:data]:[UIImage imageNamed:@"head65"];
//                self.textLayer.hidden = YES;
//                self.detailLayer.hidden = YES;
//                self.nameLabel.text = model.chinese_name;
//                self.roleLabel.text = model.role_name;
//            })
//        });
        
    }
}

#pragma mark --- Lazy

- (CALayer *)textLayer {
    if (!_textLayer) {
        CALayer *layer = [CALayer layer];
        _textLayer = layer;
        
        layer.frame = CGRectMake(20*CA_H_RATIO_WIDTH, 35*CA_H_RATIO_WIDTH, 100*CA_H_RATIO_WIDTH, 24*CA_H_RATIO_WIDTH);
        layer.backgroundColor = CA_H_F4COLOR.CGColor;
        layer.masksToBounds = YES;
        layer.cornerRadius = 3*CA_H_RATIO_WIDTH;
    }
    return _textLayer;
}

- (CALayer *)detailLayer {
    if (!_detailLayer) {
        CALayer *layer = [CALayer layer];
        _detailLayer = layer;
        
        layer.frame = CGRectMake(20*CA_H_RATIO_WIDTH, 69*CA_H_RATIO_WIDTH, 160*CA_H_RATIO_WIDTH, 18*CA_H_RATIO_WIDTH);
        layer.backgroundColor = CA_H_F4COLOR.CGColor;
        layer.masksToBounds = YES;
        layer.cornerRadius = 3*CA_H_RATIO_WIDTH;
    }
    return _detailLayer;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        UILabel *label = [UILabel new];
        _nameLabel = label;
        
        label.numberOfLines = 1;
        label.font = CA_H_FONT_PFSC_Regular(24);
        label.textColor = CA_H_4BLACKCOLOR;
        
        [self.contentView addSubview:label];
    }
    return _nameLabel;
}

- (UILabel *)roleLabel {
    if (!_roleLabel) {
        UILabel *label = [UILabel new];
        _roleLabel = label;
        
        label.numberOfLines = 1;
        label.font = CA_H_FONT_PFSC_Regular(14);
        label.textColor = CA_H_9GRAYCOLOR;
        
        [self.contentView addSubview:label];
    }
    return _roleLabel;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        UIImageView *imageView = [UIImageView new];
        _avatarImageView = imageView;
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        
        [self.contentView addSubview:imageView];
    }
    return _avatarImageView;
}
- (UIImageView *)requestImageView {
    if (!_requestImageView) {
        _requestImageView = [UIImageView new];
    }
    return _requestImageView;
}

#pragma mark --- LifeCircle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        [self upView];
    }
    return self;
}

#pragma mark --- Custom

- (void)upView {
    [super upView];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.nameLabel.frame = CGRectMake(20*CA_H_RATIO_WIDTH, 30*CA_H_RATIO_WIDTH, 240*CA_H_RATIO_WIDTH, 33*CA_H_RATIO_WIDTH);
    
    self.roleLabel.frame = CGRectMake(20*CA_H_RATIO_WIDTH, 68*CA_H_RATIO_WIDTH, 240*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH);
    
    
    self.avatarImageView.frame = CGRectMake(266*CA_H_RATIO_WIDTH, 27*CA_H_RATIO_WIDTH, 65*CA_H_RATIO_WIDTH, 65*CA_H_RATIO_WIDTH);
    self.avatarImageView.layer.cornerRadius = 65*CA_H_RATIO_WIDTH/2.0;
    
    UIView *line = [UIView new];
    line.backgroundColor = CA_H_BACKCOLOR;
    [self addSubview:line];
    line.sd_layout
    .heightIs(CA_H_LINE_Thickness)
    .bottomEqualToView(self)
    .rightEqualToView(self)
    .leftSpaceToView(self, 20*CA_H_RATIO_WIDTH);
    
    
    [self.contentView.layer addSublayer:self.textLayer];
    [self.contentView.layer addSublayer:self.detailLayer];
    self.avatarImageView.image = [UIImage imageWithColor:CA_H_F4COLOR];
}


#pragma mark --- Delegate

@end
