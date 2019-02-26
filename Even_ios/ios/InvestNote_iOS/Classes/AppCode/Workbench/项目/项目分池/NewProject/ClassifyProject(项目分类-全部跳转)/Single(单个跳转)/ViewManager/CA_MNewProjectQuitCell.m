
//
//  CA_MNewProjectQuitCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewProjectQuitCell.h"
#import "CA_MProjectModel.h"

@implementation CA_MNewProjectQuitCell

-(void)upView{
    [super upView];
//    [self.contentView addSubview:self.multipleLb];
}

-(void)setConstraints{
    [super setConstraints];
//    self.multipleLb.sd_layout
//    .leftEqualToView(self.detailLb)
//    .topSpaceToView(self.detailLb, 2*2*CA_H_RATIO_WIDTH)
//    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
//    .heightIs(10*2*CA_H_RATIO_WIDTH);
}

-(void)setModel:(CA_MProjectModel *)model{
    
    self.iconLb.hidden = [NSString isValueableString:model.project_logo];
    self.iconLb.text = [model.project_name substringToIndex:1];
    
    if ([NSString isValueableString:model.project_logo]) {
        NSString* logoUrl = @"";
        if ([model.project_logo hasPrefix:@"http"]) {
            logoUrl = model.project_logo;
        }else{
            logoUrl = [NSString stringWithFormat:@"%@%@",CA_H_SERVER_API,model.project_logo];
        }
        
        [self.sologImgView setImageURL:[NSURL URLWithString:logoUrl]];
        self.sologImgView.backgroundColor = CA_H_BACKCOLOR;
    }else {
        [self.sologImgView setImageURL:[NSURL URLWithString:@""]];
        self.sologImgView.backgroundColor = kColor(model.project_color);
    }
    
    self.titleLb.text = model.project_name;
    

    if (model.total_amount.num.doubleValue >= 100000000) {
        NSString *resultStr = [self convertNumberToString:(model.total_amount.num.doubleValue/100000000)];
        self.typeLb.text = [NSString stringWithFormat:@"总投资金额：%@亿%@",resultStr,model.total_amount.unit_cn];
    }else {
        NSString *resultStr = [self convertNumberToString:(model.total_amount.num.doubleValue/10000)];
        self.typeLb.text = [NSString stringWithFormat:@"总投资金额：%@万%@",resultStr,model.total_amount.unit_cn];
    }
    
    
    if (model.profit.doubleValue >= 100000000) {
        NSString *resultStr = [self convertNumberToString:(model.profit.doubleValue/100000000)];
        self.detailLb.text = [NSString stringWithFormat:@"总收益：%@亿%@",resultStr,model.total_amount.unit_cn];
    }else {
        NSString *resultStr = [self convertNumberToString:(model.profit.doubleValue/10000)];
        self.detailLb.text = [NSString stringWithFormat:@"总收益：%@万%@",resultStr,model.total_amount.unit_cn];
    }
//    self.detailLb.text = [NSString stringWithFormat:@"总收益：%@ %@",model.total_amount.unit_sym,([NSString isValueableString:model.profit]?model.profit:@"暂无")];
    //    self.multipleLb.text = @"回报倍数：3.0倍回报倍数：3.0倍回报倍数：3.0倍回报倍数：3.0倍";
    
    [self setupAutoHeightWithBottomView:self.detailLb bottomMargin:5*2*CA_H_RATIO_WIDTH];
}


-(NSString *)convertNumberToString:(double)number{
    NSString * numberStr = [NSString stringWithFormat:@"%0.4f",number];
    return [[numberStr numberValue] stringValue];
}

-(UILabel *)multipleLb{
    if (!_multipleLb) {
        _multipleLb = [UILabel new];
        [_multipleLb configText:@""
                      textColor:CA_H_9GRAYCOLOR
                           font:14];
    }
    return _multipleLb;
}

@end
