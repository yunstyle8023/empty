//
//  CA_MProjectNotFoundView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectNotFoundView.h"
#import "CXAHyperlinkLabel.h"

@interface CA_MProjectNotFoundView ()

@property (nonatomic,strong) UIToolbar *toolbar;

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) CXAHyperlinkLabel *messageLb;

@property (nonatomic,strong) UIButton *finishedBtn;

@end

@implementation CA_MProjectNotFoundView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self upView];
    }
    return self;
}

-(void)upView{
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.toolbar];
    self.toolbar.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    
    [self addSubview:self.contentView];
    self.contentView.sd_layout
    .leftSpaceToView(self, 25*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self, 99*2*CA_H_RATIO_WIDTH)
    .widthIs(138*2*CA_H_RATIO_WIDTH)
    .heightIs(102*2*CA_H_RATIO_WIDTH);

    self.messageLb.frame = CGRectMake(35*2*CA_H_RATIO_WIDTH, 114*2*CA_H_RATIO_WIDTH, 118*2*CA_H_RATIO_WIDTH, 45*2*CA_H_RATIO_WIDTH);
//    self.messageLb.isAttributedContent = YES;
    [self addSubview:self.messageLb];
//    self.messageLb.sd_layout
//    .leftSpaceToView(self, 35*2*CA_H_RATIO_WIDTH)
//    .topSpaceToView(self, 114*2*CA_H_RATIO_WIDTH)
//    .rightSpaceToView(self, 0*2*CA_H_RATIO_WIDTH)
//    .autoHeightRatio(0);
//    [self.messageLb setMaxNumberOfLinesToShow:0];

    [self addSubview:self.finishedBtn];
    self.finishedBtn.sd_layout
    .topSpaceToView(self.messageLb, 13*2*CA_H_RATIO_WIDTH)
    .centerXEqualToView(self.contentView)
    .widthIs(55*2*CA_H_RATIO_WIDTH)
    .heightIs(19*2*CA_H_RATIO_WIDTH);
    
}


-(void)showView{
    self.frame = CA_H_MANAGER.mainWindow.frame;
    [CA_H_MANAGER.mainWindow addSubview:self];
}

-(void)hideView{
    [self removeFromSuperview];
}

-(void)finishedBtnAction:(UIButton *)sender{
    [self hideView];
    _finishedBlock?_finishedBlock(sender):nil;
}

#pragma mark - getter and setter

-(UIButton *)finishedBtn{
    if (!_finishedBtn) {
        _finishedBtn = [UIButton new];
        _finishedBtn.backgroundColor = CA_H_TINTCOLOR;
        _finishedBtn.layer.cornerRadius = 2*2*CA_H_RATIO_WIDTH;
        _finishedBtn.layer.masksToBounds = YES;
        [_finishedBtn configTitle:@"完成"
                       titleColor:[UIColor whiteColor]
                             font:16];
        [_finishedBtn addTarget:self action:@selector(finishedBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishedBtn;
}

-(CXAHyperlinkLabel *)messageLb{
    if (!_messageLb) {
        _messageLb = [CXAHyperlinkLabel new];
        _messageLb.numberOfLines = 0;
        _messageLb.textAlignment = NSTextAlignmentCenter;
        [_messageLb configText:@"外部项目数据库为动态更新的数据库，如找不到想要的项目，可联系客服：400-770-8988"
                     textColor:CA_H_9GRAYCOLOR
                          font:16];
        [_messageLb changeLineSpaceWithSpace:6];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]
                                             initWithAttributedString:_messageLb.attributedText];
        [attStr addAttribute:NSForegroundColorAttributeName value:CA_H_TINTCOLOR range:NSMakeRange(_messageLb.attributedText.length-12, 12)];
        [attStr addAttribute:NSForegroundColorAttributeName value:CA_H_9GRAYCOLOR range:NSMakeRange(0, _messageLb.attributedText.length-12)];
        [attStr addAttribute:NSFontAttributeName value:CA_H_FONT_PFSC_Regular(16) range:NSMakeRange(0, _messageLb.attributedText.length)];
        _messageLb.attributedText = attStr;
        [_messageLb setURL:[NSURL URLWithString:@""] forRange:NSMakeRange(_messageLb.attributedText.length-12, 12)];
        _messageLb.linkAttributesWhenTouching = nil;
        _messageLb.URLClickHandler = ^(CXAHyperlinkLabel *label, NSURL *URL, NSRange textRange, NSArray *textRects) {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"400-770-8988"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        };
    }
    return _messageLb;
}

-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = kColor(@"#FFFFFF");
        _contentView.layer.cornerRadius = 5*2*CA_H_RATIO_WIDTH;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

-(UIToolbar *)toolbar{
    if (!_toolbar) {
        _toolbar = [UIToolbar new];
        _toolbar.barStyle = UIBarStyleBlack;
        _toolbar.alpha = 0.35;
    }
    return _toolbar;
}

@end
