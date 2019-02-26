//
//  CA_MProjectContentSelectView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/3.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectContentSelectView.h"
#import "CA_MProjectModel.h"

#define ButtonTitles @[ @"追踪",\
                        @"待办",\
                        @"笔记",\
                        @"文件",\
                        @"进展"]

@interface CA_MProjectContentSelectView ()

@property (nonatomic,strong) UIImageView *sologanImgView;

@property (nonatomic,strong) UILabel *iconLb;

@property (nonatomic,strong) UILabel *titleLb;

@property (nonatomic,strong) UILabel *detailLb;

@property (nonatomic,strong) UIImageView *arrowImgView;

@property (nonatomic,strong) UIView *tapView;

@end

@implementation CA_MProjectContentSelectView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self upView];
        self.currenIndex = 0;
    }
    return self;
}

-(void)upView{
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.sologanImgView];
    self.sologanImgView.sd_layout
    .leftSpaceToView(self, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self, 5*2*CA_H_RATIO_WIDTH)
    .widthIs(25*2*CA_H_RATIO_WIDTH)
    .heightEqualToWidth();
    
    [self addSubview:self.iconLb];
    self.iconLb.sd_layout
    .leftEqualToView(self.sologanImgView)
    .rightEqualToView(self.sologanImgView)
    .centerYEqualToView(self.sologanImgView)
    .autoHeightRatio(0);
    
    [self addSubview:self.titleLb];
    self.titleLb.sd_layout
    .leftSpaceToView(self.sologanImgView, 5*2*CA_H_RATIO_WIDTH)
    .topEqualToView(self.sologanImgView).offset(1*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self, 22*2*CA_H_RATIO_WIDTH)
    .heightIs(11*2*CA_H_RATIO_WIDTH);
    
    [self addSubview:self.detailLb];
    self.detailLb.sd_layout
    .leftEqualToView(self.titleLb)
    .topSpaceToView(self.titleLb, 2*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self, 22*2*CA_H_RATIO_WIDTH)
    .heightIs(10*2*CA_H_RATIO_WIDTH);
    
    [self addSubview:self.arrowImgView];
    self.arrowImgView.sd_layout
    .rightSpaceToView(self, 10*2*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.sologanImgView)
    .widthIs(kImage(@"shape5").size.width)
    .heightIs(kImage(@"shape5").size.height);

    CGFloat buttonW = [[self.buttons firstObject] size].width;
    CGFloat buttonH = [[self.buttons firstObject] size].height;
    CGFloat margin = 20*2*CA_H_RATIO_WIDTH;
    CGFloat padding = ((CA_H_SCREEN_WIDTH-margin*2)-buttonW*self.buttons.count)/(self.buttons.count-1);
    [self.buttons enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addSubview:obj];
        obj.sd_layout
        .leftSpaceToView(self, margin+(buttonW+padding)*idx)
        .bottomSpaceToView(self, 5*2*CA_H_RATIO_WIDTH)
        .widthIs(buttonW)
        .heightIs(buttonH);
    }];

    [self addSubview:self.lineView];
    self.lineView.sd_layout
    .centerXEqualToView([self.buttons firstObject])
    .bottomEqualToView(self)
    .widthIs(buttonW/2)
    .heightIs(2);
    
    [self addSubview:self.tapView];
    self.tapView.sd_layout
    .leftEqualToView(self.sologanImgView)
    .topEqualToView(self.sologanImgView)
    .bottomEqualToView(self.sologanImgView)
    .rightEqualToView(self.arrowImgView);
}

-(void)setModel:(CA_MProjectModel *)model{
    _model = model;
    
    self.iconLb.hidden = [NSString isValueableString:model.project_logo];
    self.iconLb.text = [model.project_name substringToIndex:1];
    
    if ([NSString isValueableString:model.project_logo]) {
        NSString* logoUrl = @"";
        if ([model.project_logo hasPrefix:@"http"]) {
            logoUrl = model.project_logo;
        }else{
            logoUrl = [NSString stringWithFormat:@"%@%@",CA_H_SERVER_API,model.project_logo];
        }
        
        [self.sologanImgView setImageURL:[NSURL URLWithString:logoUrl]];
        self.sologanImgView.backgroundColor = CA_H_BACKCOLOR;
    }else {
        [self.sologanImgView setImageURL:[NSURL URLWithString:@""]];
        self.sologanImgView.backgroundColor = kColor(model.project_color);
    }
    
    self.titleLb.text = model.project_name;
    
    self.detailLb.text = [NSString isValueableString:model.brief_intro]?model.brief_intro:@"暂无";
}

