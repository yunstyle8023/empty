//
//  CA_HTodoListCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/12.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HTodoListCell.h"

#import "CA_HListTodoModel.h"

@interface CA_HTodoListCell ()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *deleteLine;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *moreLabel;

@property (nonatomic, strong) UILabel *tagLabel;

@end

@implementation CA_HTodoListCell

#pragma mark --- Action

- (void)onButton:(UIButton *)sender{
//    sender.selected = !sender.selected;
    if (_clickBlock) {
        _clickBlock(self);
    }
}

#pragma mark --- Lazy

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        UILabel *label = [UILabel new];
        _tagLabel = label;
        
        label.numberOfLines = 1;
        label.textColor = [UIColor whiteColor];
        label.font = CA_H_FONT_PFSC_Regular(12);
    }
    return _tagLabel;
}

- (UIView *)headerView {
    if (!_headerView) {
        UIView *view = [UIView new];
        _headerView = view;
        
        UIImageView *imageView = [UIImageView new];
        imageView.tag = 201;
        imageView.image = [UIImage imageNamed:@"shape6"];
        
        UIView *lastView = [self customImageView:0];
        
        [view addSubview:imageView];
        imageView.sd_layout
        .widthIs(6*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .leftSpaceToView(lastView, 5*CA_H_RATIO_WIDTH)
        .centerYEqualToView(view);
        
        imageView.hidden = YES;
    }
    return _headerView;
}

- (UILabel *)moreLabel {
    if (!_moreLabel) {
        UILabel *label = [UILabel new];
        _moreLabel = label;
        
        label.font = CA_H_FONT_PFSC_Semibold(8);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = CA_H_TINTCOLOR;
    }
    return _moreLabel;
}

#pragma mark --- LeftCircle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        [self upView];
    }
    return self;
}

#pragma mark --- Custom

- (UIImageView *)customImageView:(NSInteger)tag {
    UIImageView *imageView = [self.headerView viewWithTag:200+tag];
    
    if (!imageView) {
        
        UIView *lastView = [self.headerView viewWithTag:199+tag];
        if (!lastView) {
            lastView = self.headerView;
        }
        
        imageView = [UIImageView new];
        imageView.tag = 200+tag;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.headerView addSubview:imageView];
        
        imageView.sd_layout
        .leftSpaceToView(lastView, 5*CA_H_RATIO_WIDTH)
        .topEqualToView(self.headerView)
        .bottomEqualToView(self.headerView)
        .widthEqualToHeight();
        
        imageView.sd_cornerRadiusFromWidthRatio = @(0.5);
    }
    
    return imageView;
}

