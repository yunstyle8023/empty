//
//  CA_HFileIconManager.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/2/12.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HFileIconManager.h"

#import <MobileCoreServices/MobileCoreServices.h>

@implementation CA_HFileIconManager

+ (UIImage *)iconWithFileName:(NSString *)fileName {
    
//    icons_file_？
//
//    icons_file_jpg
//
//    icons_file_txt
//
//    icons_file_doc
//    icons_file_xlsx
//    icons_file_pdf
//
//    icons_file_rar
//    icons_file_zip
    
    
    
    NSString *ext = [fileName componentsSeparatedByString:@"."].lastObject;
    
    if ([ext isEqualToString:fileName]) {
        return [UIImage imageNamed:@"icons_file_？"];
    }
    
    NSString *theUTI = [self preferredUTIForExtention:ext];
    
    if (UTTypeConformsTo((__bridge CFStringRef)theUTI, kUTTypeImage)) {
        return [UIImage imageNamed:@"icons_file_jpg"];
    }
    
    if ([theUTI isEqualToString:(NSString *)kUTTypePDF]) {
        return [UIImage imageNamed:@"icons_file_pdf"];
    }
    
    if ([theUTI isEqualToString:@"org.openxmlformats.wordprocessingml.document"]
        ||
        [theUTI isEqualToString:@"com.microsoft.word.doc"]) {
        return [UIImage imageNamed:@"icons_file_doc"];
    }
    
    if ([theUTI isEqualToString:@"org.openxmlformats.spreadsheetml.sheet"]
        ||
        [theUTI isEqualToString:@"com.microsoft.excel.xls"]) {
        return [UIImage imageNamed:@"icons_file_xlsx"];
    }
    
    if ([theUTI isEqualToString:@"public.plain-text"]) {
        return [UIImage imageNamed:@"icons_file_txt"];
    }
    
    if ([theUTI isEqualToString:@"public.zip-archive"]) {
        return [UIImage imageNamed:@"icons_file_zip"];
    }
    
    if ([theUTI isEqualToString:@"dyn.age81e2pw"]) {
        return [UIImage imageNamed:@"icons_file_rar"];
    }
    
    if ([theUTI isEqualToString:@"org.openxmlformats.presentationml.presentation"]
        ||
        [theUTI isEqualToString:@"com.microsoft.powerpoint.ppt"]) {
        return [UIImage imageNamed:@"icons_file_ppt"];
    }
    
    
    
//    public.xml
//    com.apple.property-list
//    public.mp3
    
    

    
    return [UIImage imageNamed:@"icons_file_？"];
}


+ (NSString *)preferredUTIForExtention:(NSString *)ext {
    //Request the UTI via the file extension
    NSString *theUTI = (__bridge_transfer NSString     *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)(ext), NULL);
    return theUTI;
}

@end
