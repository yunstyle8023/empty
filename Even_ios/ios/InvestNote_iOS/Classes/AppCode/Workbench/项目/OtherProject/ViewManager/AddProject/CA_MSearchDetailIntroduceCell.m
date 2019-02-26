//
//  CA_MSearchDetailintroduceCell.m
//  InvestNote_iOS
//
//  Created by yezhuge on 2017/12/21.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import "CA_MSearchDetailIntroduceCell.h"

@interface CA_MSearchDetailIntroduceCell()
@property(nonatomic,strong)UILabel* introduceLb;
@end

@implementation CA_MSearchDetailIntroduceCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.introduceLb];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.introduceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(28);
        make.top.mas_equalTo(self.contentView);
        make.trailing.mas_equalTo(self.contentView).offset(-15);
    }];
}

-(CGFloat)configCell:(NSString *)title{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 3; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:CA_H_FONT_PFSC_Regular(14),
                          NSParagraphStyleAttributeName:paraStyle,
                          NSKernAttributeName:@1};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:title attributes:dic];
    
    self.introduceLb.attributedText = attributeStr;
    
//    CGFloat height = [title heightForFont:CA_H_FONT_PFSC_Regular(14) width:252*CA_H_RATIO_WIDTH];
    
    CGFloat height = [self getSpaceLabelHeight:title withFont:CA_H_FONT_PFSC_Regular(14) withWidth:252*CA_H_RATIO_WIDTH];
    return height;
}

//计算UILabel的高度(带有行间距的情况)
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 3;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font,
                          NSParagraphStyleAttributeName:paraStyle,
                          NSKernAttributeName:@1
                          };
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

-(UILabel *)introduceLb{
    if (_introduceLb) {
        return _introduceLb;
    }
    _introduceLb = [[UILabel alloc] init];
    [_introduceLb configText:@"" textColor:CA_H_4BLACKCOLOR font:14];
    _introduceLb.numberOfLines = 0;
    return _introduceLb;
}
@end
