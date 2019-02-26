//
//  CA_HRiskInformationCollectionCell.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HRiskInformationCollectionCell.h"

#import "CA_HBaseTableCell.h"
#import "CA_HListRiskInfoModel.h"

@interface CA_HRiskInformationCollectionCell () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *shapeImageView;

@property (nonatomic, copy) NSString *cellClassStr;
@property (nonatomic, copy) NSString *cellClassStr1;

@property (nonatomic, strong) NSArray *data;

@end

@implementation CA_HRiskInformationCollectionCell

#pragma mark --- Action

- (void)setModel:(CA_HListRiskInfoData *)model {
    [super setModel:model];
    
    self.titleLabel.text = model.name;
    if ([self.dataType isEqualToString:@"runexception"]) {
        if (model.color.length) {
            self.titleLabel.textColor = [UIColor colorWithHexString:model.color];
        }
    } else {
        if (![self.dataType isEqualToString:@"judgementdoclist"]) {
            [self shape:model.isShow];
        }
        
    }
//    else if ([self.dataType isEqualToString:@"courtannouncement"]) {
//
//        [self shape:model.isShow];
//    } else if ([self.dataType isEqualToString:@"subtoexecute"]) {
//
//        [self shape:model.isShow];
//    } else if ([self.dataType isEqualToString:@"lostcreditinfo"]) {
//
//        [self shape:model.isShow];
//    }
    self.data = model.detail_list;
    [self.tableView reloadData];
}

#pragma mark --- Lazy

- (void)setDataType:(NSString *)dataType {
    if (![dataType isEqualToString:_dataType]) {
        _dataType = dataType;
        
        self.titleLabel.sd_resetLayout
        .topSpaceToView(self.backView, 15*CA_H_RATIO_WIDTH)
        .leftSpaceToView(self.backView, 15*CA_H_RATIO_WIDTH)
        .autoHeightRatio(0);
        
        if ([dataType isEqualToString:@"judgementdoclist"]) {
            [self.titleLabel setSingleLineAutoResizeWithMaxWidth:305*CA_H_RATIO_WIDTH];
        } else {
            [self.titleLabel setSingleLineAutoResizeWithMaxWidth:276*CA_H_RATIO_WIDTH];
        }
        
        if ([dataType isEqualToString:@"runexception"]) {
            self.cellClassStr = @"CA_HRiskRunexceptionCell";
        } else {
            self.cellClassStr = @"CA_HRiskDoubleCell";
            self.cellClassStr1 = @"CA_HRiskSingleCell";
        }
        
        if (self.cellClassStr) {
            [self.tableView registerClass:NSClassFromString(self.cellClassStr) forCellReuseIdentifier:dataType];
        }
        
        if (self.cellClassStr1) {
            [self.tableView registerClass:NSClassFromString(self.cellClassStr1) forCellReuseIdentifier:@"cell"];
        }
        
        self.tableView.sd_resetLayout
        .leftEqualToView(self.backView)
        .rightEqualToView(self.backView)
        .bottomEqualToView(self.backView)
        .topSpaceToView(self.titleLabel, 11*CA_H_RATIO_WIDTH);
        
        [self.tableView reloadData];
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [CA_HFoundFactoryPattern labelWithFont:CA_H_FONT_PFSC_Medium(16) color:CA_H_4BLACKCOLOR];
        _titleLabel = label;
        label.numberOfLines = 0;
        [self.backView addSubview:label];
    }
    return _titleLabel;
}

- (UIImageView *)shapeImageView {
    if (!_shapeImageView) {
        UIImageView *imageView = [UIImageView new];
        _shapeImageView = imageView;
        
        [self.backView addSubview:imageView];
        imageView.sd_layout
        .widthIs(14*CA_H_RATIO_WIDTH)
        .heightEqualToWidth()
        .topSpaceToView(self.backView, 18*CA_H_RATIO_WIDTH)
        .rightSpaceToView(self.backView, 15*CA_H_RATIO_WIDTH);
    }
    return _shapeImageView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [UITableView newTableViewGrouped];
        _tableView = tableView;
        
        tableView.backgroundColor = [UIColor clearColor];
        tableView.scrollEnabled = NO;
        tableView.userInteractionEnabled = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        [self.backView addSubview:tableView];
        UIView *line = [CA_HFoundFactoryPattern line];
        [self.backView addSubview:line];
        line.sd_layout
        .heightIs(CA_H_LINE_Thickness)
        .topEqualToView(tableView).offset(tableView.tableHeaderView.height)
        .leftSpaceToView(self.backView, 15*CA_H_RATIO_WIDTH)
        .rightSpaceToView(self.backView, 15*CA_H_RATIO_WIDTH);
    }
    return _tableView;
}

#pragma mark --- LifeCircle

#pragma mark --- Custom

- (void)upView {
    [super upView];
}

- (void)shape:(BOOL)set {
    if (set) {
        self.shapeImageView.image = [UIImage imageNamed:@"icons_Details9"];
    } else {
        self.shapeImageView.image = [UIImage imageNamed:@"icons_Details8"];
    }
}

#pragma mark --- Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.dataType isEqualToString:@"runexception"]) {
        return self.data.count;
    } else if ([self.dataType isEqualToString:@"judgementdoclist"]) {
        return self.data.count;
    } else {
        if ([self.model isShow]) {
            return self.data.count;
        } else {
            return 1;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.cellClassStr) {
        
        
        Class class = NSClassFromString(self.cellClassStr);
        
        if (![self.dataType isEqualToString:@"runexception"]) {
            NSArray *array = self.data[indexPath.row];
            if (!(array.count>1)) {
                class = NSClassFromString(self.cellClassStr1);
            }
        }
        
        CGFloat height = [tableView cellHeightForIndexPath:indexPath model:self.data[indexPath.row] keyPath:@"model" cellClass:class contentViewWidth:335*CA_H_RATIO_WIDTH];
        
        return height;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = self.dataType;
    if (![self.dataType isEqualToString:@"runexception"]) {
        NSArray *array = self.data[indexPath.row];
        if (!(array.count>1)) {
            identifier = @"cell";
        }
    }
    
    CA_HBaseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.model = self.data[indexPath.row];
    
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    return cell;
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    
    UICollectionViewLayoutAttributes *attributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    
    CGFloat height = [self.titleLabel.text heightForFont:self.titleLabel.font width:([self.dataType isEqualToString:@"judgementdoclist"]?305:276)*CA_H_RATIO_WIDTH];
    
    CGSize size = CGSizeMake(335*CA_H_RATIO_WIDTH, height+self.tableView.contentSize.height+31*CA_H_RATIO_WIDTH);
    CGRect frame = attributes.frame;
    frame.size = size;
    
    attributes.frame = frame;
    
    return attributes;
}

@end
