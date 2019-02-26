//
//  CA_HFoundSearchModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/18.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HFoundSearchModel.h"

#import "NSString+CA_HStringCheck.h"

@implementation CA_HFoundSearchDataModel

#pragma mark --- 项目

- (void)setProject_name:(NSString *)project_name {
    _project_name = project_name;
    
    NSString *str = [NSString stringWithFormat:@"%@", project_name?:@""];
    str = [str htmlColor:@"444444"];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    attrStr.font = CA_H_FONT_PFSC_Regular(16);
    attrStr.lineBreakMode = NSLineBreakByTruncatingTail;
    _project_name_attributedText = attrStr;
}

- (void)setBrief_intro:(NSString *)brief_intro {
    _brief_intro = brief_intro;
    
    NSString *str = [NSString stringWithFormat:@"%@", brief_intro?:@""];
    str = [str htmlColor:@"999999"];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    attrStr.font = CA_H_FONT_PFSC_Regular(14);
    attrStr.lineBreakMode = NSLineBreakByTruncatingTail;
    _brief_intro_attributedText = attrStr;
}

#pragma mark --- 企业工商

- (void)setEnterprise_name:(NSString *)enterprise_name {
    _enterprise_name = enterprise_name;
    
    NSString *str = [NSString stringWithFormat:@"%@", enterprise_name?:@""];
    str = [str htmlColor:@"444444"];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    attrStr.font = CA_H_FONT_PFSC_Regular(16);
    attrStr.lineBreakMode = NSLineBreakByTruncatingTail;
    _enterprise_name_attributedText = attrStr;
}

#pragma mark --- lp

- (void)setLp_name:(NSString *)lp_name {
    _lp_name = lp_name;
    
    NSString *str = [NSString stringWithFormat:@"%@", lp_name?:@""];
    str = [str htmlColor:@"444444"];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    attrStr.font = CA_H_FONT_PFSC_Regular(16);
    attrStr.lineBreakMode = NSLineBreakByTruncatingTail;
    _lp_name_attributedText = attrStr;
}

- (void)setLp_intro:(NSString *)lp_intro {
    _lp_intro = lp_intro;
    
    NSString *str = lp_intro.length?[NSString stringWithFormat:@"%@", lp_intro?:@""]:@"暂无简介";
    
    str = [str htmlColor:@"999999"];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    attrStr.font = CA_H_FONT_PFSC_Regular(14);
    attrStr.lineBreakMode = NSLineBreakByTruncatingTail;
    _lp_intro_attributedText = attrStr;
}

#pragma mark --- gp

- (void)setGp_name:(NSString *)gp_name {
    _gp_name = gp_name;
    
    NSString *str = [NSString stringWithFormat:@"%@", gp_name?:@""];;
    str = [str htmlColor:@"444444"];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    attrStr.font = CA_H_FONT_PFSC_Regular(16);
    attrStr.lineBreakMode = NSLineBreakByTruncatingTail;
    _gp_name_attributedText = attrStr;
}

- (void)setGp_intro:(NSString *)gp_intro {
    _gp_intro = gp_intro;
    
    NSString *str = gp_intro.length?[NSString stringWithFormat:@"%@", gp_intro?:@""]:@"暂无简介";
    
    str = [str htmlColor:@"999999"];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    attrStr.font = CA_H_FONT_PFSC_Regular(14);
    attrStr.lineBreakMode = NSLineBreakByTruncatingTail;
    _gp_intro_attributedText = attrStr;
}

- (void)setArea:(NSString *)area {
    _area = area;
    [self gp_changeShow];
}

- (void)setCapital_type:(NSString *)capital_type {
    _capital_type = capital_type;
    [self gp_changeShow];
}

- (void)gp_changeShow {
    NSString *str = [NSString stringWithFormat:@"%@ | %@",[NSString isValueableString:self.area]?self.area:@"暂无",[NSString isValueableString:self.capital_type]?self.capital_type:@"暂无"];
    str = [str htmlColor:@"999999"];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    attrStr.font = CA_H_FONT_PFSC_Regular(14);
    attrStr.lineBreakMode = NSLineBreakByTruncatingTail;
    _gp_show_attributedText = attrStr;
}

@end

@implementation CA_HFoundSearchModel

- (void)setData_list:(NSArray<CA_HFoundSearchDataModel *> *)data_list {
    if (![data_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dic in data_list) {
        if ([dic isKindOfClass:[CA_HFoundSearchDataModel class]]) {
            [array addObject:dic];
        }else{
            [array addObject:[CA_HFoundSearchDataModel modelWithDictionary:dic]];
        }
    }
    _data_list = array;
}

@end

@implementation CA_HFoundSearchAggregationModel

@end
