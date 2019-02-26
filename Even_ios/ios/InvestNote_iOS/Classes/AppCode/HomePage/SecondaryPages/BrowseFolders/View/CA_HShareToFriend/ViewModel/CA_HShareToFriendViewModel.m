//
//  CA_HShareToFriendViewModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/2/11.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HShareToFriendViewModel.h"

#import "CA_HFileIconManager.h"
#import "CA_HProgressView.h"

@interface CA_HShareToFriendViewModel ()

@property (nonatomic, strong) CA_HProgressView *progressHud;
@property (nonatomic, strong) UILabel *shareLabel;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *showButton;

@end

@implementation CA_HShareToFriendViewModel

#pragma mark --- Action

#pragma mark --- Lazy

- (void)setProgress:(double)progress {
    _progress = progress;
    
    if (progress == 2) {
        self.progressHud.progress = 1;
        self.progressHud.hidden = YES;
        self.shareLabel.hidden = YES;
        self.showButton.hidden = NO;
        self.shareButton.enabled = YES;
    } else {
        CA_H_DISPATCH_MAIN_THREAD(^{
            self.progressHud.progress = progress;
        });
    }
}

- (CA_HProgressView *)progressHud {
    if (!_progressHud) {
        CA_HProgressView * progressView = [CA_HProgressView new];
        
//        progressView.progressColor = CA_H_TINTCOLOR;
//        progressView.progressRemainingColor = CA_H_TINTCOLOR;
//        progressView.lineColor = CA_H_BACKCOLOR;
        
        _progressHud = progressView;
    }
    return _progressHud;
}

- (UIView *(^)(id, SEL))shareViewBlock {
    if (!_shareViewBlock) {
        CA_H_WeakSelf(self);
        _shareViewBlock = ^UIView *(id target, SEL action) {
            CA_H_StrongSelf(self);
            return [self shareView:target action:action];
        };
    }
    return _shareViewBlock;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        UIButton *button = [UIButton new];
        button.tag = 101;
        button.titleLabel.font = CA_H_FONT_PFSC_Regular(16);
        [button setTitleColor:CA_H_9GRAYCOLOR forState:UIControlStateDisabled];
        [button setTitleColor:CA_H_TINTCOLOR forState:UIControlStateNormal];
        button.enabled = NO;
        [button setTitle:CA_H_LAN(@"发送给朋友") forState:UIControlStateNormal];
        _shareButton = button;
    }
    return _shareButton;
}

- (UILabel *)shareLabel {
    if (!_shareLabel) {
        UILabel *label = [UILabel new];
        label.font = CA_H_FONT_PFSC_Regular(14);
        label.textColor = CA_H_9GRAYCOLOR;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 1;
        label.text = CA_H_LAN(@"文件下载完毕后即可发送给朋友");
        _shareLabel = label;
    }
    return _shareLabel;
}

