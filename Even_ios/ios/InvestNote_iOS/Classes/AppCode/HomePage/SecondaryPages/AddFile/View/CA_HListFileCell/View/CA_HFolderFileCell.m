//
//  CA_HFolderFileCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/22.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HFolderFileCell.h"

#import "CA_HBrowseFoldersModel.h"
#import "CA_HFileIconManager.h"

@interface CA_HFolderFileCell ()

@property (nonatomic, strong) UIImageView *cloudImageView;
@property (nonatomic, strong) UIView *tagView;
@property (nonatomic, strong) UIButton * editButton;

@end

@implementation CA_HFolderFileCell

#pragma mark --- Action

- (void)onEdit:(UIButton *)sender{
    _editBlock(self);
}

#pragma mark --- Lazy

- (CA_HFolderFileCellViewModel *)viewModel {
    if (!_viewModel) {
        CA_HFolderFileCellViewModel *viewModel = [CA_HFolderFileCellViewModel new];
        
        
        
        _viewModel = viewModel;
    }
    return _viewModel;
}

- (UIImageView *)cloudImageView {
    if (!_cloudImageView) {
        _cloudImageView = self.viewModel.cloudImageViewBlock(self.detailTextLabel);
    }
    return _cloudImageView;
}

- (UIView *)tagView {
    if (!_tagView) {
        UIView *view = self.viewModel.tagViewBlock();
        
        [self.contentView addSubview:view];
        view.sd_layout
        .leftSpaceToView(self.contentView, 74*CA_H_RATIO_WIDTH)
        .rightSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH)
        .topSpaceToView(self.detailTextLabel, 5*CA_H_RATIO_WIDTH);
        
        _tagView = view;
    }
    return _tagView;
}

- (UIButton *)editButton{
    if (!_editButton) {
        UIButton *button = self.viewModel.editBlock(self, @selector(onEdit:));
        
        [self.contentView addSubview:button];
        button.sd_layout
        .widthIs(64*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .topEqualToView(self.contentView)
        .rightEqualToView(self.contentView);
        
        button.imageView.sd_resetLayout
        .widthIs(24*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .topSpaceToView(button, 20*CA_H_RATIO_WIDTH)
        .rightSpaceToView(button, 20*CA_H_RATIO_WIDTH);
        
        _editButton = button;
    }
    
    return _editButton;
}

- (void)setEditBlock:(void (^)(UITableViewCell *))editBlock {
    _editBlock = editBlock;
    if (editBlock
        &&
        ![self.reuseIdentifier isEqualToString:@"default"]) {
        [self editButton];
    }
}

- (void)setModel:(CA_HBrowseFoldersModel *)model {
    [super setModel:model];
    
    [self editButton];
    
    if (model.file_icon.length) {
        [self.imageView setImageWithURL:[NSURL URLWithString:model.file_icon] placeholder:[UIImage imageNamed:@"icons_file_？"]];
    } else {
        self.imageView.image = [CA_HFileIconManager iconWithFileName:model.file_name];
    }
    
    self.textLabel.text = model.file_name;//@"文件名称";
//    [self.textLabel sizeToFit];
    
    self.detailTextLabel.text = model.showDetail;//@"2017.12.29  12:00  12M";
//    [self.detailTextLabel sizeToFit];
    
    self.viewModel.downloadBlock(model, self.contentView);
    
    self.viewModel.reloadTagsBlock(model.tags?:@[]);//(@[@"移动互联网行业报告书",@"移动互联网行业报告书",@"移动互联网行业报告书"]);
    [self.tagView setupAutoHeightWithBottomViewsArray:self.tagView.subviews bottomMargin:0];
    if (self.tagView.subviews.count>0) {
        self.tagView.hidden = NO;
        [self setupAutoHeightWithBottomView:self.tagView bottomMargin:10*CA_H_RATIO_WIDTH];
    } else {
        self.tagView.hidden = YES;
        [self setupAutoHeightWithBottomView:self.detailTextLabel bottomMargin:10*CA_H_RATIO_WIDTH];
    }
    
    
    BOOL set = ([model.path_option indexOfObject:@"handle"]!=NSNotFound)||([model.path_option indexOfObject:@"share"]!=NSNotFound);
    self.editButton.hidden = !_editBlock||!set;
}

#pragma mark --- LifeCircle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        [self upView];
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark --- Custom

- (void)upView {
    [super upView];
    
    self.viewModel.resetViewBlock(self);
    [self cloudImageView];
}

#pragma mark --- Delegate






@end
