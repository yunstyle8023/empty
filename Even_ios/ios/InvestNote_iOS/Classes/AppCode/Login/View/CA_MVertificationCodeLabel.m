//
//  CA_M_VertificationCodeLabel.m
//  ceshi
//
//  Created by yezhuge on 2017/11/19.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import "CA_MVertificationCodeLabel.h"

@interface CA_MVertificationCodeLabel()

@end

@implementation CA_MVertificationCodeLabel

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.textColor = CA_H_4BLACKCOLOR;
        self.firstResponder = NO;
    }
    return self;
}

/**
 重写setText方法,当text改变时手动调用drawRect方法,将text的内容按指定的格式绘制到label上
 
 @param text <#text description#>
 */
- (void)setText:(NSString *)text {
    [super setText:text];
    [self setNeedsDisplay];
}

/**
 按照指定的格式绘制验证码/密码
 
 @param rect1 <#rect1 description#>
 */
- (void)drawRect:(CGRect)rect1 {
    //计算每位验证码/密码的所在区域的宽和高
    CGRect rect = self.frame;
    float width = rect.size.width / (float)self.numberOfVertificationCode;
    float height = rect.size.height;
    
    // 将每位验证码/密码绘制到指定区域
    for (int i =0; i <self.text.length; i++) {
        // 计算每位验证码/密码的绘制区域
        CGRect tempRect =CGRectMake(i * width,0, width, height);
        if (self.secureTextEntry) {//密码形式,显示圆点
            UIImage *dotImage = kImage(@"dot");
            // 计算圆点的绘制区域
            CGPoint securityDotDrawStartPoint =CGPointMake(width * i + (width - dotImage.size.width) /2.0, (tempRect.size.height - dotImage.size.height) / 2.0);
            // 绘制圆点
            [dotImage drawAtPoint:securityDotDrawStartPoint];
        } else {//验证码,显示数字
            // 遍历验证码/密码的每个字符
            NSString *charecterString = [NSString stringWithFormat:@"%c", [self.text characterAtIndex:i]];
            // 设置验证码/密码的现实属性
            NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
            attributes[NSFontAttributeName] = CA_H_FONT_PFSC_Regular(32);
            // 计算每位验证码/密码的绘制起点（为了使验证码/密码位于tempRect的中部,不应该从tempRect的重点开始绘制）
            // 计算每位验证码/密码的在指定样式下的size
            CGSize characterSize = [charecterString sizeWithAttributes:attributes];
            CGPoint vertificationCodeDrawStartPoint = CGPointMake(width * i + (width - characterSize.width) /2.0, (tempRect.size.height - characterSize.height) /2.0-5);
            // 绘制验证码/密码
            [charecterString drawAtPoint:vertificationCodeDrawStartPoint withAttributes:attributes];
        }
    }
    //绘制底部横线
    for (int k=0; k<self.numberOfVertificationCode; k++) {
        [self drawBottomLineWithRect:rect andIndex:k];
        [self drawSenterLineWithRect:rect andIndex:k];
    }
    
}

/**
 绘制底部的线条
 
 @param rect1 <#rect1 description#>
 @param k <#k description#>
 */
- (void)drawBottomLineWithRect:(CGRect)rect1 andIndex:(int)k{
    CGRect rect = self.frame;
    float width = rect.size.width / (float)self.numberOfVertificationCode;
    float height = rect.size.height;
    //1.获取上下文
    CGContextRef context =UIGraphicsGetCurrentContext();
    //2.设置当前上下文路径
    CGFloat lineHidth = 1;//*ADAPTER_RATE;
    CGFloat strokHidth = 1;//*ADAPTER_RATE;
    CGContextSetLineWidth(context, lineHidth);
    
    if (self.isFirstResponder) {
        if ( k ==  self.text.length) {
            CGContextSetStrokeColorWithColor(context,CA_H_TINTCOLOR.CGColor);
            CGContextSetFillColorWithColor(context,CA_H_TINTCOLOR.CGColor);
        }else{
            CGContextSetStrokeColorWithColor(context,CA_H_BACKCOLOR.CGColor);
            CGContextSetFillColorWithColor(context,CA_H_BACKCOLOR.CGColor);
        }
    }else{
        CGContextSetStrokeColorWithColor(context,CA_H_BACKCOLOR.CGColor);
        CGContextSetFillColorWithColor(context,CA_H_BACKCOLOR.CGColor);
    }

    CGRect rectangle =CGRectMake(k*width+width/10,height-lineHidth-strokHidth,width-width/5,strokHidth);
    CGContextAddRect(context, rectangle);
    CGContextStrokePath(context);
}

/**
 绘制中间的输入的线条
 
 @param rect1 <#rect1 description#>
 @param k <#k description#>
 */
- (void)drawSenterLineWithRect:(CGRect)rect1 andIndex:(int)k{
    if (self.isFirstResponder) {
        if ( k == self.text.length ) {
            CGRect rect = self.frame;
            float width = rect.size.width / (float)self.numberOfVertificationCode;
            float height = rect.size.height;
            //1.获取上下文
            CGContextRef context =UIGraphicsGetCurrentContext();
            CGContextSetLineWidth(context,1);
            CGContextSetStrokeColorWithColor(context,CA_H_TINTCOLOR.CGColor);
            CGContextSetFillColorWithColor(context,CA_H_TINTCOLOR.CGColor);
            CGContextMoveToPoint(context, width * k + (width -1.0) /2.0, height/5-5);
            CGContextAddLineToPoint(context,  width * k + (width -1.0) /2.0,height-height/5-5);
            CGContextStrokePath(context);
        }
    }
}

@end
