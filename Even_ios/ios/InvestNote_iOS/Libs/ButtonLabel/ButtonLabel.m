//
//  ButtonLabel.m
//  DaDaBus
//
//  Created by Sylvia on 14-8-15.
//  Copyright (c) 2014年 Bus. All rights reserved.
//

#import "ButtonLabel.h"

@implementation ButtonLabel
@synthesize didSelect;
//@synthesize selected;
//@synthesize textNormalColor;
//@synthesize textTouchColor;
//@synthesize backGroudTouchColor;
//@synthesize backGroudNormalColor;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
//        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}
//-(void)setBackGroudNormalColor:(UIColor *)backColor
//{
//    backGroudNormalColor = backColor;
//    self.backgroundColor = backGroudNormalColor;
//}
//-(void)setTextNormalColor:(UIColor *)textColor
//{
//    textNormalColor = textColor;
//    self.textColor = textNormalColor;
//}
//
//-(void)setSelected:(BOOL)newselected
//{
//    selected = newselected;
//    if (selected) {
//        self.textColor = textTouchColor;
//        self.backgroundColor = backGroudTouchColor;
//    }
//    else{
//        self.textColor = textNormalColor;
//        self.backgroundColor = backGroudNormalColor;
//    }
//}
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    /*
//        1点击开始 设置点击效果
//     */
//
//    self.backgroundColor = backGroudTouchColor;
//    self.textColor = textTouchColor;
//}
// FramWidth/2-0.5 44
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *_touch = [touches anyObject];
    CGPoint point = [_touch locationInView:self];
    CGSize size = self.bounds.size;
    
    if (point.x<=size.width&&point.y<=size.height&&point.x>=0&&point.y>=0) {
        /*
            2在指定范围内结束点击 结束点击效果 触发点击事件
         */
//        self.textColor = textNormalColor;
//        self.backgroundColor = backGroudNormalColor;
        if (self.didSelect) {
            self.didSelect(self);
        }
    }else{
        /*
            在控件范围外结束点击事件
         */
//        self.textColor = textNormalColor;
//        self.backgroundColor = backGroudNormalColor;
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *_touch = [touches anyObject];
    CGPoint point = [_touch locationInView:self];
    CGSize size = self.bounds.size;
    
    if (point.x<=size.width&&point.y<=size.height&&point.x>=0&&point.y>=0){
        /*
            5表明滑动进入指定范围 设置点击效果围 结束点击效果
         */
//        self.textColor = textTouchColor;
//        self.backgroundColor = backGroudTouchColor;
    }else{
        /*
            4表明滑动超出指定范
         */
//        self.textColor = textNormalColor;
//        self.backgroundColor = backGroudNormalColor;
    }
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    /*
        6点击自动失败 结束点击效果 不做任何操作
     */
//    self.textColor = textNormalColor;
//    self.backgroundColor = backGroudNormalColor;
}

@end
