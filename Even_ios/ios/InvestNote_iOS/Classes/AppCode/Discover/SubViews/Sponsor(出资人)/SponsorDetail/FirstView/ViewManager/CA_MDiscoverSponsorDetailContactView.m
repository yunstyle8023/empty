//
//  CA_MDiscoverSponsorDetailContactView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverSponsorDetailContactView.h"
#import "CA_MDiscoverSponsorDetailModel.h"

@interface CA_MDiscoverSponsorDetailContactView ()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UILabel *contactLb;
@property (nonatomic,strong) UILabel *person;
@property (nonatomic,strong) UILabel *personLb;
@property (nonatomic,strong) UILabel *email;
@property (nonatomic,strong) UILabel *emailLb;
@property (nonatomic,strong) UILabel *tel;
@property (nonatomic,strong) UILabel *telLb;
@property (nonatomic,strong) UILabel *messageLb;
@property (nonatomic,strong) UIButton *closeBtn;

//
@property (nonatomic,strong) UIView *coverViewPerson;
@property (nonatomic,strong) UIView *coverViewEmail;
@property (nonatomic,strong) UIView *coverViewTel;
@end

@implementation CA_MDiscoverSponsorDetailContactView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.hidden = YES;
        [self upView];
        [self setConstrains];
    }
    return self;
}

-(void)upView{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bgView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.contactLb];
    [self.contentView addSubview:self.person];
    [self.contentView addSubview:self.personLb];
    [self.contentView addSubview:self.email];
    [self.contentView addSubview:self.emailLb];
    [self.contentView addSubview:self.tel];
    [self.contentView addSubview:self.telLb];
    [self.contentView addSubview:self.messageLb];
    [self.contentView addSubview:self.closeBtn];
    //
    [self.contentView addSubview:self.coverViewPerson];
    [self.contentView addSubview:self.coverViewEmail];
    [self.contentView addSubview:self.coverViewTel];
}

-(void)setConstrains{
    self.bgView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    
    self.contentView.sd_layout
    .centerXEqualToView(self)
    .centerYEqualToView(self)
    .widthIs(138*2*CA_H_RATIO_WIDTH);
    
    self.contactLb.sd_layout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.contactLb setSingleLineAutoResizeWithMaxWidth:0];
    
    self.person.sd_layout
    .leftEqualToView(self.contactLb)
    .topSpaceToView(self.contactLb, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.person setSingleLineAutoResizeWithMaxWidth:0];
    
    self.personLb.sd_layout
    .leftSpaceToView(self.contentView, 49*2*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.person)
    .autoHeightRatio(0);
    [self.personLb setSingleLineAutoResizeWithMaxWidth:0];

    self.email.sd_layout
    .leftEqualToView(self.person)
    .topSpaceToView(self.person, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.email setSingleLineAutoResizeWithMaxWidth:0];

    self.emailLb.sd_layout
    .leftSpaceToView(self.contentView, 49*2*CA_H_RATIO_WIDTH)
    .topEqualToView(self.email)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.emailLb setMaxNumberOfLinesToShow:0];

    self.tel.sd_layout
    .leftEqualToView(self.email)
    .topSpaceToView(self.emailLb, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.tel setSingleLineAutoResizeWithMaxWidth:0];
    
    self.telLb.sd_layout
    .leftSpaceToView(self.contentView, 49*2*CA_H_RATIO_WIDTH)
    .topEqualToView(self.tel)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.telLb setMaxNumberOfLinesToShow:0];
    
    self.messageLb.sd_layout
    .leftEqualToView(self.tel)
    .topSpaceToView(self.telLb, 8*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.messageLb setSingleLineAutoResizeWithMaxWidth:0];
    
    self.closeBtn.sd_layout
    .centerXEqualToView(self.contentView)
    .topSpaceToView(self.messageLb, 10*2*CA_H_RATIO_WIDTH)
    .widthIs(55*2*CA_H_RATIO_WIDTH)
    .heightIs(19*2*CA_H_RATIO_WIDTH);
    
    [self.contentView setupAutoHeightWithBottomView:self.closeBtn bottomMargin:10*2*CA_H_RATIO_WIDTH];
    
    
    //
    self.coverViewPerson.sd_layout
    .leftSpaceToView(self.contentView, 49*2*CA_H_RATIO_WIDTH)
    .topEqualToView(self.person)
    .widthIs(25*2*CA_H_RATIO_WIDTH)
    .heightIs(11*2*CA_H_RATIO_WIDTH);
    
    self.coverViewEmail.sd_layout
    .leftSpaceToView(self.contentView, 49*2*CA_H_RATIO_WIDTH)
    .topEqualToView(self.email)
    .widthIs(79*2*CA_H_RATIO_WIDTH)
    .heightIs(11*2*CA_H_RATIO_WIDTH);
    
    self.coverViewTel.sd_layout
    .leftSpaceToView(self.contentView, 49*2*CA_H_RATIO_WIDTH)
    .topEqualToView(self.tel)
    .widthIs(79*2*CA_H_RATIO_WIDTH)
    .heightIs(11*2*CA_H_RATIO_WIDTH);
}

