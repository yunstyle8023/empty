//
//  CA_MProjectProgressCell.m
//  InvestNote_iOS
//  Created by yezhuge on 2017/12/12.
//  God bless me without no bugs.
//

#import "CA_MProjectRecordCell.h"

@interface CA_MProjectRecordCell(){
    CGFloat _margin;
}
/// 原点
@property(nonatomic,strong)UIView* circleView;
@property(nonatomic,strong)UIView* circleBgView;
/// 细线
@property(nonatomic,strong)UIView* lineView;
/// 时间
@property(nonatomic,strong)UILabel* timeLb;
/// 项目状态(项目激活/放弃项目...)
@property(nonatomic,strong)UILabel* stateLb;
/// 申请人
@property (nonatomic,strong) UILabel *applyLb;
/// 操作人头像
@property (nonatomic,strong) UIImageView *iconImgView;
/// 操作人
@property(nonatomic,strong)UILabel* personLb;
/// 理由
@property(nonatomic,strong)UILabel* reasonLb;
@end

@implementation CA_MProjectRecordCell

#pragma mark - Init

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - SetupUI

- (void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.circleBgView];
    [self.contentView addSubview:self.circleView];
    [self.contentView addSubview:self.timeLb];
    [self.contentView addSubview:self.stateLb];
    [self.contentView addSubview:self.applyLb];
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.personLb];
    [self.contentView addSubview:self.reasonLb];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.circleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(self.contentView).offset(20);
        make.height.width.mas_equalTo(18);
    }];
    
    [self.circleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.circleBgView);
        make.height.width.mas_equalTo(12);
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.centerX.mas_equalTo(self.circleView);
        make.width.mas_equalTo(CA_H_LINE_Thickness);
    }];
    
    [self.timeLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.circleBgView);
        make.leading.mas_equalTo(self.circleView.mas_trailing).offset(10);
    }];
    
    [self.stateLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLb.mas_bottom).offset(10);
        make.leading.mas_equalTo(self.timeLb);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
    }];
    
    [self.reasonLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.stateLb.mas_bottom).offset(10);
        make.leading.mas_equalTo(self.stateLb);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
    }];
    
    [self.applyLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.reasonLb.mas_bottom).offset(_margin);
        make.leading.mas_equalTo(self.reasonLb);
    }];
    
    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.applyLb);
        make.leading.mas_equalTo(self.applyLb.mas_trailing).offset(5);
        //
        make.width.height.mas_equalTo(20);
    }];

    [self.personLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconImgView);
        make.leading.mas_equalTo(self.iconImgView.mas_trailing).offset(5);
//        make.trailing.mas_equalTo(self.contentView).offset(-20);
    }];
    
}

#pragma mark - Public

