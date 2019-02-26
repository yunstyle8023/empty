//
//  NSString+CA_HStringCheck.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/2/2.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CA_HStringCheck)

- (NSArray*)getUrlStringParams;

- (NSString *)htmlColor:(NSString *)colorStr;

- (NSMutableAttributedString *)colorText:(NSString *)colorText font:(UIFont *)font color:(UIColor *)color changeColor:(UIColor *)changeColor;

- (BOOL)checkFileTag ;

@end