-(void)setIs_imported:(BOOL)is_imported{
    _is_imported = is_imported;
    
    if (is_imported) {
       [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        self.coverViewPerson.hidden = YES;
        self.coverViewEmail.hidden = YES;
        self.coverViewTel.hidden = YES;
    }else{
        [_closeBtn setTitle:@"确认查看" forState:UIControlStateNormal];
        self.coverViewPerson.hidden = NO;
        self.coverViewEmail.hidden = NO;
        self.coverViewTel.hidden = NO;
    }
}

-(void)setContact_data:(CA_MDiscoverSponsorContact_data *)contact_data{
    _contact_data = contact_data;
    
    self.personLb.text = [NSString isValueableString:contact_data.contact_name]?contact_data.contact_name:@"暂无";
    self.emailLb.text = [NSString isValueableString:contact_data.contact_email]?contact_data.contact_email:@"暂无";
    self.telLb.text = [NSString isValueableString:contact_data.contact_tel]?contact_data.contact_tel:@"暂无";
    
    if (self.is_imported) {
        self.messageLb.hidden = YES;
    }else{
        self.messageLb.hidden = NO;
    }
}

-(void)setCount:(NSNumber *)count{
    _count = count;
    NSString *str = [NSString stringWithFormat:@"今天还有 %@ 次机会（每天10次机会)",count];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attr addAttribute:NSFontAttributeName value:CA_H_FONT_PFSC_Regular(14) range:NSMakeRange(0, str.length)];
    
    [attr addAttribute:NSForegroundColorAttributeName value:CA_H_9GRAYCOLOR range:NSMakeRange(0, 4)];
    [attr addAttribute:NSForegroundColorAttributeName value:CA_H_TINTCOLOR range:NSMakeRange(4, str.length-16)];
    
    
    [attr addAttribute:NSForegroundColorAttributeName value:CA_H_9GRAYCOLOR range:NSMakeRange((str.length - 16)+4, 12)];
    
    self.messageLb.attributedText = attr;
    
}

-(void)closeBtnAction{
    
    if (self.is_imported) {
        self.hidden = YES;
    }else{
        [CA_HProgressHUD showHud:self text:@""];
        [CA_HNetManager postUrlStr:CA_M_QueryLpContact parameters:@{@"data_id":self.data_id} callBack:^(CA_HNetModel *netModel) {
            if (netModel.type == CA_H_NetTypeSuccess) {
                if (netModel.errcode.intValue == 0) {
                    
                    self.coverViewPerson.hidden = YES;
                    self.coverViewEmail.hidden = YES;
                    self.coverViewTel.hidden = YES;
                    
                    self.personLb.text = [NSString isValueableString:netModel.data[@"contact_name"]]?netModel.data[@"contact_name"]:@"暂无";
                    self.emailLb.text = [NSString isValueableString:netModel.data[@"contact_email"]]?netModel.data[@"contact_email"]:@"暂无";
                    self.telLb.text = [NSString isValueableString:netModel.data[@"contact_tel"]]?netModel.data[@"contact_tel"]:@"暂无";
                    
                    self.count = netModel.data[@"import_count"];
                    
                    self.is_imported = YES;
                    
                    if (self.lookBlock) {
                        self.lookBlock(self.count);
                    }
                }
            }
            [CA_HProgressHUD hideHud:self];
        } progress:nil];
    }
}

