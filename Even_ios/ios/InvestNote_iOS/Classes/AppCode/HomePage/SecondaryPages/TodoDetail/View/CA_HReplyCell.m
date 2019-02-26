//
//  CA_HReplyCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/1.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HReplyCell.h"
#import "CA_HTodoDetailModel.h"

@interface CA_HReplyCell ()

@property (nonatomic, nonnull, strong) UIButton *button;
@property (nonatomic, nonnull, strong) UILabel *label;
@property (nonatomic, assign) BOOL isMine;

@end

@implementation CA_HReplyCell

#pragma mark --- Action

- (void)setModel:(CA_HTodoDetailCommentModel *)model {
    [super setModel:model];
    
    if (model.privilege.count) {
        self.isMine = ([model.privilege indexOfObject:@"delete"] != NSNotFound);
        self.button.hidden = NO;
    } else {
        self.button.hidden = YES;
    }

    
    [self.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", CA_H_SERVER_API, model.creator.avatar]] placeholder:[UIImage imageNamed:@"head30"]];
    self.textLabel.text = model.creator.chinese_name;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.ts_create.doubleValue];
    self.detailTextLabel.text = [date stringWithFormat:@"yyyy.MM.dd HH:mm"];
    
//    NSMutableAttributedString *text = [NSMutableAttributedString new];
//
//    for (CA_HParticipantsModel *pModel in model.notice_user_list) {
//        NSMutableAttributedString *people = [[NSMutableAttributedString alloc]initWithString:@"@"];
//        [people appendString:pModel.chinese_name];
//        [people appendString:@" "];
//        people.color = CA_H_TINTCOLOR;
//        [text appendAttributedString:people];
//    }
//
//
//    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:model.content];
//    content.color = CA_H_4BLACKCOLOR;
//
//    [text appendAttributedString:content];
//    text.font = CA_H_FONT_PFSC_Regular(15);
//
//    self.label.attributedText = text;
    
    self.label.text = model.content;
    [self.label sizeToFit];
    
    [self setupAutoHeightWithBottomView:self.label bottomMargin:2*CA_H_RATIO_WIDTH];
}

- (void)onButton:(UIButton *)sender {
    if (_onClickBlock) {
        _onClickBlock(self, self.isMine);
    }
}

#pragma mark --- Lazy

- (UIButton *)button {
    if (!_button) {
        UIButton *button = [UIButton new];
        _button = button;
        
        [button setTitleColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
        
        button.titleLabel.font = CA_H_FONT_PFSC_Regular(12);
        button.titleLabel.numberOfLines = 1;
        button.titleLabel.sd_resetLayout
        .rightSpaceToView(button, 20*CA_H_RATIO_WIDTH)
        .centerYEqualToView(button)
        .autoHeightRatio(0);
        [button.titleLabel setMaxNumberOfLinesToShow:1];
        [button.titleLabel setSingleLineAutoResizeWithMaxWidth:65*CA_H_RATIO_WIDTH];
        
        button.imageView.sd_resetLayout
        .widthIs(16*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .centerYEqualToView(button)
        .rightSpaceToView(button.titleLabel, 5*CA_H_RATIO_WIDTH);
        
        [button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:button];
        button.sd_layout
        .heightIs(66*CA_H_RATIO_WIDTH)
        .widthIs(85*CA_H_RATIO_WIDTH)
        .topEqualToView(self.contentView)
        .rightEqualToView(self.contentView);
    }
    return _button;
}

- (UILabel *)label {
    if (!_label) {
        UILabel *label = [UILabel new];
        _label = label;
        
//        label.isAttributedContent = YES;
        label.font = CA_H_FONT_PFSC_Regular(15);
        label.textColor = CA_H_4BLACKCOLOR;
        label.numberOfLines = 0;
        
        [self.contentView addSubview:label];
        label.sd_layout
        .widthIs(295*CA_H_RATIO_WIDTH)
        .leftSpaceToView(self.contentView, 60*CA_H_RATIO_WIDTH)
        .topSpaceToView(self.detailTextLabel, 9*CA_H_RATIO_WIDTH)
        .autoHeightRatio(0);
        [label setSingleLineAutoResizeWithMaxWidth:295*CA_H_RATIO_WIDTH];
    }
    return _label;
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
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.sd_resetLayout
    .widthIs(30*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .leftSpaceToView(self.imageView.superview, 20*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.imageView.superview, 18*CA_H_RATIO_WIDTH);
    self.imageView.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    self.textLabel.font = CA_H_FONT_PFSC_Regular(14);
    self.textLabel.textColor = CA_H_9GRAYCOLOR;
    self.textLabel.numberOfLines = 1;
    self.textLabel.sd_resetLayout
    .topSpaceToView(self.textLabel.superview, 18*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.textLabel.superview, 60*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.textLabel setMaxNumberOfLinesToShow:1];
    [self.textLabel setSingleLineAutoResizeWithMaxWidth:240*CA_H_RATIO_WIDTH];
    
    self.detailTextLabel.font = CA_H_FONT_PFSC_Regular(12);
    self.detailTextLabel.textColor = CA_H_BCOLOR;
    self.detailTextLabel.numberOfLines = 1;
    self.detailTextLabel.sd_resetLayout
    .topSpaceToView(self.textLabel, 0)
    .leftSpaceToView(self.detailTextLabel.superview, 60*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.detailTextLabel setMaxNumberOfLinesToShow:1];
    [self.detailTextLabel setSingleLineAutoResizeWithMaxWidth:240*CA_H_RATIO_WIDTH];
    
}

- (void)setIsMine:(BOOL)isMine {
    _isMine = isMine;
    if (isMine) {
        [self.button setTitle:CA_H_LAN(@"删除") forState:UIControlStateNormal];
        [self.button setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    } else {
        [self.button setTitle:CA_H_LAN(@"回复") forState:UIControlStateNormal];
        [self.button setImage:[UIImage imageNamed:@"reply3"] forState:UIControlStateNormal];
    }
}

#pragma mark --- Delegate

@end
