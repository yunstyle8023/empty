//
//  NSString+CA_HStringCheck.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/2/2.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "NSString+CA_HStringCheck.h"

@implementation NSString (CA_HStringCheck)

- (NSArray*)getUrlStringParams {
    NSString*urlString = [NSString stringWithString:self];
    if(urlString.length==0) {
        NSLog(@"链接为空！");
        return @[@"",@{}];
    }
    //先截取问号
    NSArray*allElements = [urlString componentsSeparatedByString:@"?"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];//待set的参数字典
    if(allElements.count==2) {
        //有参数或者?后面为空
        NSString*myUrlString = allElements[0];
        NSString*paramsString = allElements[1];
        //获取参数对
        NSArray*paramsArray = [paramsString componentsSeparatedByString:@"&"];
        if(paramsArray.count>=2) {
            for(NSInteger i =0; i < paramsArray.count; i++) {
                NSString*singleParamString = paramsArray[i];
                NSArray*singleParamSet = [singleParamString componentsSeparatedByString:@"="];
                if(singleParamSet.count==2) {
                    NSString*key = singleParamSet[0];
                    NSString*value = singleParamSet[1];
                    if(key.length>0|| value.length>0) {
                        [params setObject:value.length>0?value:@""forKey:key.length>0?key:@""];
                    }
                }
            }
        } else if(paramsArray.count==1) {
            //无 &。url只有?后一个参数
            NSString*singleParamString = paramsArray[0];
            NSArray*singleParamSet = [singleParamString componentsSeparatedByString:@"="];
            if(singleParamSet.count==2) {
                NSString*key = singleParamSet[0];
                NSString*value = singleParamSet[1];
                if(key.length>0|| value.length>0) {
                    [params setObject:value.length>0?value:@""forKey:key.length>0?key:@""];
                }
            }else{
                //问号后面啥也没有 xxxx?  无需处理
            }
        }
        //整合url及参数
        return@[myUrlString,params];
    }else if(allElements.count>2) {
        NSLog(@"链接不合法！链接包含多个\"?\"");
        return @[@"",@{}];
    } else {
        NSLog(@"链接不包含参数！");
        return@[urlString,@{}];
    }
}


- (NSString *)htmlColor:(NSString *)colorStr {
    
    NSString *wrongStr = [NSString stringWithFormat:@"</font><color='#%@'>", colorStr];
    NSString *changeStr = [NSString stringWithFormat:@"<color='#%@'>", colorStr];
    NSString *rightStr = [NSString stringWithFormat:@"<font color='#%@'>", colorStr];
    
    
    NSArray *array = [self componentsSeparatedByString:@"</font>"];
    NSString *htmlStr = [array componentsJoinedByString:wrongStr];
    array = [htmlStr componentsSeparatedByString:@"<font color="];
    htmlStr = [array componentsJoinedByString:@"</font><font color="];
    array = [htmlStr componentsSeparatedByString:changeStr];
    htmlStr = [array componentsJoinedByString:rightStr];
    htmlStr = [NSString stringWithFormat:@"<font color='#%@'>%@</font>", colorStr, htmlStr];
    
    return htmlStr;
}

- (NSMutableAttributedString *)colorText:(NSString *)colorText font:(UIFont *)font color:(UIColor *)color changeColor:(UIColor *)changeColor {
    
    NSArray *array = [self componentsSeparatedByString:colorText];
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    for (NSString *str in array) {
        NSMutableAttributedString *text1 = [NSMutableAttributedString new];
        [text1 appendString:str];
        text1.color = color;
        [text appendAttributedString:text1];
        
        if (text.length < self.length) {
            NSMutableAttributedString *text2 = [NSMutableAttributedString new];
            [text2 appendString:colorText];
            text2.color = changeColor;
            [text appendAttributedString:text2];
        }
    }
    text.font = font;
    
    return text;
}

- (BOOL)checkFileTag {
    NSString * regex = @"^[a-zA-Z0-9_\u4E00-\u9FA5(-)(➋-➒)]{0,}$";
    return [self checkRegex:regex];
}

- (BOOL)checkRegex:(NSString *)regex {
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self];
    
    return isMatch;
}

@end
