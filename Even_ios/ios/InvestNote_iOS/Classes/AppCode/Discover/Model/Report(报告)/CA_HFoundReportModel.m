//
//  CA_HFoundReportModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/30.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HFoundReportModel.h"

#import "NSString+CA_HStringCheck.h"

#import "CA_HDownloadCenterViewModel.h"

@implementation CA_HFoundReportData

- (void)setReseacher:(NSString *)reseacher {
    _reseacher = reseacher;
    
    NSString *str = [NSString stringWithFormat:@"%@", reseacher?:@""];
    str = [str htmlColor:@"999999"];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    attrStr.font = CA_H_FONT_PFSC_Regular(14);
    attrStr.lineBreakMode = NSLineBreakByTruncatingTail;
    _reseacher_attributedText = attrStr;
}

- (void)setReport_name:(NSString *)report_name {
    _report_name = report_name;
    
    NSString *str = [NSString stringWithFormat:@"%@", report_name?:@""];
    str = [str htmlColor:@"444444"];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    attrStr.font = CA_H_FONT_PFSC_Regular(16);
    attrStr.lineBreakMode = NSLineBreakByTruncatingTail;
    _report_name_attributedText = attrStr;
}

- (void)checkSaved {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *homeDocumentPath = NSHomeDirectory();
    
    NSString *path = [[homeDocumentPath stringByAppendingPathComponent:CA_H_ReportDocumentsDirectory] stringByAppendingString:[NSString stringWithFormat:@"/%@/", self.report_id]];
    
    NSString *fileUrl = self.report_url;
    NSString *fileName = self.report_name_attributedText.string;
    
    NSArray *suffixArray = [fileUrl componentsSeparatedByString:@"."];
    if (suffixArray.count > 1) {
        NSString *suffix = suffixArray.lastObject;
        if (![fileName hasSuffix:suffix]) {
            fileName = [NSString stringWithFormat:@"%@.%@", fileName, suffix];
        }
    }
    
    NSString *filePath = [path stringByAppendingString:[CA_HDownloadCenterViewModel fileName:fileName transcoding:YES]];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        self.saved = YES;
    } else {
        self.saved = NO;
    }
}

@end


@implementation CA_HFoundReportModel

- (void)setData_list:(NSArray<CA_HFoundReportData *> *)data_list {
    if (![data_list isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dic in data_list) {
        if ([dic isKindOfClass:[CA_HFoundReportData class]]) {
            [array addObject:dic];
        }else{
            CA_HFoundReportData *model = [CA_HFoundReportData modelWithDictionary:dic];
            [model checkSaved];
            [array addObject:model];
        }
    }
    _data_list = array;
}

@end
