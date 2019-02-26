//
//  CA_HNoteListCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/25.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HNoteListCell.h"

#import "CA_HListNoteModel.h"

@interface CA_HNoteListCell ()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * contentLabel;
@property (nonatomic, strong) UILabel * tagLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel * dayLabel;
@property (nonatomic, strong) UILabel * monthLabel;
@property (nonatomic, strong) UIImageView * tagImageView;
@property (nonatomic, strong) UIImageView * commentImageView;

@end

@implementation CA_HNoteListCell

- (void)dealloc {
    
}

- (void)upView{
    [super upView];
    _isProject = NO;
    self.contentView.tag = 3333;
    
    _dayLabel = [UILabel new];
    _dayLabel.textAlignment = NSTextAlignmentRight;
    _dayLabel.textColor = CA_H_4BLACKCOLOR;
    _dayLabel.font = CA_H_FONT_PFSC_Medium(24);
    _dayLabel.hidden = YES;
    
    _monthLabel = [UILabel new];
    _monthLabel.textAlignment = NSTextAlignmentRight;
    _monthLabel.textColor = CA_H_9GRAYCOLOR;
    _monthLabel.font = CA_H_FONT_PFSC_Regular(12);
    _monthLabel.hidden = YES;
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = CA_H_4BLACKCOLOR;
    _titleLabel.font = CA_H_FONT_PFSC_Medium(16);
    
    _contentLabel = [UILabel new];
    _contentLabel.textColor = CA_H_9GRAYCOLOR;
    _contentLabel.font = CA_H_FONT_PFSC_Light(13);
    
    _tagImageView = [UIImageView new];
    _tagImageView.image = [UIImage imageNamed:@"project_icon"];
//    _tagImageView.hidden = YES;
    
    _tagLabel = [UILabel new];
    _tagLabel.textColor = CA_H_9GRAYCOLOR;
    _tagLabel.font = CA_H_FONT_PFSC_Light(12);
//    _tagLabel.hidden = YES;
    
    _timeLabel = [UILabel new];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.textColor = CA_H_9GRAYCOLOR;
    _timeLabel.font = CA_H_FONT_PFSC_Light(12);
//    _timeLabel.hidden = YES;
    
    _commentImageView = [UIImageView new];
    _commentImageView.image = [UIImage imageNamed:@"reply"];
    
    UIView *line = [UIView new];
    line.backgroundColor = CA_H_BACKCOLOR;
    
    [self.contentView addSubview:_dayLabel];
    [self.contentView addSubview:_monthLabel];
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_contentLabel];
    [self.contentView addSubview:_tagImageView];
    [self.contentView addSubview:_tagLabel];
    [self.contentView addSubview:_timeLabel];
    [self.contentView addSubview:_commentImageView];
    [self.contentView addSubview:line];
    
    _dayLabel.sd_layout
    .widthIs(30*CA_H_RATIO_WIDTH)
    .heightIs(33*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 10*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH);
    
    _monthLabel.sd_layout
    .widthRatioToView(_dayLabel, 1)
    .heightIs(17*CA_H_RATIO_WIDTH)
    .topSpaceToView(_dayLabel, 0)
    .leftEqualToView(_dayLabel);
    
    _titleLabel.sd_layout
    .topSpaceToView(self.contentView, 10*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 70*CA_H_RATIO_WIDTH)
//    .rightSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    _titleLabel.numberOfLines = 2;
    [_titleLabel setMaxNumberOfLinesToShow:2];
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:284*CA_H_RATIO_WIDTH];
    
    _contentLabel.sd_layout
    .topSpaceToView(_titleLabel, 10*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 70*CA_H_RATIO_WIDTH)
