//
//  ZFTranslucencePath.h
//  demo
//  Created by yezhuge on 2017/12/1.
//  God bless me without no bugs.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface ZFTranslucencePath : CAShapeLayer

+ (instancetype)layerWithArcCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise;

- (instancetype)initWithArcCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise;

@end
