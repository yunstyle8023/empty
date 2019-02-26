
//
//  CA_MCaptchaView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/1/17.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MCaptchaView.h"

#define kCharCount 4
#define kFontSize [UIFont systemFontOfSize:arc4random() % 5 + 15]

@interface CA_MCaptchaView ()
@property(nonatomic,strong)NSMutableArray* changeArray; //字符素材数组
@end

@implementation CA_MCaptchaView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kColor(@"#F6D17B");
        [self getChangeStr];
    }
    return self;
}

-(void)getChangeStr{
    NSMutableString *getStr = [[NSMutableString alloc] initWithCapacity:kCharCount];
    self.changeString = [[NSMutableString alloc] initWithCapacity:kCharCount];
    for(int i = 0; i < kCharCount; i++){
        NSInteger index = arc4random() % ([self.changeArray count] - 1);
        getStr = [self.changeArray objectAtIndex:index];
        self.changeString = (NSMutableString *)[self.changeString stringByAppendingString:getStr];
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.backgroundColor = kColor(@"#F6D17B");
    
    //获得要显示验证码字符串，根据长度，计算每个字符显示的大概位置
    NSString *text = [NSString stringWithFormat:@"%@",self.changeString];
    CGSize cSize = [@"S" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    int width = rect.size.width / text.length - cSize.width;
    int height = rect.size.height - cSize.height;
    CGPoint point;
    
    //依次绘制每一个字符,可以设置显示的每个字符的字体大小、颜色、样式等
    float pX, pY;
    for (int i = 0; i < text.length; i++){
        pX = arc4random() % width + rect.size.width / text.length * i;
        pY = arc4random() % height;
        point = CGPointMake(pX, pY);
        unichar c = [text characterAtIndex:i];
        NSString *textC = [NSString stringWithFormat:@"%C", c];
        [textC drawAtPoint:point withAttributes:@{NSFontAttributeName:kFontSize,NSForegroundColorAttributeName:kColor(@"#FFFFFF")}];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self getChangeStr];
    [self setNeedsDisplay];
}

-(void)changeCaptcha{
    [self getChangeStr];
    [self setNeedsDisplay];
}

-(NSMutableArray *)changeArray{
    if (!_changeArray) {
        _changeArray = [[NSMutableArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",nil];
    }
    return _changeArray;
}

@end
