//
//  CA_MSelectCell.m
//  InvestNote_iOS
//  Created by yezhuge on 2017/11/29.
//  God bless me without no bugs.
//

#import "CA_MSelectCell.h"

@interface CA_MSelectCell()

@end

@implementation CA_MSelectCell

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
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.selectLb];
    [self.contentView addSubview:self.arrowImgView];
    [self.contentView addSubview:self.lineView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(self.contentView).offset(20);
    }];
    
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
    }];
    
    [self.selectLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.trailing.mas_equalTo(self.arrowImgView.mas_leading).offset(-5);
        make.width.mas_equalTo(250*CA_H_RATIO_WIDTH);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.titleLb);
        make.trailing.mas_equalTo(self.arrowImgView);
        make.bottom.mas_equalTo(self.contentView).offset(-CA_H_LINE_Thickness);
        make.height.mas_equalTo(CA_H_LINE_Thickness);
    }];
}

#pragma mark - Public

- (void)configCell:(NSString*)title :(NSString*)selectStr{
    self.titleLb.text = title;
    self.selectLb.text = selectStr;
    if ([selectStr isEqualToString:@"选择"]) {
        self.selectLb.textColor = CA_H_9GRAYCOLOR;
    }else{
        self.selectLb.textColor = CA_H_4BLACKCOLOR;
    }
}

#pragma mark - Private

#pragma mark - Getter and Setter
-(UIImageView *)arrowImgView{
    if (_arrowImgView) {
        return _arrowImgView;
    }
    _arrowImgView = [[UIImageView alloc] init];
    _arrowImgView.image = kImage(@"shape5");
    return _arrowImgView;
}
-(UILabel *)selectLb{
    if (_selectLb) {
        return _selectLb;
    }
    _selectLb = [[UILabel alloc] init];
    [_selectLb configText:@"选择" textColor:CA_H_9GRAYCOLOR font:16];
    _selectLb.textAlignment = NSTextAlignmentRight;
    return _selectLb;
}
-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [[UILabel alloc] init];
    [_titleLb configText:@"" textColor:CA_H_4BLACKCOLOR font:16];
    return _titleLb;
}
-(UIView *)lineView{
    if (_lineView) {
        return _lineView;
    }
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = CA_H_BACKCOLOR;
    return _lineView;
}
@end
