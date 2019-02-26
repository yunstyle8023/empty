//
//  ZFTranslucencePath.m
//  demo
//  Created by yezhuge on 2017/12/1.
//  God bless me without no bugs.
//

#import "ZFTranslucencePath.h"

@implementation ZFTranslucencePath

+ (instancetype)layerWithArcCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise{
    return [[ZFTranslucencePath alloc] initWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
}

- (instancetype)initWithArcCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise{
    self = [super init];
    if (self) {
        self.fillColor = nil;
        self.opacity = 0.5f;
        self.path = [self translucencePathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise].CGPath;
    }
    return self;
}

- (UIBezierPath *)translucencePathWithArcCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise{
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
    return bezierPath;
}
@end
