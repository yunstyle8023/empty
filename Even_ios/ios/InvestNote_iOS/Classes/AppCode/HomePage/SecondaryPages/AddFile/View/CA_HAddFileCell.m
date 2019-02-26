//
//  CA_HAddFileCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/22.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HAddFileCell.h"

#import "CA_HBrowseFoldersModel.h"

#import "CA_HAddFileModel.h"

#import "CA_HFileIconManager.h"

#import "CA_HProgressView.h"

@interface CA_HAddFileCell ()

@property (nonatomic, strong) UIButton * deleteButton;
@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) UIView * imageBackView;

@property (nonatomic, strong) UILabel * tagLabel;

@property (nonatomic, strong) UIView * progressView;
@property (nonatomic, strong) CA_HProgressView * progressHud;
@property (nonatomic, strong) UILabel * progressTitle;
@property (nonatomic, strong) UILabel * progressLabel;

@end

@implementation CA_HAddFileCell

#pragma mark --- Action

- (void)onDeleteButton:(UIButton *)sender{
    if (_deleteBlock) {
        [[(CA_HAddFileModel *)self.model dataTask] cancel];
        _deleteBlock(self, YES);
    }
}

#pragma mark --- Lazy

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        UILabel * label = [UILabel new];
        
        label.textAlignment = NSTextAlignmentRight;
        label.font = CA_H_FONT_PFSC_Regular(14);
        label.textColor = CA_H_9GRAYCOLOR;
        
        [self.contentView addSubview:label];
        label.sd_layout
        .centerYEqualToView(self.contentView)
        .rightEqualToView(self.contentView);
        label.sd_cornerRadius = @(3*CA_H_RATIO_WIDTH);
        [label setSingleLineAutoResizeWithMaxWidth:78*CA_H_RATIO_WIDTH];
        [label setMaxNumberOfLinesToShow:1];
        
        
        _tagLabel = label;
    }
    return _tagLabel;
}

