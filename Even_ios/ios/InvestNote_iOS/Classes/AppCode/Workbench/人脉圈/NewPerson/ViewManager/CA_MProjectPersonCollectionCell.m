//
//  CA_MProjectPersonCollectionCell.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/19.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectPersonCollectionCell.h"
#import "CA_MProjectTagLabel.h"

@interface CA_MProjectPersonCollectionCell ()
@property (nonatomic,strong) CA_MProjectTagLabel *tagLb;
@end

@implementation CA_MProjectPersonCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.tagLb];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.tagLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

-(void)setModel:(CA_MPersonTagModel *)model{
    _model = model;
    self.tagLb.title = model.tag_name;
}

-(CA_MProjectTagLabel *)tagLb{
    if (_tagLb) {
        return _tagLb;
    }
    _tagLb = [[CA_MProjectTagLabel alloc] init];
    return _tagLb;
}

@end
