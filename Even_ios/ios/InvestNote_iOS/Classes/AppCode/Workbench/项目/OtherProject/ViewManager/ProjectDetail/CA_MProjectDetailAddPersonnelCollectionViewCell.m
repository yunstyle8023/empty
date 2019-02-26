//
//  CA_MProjectDetailAddPersonnelCollectionViewCell.m
//  InvestNote_iOS
//
//  Created by yezhuge on 2017/12/22.
//  Copyright © 2017年 yezhuge. All rights reserved.
//

typedef enum tagBorderType
{
    BorderTypeDashed,
    BorderTypeSolid
}BorderType;

@interface DashesLineView : UIView
{
    CAShapeLayer *_shapeLayer;
    BorderType _borderType;
    CGFloat _cornerRadius;
    CGFloat _borderWidth;
    NSUInteger _dashPattern;
    NSUInteger _spacePattern;
    UIColor *_borderColor;
}

@property (assign, nonatomic) BorderType borderType;
@property (assign, nonatomic) CGFloat cornerRadius;
@property (assign, nonatomic) CGFloat borderWidth;
@property (assign, nonatomic) NSUInteger dashPattern;
@property (assign, nonatomic) NSUInteger spacePattern;
@property (strong, nonatomic) UIColor *borderColor;
@end

@implementation DashesLineView

@synthesize borderType = _borderType;
@synthesize cornerRadius = _cornerRadius;
@synthesize borderWidth = _borderWidth;
@synthesize dashPattern = _dashPattern;
@synthesize spacePattern = _spacePattern;
@synthesize borderColor = _borderColor;

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self drawDashedBorder];
    }
    return self;
}

#pragma mark - Drawing

- (void)drawDashedBorder{
    if (_shapeLayer) [_shapeLayer removeFromSuperlayer];
    
    //border definitions
    CGFloat cornerRadius = _cornerRadius;
    CGFloat borderWidth = _borderWidth;
    NSInteger dashPattern1 = _dashPattern;
    NSInteger dashPattern2 = _spacePattern;
    UIColor *lineColor = _borderColor ? _borderColor : kColor(@"#DDDDDD");
    
    //drawing
    CGRect frame = self.bounds;
    
    _shapeLayer = [CAShapeLayer layer];
    
    //creating a path
    CGMutablePathRef path = CGPathCreateMutable();
    
    //drawing a border around a view
    CGPathMoveToPoint(path, NULL, 0, frame.size.height - cornerRadius);
    CGPathAddLineToPoint(path, NULL, 0, cornerRadius);
    CGPathAddArc(path, NULL, cornerRadius, cornerRadius, cornerRadius, M_PI, -M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width - cornerRadius, 0);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, cornerRadius, cornerRadius, -M_PI_2, 0, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width, frame.size.height - cornerRadius);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, frame.size.height - cornerRadius, cornerRadius, 0, M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, cornerRadius, frame.size.height);
    CGPathAddArc(path, NULL, cornerRadius, frame.size.height - cornerRadius, cornerRadius, M_PI_2, M_PI, NO);
    
    //path is set as the _shapeLayer object's path
    _shapeLayer.path = path;
    CGPathRelease(path);
    
    _shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
    _shapeLayer.frame = frame;
    _shapeLayer.masksToBounds = NO;
    [_shapeLayer setValue:[NSNumber numberWithBool:NO] forKey:@"isCircle"];
    _shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    _shapeLayer.strokeColor = [lineColor CGColor];
    _shapeLayer.lineWidth = borderWidth;
    _shapeLayer.lineDashPattern = _borderType == BorderTypeDashed ? [NSArray arrayWithObjects:[NSNumber numberWithInt:dashPattern1], [NSNumber numberWithInt:dashPattern2], nil] : nil;
    _shapeLayer.lineCap = kCALineCapRound;
    
    //_shapeLayer is added as a sublayer of the view
    [self.layer addSublayer:_shapeLayer];
    self.layer.cornerRadius = cornerRadius;
}

#pragma mark - Setters

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self drawDashedBorder];
}

- (void)setBorderType:(BorderType)borderType{
    _borderType = borderType;
    [self drawDashedBorder];
}

- (void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    [self drawDashedBorder];
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    _borderWidth = borderWidth;
    [self drawDashedBorder];
}

- (void)setDashPattern:(NSUInteger)dashPattern{
    _dashPattern = dashPattern;
    [self drawDashedBorder];
}

- (void)setSpacePattern:(NSUInteger)spacePattern{
    _spacePattern = spacePattern;
    [self drawDashedBorder];
}

- (void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    [self drawDashedBorder];
}

@end

#import "CA_MProjectDetailAddPersonnelCollectionViewCell.h"

@interface CA_MProjectDetailAddPersonnelCollectionViewCell()
@property(nonatomic,strong)DashesLineView* bgView;
@property(nonatomic,strong)UIButton* addBtn;
@property(nonatomic,strong)UILabel* addLb;
@end

@implementation CA_MProjectDetailAddPersonnelCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.addBtn];
    [self.contentView addSubview:self.addLb];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
//    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.mas_equalTo(self.contentView);
//        make.top.mas_equalTo(self.contentView);
//        make.width.mas_equalTo((110-5)*CA_H_RATIO_WIDTH);
//        make.height.mas_equalTo(146*CA_H_RATIO_WIDTH);
//    }];
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView);
        make.top.mas_equalTo(self.contentView).offset(30);
    }];
    
    [self.addLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView);
        make.top.mas_equalTo(self.addBtn.mas_bottom).offset(15);
    }];
}

-(void)addBtnAction{
    if (self.block) {
        self.block();
    }
}

-(UILabel *)addLb{
    if (_addLb) {
        return _addLb;
    }
    _addLb = [[UILabel alloc] init];
    [_addLb configText:@"添加人员" textColor:CA_H_9GRAYCOLOR font:14];
    return _addLb;
}
-(UIButton *)addBtn{
    if (_addBtn) {
        return _addBtn;
    }
    _addBtn = [[UIButton alloc] init];
    [_addBtn setBackgroundImage:kImage(@"add3") forState:UIControlStateNormal];
    [_addBtn setBackgroundImage:kImage(@"add3") forState:UIControlStateHighlighted];
    [_addBtn addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
    return _addBtn;
}
-(DashesLineView *)bgView{
    if (_bgView) {
        return _bgView;
    }
    _bgView = [[DashesLineView alloc] initWithFrame:CGRectMake(0, 2, (110-5)*CA_H_RATIO_WIDTH, 146*CA_H_RATIO_WIDTH)];
    _bgView.borderType = BorderTypeDashed;
    _bgView.dashPattern = 4;
    _bgView.spacePattern = 4;
    _bgView.borderWidth = 1.5;
    _bgView.cornerRadius = 6;
    return _bgView;
}
@end
