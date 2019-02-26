//
//  NSString+XuSong.h
//  demo
//
//  Created by yezhuge on 2017/12/1.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (XuSong)
- (CGRect)stringWidthRectWithSize:(CGSize)size fontOfSize:(CGFloat)font;
//检测两个字符串是否相等
+ (BOOL)isValueableString:(NSString *)content;
@end
