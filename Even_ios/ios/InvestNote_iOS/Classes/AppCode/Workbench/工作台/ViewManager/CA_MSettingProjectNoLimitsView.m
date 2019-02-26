
//
//  CA_MSettingProjectNoLimitsView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/1.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MSettingProjectNoLimitsView.h"

@interface CA_MSettingProjectNoLimitsView ()
@property(nonatomic,strong)UIImageView* iconImgView;
@property(nonatomic,strong)UILabel* messageLb;
@end

@implementation CA_MSettingProjectNoLimitsView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.iconImgView];
        [self addSubview:self.messageLb];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(180*CA_H_RATIO_WIDTH);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.messageLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImgView.mas_bottom).offset(60*CA_H_RATIO_WIDTH);
        make.leading.mas_equalTo(self).offset(60);
        make.trailing.mas_equalTo(self).offset(-60);
    }];
}

-(void)setMessage:(NSString *)message{
    _message = message;
    self.messageLb.attributedText = [self fetchAttrStr:message];
}

- (NSAttributedString*)fetchAttrStr:(NSString*)message{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentCenter;
    paraStyle.lineSpacing = 5; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:CA_H_FONT_PFSC_Regular(18),
                          NSForegroundColorAttributeName:CA_H_TINTCOLOR,
                          NSParagraphStyleAttributeName:paraStyle};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:message attributes:dic];
    return attributeStr;
}

-(UILabel *)messageLb{
    if (_messageLb) {
        return _messageLb;
    }
    _messageLb = [[UILabel alloc] init];
    _messageLb.numberOfLines = 0;
    return _messageLb;
}
-(UIImageView *)iconImgView{
    if (_iconImgView) {
        return _iconImgView;
    }
    _iconImgView = [[UIImageView alloc] init];
    _iconImgView.image = kImage(@"project_lock");
    return _iconImgView;
}
@end
