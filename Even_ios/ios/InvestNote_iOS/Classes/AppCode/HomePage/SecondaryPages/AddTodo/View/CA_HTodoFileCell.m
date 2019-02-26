//
//  CA_HTodoFileCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/14.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HTodoFileCell.h"

#import "CA_HAddFileModel.h"

#import "CA_HFileIconManager.h"

#import "CA_HProgressView.h"

@interface CA_HTodoFileCell ()

@property (nonatomic, strong) UIButton * deleteButton;
@property (nonatomic, strong) UIView * progressView;
@property (nonatomic, strong) CA_HProgressView * progressHud;
@property (nonatomic, strong) UILabel * progressLabel;

@end

@implementation CA_HTodoFileCell

- (void)upView{
    [super upView];
    
    UIView *line = [UIView new];
    line.backgroundColor = CA_H_BACKCOLOR;
    [self addSubview:line];
    line.sd_layout
    .heightIs(CA_H_LINE_Thickness)
    .bottomEqualToView(self)
    .rightSpaceToView(self, 20*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self, 20*CA_H_RATIO_WIDTH);
    
    self.textLabel.font = CA_H_FONT_PFSC_Medium(16);
    self.textLabel.textColor = CA_H_4BLACKCOLOR;
    
    self.textLabel.sd_resetLayout
    .topSpaceToView(self.textLabel.superview, 20*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.textLabel.superview, 80*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.textLabel setMaxNumberOfLinesToShow:1];
    [self.textLabel setSingleLineAutoResizeWithMaxWidth:240*CA_H_RATIO_WIDTH];
    
    self.detailTextLabel.font = CA_H_FONT_PFSC_Regular(14);
    self.detailTextLabel.textColor = CA_H_9GRAYCOLOR;
    
    self.detailTextLabel.sd_resetLayout
    .topSpaceToView(self.textLabel, 2*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.detailTextLabel.superview, 80*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.detailTextLabel setMaxNumberOfLinesToShow:1];
    [self.detailTextLabel setSingleLineAutoResizeWithMaxWidth:240*CA_H_RATIO_WIDTH];
    
    self.imageView.image = [UIImage imageNamed:@"attachment_icon"];
    
    [self.imageView sd_clearAutoLayoutSettings];
    self.imageView.sd_resetLayout
    .widthIs(24*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .leftSpaceToView(self.imageView.superview, 20*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.imageView.superview).offset(-8*CA_H_RATIO_WIDTH);
    
    [self.contentView addSubview:self.progressView];
    self.progressView.sd_layout
    .heightIs(40*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 54*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.contentView)
    .rightEqualToView(self.contentView);
    
}


- (void)setModel:(CA_HAddFileModel *)model {
    [(CA_HAddFileModel *)self.model setProgressBlock:nil];
    [super setModel:model];
    
    BOOL set = model.isFinish;
    
    self.progressView.hidden = set;
    self.deleteButton.hidden = !set;
    
    
    if (set) {
        self.imageView.image = [CA_HFileIconManager iconWithFileName:model.fileName];
        self.imageView.sd_resetLayout
        .widthIs(50*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .leftSpaceToView(self.imageView.superview, 20*CA_H_RATIO_WIDTH)
        .centerYEqualToView(self.imageView.superview);
        
        self.textLabel.text = [(CA_HAddFileModel *)self.model fileName];
        [self.textLabel sizeToFit];
        
        self.detailTextLabel.text = [[model.createDate stringWithFormat:@"Y.M.d   "] stringByAppendingString:model.fileSize];
        [self.detailTextLabel sizeToFit];
        
    } else {
        self.imageView.image = [UIImage imageNamed:@"attachment_icon"];
        self.imageView.sd_resetLayout
        .widthIs(24*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .leftSpaceToView(self.imageView.superview, 20*CA_H_RATIO_WIDTH)
        .centerYEqualToView(self.imageView.superview).offset(-8*CA_H_RATIO_WIDTH);
        
        self.detailTextLabel.text = nil;
        self.textLabel.text = nil;
        
        
        _progressHud.progress = model.progress;
        _progressLabel.text = [NSString stringWithFormat:@"%@（%@） %2ld%%", model.fileName, model.fileSize, (long)(_progressHud.progress*100)];
        CA_H_WeakSelf(self);
        model.progressBlock = ^(double progress) {
            CA_H_StrongSelf(self);
            CA_HAddFileModel *mod = (CA_HAddFileModel *)self.model;
            if (progress > 1) {
                if ([mod isFinish]) {
                    [self setModel:mod];
                }
            } else {
                CA_H_DISPATCH_MAIN_THREAD((^{
                    self.progressHud.progress = progress;
                    self.progressLabel.text = [NSString stringWithFormat:@"%@（%@） %2ld%%", mod.fileName, mod.fileSize, (long)(self.progressHud.progress*100)];
                }));
            }
        };
    }
    
    
}

- (UIView *)progressView{
    if (!_progressView) {
        _progressView = [UIView new];
        
        CA_HProgressView * progressView = [CA_HProgressView new];
        
//        progressView.progressColor = CA_H_TINTCOLOR;
//        progressView.progressRemainingColor = CA_H_TINTCOLOR;
//        progressView.lineColor = CA_H_BACKCOLOR;
        
        _progressHud = progressView;
        
        [_progressView addSubview:progressView];
        progressView.sd_layout
        .widthIs(263*CA_H_RATIO_WIDTH)
        .heightIs(3*CA_H_RATIO_WIDTH)
        .centerYEqualToView(_progressView)
        .leftEqualToView(_progressView);
        
        UIButton * cencel = [UIButton new];
        [cencel setBackgroundImage:[UIImage imageNamed:@"x "] forState:UIControlStateNormal];
        [cencel addTarget:self action:@selector(onDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        [_progressView addSubview:cencel];
        cencel.sd_layout
        .widthIs(18*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .centerYEqualToView(_progressView)
        .rightSpaceToView(_progressView, 25*CA_H_RATIO_WIDTH);
        
        _progressLabel = [UILabel new];
        _progressLabel.font = CA_H_FONT_PFSC_Regular(12);
        _progressLabel.textColor = CA_H_9GRAYCOLOR;
        [_progressView addSubview:_progressLabel];
        _progressLabel.sd_layout
        .topEqualToView(_progressView)
        .leftEqualToView(_progressView)
        .autoHeightRatio(0);
        [_progressLabel setMaxNumberOfLinesToShow:1];
        [_progressLabel setSingleLineAutoResizeWithMaxWidth:263*CA_H_RATIO_WIDTH];
    }
    return _progressView;
}

- (UIButton *)deleteButton{
    if (!_deleteButton) {
        UIButton * deleteButton = [UIButton new];
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"delete_icon 2"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(onDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:deleteButton];
        
        deleteButton.sd_layout
        .widthIs(28*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .rightSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH)
        .bottomSpaceToView(self.contentView, 22.5*CA_H_RATIO_WIDTH);
        
        _deleteButton = deleteButton;
    }
    return _deleteButton;
}

- (void)onDeleteButton:(UIButton *)sender{
    if (_deleteBlock) {
        [[(CA_HAddFileModel *)self.model dataTask] cancel];
        _deleteBlock(self);
    }
}

@end
