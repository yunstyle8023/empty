//
//  CA_HFolderFileCellViewModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/1/10.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HFolderFileCellViewModel.h"

#import "CA_HBrowseFoldersModel.h"

#import "CA_HProgressView.h"

@interface CA_HFolderFileCellViewModel ()

@property (nonatomic, strong) UIView *tagView;
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UIImageView *cloudImageView;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) CA_HProgressView *progressHud;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *stopButton;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) CA_HBrowseFoldersModel *model;

@end

@implementation CA_HFolderFileCellViewModel


#pragma mark --- Action

- (void)onButton:(UIButton *)sender {
    if (sender.tag == 100) {
        if (sender.selected) {
            sender.selected = NO;
            _model.isDownLoad = 3;
            [_model.dataTask resume];
        } else {
            sender.selected = YES;
            _model.isDownLoad = 4;
            [_model.dataTask suspend];
        }
    } else {
        [_model.dataTask cancel];
        _model.progressBlock = nil;
        self.editButton.hidden = NO;
        self.buttonView.hidden = YES;
        self.progressHud.hidden = YES;
        self.cloudImageView.hidden = NO;
    }
}

#pragma mark --- Lazy

- (UIImageView *(^)(UIView *))cloudImageViewBlock {
    if (!_cloudImageViewBlock) {
        CA_H_WeakSelf(self);
        _cloudImageViewBlock = ^UIImageView *(UIView *leftView) {
            CA_H_StrongSelf(self);
            
            UIImageView * imageView = [UIImageView new];
            
            imageView.image = [UIImage imageNamed:@"cloud_icon"];
            
            [leftView.superview addSubview:imageView];
            
            imageView.sd_layout
            .widthIs(20*CA_H_RATIO_WIDTH)
            .heightEqualToWidth()
            .leftSpaceToView(leftView, 5*CA_H_RATIO_WIDTH)
            .centerYEqualToView(leftView);
            
            imageView.hidden = YES;
            
            self.cloudImageView = imageView;
            
            return imageView;
        };
    }
    return _cloudImageViewBlock;
}

- (void (^)(UITableViewCell *))resetViewBlock {
    if (!_resetViewBlock) {
        _resetViewBlock = ^(UITableViewCell *cell) {
            cell.imageView.sd_resetLayout
            .widthIs(50*CA_H_RATIO_WIDTH)
            .heightEqualToWidth()
            .leftSpaceToView(cell.imageView.superview, 17*CA_H_RATIO_WIDTH)
            .topSpaceToView(cell.imageView.superview, 7*CA_H_RATIO_WIDTH);
            
            cell.textLabel.textColor = CA_H_4BLACKCOLOR;
            cell.textLabel.font = CA_H_FONT_PFSC_Regular(16);
            
            cell.textLabel.sd_resetLayout
            .topSpaceToView(cell.textLabel.superview, 10*CA_H_RATIO_WIDTH)
            .leftSpaceToView(cell.textLabel.superview, 74*CA_H_RATIO_WIDTH)
            .widthIs(210*CA_H_RATIO_WIDTH)
            .autoHeightRatio(0);
            cell.textLabel.numberOfLines = 1;
            [cell.textLabel setMaxNumberOfLinesToShow:1];
            [cell.textLabel setSingleLineAutoResizeWithMaxWidth:210*CA_H_RATIO_WIDTH];
            
            cell.detailTextLabel.textColor = CA_H_9GRAYCOLOR;
            cell.detailTextLabel.font = CA_H_FONT_PFSC_Regular(14);
            
            cell.detailTextLabel.sd_resetLayout
            .topSpaceToView(cell.textLabel, 2*CA_H_RATIO_WIDTH)
            .leftSpaceToView(cell.detailTextLabel.superview, 74*CA_H_RATIO_WIDTH)
            .autoHeightRatio(0);
            cell.detailTextLabel.numberOfLines = 1;
            [cell.detailTextLabel setMaxNumberOfLinesToShow:1];
            [cell.detailTextLabel setSingleLineAutoResizeWithMaxWidth:250*CA_H_RATIO_WIDTH];
            
            UIView *line = [UIView new];
            line.backgroundColor = CA_H_BACKCOLOR;
            [cell addSubview:line];
            line.sd_layout
            .heightIs(CA_H_LINE_Thickness)
            .bottomEqualToView(cell)
            .rightEqualToView(cell)
            .leftSpaceToView(cell, 74*CA_H_RATIO_WIDTH);
        };
    }
    return _resetViewBlock;
}

- (void (^)(CA_HBrowseFoldersModel *, UIView *))downloadBlock {
    if (!_downloadBlock) {
        CA_H_WeakSelf(self);
        _downloadBlock = ^ (CA_HBrowseFoldersModel *model, UIView *contentView) {
            CA_H_StrongSelf(self);
            self.contentView = contentView;
            [self download:model];
        };
    }
    return _downloadBlock;
}

- (UIView *)tagView {
    if (!_tagView) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        _tagView = view;
    }
    return _tagView;
}
- (UIView *(^)(void))tagViewBlock {
    if (!_tagViewBlock) {
        CA_H_WeakSelf(self);
        _tagViewBlock = ^UIView *{
            CA_H_StrongSelf(self);
            return self.tagView;
        };
    }
    return _tagViewBlock;
}


- (void (^)(NSArray *))reloadTagsBlock {
    if (!_reloadTagsBlock) {
        CA_H_WeakSelf(self);
        _reloadTagsBlock = ^(NSArray *tags) {
            CA_H_StrongSelf(self);
            [self reloadTags:tags];
        };
    }
    return _reloadTagsBlock;
}

