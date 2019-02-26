//
//  UILabel+CA_M_Lable.h
//  ceshi
//
//  Created by yezhuge on 2017/11/18.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (CA_MLable)


/**
 统一设置标题 标题颜色 字体大小

 @param text <#text description#>
 @param color <#color description#>
 @param fontSize <#fontSize description#>
 */
- (void)configText:(NSString*)text textColor:(UIColor*)color font:(CGFloat)fontSize;

/**
 *  改变行间距
 */
- (void)changeLineSpaceWithSpace:(float)space;

/**
 *  改变字间距
 */
- (void)changeWordSpaceWithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
- (void)changeSpacewithLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

@end