- (UIButton *)showButton {
    if (!_showButton) {
        UIButton *button = [UIButton new];
        button.userInteractionEnabled = NO;
        [button setImage:[UIImage imageNamed:@"icons_choose3"] forState:UIControlStateNormal];
        button.titleLabel.font = CA_H_FONT_PFSC_Regular(16);
        [button setTitleColor:CA_H_TINTCOLOR forState:UIControlStateNormal];
        [button setTitle:CA_H_LAN(@" 下载成功！") forState:UIControlStateNormal];
        [button sizeToFit];
        button.hidden = YES;
        
        _showButton = button;
    }
    return _showButton;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (UIView *)shareView:(id)target action:(SEL)action {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    
    [self button:view target:target action:action];
    [self file:view];
    
    [view addSubview:self.showButton];
    self.showButton.sd_layout
    .centerXEqualToView(view)
    .topSpaceToView(view, 113*CA_H_RATIO_WIDTH)
    .heightIs(24*CA_H_RATIO_WIDTH)
    .widthIs(160*CA_H_RATIO_WIDTH);
    
    [view addSubview:self.progressHud];
    self.progressHud.sd_layout
    .heightIs(4*CA_H_RATIO_WIDTH)
    .leftSpaceToView(view, 20*CA_H_RATIO_WIDTH)
    .rightSpaceToView(view, 20*CA_H_RATIO_WIDTH)
    .topSpaceToView(view, 104*CA_H_RATIO_WIDTH);
    
    [view addSubview:self.shareLabel];
    self.shareLabel.sd_layout
    .heightIs(20*CA_H_RATIO_WIDTH)
    .leftSpaceToView(view, 20*CA_H_RATIO_WIDTH)
    .rightSpaceToView(view, 20*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.progressHud, 15*CA_H_RATIO_WIDTH);
    
    return view;
}

// file
- (void)file:(UIView *)view {
    UIView *fileView = [UIView new];
    
    UIImageView *imageView = [UIImageView new];
    if (self.model.file_icon.length) {
        [imageView setImageWithURL:[NSURL URLWithString:self.model.file_icon] placeholder:[UIImage imageNamed:@"icons_file_？"]];
    } else {
        imageView.image = [CA_HFileIconManager iconWithFileName:self.model.file_name];
    }
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.textColor = CA_H_4BLACKCOLOR;
    nameLabel.font = CA_H_FONT_PFSC_Regular(16);
    nameLabel.numberOfLines = 1;
    nameLabel.text = self.model.file_name;
    
    UILabel *sizeLabel = [UILabel new];
    sizeLabel.textColor = CA_H_9GRAYCOLOR;
    sizeLabel.font = CA_H_FONT_PFSC_Regular(16);
    sizeLabel.numberOfLines = 1;
    
    double size = self.model.file_size.doubleValue;
    
    NSString * fileSize;
    if (size < 1024) {
        fileSize = [NSString stringWithFormat:@"(%.2fK)", size];
    }else if (size < 1024*1024) {
        fileSize = [NSString stringWithFormat:@"(%.2fM)", size/1024.0];
    }
    sizeLabel.text = fileSize;
    
    [fileView addSubview:imageView];
    [fileView addSubview:nameLabel];
    [fileView addSubview:sizeLabel];
    
    imageView.sd_layout
    .widthIs(50*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .leftEqualToView(fileView)
    .centerYEqualToView(fileView);
    
    nameLabel.sd_layout
    .leftSpaceToView(imageView, 2*CA_H_RATIO_WIDTH)
    .topSpaceToView(fileView, 14*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    
    sizeLabel.sd_layout
    .leftSpaceToView(nameLabel, 0)
    .topSpaceToView(fileView, 14*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    
    [sizeLabel setMaxNumberOfLinesToShow:1];
    [sizeLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    CGFloat width = [fileSize widthForFont:sizeLabel.font];
    
    [nameLabel setMaxNumberOfLinesToShow:1];
    [nameLabel setSingleLineAutoResizeWithMaxWidth:243*CA_H_RATIO_WIDTH-width];
    
    [nameLabel sizeToFit];
    [sizeLabel sizeToFit];
    
    [view addSubview:fileView];
    
    fileView.sd_layout
    .heightIs(50*CA_H_RATIO_WIDTH)
    .topSpaceToView(view, 27*CA_H_RATIO_WIDTH)
    .centerXEqualToView(view);
    [fileView setupAutoWidthWithRightView:sizeLabel rightMargin:0];
}

// button
- (void)button:(UIView *)view target:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton new];
    button.tag = 100;
    button.titleLabel.font = CA_H_FONT_PFSC_Regular(16);
    [button setTitleColor:CA_H_5BLACKCOLOR forState:UIControlStateNormal];
    [button setTitle:CA_H_LAN(@"取消") forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [self.shareButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineH = [UIView new];
    lineH.backgroundColor = CA_H_BACKCOLOR;
    UIView *lineV = [UIView new];
    lineV.backgroundColor = CA_H_BACKCOLOR;
    
    [view addSubview:lineH];
    [view addSubview:lineV];
    [view addSubview:button];
    [view addSubview:self.shareButton];
    
    lineH.sd_layout
    .heightIs(CA_H_LINE_Thickness)
    .leftEqualToView(view)
    .rightEqualToView(view)
    .bottomSpaceToView(view, 45.5*CA_H_RATIO_WIDTH);
    
    lineV.sd_layout
    .widthIs(CA_H_RATIO_WIDTH)
    .leftSpaceToView(view, 162*CA_H_RATIO_WIDTH)
    .topSpaceToView(lineH, 10*CA_H_RATIO_WIDTH)
    .bottomSpaceToView(view, 9.5*CA_H_RATIO_WIDTH);
    
    button.sd_layout
    .leftEqualToView(view)
    .rightSpaceToView(lineV, 0)
    .topSpaceToView(lineH, 0)
    .bottomEqualToView(view);
    
    self.shareButton.sd_layout
    .leftSpaceToView(lineV, 0)
    .rightEqualToView(view)
    .topSpaceToView(lineH, 0)
    .bottomEqualToView(view);
}

#pragma mark --- Delegate

@end