- (CGFloat)configCell:(CA_MProcedure_logModel*)model
            indexPath:(NSIndexPath*)indexPath
             totalRow:(NSInteger)totalRow{
    
    if (indexPath.row == 0) {
        self.circleBgView.hidden = NO;
    }else{
        self.circleBgView.hidden = YES;
    }
    
    if (indexPath.row == totalRow - 1) {
        self.lineView.hidden = YES;
    }else{
        self.lineView.hidden = NO;
    }
    
    if (![NSString isValueableString:model.sub_title]){
        self.reasonLb.hidden = YES;
        self.reasonLb.attributedText = [[NSAttributedString alloc] initWithString:@""];
    }else{
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paraStyle.alignment = NSTextAlignmentLeft;
        paraStyle.lineSpacing = 1.5f; //设置行间距
        paraStyle.hyphenationFactor = 1.0;
        paraStyle.firstLineHeadIndent = 0.0;
        paraStyle.paragraphSpacingBefore = 0.0;
        paraStyle.headIndent = 0;
        paraStyle.tailIndent = 0;
        NSDictionary *dic = @{NSFontAttributeName:CA_H_FONT_PFSC_Regular(14), NSParagraphStyleAttributeName:paraStyle};
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:model.sub_title attributes:dic];
        self.reasonLb.hidden = NO;
        self.reasonLb.attributedText = attributeStr;
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.ts_create.longValue];
    self.timeLb.text = [date stringWithFormat:@"yyyy.MM.dd HH:mm"];//@"2017.12.12  18:00"
    
    self.stateLb.text = model.procedure_log_title;
    
    [self.iconImgView setImageWithURL:[NSURL URLWithString:model.creator.avatar]
                          placeholder:kImage(@"head20")];
    
    self.personLb.text = model.creator.chinese_name;
    
    CGFloat timeH = [self.timeLb.text heightForFont:CA_H_FONT_PFSC_Regular(14) width:313];
    
    CGFloat stateH = [self.stateLb.text heightForFont:CA_H_FONT_PFSC_Regular(14) width:313];
    
    CGFloat personH = [self.personLb.text heightForFont:CA_H_FONT_PFSC_Regular(14) width:313];
    
    CGFloat height = timeH + 10 + stateH + 10 + personH + 20;
    
    if (!self.reasonLb.isHidden) {
        CGFloat reasonH = [self getSpaceLabelHeight:model.procedure_comment withFont:CA_H_FONT_PFSC_Regular(14) withWidth:313];
        height = height + reasonH ;
        _margin = 10;
    }else{
        _margin = 0;
    }
    [self.contentView layoutIfNeeded];
    
    return height;
}

#pragma mark - Private
//计算UILabel的高度(带有行间距的情况)
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}
#pragma mark - Getter and Setter
-(UILabel *)reasonLb{
    if (_reasonLb) {
        return _reasonLb;
    }
    _reasonLb = [[UILabel alloc] init];
    [_reasonLb configText:@"" textColor:CA_H_9GRAYCOLOR font:14];
    _reasonLb.numberOfLines = 0;
    return _reasonLb;
}
-(UILabel *)applyLb{
    if (_applyLb) {
        return _applyLb;
    }
    _applyLb = [[UILabel alloc] init];
    [_applyLb configText:@"申请人:" textColor:CA_H_9GRAYCOLOR font:14];
    [_applyLb sizeToFit];
    return _applyLb;
}
-(UIImageView *)iconImgView{
    if (_iconImgView) {
        return _iconImgView;
    }
    _iconImgView = [[UIImageView alloc] init];
    _iconImgView.layer.cornerRadius = 20 / 2;
    _iconImgView.layer.masksToBounds = YES;
    return _iconImgView;
}
-(UILabel *)personLb{
    if (_personLb) {
        return _personLb;
    }
    _personLb = [[UILabel alloc] init];
    [_personLb configText:@"" textColor:CA_H_9GRAYCOLOR font:14];
    return _personLb;
}
-(UILabel *)stateLb{
    if (_stateLb) {
        return _stateLb;
    }
    _stateLb = [[UILabel alloc] init];
    [_stateLb configText:@"" textColor:CA_H_4BLACKCOLOR font:14];
    return _stateLb;
}
-(UILabel *)timeLb{
    if (_timeLb) {
        return _timeLb;
    }
    _timeLb = [[UILabel alloc] init];
    [_timeLb configText:@"" textColor:CA_H_9GRAYCOLOR font:14];
    return _timeLb;
}
-(UIView *)lineView{
    if (_lineView) {
        return _lineView;
    }
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = CA_H_BACKCOLOR;
    return _lineView;
}
-(UIView *)circleView{
    if (_circleView) {
        return _circleView;
    }
    _circleView = [UIView new];
    _circleView.layer.cornerRadius = 6;
    _circleView.layer.masksToBounds = YES;
    _circleView.backgroundColor = CA_H_TINTCOLOR;
    return _circleView;
}
-(UIView *)circleBgView{
    if (_circleBgView) {
        return _circleBgView;
    }
    _circleBgView = [UIView new];
    _circleBgView.layer.cornerRadius = 9;
    _circleBgView.layer.masksToBounds = YES;
    _circleBgView.backgroundColor = kColor(@"#D3D8F9");
    return _circleBgView;
}
@end
