//
//  ZFConst.m
//  InvestNote_iOS
//
//  Created by yezhuge on 2017/12/1.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ZFBlack [UIColor blackColor]
#define ZFDarkGray [UIColor darkGrayColor]
#define ZFLightGray [UIColor lightGrayColor]
#define ZFWhite [UIColor whiteColor]
#define ZFGray [UIColor grayColor]
#define ZFRed [UIColor redColor]
#define ZFGreen [UIColor greenColor]
#define ZFBlue [UIColor blueColor]
#define ZFCyan [UIColor cyanColor]
#define ZFYellow [UIColor yellowColor]
#define ZFMagenta [UIColor magentaColor]
#define ZFOrange [UIColor orangeColor]
#define ZFPurple [UIColor purpleColor]
#define ZFBrown [UIColor brownColor]
#define ZFClear [UIColor clearColor]


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define ADAPTATION_WIDTH7(Width) [UIScreen mainScreen].bounds.size.width * (Width) / 375
#define IMGNAME(name) [UIImage imageNamed:name]
/**
 *  直接填写小数
 */
#define ZFDecimalColor(r, g, b, a) [UIColor colorWithRed:r green:g blue:b alpha:a]

/**
 *  直接填写整数
 */
#define ZFColor(r, g, b, a) [UIColor colorWithRed:r / 255.f green:g / 255.f blue:b / 255.f alpha:a]

/**
 *  随机颜色
 */
#define ZFRandomColor ZFColor(arc4random() % 256, arc4random() % 256, arc4random() % 256, 1)

#define NAVIGATIONBAR_HEIGHT 64.f
#define TABBAR_HEIGHT 49.f

/**
 *  角度求三角函数sin值
 *  @param a 角度
 */
#define ZFSin(a) sin(a / 180.f * M_PI)

/**
 *  角度求三角函数cos值
 *  @param a 角度
 */
#define ZFCos(a) cos(a / 180.f * M_PI)

/**
 *  角度求三角函数tan值
 *  @param a 角度
 */
#define ZFTan(a) tan(a / 180.f * M_PI)

/**
 *  弧度转角度
 *  @param radian 弧度
 */
#define ZFAngle(radian) (radian / M_PI * 180.f)

/**
 *  角度转弧度
 *  @param angle 角度
 */
#define ZFRadian(angle) (angle / 180.f * M_PI)

/**
 *  坐标轴起点x值
 */
#define ZFAxisLineStartXPos 50.f

/**
 *  y轴label tag值
 */
#define YLineValueLabelTag 100

/**
 *  x轴item宽度
 */
#define XLineItemWidth 25.f

/**
 *  x轴item间隔
 */
#define XLineItemGapLength 20.f


//#warning message - 此属性最好不要随意修改
/**
 *  坐标y轴最大上限值到箭头的间隔距离 (此属性最好不要随意修改)
 */
#define ZFAxisLineGapFromYLineMaxValueToArrow 20.f
