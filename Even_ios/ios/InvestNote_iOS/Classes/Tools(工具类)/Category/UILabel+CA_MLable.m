//
//  UILabel+CA_M_Lable.m
//  ceshi
//
//  Created by yezhuge on 2017/11/18.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import "UILabel+CA_MLable.h"

@implementation UILabel (CA_MLable)

- (void)configText:(NSString *)text textColor:(UIColor *)color font:(CGFloat)fontSize{
    self.text = text;
    self.textColor = color;
    self.font = CA_H_FONT_PFSC_Regular(fontSize);
}

/**
 *  改变行间距
 */
- (void)changeLineSpaceWithSpace:(float)space {
    
    NSString *labelText = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
    
}

/**
 *  改变字间距
 */
- (void)changeWordSpaceWithSpace:(float)space {
    
    NSString *labelText = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
}

/**
 *  改变行间距和字间距
 */
- (void)changeSpacewithLineSpace:(float)lineSpace WordSpace:(float)wordSpace {
    
    NSString *labelText = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
}

@end
