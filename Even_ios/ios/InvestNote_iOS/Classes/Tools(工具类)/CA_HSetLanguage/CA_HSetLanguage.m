//
//  CA_HSetLanguage.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/27.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HSetLanguage.h"

@implementation CA_HSetLanguage

+ (NSString *)languageString:(NSString *)string{
    
    if (CA_H_MANAGER.lanType == CA_H_Language_ChineseSimplified) {
        return string;
    }else{
        NSString *path = [[NSBundle mainBundle] pathForResource:@""/**语言文件名*/ ofType:@"lproj"];
       return [[NSBundle bundleWithPath:path] localizedStringForKey:string value:nil table:@""/**.strings文件名*/];
    }
}

@end
