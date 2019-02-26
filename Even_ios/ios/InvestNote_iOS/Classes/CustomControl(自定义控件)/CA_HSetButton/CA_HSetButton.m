//
//  CA_HSetButton.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/23.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HSetButton.h"

@implementation CA_HSetButton

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    if (!title) {
        [super setTitle:title forState:state];
        return;
    }
    
    NSString * lanTitle = nil;
    if (CA_H_MANAGER.lanType == CA_H_Language_ChineseSimplified) {
        lanTitle = title;
    }else{
        NSString *path = [[NSBundle mainBundle] pathForResource:@""/**语言文件名*/ ofType:@"lproj"];
        
        lanTitle = [[NSBundle bundleWithPath:path] localizedStringForKey:title value:nil table:@""/**.strings文件名*/];
    }
    
    [super setTitle:lanTitle forState:state];
}

@end
