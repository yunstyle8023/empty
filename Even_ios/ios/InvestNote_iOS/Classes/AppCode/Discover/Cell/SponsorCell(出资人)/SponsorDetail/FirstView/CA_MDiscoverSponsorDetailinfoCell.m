
//
//  CA_MDiscoverSponsorDetailinfoCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverSponsorDetailinfoCell.h"
#import "CA_MDiscoverSponsorDetailModel.h"
#import "ButtonLabel.h"

@interface CA_MDiscoverSponsorDetailinfoCell ()
@property (nonatomic,strong) UILabel *chOrganization;
@property (nonatomic,strong) UILabel *enOrganization;
@property (nonatomic,strong) UILabel *enOrganizationLb;
@property (nonatomic,strong) UILabel *capitalType;
@property (nonatomic,strong) UILabel *capitalTypeLb;
@property (nonatomic,strong) UILabel *lpCount;
@property (nonatomic,strong) UILabel *lpCountLb;
@property (nonatomic,strong) UILabel *lpType;
@property (nonatomic,strong) UILabel *lpTypeLb;
@property (nonatomic,strong) UILabel *organizationForm;
@property (nonatomic,strong) UILabel *organizationFormLb;
@property (nonatomic,strong) UILabel *address;
@property (nonatomic,strong) UILabel *addressLb;
@end

@implementation CA_MDiscoverSponsorDetailinfoCell

-(void)upView{
    [super upView];
    [self.contentView addSubview:self.chOrganization];
    [self.contentView addSubview:self.chOrganizationLb];
    [self.contentView addSubview:self.enOrganization];
    [self.contentView addSubview:self.enOrganizationLb];
    [self.contentView addSubview:self.capitalType];
    [self.contentView addSubview:self.capitalTypeLb];
    [self.contentView addSubview:self.lpCount];
    [self.contentView addSubview:self.lpCountLb];
    [self.contentView addSubview:self.lpType];
    [self.contentView addSubview:self.lpTypeLb];
    [self.contentView addSubview:self.organizationForm];
    [self.contentView addSubview:self.organizationFormLb];
    [self.contentView addSubview:self.address];
    [self.contentView addSubview:self.addressLb];
    [self setConstarins];
}

-(void)setConstarins{
    self.chOrganization.isAttributedContent = YES;
    self.chOrganization.sd_layout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topEqualToView(self.contentView)
    .autoHeightRatio(0);
    [self.chOrganization setSingleLineAutoResizeWithMaxWidth:0];
    
    self.chOrganizationLb.isAttributedContent = YES;
    self.chOrganizationLb.sd_layout
    .leftSpaceToView(self.contentView, 70*2*CA_H_RATIO_WIDTH)
    .topEqualToView(self.contentView)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.chOrganizationLb setMaxNumberOfLinesToShow:0];
    
    self.enOrganization.isAttributedContent = YES;
    self.enOrganization.sd_layout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.chOrganizationLb, 8*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.enOrganization setSingleLineAutoResizeWithMaxWidth:0];
    
    self.enOrganizationLb.isAttributedContent = YES;
    self.enOrganizationLb.sd_layout
    .leftSpaceToView(self.contentView, 70*2*CA_H_RATIO_WIDTH)
    .topEqualToView(self.enOrganization)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.enOrganizationLb setMaxNumberOfLinesToShow:0];
    
    self.capitalType.isAttributedContent = YES;
    self.capitalType.sd_layout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.enOrganizationLb, 8*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.capitalType setSingleLineAutoResizeWithMaxWidth:0];
    
    self.capitalTypeLb.isAttributedContent = YES;
    self.capitalTypeLb.sd_layout
    .leftSpaceToView(self.contentView, 70*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.enOrganizationLb, 8*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.capitalTypeLb setMaxNumberOfLinesToShow:0];
    
    self.lpCount.isAttributedContent = YES;
    self.lpCount.sd_layout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.capitalTypeLb, 8*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.lpCount setSingleLineAutoResizeWithMaxWidth:0];
    
    self.lpCountLb.isAttributedContent = YES;
    self.lpCountLb.sd_layout
    .leftSpaceToView(self.contentView, 70*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.capitalTypeLb, 8*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.lpCountLb setMaxNumberOfLinesToShow:0];
    
    self.lpType.isAttributedContent = YES;
    self.lpType.sd_layout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.lpCountLb, 8*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.lpType setSingleLineAutoResizeWithMaxWidth:0];
    
    self.lpTypeLb.isAttributedContent = YES;
    self.lpTypeLb.sd_layout
    .leftSpaceToView(self.contentView, 70*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.lpCountLb, 8*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.lpTypeLb setMaxNumberOfLinesToShow:0];
    
    self.organizationForm.isAttributedContent = YES;
    self.organizationForm.sd_layout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.lpTypeLb, 8*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.organizationForm setSingleLineAutoResizeWithMaxWidth:0];
    
    self.organizationFormLb.isAttributedContent = YES;
    self.organizationFormLb.sd_layout
    .leftSpaceToView(self.contentView, 70*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.lpTypeLb, 8*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.organizationFormLb setMaxNumberOfLinesToShow:0];
    
    self.address.isAttributedContent = YES;
    self.address.sd_layout
    .leftSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.organizationFormLb, 8*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.address setSingleLineAutoResizeWithMaxWidth:0];
    
    self.addressLb.isAttributedContent = YES;
    self.addressLb.sd_layout
    .leftSpaceToView(self.contentView, 70*2*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.organizationFormLb, 8*2*CA_H_RATIO_WIDTH)
    .rightSpaceToView(self.contentView, 10*2*CA_H_RATIO_WIDTH)
    .autoHeightRatio(0);
    [self.addressLb setMaxNumberOfLinesToShow:0];
}