- (void)upView{
    [super upView];
    
    _type = -1;
    
    _button = [UIButton new];
    [_button setBackgroundImage:[UIImage imageNamed:@"unfinished"] forState:UIControlStateNormal];
    [_button setBackgroundImage:[UIImage imageNamed:@"finished"] forState:UIControlStateSelected];
    [_button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_button];
    
    _button.sd_resetLayout
    .widthIs(26*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .topSpaceToView(self.contentView, 10*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
    
    self.textLabel.font = CA_H_FONT_PFSC_Medium(16);
    self.textLabel.numberOfLines = 1;
    
    self.textLabel.sd_resetLayout
    .topSpaceToView(self.textLabel.superview, 10*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.textLabel.superview, 60*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.textLabel setMaxNumberOfLinesToShow:1];
    [self.textLabel setSingleLineAutoResizeWithMaxWidth:294*CA_H_RATIO_WIDTH];
    
    self.detailTextLabel.font = CA_H_FONT_PFSC_Regular(14);
    self.detailTextLabel.isAttributedContent = YES;
    self.detailTextLabel.numberOfLines = 1;
    
    self.detailTextLabel.sd_resetLayout
    .topSpaceToView(self.textLabel, 2*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.detailTextLabel.superview, 60*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.detailTextLabel setMaxNumberOfLinesToShow:1];
    [self.detailTextLabel setSingleLineAutoResizeWithMaxWidth:294*CA_H_RATIO_WIDTH];
    
    
    UIView *tagView = [UIView new];
    tagView.backgroundColor = [UIColor clearColor];
    tagView.layer.cornerRadius = 2*CA_H_RATIO_WIDTH;
    tagView.layer.masksToBounds = YES;
    
    [tagView addSubview:self.tagLabel];
    self.tagLabel.sd_layout
    .centerYEqualToView(tagView)
    .leftSpaceToView(tagView, 5*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.tagLabel setSingleLineAutoResizeWithMaxWidth:150*CA_H_RATIO_WIDTH];
    [self.tagLabel setMaxNumberOfLinesToShow:1];
    
    [self.contentView addSubview:tagView];
    tagView.sd_layout
    .heightIs(19*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.textLabel)
    .leftSpaceToView(self.textLabel, 5*CA_H_RATIO_WIDTH);
    [tagView setupAutoWidthWithRightView:self.tagLabel rightMargin:5*CA_H_RATIO_WIDTH];
    
    
    
    _deleteLine = [UILabel new];
    _deleteLine.backgroundColor = CA_H_9GRAYCOLOR;
    _deleteLine.hidden = YES;
    [self.contentView addSubview:_deleteLine];
    _deleteLine.sd_layout
    .heightIs(CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 60*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 21*CA_H_RATIO_WIDTH);
    
    
    UIView *line = [UIView new];
    line.backgroundColor = CA_H_BACKCOLOR;
    [self.contentView addSubview:line];
    line.sd_layout
    .heightIs(CA_H_LINE_Thickness)
    .bottomEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 60*CA_H_RATIO_WIDTH);
    
    
    [self.contentView addSubview:self.headerView];
    self.headerView.sd_layout
    .heightIs(20*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 55*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 8*CA_H_RATIO_WIDTH)
    .bottomSpaceToView(line, 10*CA_H_RATIO_WIDTH);
}

- (void)setType:(CA_H_TodoCellType)type{
    if (_type != type) {
        _type = type;
        if (type) {
            self.textLabel.textColor = CA_H_9GRAYCOLOR;
            _deleteLine.hidden = NO;
            _button.selected = YES;
        } else {
            self.textLabel.textColor = CA_H_4BLACKCOLOR;
            _deleteLine.hidden = YES;
            _button.selected = NO;
        }
    }
}

- (void)setModel:(CA_HListTodoContentModel *)model{
    [super setModel:model];
    
    self.textLabel.text = model.todo_name;
    self.tagLabel.text = model.tag_level_desc;
    if (model.tag_level_color.length) {
        CGFloat width = [self.tagLabel.text widthForFont:self.tagLabel.font] + 10*CA_H_RATIO_WIDTH;
        [self.textLabel setSingleLineAutoResizeWithMaxWidth:294*CA_H_RATIO_WIDTH-width];
        self.tagLabel.superview.backgroundColor = [UIColor colorWithHexString:model.tag_level_color];
    } else {
        self.tagLabel.text = nil;
        self.tagLabel.superview.backgroundColor = [UIColor clearColor];
        [self.textLabel setSingleLineAutoResizeWithMaxWidth:294*CA_H_RATIO_WIDTH];
    }
    
    
    NSMutableAttributedString * text = [NSMutableAttributedString new];
    
    if (model.ts_finish.integerValue > 0) {
        NSDate * date = [NSDate dateWithTimeIntervalSince1970:model.ts_finish.doubleValue];
        
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"M月d日 aa hh:mm"];
//        [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"]];
//        NSString * dateStr = [formatter stringFromDate:date];
        
        NSString *dateStr = [date stringWithFormat:@"MM月dd日 HH:mm"];
        
        NSMutableAttributedString * redText = [[NSMutableAttributedString alloc]initWithString:dateStr];
        if ([date compare:[NSDate date]]==NSOrderedDescending) {
            redText.color = CA_H_9GRAYCOLOR;
        } else {
            [redText insertString:@"已过期 | " atIndex:0];
            redText.color = CA_H_REDCOLOR; //超时未完成 显示红色
        }
        [text appendAttributedString:redText];
    }
    
    if ([model.object_type isEqualToString:@"project"]) {
        NSString *blackStr = text.length?[NSString stringWithFormat:@" | %@", model.object_name]:model.object_name;
        NSMutableAttributedString * blackText = [[NSMutableAttributedString alloc]initWithString:blackStr];
        blackText.color = CA_H_9GRAYCOLOR;
        [text appendAttributedString:blackText];
    }
    
    text.font = self.detailTextLabel.font;
    
    if (_type) {
        text.color = CA_H_9GRAYCOLOR;
        if (model.tag_level_color.length) {
            self.tagLabel.superview.backgroundColor = CA_H_9GRAYCOLOR;
        } else {
            self.tagLabel.text = nil;
            self.tagLabel.superview.backgroundColor = [UIColor clearColor];
        }
    }
    
    self.detailTextLabel.attributedText = text;
    
    UIImageView *imageView = [self customImageView:0];
    [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",CA_H_SERVER_API, model.creator.avatar]] placeholder:[UIImage imageNamed:@"head20"]];
    
    NSInteger imageCount = model.member_list.count;
    
    imageView = [self customImageView:1];
    imageView.hidden = (imageCount == 0);
    
    for (NSInteger i=0; i<10; i++) {
        if (i<imageCount) {
            imageView = [self customImageView:i+2];
            CA_HParticipantsModel *pModel = model.member_list[i];
            [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",CA_H_SERVER_API, pModel.avatar]] placeholder:[UIImage imageNamed:@"head20"]];
            imageView.hidden = NO;
            
            if (i == 9) {
                if (imageCount > 10) {
                    if (imageCount > 108) {
                        self.moreLabel.text = @"99+";
                    } else {
                        self.moreLabel.text = [NSString stringWithFormat:@"+%ld", imageCount-9];
                    }
                    [imageView addSubview:self.moreLabel];
                    self.moreLabel.sd_layout
                    .spaceToSuperView(UIEdgeInsetsZero);
                } else {
                    [self.moreLabel removeFromSuperviewAndClearAutoLayoutSettings];
                }
            }
        } else {
            imageView = [self.headerView viewWithTag:202+i];
            if (!imageView) break;
            imageView.hidden = YES;
        }
    }
}

@end