- (UIButton *(^)(id, SEL))editBlock {
    if (!_editBlock) {
        CA_H_WeakSelf(self);
        _editBlock = ^UIButton *(id target, SEL action) {
            CA_H_StrongSelf(self);
            UIButton *button = [UIButton new];
            [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:@"more_icon"] forState:UIControlStateNormal];
            self.editButton = button;
            return button;
        };
    }
    return _editBlock;
}


- (CA_HProgressView *)progressHud{
    if (!_progressHud) {
        CA_HProgressView *progressHud = [CA_HProgressView new];
        
//        progressHud.progressColor = CA_H_TINTCOLOR;
//        progressHud.progressRemainingColor = CA_H_TINTCOLOR;
//        progressHud.lineColor = CA_H_BACKCOLOR;
        
        [self.contentView addSubview:progressHud];
        
        progressHud.sd_layout
        .heightIs(4*CA_H_RATIO_WIDTH)
        .bottomEqualToView(self.contentView)
        .rightSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH)
        .leftSpaceToView(self.contentView, 74*CA_H_RATIO_WIDTH);
        
        _progressHud = progressHud;
    }
    return _progressHud;
}

- (UIView *)buttonView {
    if (!_buttonView) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:view];
        [self.contentView bringSubviewToFront:view];
        view.sd_layout
        .widthIs(70*CA_H_RATIO_WIDTH)
        .heightIs(24*CA_H_RATIO_WIDTH)
        .topSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH)
        .rightSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
        
        [view addSubview:self.stopButton];
        self.stopButton.sd_layout
        .widthIs(24*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .centerYEqualToView(view)
        .rightEqualToView(view);
        
        [view addSubview:self.playButton];
        
        self.playButton.sd_layout
        .widthIs(24*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .centerYEqualToView(view)
        .rightSpaceToView(self.stopButton, 10*CA_H_RATIO_WIDTH);
        
        view.hidden = YES;
        _buttonView = view;
    }
    return _buttonView;
}

- (UIButton *)playButton{
    if (!_playButton) {
        UIButton * button = [UIButton new];
        
        button.tag = 100;
        [button setBackgroundImage:[UIImage imageNamed:@"pause2_icon"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"play2_icon"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _playButton = button;
    }
    return _playButton;
}

- (UIButton *)stopButton{
    if (!_stopButton) {
        UIButton * button = [UIButton new];
        
        button.tag = 101;
        [button setBackgroundImage:[UIImage imageNamed:@"stop2_icon"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _stopButton = button;
    }
    return _stopButton;
}


#pragma mark --- LifeCircle

- (void)dealloc {
    
}

#pragma mark --- Custom

- (void)reloadTags:(NSArray *)tags {
    [self.tagView removeAllSubviews];
    
    CGFloat left = 0;
    CGFloat top = 0;
    for (CA_HFileTagModel *tag in tags) {
        
        UILabel *label = [self tagLabel];
        label.text = tag.tag_name;
        
        CGFloat width = [label.text widthForFont:label.font]+10*CA_H_RATIO_WIDTH;
        if (left>0
            &&
            left+width>281*CA_H_RATIO_WIDTH) {
            left = 0;
            top += 23*CA_H_RATIO_WIDTH;
        }
        label.frame = CGRectMake(left, top, width, 18*CA_H_RATIO_WIDTH);
        [self.tagView addSubview:label];
        
        left += (width+5*CA_H_RATIO_WIDTH);
    }
}

- (UILabel *)tagLabel {
    UILabel *label = [UILabel new];
    label.textColor = CA_H_TINTCOLOR;
    label.font = CA_H_FONT_PFSC_Regular(12);
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.backgroundColor = UIColorHex(0xEFF3FB).CGColor;
    label.layer.cornerRadius = 2*CA_H_RATIO_WIDTH;
    label.clipsToBounds = YES;
    return label;
}

- (void)showLabel {
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor whiteColor];
    label.font = CA_H_FONT_PFSC_Regular(14);
    label.textColor = CA_H_TINTCOLOR;
    label.textAlignment = NSTextAlignmentRight;
    label.text = CA_H_LAN(@"下载成功！");
    
    [self.buttonView addSubview:label];
    label.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    
    [self performSelector:@selector(hideLabel:) withObject:label afterDelay:1.5];
}

- (void)hideLabel:(UILabel *)label {
    self.progressHud.hidden = YES;
    self.buttonView.hidden = YES;
    self.editButton.hidden = NO;
    [label removeFromSuperviewAndClearAutoLayoutSettings];
}

- (void)download:(CA_HBrowseFoldersModel *)model {
    _model.progressBlock = nil;
    _model = model;
    
    if (model.isDownLoad<3) {
        model.progressBlock = nil;
        self.progressHud.hidden = YES;
        self.buttonView.hidden = YES;
        self.editButton.hidden = NO;
    }else {
        model.progressBlock = ^(double progress) {
            
            if (progress == 2) {
                self.model.progressBlock = nil;
                CA_H_DISPATCH_MAIN_THREAD(^{
                    self.progressHud.progress = 1;
                });
                if (self.model.isDownLoad == 1) {
                    [self showLabel];
                }
                return ;
            }
            CA_H_DISPATCH_MAIN_THREAD(^{
                self.progressHud.progress = progress;
            });
        };
        self.progressHud.progress = model.progress;
        self.progressHud.hidden = NO;
        self.buttonView.hidden = NO;
        self.editButton.hidden = YES;
        self.playButton.selected = (model.isDownLoad==4);
    }
    self.cloudImageView.hidden = (model.isDownLoad != 2);
    
}

#pragma mark --- Delegate



@end
