//
//  CA_HStockMarketCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/9.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HStockMarketCell.h"

#import "CA_HEnterpriseBusinessInfoModel.h"

@interface CA_HStockMarketCell ()

@property (nonatomic, strong) YYLabel *stockLabel;
@property (nonatomic, strong) UILabel *label;

@end

@implementation CA_HStockMarketCell

#pragma mark --- Action

- (void)setModel:(CA_HEnterpriseStock *)model {
    [super setModel:model];
    
    if (model.price_change.doubleValue == 0) {
        self.stockLabel.text = [NSString stringWithFormat:@"%.2f  %.2f(%.2f%%)", model.close_price.doubleValue, model.price_change.doubleValue, model.p_change.doubleValue];
    } else {
        
        NSMutableAttributedString *text = [NSMutableAttributedString new];
        
        if (model.price_change.doubleValue>0) {
            NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:[UIImage imageNamed:@"up"] contentMode:UIViewContentModeCenter attachmentSize:CGSizeMake(20*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH) alignToFont:self.stockLabel.font alignment:YYTextVerticalAlignmentCenter];
            
            [text appendString:[NSString stringWithFormat:@"%.2f ", model.close_price.doubleValue]];
            [text appendAttributedString:attachText];
            [text appendString:[NSString stringWithFormat:@" +%.2f(+%.2f%%)", model.price_change.doubleValue, model.p_change.doubleValue]];
            
            text.color = UIColorHex(0xDC5656);
        } else {
            NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:[UIImage imageNamed:@"down"] contentMode:UIViewContentModeCenter attachmentSize:CGSizeMake(20*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH) alignToFont:self.stockLabel.font alignment:YYTextVerticalAlignmentCenter];
            
            [text appendString:[NSString stringWithFormat:@"%.2f ", model.close_price.doubleValue]];
            [text appendAttributedString:attachText];
            [text appendString:[NSString stringWithFormat:@" %.2f(%.2f%%)", model.price_change.doubleValue, model.p_change.doubleValue]];
            
            text.color = UIColorHex(0x4CD964);
        }
        
        text.font = CA_H_FONT_PFSC_Medium(20);
        
        self.stockLabel.attributedText = text;
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.last_closing_date.doubleValue];
    self.label.text = [NSString stringWithFormat:@"股票代码：%@     收盘日期：%@", model.stock_code?:@"", [date stringWithFormat:@"yyyy.MM.dd"]];
}

#pragma mark --- Lazy

- (YYLabel *)stockLabel {
    if (!_stockLabel) {

        YYLabel *label = [YYLabel new];
        label.font = CA_H_FONT_PFSC_Medium(20);
        label.textColor = CA_H_4BLACKCOLOR;
        label.numberOfLines = 1;
        _stockLabel = label;
    }
    return _stockLabel;
}

- (UILabel *)label {
    if (!_label) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Regular(14) color:CA_H_4BLACKCOLOR];
        _label = label;
    }
    return _label;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)upView {
    [super upView];
    
    [self.backView addSubview:self.stockLabel];
    self.stockLabel.sd_layout
    .heightIs(28*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.backView, 15*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.backView, 15*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.backView, 15*CA_H_RATIO_WIDTH);
    
    [self.backView addSubview:self.label];
    self.label.sd_layout
    .heightIs(20*CA_H_RATIO_WIDTH)
    .leftSpaceToView(self.backView, 15*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.backView, 15*CA_H_RATIO_WIDTH)
    .bottomSpaceToView(self.backView, 15*CA_H_RATIO_WIDTH);
}

#pragma mark --- Delegate

@end
