//
//  CA_HDownloadReportCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/6/4.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HDownloadReportCell.h"

#import "CA_HDownloadCenterReportModel.h"

#import "CA_HProgressView.h"

@interface CA_HDownloadReportCell ()

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *typeLabel;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UIButton *downloadButton;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) CA_HProgressView *progressView;

@end

@implementation CA_HDownloadReportCell

#pragma mark --- Action

- (void)onButton:(UIButton *)sender {
    CA_HDownloadCenterReportModel *model = (id)self.model;
    switch (sender.tag) {
        case 100:
            [model download];
            self.type = model.status.integerValue;
            break;
        case 200:
            [model cancel];
            self.type = model.status.integerValue;
            break;
        case 201:
            sender.selected = !sender.selected;
            [model suspend:sender.selected];
            break;
        default:
            break;
    }
}

- (void)setModel:(CA_HDownloadCenterReportModel *)model {
    
    [(CA_HDownloadCenterReportModel *)self.model setProgressBlock:nil];
    [super setModel:model];
    
    CA_H_WeakSelf(self);
    model.progressBlock = ^(double progress) {
        CA_H_StrongSelf(self);
        self.progressView.progress = progress;
    };
    
    [self.iconImageView setImageWithURL:[NSURL URLWithString:model.file_icon] placeholder:[UIImage imageNamed:@"icons_file_？"]];
    self.nameLabel.text = model.report_name;
    
    self.type = model.status.integerValue;
}

- (void)setType:(NSInteger)type {
    _type = type;
    switch (type) {
        case 1:
            self.nameLabel.textColor = CA_H_4BLACKCOLOR;
            self.typeLabel.textColor = [UIColor colorWithHexString:@"#4CD964"];
            self.typeLabel.text = @"制作完成！";
            [self.nameLabel setSingleLineAutoResizeWithMaxWidth:247*CA_H_RATIO_WIDTH];
            _progressView.hidden = YES;
            _buttonView.hidden = YES;
            self.downloadButton.hidden = NO;
            break;
        case 2:
            self.progressView.progress = [(CA_HDownloadCenterReportModel *)self.model progress];
            self.nameLabel.textColor = CA_H_4BLACKCOLOR;
            self.typeLabel.textColor = CA_H_TINTCOLOR;
            self.typeLabel.text = @"下载中…";
            [self.nameLabel setSingleLineAutoResizeWithMaxWidth:213*CA_H_RATIO_WIDTH];
            _downloadButton.hidden = YES;
            self.buttonView.hidden = NO;
            self.progressView.hidden = NO;
            break;
        default:
            if ([(CA_HDownloadCenterReportModel *)self.model failure].integerValue == 0) {
                self.typeLabel.textColor = CA_H_TINTCOLOR;
                self.typeLabel.text = @"报告制作中…";
            } else {
                self.typeLabel.textColor = UIColorHex(0xDC5656);
                self.typeLabel.text = @"制作失败，24小时后删除";
            }
            self.nameLabel.textColor = CA_H_9GRAYCOLOR;
            [self.nameLabel setSingleLineAutoResizeWithMaxWidth:281*CA_H_RATIO_WIDTH];
            _progressView.hidden = YES;
            _buttonView.hidden = YES;
            _downloadButton.hidden = YES;
            break;
    }
}

#pragma mark --- Lazy

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        UIImageView *imageView = [UIImageView new];
        _iconImageView = imageView;
        
        [self.contentView addSubview:imageView];
    }
    return _iconImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(16) color:CA_H_9GRAYCOLOR];
        _nameLabel = label;
        
        [self.contentView addSubview:label];
    }
    return _nameLabel;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(14) color:CA_H_TINTCOLOR];
        _typeLabel = label;
        
        [self.contentView addSubview:label];
    }
    return _typeLabel;
}

- (UIButton *)downloadButton {
    if (!_downloadButton) {
        UIButton *button = [UIButton new];
        _downloadButton = button;
        
        button.tag = 100;
        button.backgroundColor = CA_H_TINTCOLOR;
        button.layer.cornerRadius = 2*CA_H_RATIO_WIDTH;
        button.layer.masksToBounds = YES;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"下载" forState:UIControlStateNormal];
        button.titleLabel.font = CA_H_FONT_PFSC_Regular(12);
        
        [button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:button];
        button.sd_layout
        .widthIs(40*CA_H_RATIO_WIDTH)
        .heightIs(25*CA_H_RATIO_WIDTH)
        .rightSpaceToView(self.contentView, 10*CA_H_RATIO_WIDTH)
        .topSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
    }
    return _downloadButton;
}

- (UIView *)buttonView {
    if (!_buttonView) {
        UIView *view = [UIView new];
        _buttonView = view;
        
        UIButton *rightButton = [UIButton new];
        rightButton.tag = 200;
        [rightButton setBackgroundImage:[UIImage imageNamed:@"stop2_icon"] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:rightButton];
        rightButton.sd_layout
        .widthIs(24*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .rightSpaceToView(view, 10*CA_H_RATIO_WIDTH)
        .bottomEqualToView(view);
        
        UIButton *leftButton = [UIButton new];
        leftButton.tag = 201;
        [leftButton setBackgroundImage:[UIImage imageNamed:@"pause2_icon"] forState:UIControlStateNormal];
        [leftButton setBackgroundImage:[UIImage imageNamed:@"play2_icon"] forState:UIControlStateSelected];
        [leftButton addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:leftButton];
        leftButton.sd_layout
        .widthIs(24*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .rightSpaceToView(rightButton, 10*CA_H_RATIO_WIDTH)
        .bottomEqualToView(view);
        
        [self.contentView addSubview:view];
        view.sd_layout
        .widthIs(78*CA_H_RATIO_WIDTH)
        .heightIs(30*CA_H_RATIO_WIDTH)
        .rightSpaceToView(self.contentView, 10*CA_H_RATIO_WIDTH)
        .topSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
    }
    return _buttonView;
}

- (CA_HProgressView *)progressView {
    if (!_progressView) {
        CA_HProgressView *progressView = [CA_HProgressView new];
        _progressView = progressView;
        
        [self.contentView addSubview:progressView];
        progressView.sd_layout
        .heightIs(4*CA_H_RATIO_WIDTH)
        .leftSpaceToView(self.contentView, 74*CA_H_RATIO_WIDTH)
        .rightSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH)
        .bottomEqualToView(self.contentView);
    }
    return _progressView;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)upView {
    [super upView];
    
    self.iconImageView.sd_layout
    .widthIs(44*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .topSpaceToView(self.contentView, 10*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
    
    self.nameLabel.sd_layout
    .topSpaceToView(self.contentView, 10*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 74*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.nameLabel setMaxNumberOfLinesToShow:1];
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:281*CA_H_RATIO_WIDTH];
    
    self.typeLabel.sd_layout
    .widthIs(200*CA_H_RATIO_WIDTH)
    .heightIs(20*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.nameLabel, 2*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 74*CA_H_RATIO_WIDTH);
    
    [CA_HFoundFactoryPattern lineWithView:self left:74*CA_H_RATIO_WIDTH right:0];
}

#pragma mark --- Delegate

@end