-(void)setModel:(CA_MDiscoverSponsorDetailModel *)model{
    [super setModel:model];
    
    self.chOrganization.text = @"机构全称";
    [self.chOrganization changeLineSpaceWithSpace:6];
    
    self.chOrganizationLb.text = model.base_info.lp_name;
    [self.chOrganizationLb changeLineSpaceWithSpace:6];
    
    self.enOrganization.text = @"英文全称";
    [self.enOrganization changeLineSpaceWithSpace:6];
    
    self.enOrganizationLb.text = [NSString isValueableString:model.base_info.lp_enname]?model.base_info.lp_enname:@"暂无";
    [self.enOrganizationLb changeLineSpaceWithSpace:6];
    
    self.capitalType.text = @"资本类型";
    [self.capitalType changeLineSpaceWithSpace:6];
    
    self.capitalTypeLb.text = [NSString isValueableString:model.base_info.capital_type]?model.base_info.capital_type:@"暂无";
    [self.capitalTypeLb changeLineSpaceWithSpace:6];
    
    self.lpCount.text = @"LP管理资本量";
    [self.lpCount changeLineSpaceWithSpace:6];
    
    self.lpCountLb.text = [NSString isValueableString:model.base_info.managerial_capital]?model.base_info.managerial_capital:@"暂无";
    [self.lpCountLb changeLineSpaceWithSpace:6];
    
    self.lpType.text = @"LP类型";
    [self.lpType changeLineSpaceWithSpace:6];
    
    self.lpTypeLb.text = [NSString isValueableString:model.base_info.lp_type]?model.base_info.lp_type:@"暂无";
    [self.lpTypeLb changeLineSpaceWithSpace:6];
    
    self.organizationForm.text = @"组织形式";
    [self.organizationForm changeLineSpaceWithSpace:6];
    
    self.organizationFormLb.text = [NSString isValueableString:model.base_info.vcpeform]?model.base_info.vcpeform:@"暂无";
    [self.organizationFormLb changeLineSpaceWithSpace:6];
    
    self.address.text = @"公司地址";
    [self.address changeLineSpaceWithSpace:6];
    
    self.addressLb.text = [NSString isValueableString:model.base_info.address]?model.base_info.address:@"暂无";
    [self.addressLb changeLineSpaceWithSpace:6];
    
    [self setupAutoHeightWithBottomView:self.addressLb bottomMargin:10*2*CA_H_RATIO_WIDTH];
}

#pragma mark - getter and setter
-(UILabel *)addressLb{
    if (!_addressLb) {
        _addressLb = [self createLabel];
        _addressLb.numberOfLines = 0;
    }
    return _addressLb;
}
-(UILabel *)address{
    if (!_address) {
        _address = [self createLabel];
    }
    return _address;
}
-(UILabel *)organizationFormLb{
    if (!_organizationFormLb) {
        _organizationFormLb = [self createLabel];
        _organizationFormLb.numberOfLines = 0;
    }
    return _organizationFormLb;
}
-(UILabel *)organizationForm{
    if (!_organizationForm) {
        _organizationForm = [self createLabel];
    }
    return _organizationForm;
}
-(UILabel *)lpTypeLb{
    if (!_lpTypeLb) {
        _lpTypeLb = [self createLabel];
        _lpTypeLb.numberOfLines = 0;
    }
    return _lpTypeLb;
}
-(UILabel *)lpType{
    if (!_lpType) {
        _lpType = [self createLabel];
    }
    return _lpType;
}
-(UILabel *)lpCountLb{
    if (!_lpCountLb) {
        _lpCountLb = [self createLabel];
        _lpCountLb.numberOfLines = 0;
    }
    return _lpCountLb;
}
-(UILabel *)lpCount{
    if (!_lpCount) {
        _lpCount = [self createLabel];
    }
    return _lpCount;
}
-(UILabel *)capitalTypeLb{
    if (!_capitalTypeLb) {
        _capitalTypeLb = [self createLabel];
        _capitalTypeLb.numberOfLines = 0;
    }
    return _capitalTypeLb;
}
-(UILabel *)capitalType{
    if (!_capitalType) {
        _capitalType = [self createLabel];
    }
    return _capitalType;
}
-(UILabel *)enOrganizationLb{
    if (!_enOrganizationLb) {
        _enOrganizationLb = [self createLabel];
        _enOrganizationLb.numberOfLines = 0;
    }
    return _enOrganizationLb;
}
-(UILabel *)enOrganization{
    if (!_enOrganization) {
        _enOrganization = [self createLabel];
    }
    return _enOrganization;
}
-(ButtonLabel *)chOrganizationLb{
    if (!_chOrganizationLb) {
        _chOrganizationLb = [ButtonLabel new];
        _chOrganizationLb.numberOfLines = 0;
        [_chOrganizationLb configText:@""
             textColor:CA_H_TINTCOLOR
                  font:16];
    }
    return _chOrganizationLb;
}
-(UILabel *)chOrganization{
    if (!_chOrganization) {
        _chOrganization = [self createLabel];
    }
    return _chOrganization;
}
-(UILabel *)createLabel{
    UILabel *lb = [UILabel new];
    [lb configText:@""
         textColor:CA_H_4BLACKCOLOR
              font:16];
    return lb;
}

@end
