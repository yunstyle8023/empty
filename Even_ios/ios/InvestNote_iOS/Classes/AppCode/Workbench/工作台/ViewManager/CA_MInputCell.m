//
//  CA_MInputCell.m
//  InvestNote_iOS
//  Created by yezhuge on 2017/11/29.
//  God bless me without no bugs.
//

#import "CA_MInputCell.h"

@interface CA_MInputCell()
<UITextFieldDelegate>
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UITextField *txtField;
@property (nonatomic,strong) UIView *lineView;
@end

@implementation CA_MInputCell

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
    [self.contentView addSubview:self.txtField];
    [self.contentView addSubview:self.lineView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(self.contentView).offset(20);
    }];
    
    [self.txtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.trailing.mas_equalTo(self.contentView).offset(-20);
        //
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(280);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.titleLb);
        make.trailing.mas_equalTo(self.txtField);
        make.bottom.mas_equalTo(self.contentView).offset(-CA_H_LINE_Thickness);
        make.height.mas_equalTo(CA_H_LINE_Thickness);
    }];
}

#pragma mark - Public

-(void)setKeyBoardType:(UIKeyboardType)keyBoardType{
    self.txtField.keyboardType = keyBoardType;
}

-(void)setEnabled:(BOOL)enabled{
    self.txtField.enabled = enabled;
}

- (void)configCell:(NSString*)title text:(NSString*)text placeholder:(NSString*)placeholder{
    self.titleLb.text = title;
    
    if ([NSString isValueableString:placeholder]) {
        NSMutableAttributedString* attStr = [[NSMutableAttributedString alloc] initWithString:placeholder];
        [attStr addAttribute:NSForegroundColorAttributeName value:CA_H_9GRAYCOLOR range:NSMakeRange(0, placeholder.length)];
        [attStr addAttribute:NSFontAttributeName value:CA_H_FONT_PFSC_Regular
         (16) range:NSMakeRange(0, placeholder.length)];
        self.txtField.attributedPlaceholder = attStr;
    }else{
        self.txtField.attributedPlaceholder = [[NSMutableAttributedString alloc] init];
    }
    
    if ([NSString isValueableString:text]) {
        self.txtField.text = text;
    }else{
        self.txtField.text = @"";
    }
    
}


#pragma mark - Private

-(void)textFieldTextChange:(UITextField*)txtField{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(textDidChange:content:)]) {
        [self.delegate textDidChange:self content:txtField.text];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Getter and Setter
-(UITextField *)txtField{
    if (_txtField) {
        return _txtField;
    }
    _txtField = [[UITextField alloc] init];
    [_txtField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    _txtField.textColor = CA_H_4BLACKCOLOR;
    _txtField.textAlignment = NSTextAlignmentRight;
    _txtField.font = CA_H_FONT_PFSC_Regular(16);
    _txtField.delegate = self;
    _txtField.returnKeyType = UIReturnKeyDone;
    return _txtField;
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
