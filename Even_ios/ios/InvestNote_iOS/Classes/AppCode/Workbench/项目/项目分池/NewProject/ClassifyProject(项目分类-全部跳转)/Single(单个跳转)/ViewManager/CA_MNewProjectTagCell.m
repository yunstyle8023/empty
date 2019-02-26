
//
//  CA_MNewProjectTagCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewProjectTagCell.h"
#import "CA_MProjectModel.h"

@implementation CA_MNewProjectTagCell

-(void)upView{
    [super upView];
    [self.contentView addSubview:self.tagView];
}

-(void)setConstraints{
    [super setConstraints];
    
    self.tagView.sd_layout
    .leftSpaceToView(self.titleLb, 3*2*CA_H_RATIO_WIDTH)
    .centerYEqualToView(self.titleLb)
    .heightIs(11*2*CA_H_RATIO_WIDTH);
    [self.tagView setupAutoWidthWithRightView:self.tagView.tagLb rightMargin:3*2*CA_H_RATIO_WIDTH];
    
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

    self.typeLb.text = [NSString isValueableString:model.brief_intro]?model.brief_intro:@"暂无";
    self.detailLb.text = [NSString stringWithFormat:@"%@-%@ | %@-%@ | %@",
                         [NSString isValueableString:[model.project_area firstObject]]?[model.project_area firstObject]:@"暂无",
                         [NSString isValueableString:[model.project_area lastObject]]?[model.project_area lastObject]:@"暂无",
                         [NSString isValueableString:model.category.parent_category_name]?model.category.parent_category_name:@"暂无",
                         [NSString isValueableString:model.category.child_category_name]?model.category.child_category_name:@"暂无",
                         [NSString isValueableString:model.invest_stage]?model.invest_stage:@"暂无"];

    self.tagView.tagLb.text = model.project_progress;
    if ([NSString isValueableString:model.project_progress]) {
        self.tagView.hidden = NO;
        CGFloat tagWidth = [self.tagView.tagLb.text widthForFont:CA_H_FONT_PFSC_Light(12)]+7*2*CA_H_RATIO_WIDTH;
        [self.titleLb setSingleLineAutoResizeWithMaxWidth:CA_H_SCREEN_WIDTH-50*2*CA_H_RATIO_WIDTH-tagWidth-3*2*CA_H_RATIO_WIDTH];
    }else{
        self.tagView.hidden = YES;
        [self.titleLb setSingleLineAutoResizeWithMaxWidth:CA_H_SCREEN_WIDTH-50*2*CA_H_RATIO_WIDTH];
    }
    
    [self setupAutoHeightWithBottomView:self.detailLb bottomMargin:5*2*CA_H_RATIO_WIDTH];
}


-(CA_MProjectTagView *)tagView{
    if (!_tagView) {
        _tagView = [CA_MProjectTagView new];
    }
    return _tagView;
}

@end
