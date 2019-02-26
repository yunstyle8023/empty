//
//  CA_MPersonDetailSectionView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/12.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MPersonDetailSectionView.h"

typedef enum : NSUInteger {
    CA_MPersonDetailTag_detail,
    CA_MPersonDetailTag_log,
    CA_MPersonDetailTag_file,
} CA_MPersonDetailTag;

@interface CA_MPersonDetailSectionView ()

@property (nonatomic,strong) UIButton *detailBtn;
@property (nonatomic,strong) UIButton *logBtn;
@property (nonatomic,strong) UIButton *fileBtn;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) NSMutableArray *buttons;
@property (nonatomic,strong) UIButton *currentBtn;
@end

@implementation CA_MPersonDetailSectionView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.currentBtn = self.detailBtn;
    }
    return self;
}

-(void)setupUI{
    [self addSubview:self.bgView];
    [self addSubview:self.detailBtn];
    [self addSubview:self.logBtn];
    [self addSubview:self.fileBtn];
    [self addSubview:self.lineView];
}

-(void)layoutSubviews{
    [super layoutSubviews];

    [self.logBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];

    [self.detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.trailing.mas_equalTo(self.logBtn.mas_leading).offset(-44*CA_H_RATIO_WIDTH);
    }];

    [self.fileBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.leading.mas_equalTo(self.logBtn.mas_trailing).offset(44*CA_H_RATIO_WIDTH);
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.detailBtn);
        make.bottom.mas_equalTo(self).offset(-3);
        make.width.mas_equalTo(16*CA_H_RATIO_WIDTH);
        make.height.mas_equalTo(2);
    }];
}

-(void)changeLineView:(CGFloat)x{

    CGFloat origianlX = self.detailBtn.mj_x + self.detailBtn.mj_w / 2;
    CGFloat margin = CA_H_SCREEN_WIDTH/2 - origianlX;
    self.lineView.centerX = origianlX + x / CA_H_SCREEN_WIDTH * margin;
    
    UIView *line = self.lineView.subviews.firstObject;
    float ratio = (x / CA_H_SCREEN_WIDTH) - (int)(x / CA_H_SCREEN_WIDTH);
    line.sd_layout.widthIs((1-2*fabs((ratio-0.5)))*margin
                           + 16*CA_H_RATIO_WIDTH);
    
}


-(void)changeButton:(NSInteger)index{
    self.currentBtn = self.buttons[index];
    for (UIButton*btn in self.buttons) {
        if (btn != self.currentBtn) {
            btn.selected = NO;
        }else{
            btn.selected = YES;
        }
    }
}

-(void)buttonClick:(UIButton*)button{
    
    if (button == self.currentBtn) {
        return;
    }

//    button.selected = !button.isSelected;
    self.currentBtn = button;

    for (UIButton*btn in self.buttons) {
        if (btn != self.currentBtn) {
            btn.selected = NO;
        }else{
            btn.selected = YES;
        }
    }

    //移动view
    if (self.changeBlock) {
        self.changeBlock(self.currentBtn.tag);
    }

    //移动下划线
    [UIView animateWithDuration:0.25 animations:^{
        self.lineView.centerX = self.currentBtn.centerX;
    }];
}

#pragma mark - getter and setter
-(UIView *)bgView{
    if (_bgView) {
        return _bgView;
    }
    CGRect rect = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, 40*CA_H_RATIO_WIDTH);
    _bgView = [[UIView alloc] initWithFrame:rect];
    _bgView.backgroundColor = kColor(@"#FFFFFF");
    [CA_HShadow dropShadowWithView:_bgView
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.2];
    return _bgView;
}
-(UIView *)lineView{
    if (_lineView) {
        return _lineView;
    }
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = CA_H_TINTCOLOR;
    UIView *line = [UIView new];
    line.backgroundColor = CA_H_TINTCOLOR;
    line.layer.cornerRadius = 1*CA_H_RATIO_WIDTH;
    line.layer.masksToBounds = YES;
    [_lineView addSubview:line];
    line.sd_layout
    .heightIs(2)
    .widthIs(16*CA_H_RATIO_WIDTH)
    .centerXEqualToView(_lineView)
    .centerYEqualToView(_lineView);
    return _lineView;
}
-(NSMutableArray *)buttons{
    if (_buttons) {
        return _buttons;
    }
    _buttons = @[].mutableCopy;
    [_buttons addObjectsFromArray:@[self.detailBtn,self.logBtn,self.fileBtn]];
    return _buttons;
}
-(UIButton*)createButton:(NSString*)title selected:(BOOL)selected tag:(CA_MPersonDetailTag)tag{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
    [button setTitleColor:CA_H_TINTCOLOR forState:UIControlStateSelected];
    button.titleLabel.font = CA_H_FONT_PFSC_Regular(16);
    button.selected = selected;
    button.tag = tag;
    [button addTarget:self
               action:@selector(buttonClick:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}
-(UIButton *)fileBtn{
    if (_fileBtn) {
        return _fileBtn;
    }
    _fileBtn = [self createButton:@"文件" selected:NO  tag:CA_MPersonDetailTag_file];
    return _fileBtn;
}
-(UIButton *)logBtn{
    if (_logBtn) {
        return _logBtn;
    }
    _logBtn = [self createButton:@"拜访记录" selected:NO tag:CA_MPersonDetailTag_log];
    return _logBtn;
}
-(UIButton *)detailBtn{
    if (_detailBtn) {
        return _detailBtn;
    }
    _detailBtn = [self createButton:@"详情" selected:YES tag:CA_MPersonDetailTag_detail];
    return _detailBtn;
}
@end