-(void)didScroll:(CGFloat)x{
    //移动下划线
    CGFloat buttonW = [[self.buttons firstObject] size].width;
    CGFloat margin = 20*2*CA_H_RATIO_WIDTH;
    CGFloat padding = ((CA_H_SCREEN_WIDTH-margin*2)-buttonW*self.buttons.count)/(self.buttons.count-1);
    CGFloat origianlX = margin + buttonW / 2;
    self.lineView.centerX = origianlX + x / CA_H_SCREEN_WIDTH * (padding+buttonW);
    
    float ratio = (x / CA_H_SCREEN_WIDTH) - (int)(x / CA_H_SCREEN_WIDTH);

    UIView *line = self.lineView.subviews.firstObject;
    line.sd_layout.widthIs((1-2*fabs((ratio-0.5)))*padding
                           + (buttonW/2)*CA_H_RATIO_WIDTH);
}

-(void)didEndScroll:(CGFloat)x{
    
    self.currenIndex = x/CA_H_SCREEN_WIDTH;
    
    [self.buttons enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = (self.currenIndex==idx ? YES : NO);
    }];
    
}

-(void)buttonAction:(UIButton *)sender{
    
    if (self.currenIndex == sender.tag) return;
    
    self.currenIndex = sender.tag;
    
    [self.buttons enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = (self.currenIndex==idx ? YES : NO);
    }];
    
    self.didSelect ?self.didSelect(self.currenIndex):nil;
    
}

#pragma mark - getter and setter

-(UIView *)tapView{
    if (!_tapView) {
        _tapView = [UIView new];
        _tapView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            _jumpBlock?_jumpBlock():nil;
        }];
        [_tapView addGestureRecognizer:tapGesture];
    }
    return _tapView;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = CA_H_TINTCOLOR;
        UIView *line = [UIView new];
        line.backgroundColor = CA_H_TINTCOLOR;
        line.layer.cornerRadius = 1*CA_H_RATIO_WIDTH;
        line.layer.masksToBounds = YES;
        [_lineView addSubview:line];
        line.sd_layout
        .heightIs(2)
        .widthIs(8*2*CA_H_RATIO_WIDTH)
        .centerXEqualToView(_lineView)
        .centerYEqualToView(_lineView);
    }
    return _lineView;
}

-(NSMutableArray<UIButton *> *)collectionButtons{
    NSMutableArray *buttons = @[].mutableCopy;
    
    [ButtonTitles enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton new];
        button.selected = !idx;
        button.tag = idx;
        [button configTitle:obj
                 titleColor:CA_H_9GRAYCOLOR
                       font:16];
        [button setTitleColor:CA_H_TINTCOLOR
                     forState:UIControlStateSelected];
        [button addTarget:self
                   action:@selector(buttonAction:)
         forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        [buttons addObject:button];
    }];
    
    return buttons;
}

-(NSMutableArray<UIButton *> *)buttons{
    if (!_buttons) {
        _buttons = [self collectionButtons];
    }
    return _buttons;
}

-(UIImageView *)arrowImgView{
    if (!_arrowImgView) {
        _arrowImgView = [UIImageView new];
        _arrowImgView.image = kImage(@"shape5");
        _arrowImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _arrowImgView;
}

-(UILabel *)detailLb{
    if (!_detailLb) {
        _detailLb = [UILabel new];
        [_detailLb configText:@""
                   textColor:CA_H_9GRAYCOLOR
                        font:14];
    }
    return _detailLb;
}

-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        [_titleLb configText:@""
                  textColor:CA_H_4BLACKCOLOR
                       font:16];
    }
    return _titleLb;
}

-(UILabel *)iconLb{
    if (!_iconLb) {
        _iconLb = [UILabel new];
        _iconLb.textAlignment = NSTextAlignmentCenter;
        [_iconLb configText:@""
                  textColor:kColor(@"#FFFFFF")
                       font:20];
    }
    return _iconLb;
}

-(UIImageView *)sologanImgView{
    if (!_sologanImgView) {
        _sologanImgView = [UIImageView new];
        _sologanImgView.contentMode = UIViewContentModeScaleAspectFit;
        _sologanImgView.layer.cornerRadius = 2*2*CA_H_RATIO_WIDTH;
        _sologanImgView.layer.masksToBounds = YES;
    }
    return _sologanImgView;
}

@end