#pragma mark - getter and setter

-(UIView *)coverViewTel{
    if (!_coverViewTel) {
        _coverViewTel = [UIView new];
        _coverViewTel.backgroundColor = CA_H_BACKCOLOR;
        _coverViewTel.layer.cornerRadius = 2*2*CA_H_RATIO_WIDTH;
        _coverViewTel.layer.masksToBounds = YES;
    }
    return _coverViewTel;
}

-(UIView *)coverViewEmail{
    if (!_coverViewEmail) {
        _coverViewEmail = [UIView new];
        _coverViewEmail.backgroundColor = CA_H_BACKCOLOR;
        _coverViewEmail.layer.cornerRadius = 2*2*CA_H_RATIO_WIDTH;
        _coverViewEmail.layer.masksToBounds = YES;
    }
    return _coverViewEmail;
}

-(UIView *)coverViewPerson{
    if (!_coverViewPerson) {
        _coverViewPerson = [UIView new];
        _coverViewPerson.backgroundColor = CA_H_BACKCOLOR;
        _coverViewPerson.layer.cornerRadius = 2*2*CA_H_RATIO_WIDTH;
        _coverViewPerson.layer.masksToBounds = YES;
    }
    return _coverViewPerson;
}

-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
        _closeBtn.layer.cornerRadius = 2*2*CA_H_RATIO_WIDTH;
        _closeBtn.layer.masksToBounds = YES;
        _closeBtn.backgroundColor = CA_H_TINTCOLOR;
        _closeBtn.titleLabel.font = CA_H_FONT_PFSC_Regular(16);
        [_closeBtn setTitleColor:kColor(@"#FFFFFF") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}
-(UILabel *)messageLb{
    if (!_messageLb) {
        _messageLb = [UILabel new];
        _messageLb.text = @"今天还有 10 次机会（每天10次机会)";
    }
    return _messageLb;
}
-(UILabel *)telLb{
    if (!_telLb) {
        _telLb = [UILabel new];
        _telLb.numberOfLines = 0;
        [_telLb configText:@" "
                   textColor:CA_H_4BLACKCOLOR
                        font:16];
    }
    return _telLb;
}
-(UILabel *)tel{
    if (!_tel) {
        _tel = [UILabel new];
        [_tel configText:@"电话"
                 textColor:CA_H_6GRAYCOLOR
                      font:16];
    }
    return _tel;
}
-(UILabel *)emailLb{
    if (!_emailLb) {
        _emailLb = [UILabel new];
        _emailLb.numberOfLines = 0;
        [_emailLb configText:@" "
                    textColor:CA_H_4BLACKCOLOR
                         font:16];
    }
    return _emailLb;
}
-(UILabel *)email{
    if (!_email) {
        _email = [UILabel new];
        [_email configText:@"邮箱"
                  textColor:CA_H_6GRAYCOLOR
                       font:16];
    }
    return _email;
}
-(UILabel *)personLb{
    if (!_personLb) {
        _personLb = [UILabel new];
        [_personLb configText:@" "
                  textColor:CA_H_4BLACKCOLOR
                       font:16];
    }
    return _personLb;
}
-(UILabel *)person{
    if (!_person) {
        _person = [UILabel new];
        [_person configText:@"联系人"
                  textColor:CA_H_6GRAYCOLOR
                       font:16];
    }
    return _person;
}
-(UILabel *)contactLb{
    if (!_contactLb) {
        _contactLb = [UILabel new];
        _contactLb.text = @"联系方式";
        _contactLb.textColor = CA_H_4BLACKCOLOR;
        _contactLb.font = CA_H_FONT_PFSC_Medium(20);
    }
    return _contactLb;
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
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = kColor(@"#04040F");
        _bgView.alpha = 0.34;
        CA_H_WeakSelf(self)
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            CA_H_StrongSelf(self)
            self.hidden = YES;
        }];
        [_bgView addGestureRecognizer:tapGesture];
    }
    return _bgView;
}

@end