//    .rightSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    _contentLabel.numberOfLines = 2;
    [_contentLabel setMaxNumberOfLinesToShow:2];
    [_contentLabel setSingleLineAutoResizeWithMaxWidth:284*CA_H_RATIO_WIDTH];
    
    _tagImageView.sd_layout
    .widthIs(14*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .topSpaceToView(_contentLabel, 10*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.contentView, 70*CA_H_RATIO_WIDTH);
    
    _tagLabel.sd_layout
    .topSpaceToView(_contentLabel, 8*CA_H_RATIO_WIDTH)
    .leftSpaceToView(_tagImageView, 5*CA_H_RATIO_WIDTH)
    .minWidthIs(200*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    _tagLabel.numberOfLines = 1;
    [_tagLabel setSingleLineAutoResizeWithMaxWidth:230*CA_H_RATIO_WIDTH];
    [_tagLabel setMaxNumberOfLinesToShow:1];
    
    _timeLabel.sd_layout
    .centerYEqualToView(_tagImageView)
    .rightSpaceToView(self.contentView, 20*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    _timeLabel.numberOfLines = 1;
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:50*CA_H_RATIO_WIDTH];
    [_timeLabel setMaxNumberOfLinesToShow:1];
    
    _commentImageView.sd_layout
    .widthIs(14*CA_H_RATIO_WIDTH)
    .heightEqualToWidth()
    .centerYEqualToView(_tagImageView)
    .rightSpaceToView(_timeLabel, 5*CA_H_RATIO_WIDTH);
    
    
    line.sd_layout
    .heightIs(CA_H_LINE_Thickness)
    .bottomEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 70*CA_H_RATIO_WIDTH);
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    RACSignal *siganl = [center rac_addObserverForName:CA_H_NoteCommontCountNotification object:nil];
    //设置接收通知的回调处理
    CA_H_WeakSelf(self);
    [siganl subscribeNext:^(NSNotification *x) {
        CA_H_StrongSelf(self);
        CA_HListNoteContentModel *model = (id)self.model;
        if (model && [x.userInfo[@"note_id"] isEqualToNumber:model.note_id]) {
            model.comment_count = x.userInfo[@"comment_count"];
            self.timeLabel.text = [NSString stringWithFormat:@"%ld", model.comment_count.longValue];
        }
    }];
}

- (void)setModel:(CA_HListNoteContentModel *)model{
    [super setModel:model];
    
    _dayLabel.text = [NSString stringWithFormat:@"%ld", model.day];
    _dayLabel.hidden = !model.day;
    
    _monthLabel.text = [NSString stringWithFormat:@"%ld月", model.month];
    _monthLabel.hidden = !model.month;
    
    _titleLabel.text = model.note_title;
    [_titleLabel sizeToFit];
    
    _contentLabel.text = model.content;
    [_contentLabel sizeToFit];

    if (_isProject||_isHuman) {
        _tagImageView.sd_cornerRadiusFromWidthRatio = @(0.5);
        [_tagImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",CA_H_SERVER_API, model.creator.avatar]] placeholder:[UIImage imageNamed:@"head20"]];
        _tagLabel.text = _isHuman?model.creator.chinese_name:model.note_type_name;
//        [_tagLabel sizeToFit];
    } else {
        NSMutableString * mutString = [NSMutableString new];
        [mutString appendString:model.object_name.length?model.object_name:@"未归属"];
        
        if (model.note_type_id.integerValue) {
            [mutString appendString:@"·"];
            [mutString appendString:model.note_type_name];
        }
        
        _tagLabel.text = mutString;
//        [_tagLabel sizeToFit];
    }
    
    _timeLabel.text = [NSString stringWithFormat:@"%ld", model.comment_count.longValue];
//    [_timeLabel sizeToFit];
    _timeLabel.hidden = NO;
    
    [self setupAutoHeightWithBottomView:_tagImageView bottomMargin:12*CA_H_RATIO_WIDTH];
}

- (void)willTransitionToState:(UITableViewCellStateMask)state {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSArray * images = CA_H_EDIT_IMAGES;
        
        for (UIView * subView in self.subviews) {
            
            if ([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")] && [subView.subviews count] >= images.count) {
                
                NSArray * actionButtons = [subView valueForKey:@"actionButtons"];
                
                
                for (NSInteger i = 0; i < images.count; i++) {
                    UIButton * button = actionButtons[i];
                    
                    [CA_HNoteListCell customButton:button title:[[(id)button action] title] imageName:images[images.count-i-1]];
                }

            }
        }
    });
    
}

+ (void)customButton:(UIButton *)button title:(NSString *)title imageName:(NSString *)imageName{
    [button setBackgroundImage:[UIImage imageWithColor:CA_H_F8COLOR] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:CA_H_F8COLOR] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    [button setTitle:CA_H_LAN(title) forState:UIControlStateNormal];
    [button setTitleColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
    button.titleLabel.font = CA_H_FONT_PFSC_Regular(12);
    
    if (@available(iOS 11.0, *)){
    }else{
        [self centerImageAndTextOnButton:button];
    }
}

+ (void)centerImageAndTextOnButton:(UIButton*)button
{
    
    CGSize imageSize = button.imageView.image.size;
    CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
    button.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + imageSize.height), 0.0, 0.0, - titleSize.width);
    
}

@end
