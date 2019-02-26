//
//  CA_HSetLabel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/17.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HSetLabel.h"

@implementation CA_HSetLabel

- (void)setText:(NSString *)text{
    
    if (!text) {
        [super setText:text];
        return;
    }
    
    NSString * lanText = nil;
    if (CA_H_MANAGER.lanType == CA_H_Language_ChineseSimplified) {
        lanText = text;
    }else{
        NSString *path = [[NSBundle mainBundle] pathForResource:@""/**语言文件名*/ ofType:@"lproj"];
        
        lanText = [[NSBundle bundleWithPath:path] localizedStringForKey:text value:nil table:@""/**.strings文件名*/];
    }
    
    [super setText:lanText];
}

@end
