//
//  CA_HNoteDetailAttachCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/7/9.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HNoteDetailAttachCell.h"

#import "CA_HNoteDetailModel.h"

@interface CA_HNoteDetailAttachCell ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) CALayer *shadowLayer;
@property (nonatomic, strong) UITextView *textView;

@end

@implementation CA_HNoteDetailAttachCell

#pragma mark --- Action

- (void)setModel:(CA_HNoteDetailContentModel *)model {
    [super setModel:model];
    
    if ([self.reuseIdentifier hasPrefix:@"attach"]) {
        self.label.text = model.file_name;
    } else if ([self.reuseIdentifier hasPrefix:@"record"]) {
        long duration = model.record_duration.longValue;
        self.label.text = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld", duration/3600, duration%3600/60, duration%60];
    } else {
//        if (![self.label.attributedText isEqualToAttributedString:model.attributedContent]) {
//            self.label.height = model.cellHeight-20*CA_H_RATIO_WIDTH;
//            self.label.attributedText = model.attributedContent;
//        }
        self.textView.height = model.cellHeight;
        self.textView.attributedText = model.attributedContent;
    }
}

#pragma mark --- Lazy

- (UITextView *)textView {
    if (!_textView) {
        UITextView *textView = [UITextView new];
        _textView = textView;
        
        textView.contentInset = UIEdgeInsetsZero;
        textView.textContainerInset = UIEdgeInsetsMake(10*CA_H_RATIO_WIDTH, 16*CA_H_RATIO_WIDTH, 10*CA_H_RATIO_WIDTH, 16*CA_H_RATIO_WIDTH);
        textView.userInteractionEnabled = NO;
    }
    return _textView;
}

- (UILabel *)label {
    if (!_label) {
        UILabel *label = [UILabel new];
        _label = label;
    }
    return _label;
}

- (CALayer *)shadowLayer {
    if (!_shadowLayer) {
        CALayer *layer = [CALayer layer];
        _shadowLayer = layer;
        
        layer.frame = CGRectMake(20*CA_H_RATIO_WIDTH, 10*CA_H_RATIO_WIDTH, 335*CA_H_RATIO_WIDTH, 58*CA_H_RATIO_WIDTH);
        layer.cornerRadius = 5*CA_H_RATIO_WIDTH;
        layer.backgroundColor=[UIColor whiteColor].CGColor;//shadowColor.CGColor;
        layer.masksToBounds = NO;
        layer.shadowColor = CA_H_SHADOWCOLOR.CGColor;//shadowColor阴影颜色
        layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
        layer.shadowOpacity = 0.5;//阴影透明度，默认0
        layer.shadowRadius = 4*CA_H_RATIO_WIDTH;//阴影半径，默认3
    }
    return _shadowLayer;
}

#pragma mark --- LifeCircle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if ([reuseIdentifier hasPrefix:@"attach"]) {
            [self upAttachView];
        } else if ([reuseIdentifier hasPrefix:@"record"]) {
            [self upRecordView];
        } else {
            [self upTextView];
        }
    }
    return self;
}

#pragma mark --- Custom

- (void)upTextView {
    [super upView];
    
    self.textView.frame = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, 0);
    [self.contentView addSubview:self.textView];
    
//    self.label.numberOfLines = 0;
//    self.label.frame = CGRectMake(20*CA_H_RATIO_WIDTH, 10*CA_H_RATIO_WIDTH, 335*CA_H_RATIO_WIDTH, 0);
//    [self.contentView addSubview:self.label];
}

- (void)upRecordView {
    UIImageView *imageView = [self customView];
    imageView.image = [UIImage imageNamed:@"micro_icon"];
    self.label.font = CA_H_FONT_PFSC_Light(16);
}

- (void)upAttachView {
    UIImageView *imageView = [self customView];
    imageView.image = [UIImage imageNamed:@"attachment_icon"];
    self.label.font = CA_H_FONT_PFSC_Regular(16);
}

- (UIImageView *)customView {
    [super upView];
    
    self.label.numberOfLines = 1;
    self.label.textColor = CA_H_4BLACKCOLOR;
    self.label.frame = CGRectMake(69*CA_H_RATIO_WIDTH, 28*CA_H_RATIO_WIDTH, 266*CA_H_RATIO_WIDTH, 22*CA_H_RATIO_WIDTH);
    [self.contentView addSubview:self.label];
    
    [self.contentView.layer insertSublayer:self.shadowLayer below:self.label.layer];
    
    UIImageView *imageView = [UIImageView new];
    imageView.frame = CGRectMake(33*CA_H_RATIO_WIDTH, 27*CA_H_RATIO_WIDTH, 24*CA_H_RATIO_WIDTH, 24*CA_H_RATIO_WIDTH);
    [self.contentView addSubview:imageView];
    
    return imageView;
}

#pragma mark --- Delegate

@end
