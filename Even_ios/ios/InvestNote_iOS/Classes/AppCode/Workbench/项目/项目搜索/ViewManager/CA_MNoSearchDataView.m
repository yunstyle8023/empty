//
//  CA_MNoSearchDataView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/12.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNoSearchDataView.h"
#import "CXAHyperlinkLabel.h"

@interface CA_MNoSearchDataView ()

@end

@implementation CA_MNoSearchDataView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self upView];
    }
    return self;
}

-(void)upView{
    
    [self addSubview:self.guideLb];
    self.guideLb.sd_layout
    .leftSpaceToView(self, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self, 10*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self, 10*2*CA_H_RATIO_WIDTH)
    .heightIs(11*2*CA_H_RATIO_WIDTH);
    
    self.messageLb.frame = CGRectMake(10*2*CA_H_RATIO_WIDTH, 25*2*CA_H_RATIO_WIDTH, 159*2*CA_H_RATIO_WIDTH, 100*2*CA_H_RATIO_WIDTH);
//    self.messageLb.isAttributedContent = YES;
    [self addSubview:self.messageLb];
//    self.messageLb.sd_layout
//    .leftSpaceToView(self, 10*2*CA_H_RATIO_WIDTH)
//    .topSpaceToView(self.guideLb, 4*2*CA_H_RATIO_WIDTH)
//    .rightSpaceToView(self, 19*2*CA_H_RATIO_WIDTH)
//    .autoHeightRatio(0);
//    [self.messageLb setMaxNumberOfLinesToShow:0];
}

-(CXAHyperlinkLabel *)messageLb{
    if (!_messageLb) {
        _messageLb = [CXAHyperlinkLabel new];
        _messageLb.numberOfLines = 0;
        [_messageLb configText:@"1. 请输入项目名称，检索外部数据库项目 \n2. 选择匹配的项目 \n3. 完成关联 \n\n提示：外部项目数据库为动态更新的数据库，如找不到想要的项目，可联系客服：400-770-8988"
                     textColor:CA_H_9GRAYCOLOR
                          font:14];
        [_messageLb changeLineSpaceWithSpace:6];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]
                                             initWithAttributedString:_messageLb.attributedText];
        [attStr addAttribute:NSForegroundColorAttributeName value:CA_H_TINTCOLOR range:NSMakeRange(_messageLb.attributedText.length-12, 12)];
        [attStr addAttribute:NSForegroundColorAttributeName value:CA_H_9GRAYCOLOR range:NSMakeRange(0, _messageLb.attributedText.length-12)];
        [attStr addAttribute:NSFontAttributeName value:CA_H_FONT_PFSC_Regular(14) range:NSMakeRange(0, _messageLb.attributedText.length)];
        _messageLb.attributedText = attStr;
        [_messageLb setURL:[NSURL URLWithString:@""] forRange:NSMakeRange(_messageLb.attributedText.length-12, 12)];
        _messageLb.linkAttributesWhenTouching = nil;
        _messageLb.URLClickHandler = ^(CXAHyperlinkLabel *label, NSURL *URL, NSRange textRange, NSArray *textRects) {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"400-770-8988"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        };
    }
    return _messageLb;
}

-(UILabel *)guideLb{
    if (!_guideLb) {
        _guideLb = [UILabel new];
        [_guideLb configText:@"关联步骤指引"
                   textColor:CA_H_9GRAYCOLOR
                        font:16];
    }
    return _guideLb;
}

@end