- (UIView *)imageBackView {
    if (!_imageBackView) {
        UIView * view = [UIView new];
        
        view.frame = CGRectMake(-38*CA_H_RATIO_WIDTH, 0, 105*CA_H_RATIO_WIDTH, 65*CA_H_RATIO_WIDTH);
        
        _iconImageView = [UIImageView new];
        [view addSubview:_iconImageView];
        _iconImageView.sd_layout
        .widthIs(50*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .centerYEqualToView(view)
        .rightEqualToView(view);
        
        _deleteButton = [UIButton new];
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"delete_icon 2"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(onDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:_deleteButton];
        _deleteButton.sd_layout
        .widthIs(28*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .centerYEqualToView(view)
        .leftSpaceToView(view, 20*CA_H_RATIO_WIDTH);
        
        _deleteButton.hidden = YES;
        
        _imageBackView = view;
    }
    return _imageBackView;
}

- (UIView *)progressView {
    if (!_progressView) {
        _progressView = [UIView new];
        
        CA_HProgressView * progressView = [CA_HProgressView new];
        
//        progressView.progressColor = CA_H_TINTCOLOR;
//        progressView.progressRemainingColor = CA_H_TINTCOLOR;
//        progressView.lineColor = CA_H_BACKCOLOR;
        
        _progressHud = progressView;
        
        [_progressView addSubview:progressView];
        progressView.sd_layout
        .widthIs(248*CA_H_RATIO_WIDTH)
        .heightIs(3*CA_H_RATIO_WIDTH)
        .topSpaceToView(_progressView, 40*CA_H_RATIO_WIDTH)
        .leftEqualToView(_progressView);
        
        UIButton * cencel = [UIButton new];
        [cencel setBackgroundImage:[UIImage imageNamed:@"x "] forState:UIControlStateNormal];
        [cencel addTarget:self action:@selector(onDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        [_progressView addSubview:cencel];
        cencel.sd_layout
        .widthIs(18*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .centerYEqualToView(progressView)
        .rightSpaceToView(_progressView, 20*CA_H_RATIO_WIDTH);
        
        
        _progressTitle = [UILabel new];
        _progressTitle.font = CA_H_FONT_PFSC_Regular(16);
        _progressTitle.textColor = CA_H_4BLACKCOLOR;
        [_progressView addSubview:_progressTitle];
        _progressTitle.sd_layout
        .topSpaceToView(_progressView, 10*CA_H_RATIO_WIDTH)
        .leftEqualToView(_progressView)
        .autoHeightRatio(0);
        [_progressTitle setMaxNumberOfLinesToShow:1];
        [_progressTitle setSingleLineAutoResizeWithMaxWidth:197*CA_H_RATIO_WIDTH];
        
        _progressLabel = [UILabel new];
        _progressLabel.font = CA_H_FONT_PFSC_Regular(14);
        _progressLabel.textColor = CA_H_TINTCOLOR;
        _progressLabel.textAlignment = NSTextAlignmentRight;
        [_progressView addSubview:_progressLabel];
        _progressLabel.sd_layout
        .rightSpaceToView(_progressView, 53*CA_H_RATIO_WIDTH)
        .centerYEqualToView(_progressTitle)
        .autoHeightRatio(0);
        [_progressLabel setMaxNumberOfLinesToShow:1];
        [_progressLabel setSingleLineAutoResizeWithMaxWidth:50*CA_H_RATIO_WIDTH];
    }
    return _progressView;
}

#pragma mark --- LifeCircle

- (void)dealloc {
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self upView];
    }
    return self;
}

#pragma mark --- Custom

- (void)upView{
    [super upView];
    
    _canTag = NO;
    
    self.textLabel.font = CA_H_FONT_PFSC_Regular(16);
    self.textLabel.textColor = CA_H_4BLACKCOLOR;
    self.textLabel.sd_resetLayout
    .topSpaceToView(self.textLabel.superview, 10*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.textLabel.superview, 112*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.textLabel setMaxNumberOfLinesToShow:1];
    [self.textLabel setSingleLineAutoResizeWithMaxWidth:150*CA_H_RATIO_WIDTH];
    
    self.detailTextLabel.textColor = CA_H_9GRAYCOLOR;
    self.detailTextLabel.font = CA_H_FONT_PFSC_Regular(14);
    self.detailTextLabel.sd_resetLayout
    .topSpaceToView(self.textLabel, 2*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.detailTextLabel.superview, 112*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.detailTextLabel setMaxNumberOfLinesToShow:1];
    [self.detailTextLabel setSingleLineAutoResizeWithMaxWidth:150*CA_H_RATIO_WIDTH];
    
    
    [self.contentView addSubview:self.imageBackView];
    [self.contentView addSubview:self.progressView];
    self.progressView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 74*CA_H_RATIO_WIDTH, 0, 0));
    
    UIView *line = [UIView new];
    line.backgroundColor = CA_H_BACKCOLOR;
    [self addSubview:line];
    line.sd_layout
    .heightIs(CA_H_LINE_Thickness)
    .leftSpaceToView(self, 20*CA_H_RATIO_WIDTH)
    .rightEqualToView(self)
    .bottomEqualToView(self);
}

- (void)setTags:(NSArray *)tags {
    _tags = tags;
    if (tags.count) {
        [(CA_HAddFileModel *)self.model setTags:tags];
        NSString *tagStr = @"";
        for (CA_HFileTagModel *model in tags) {
            if (tagStr.length > 0) {
                tagStr = [tagStr stringByAppendingString:@","];
            }
            tagStr = [tagStr stringByAppendingString:model.tag_name?:@""];
        }
        self.tagLabel.textColor = CA_H_TINTCOLOR;
        self.tagLabel.backgroundColor = UIColorHex(0xEFF3FB);
        self.tagLabel.text = tagStr;
    } else {
        self.tagLabel.text = CA_H_LAN(@"添加标签");
        self.tagLabel.backgroundColor = [UIColor clearColor];
    }
}

- (void)setModel:(CA_HAddFileModel *)model {
    [(CA_HAddFileModel *)self.model setProgressBlock:nil];
    [super setModel:model];
    
    BOOL set = model.isFinish&&!_noChange;
    
    _canTag = set;
    self.progressView.hidden = set;
    self.deleteButton.hidden = !set;

    _iconImageView.image = [CA_HFileIconManager iconWithFileName:model.fileName];
    
    if (set) {
        self.imageBackView.mj_x = 0;
        self.textLabel.text = [(CA_HAddFileModel *)self.model fileName];
        [self.textLabel sizeToFit];
        
        self.detailTextLabel.text = model.fileSize;
        [self.detailTextLabel sizeToFit];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.tags = model.tags;
        
    } else {
        self.imageBackView.mj_x = -38*CA_H_RATIO_WIDTH;
        self.detailTextLabel.text = nil;
        self.textLabel.text = nil;
        self.tagLabel.text = nil;
        
        self.accessoryType = UITableViewCellAccessoryNone;
        
        _progressHud.progress = model.progress;
        _progressLabel.text = [NSString stringWithFormat:@"%ld%%", (long)(_progressHud.progress*100)];
        _progressTitle.text = model.fileName;
        CA_H_WeakSelf(self);
        model.progressBlock = ^(double progress) {
            CA_H_StrongSelf(self);
            CA_H_WeakSelf(self);
            if (progress > 1) {
                if ([(CA_HAddFileModel *)self.model isFinish]) {
                    if (self.noChange) {
                        if (self.deleteBlock) {
                            self.deleteBlock(self, NO);
                        }
                    }else {
                        [UIView animateWithDuration:0.25 animations:^{
                            CA_H_StrongSelf(self);
                            self.imageBackView.mj_x = 0;
                        } completion:^(BOOL finished) {
                            CA_H_StrongSelf(self);
                            if (self.deleteBlock) {
                                self.deleteBlock(self, NO);
                            }
                            [self setModel:self.model];
                        }];
                    }
                }
            } else {
                CA_H_DISPATCH_MAIN_THREAD((^{
                    CA_H_StrongSelf(self);
                    self.progressHud.progress = progress;
                    self.progressLabel.text = [NSString stringWithFormat:@"%ld%%", (long)(self.progressHud.progress*100)];
                }));
            }
        };
    }
}





@end
