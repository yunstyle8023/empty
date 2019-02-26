//
//  CA_HAddMenuView.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/25.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HAddMenuView.h"


#define CA_H_MENU_IMAGEDIC @{   @"笔记":@"noteicon",\
                                @"待办":@"missionicon",\
                                @"文件":@"fileicon"}

@interface CA_HAddMenuView ()<UITableViewDelegate, UITableViewDataSource, CAAnimationDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSDictionary * dataDic;

@end

@implementation CA_HAddMenuView

#pragma mark --- Lazy

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView newTableViewPlain];
        if (_cellClass) {
            [_tableView registerClass:[NSClassFromString(_cellClass) class] forCellReuseIdentifier:@"menu"];
        }else{
            [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"menu"];
        }
        _tableView.rowHeight = 40;
        _tableView.bounces = NO;
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        CA_H_WeakSelf(self);
        _tableView.didFinishAutoLayoutBlock = ^(CGRect frame) {
            CA_H_StrongSelf(self);
            
            [CA_HShadow dropShadowWithView:self
                                    bounds:frame
                              cornerRadius:self.tableView.sd_cornerRadius.floatValue
                                    offset:CGSizeMake(0, 0)
                                    radius:6
                                     color:CA_H_SHADOWCOLOR
                                   opacity:0.3];
            [self bringSubviewToFront:self.tableView];
        };
        _tableView.sd_cornerRadius = @(6);

        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]){
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
    }
    return _tableView;
}

- (NSDictionary *)dataDic{
    if (!_dataDic) {
        _dataDic = CA_H_MENU_IMAGEDIC;
    }
    return _dataDic;
}

- (void)setData:(NSArray *)data{
    _data = data;
    if (data) {
        if (_tableLayoutBlock) {
            _tableLayoutBlock(self.tableView);
        }else{
            self.tableView.sd_resetLayout
            .widthIs(95)
            .heightIs(41*data.count-1)
            .topSpaceToView(self, 5)
            .rightSpaceToView(self, 20*CA_H_RATIO_WIDTH);
        }
    }
}

#pragma mark --- LifeCircle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self upView];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_clickBlock) {
        _clickBlock(-1);
        _clickBlock = nil;
    }
}


#pragma mark --- Custom

- (void)upView{
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;
}

- (void)showMenu:(BOOL)animated{
    self.hidden = NO;
    if (animated) {
        if (_tableLayoutBlock) {
            self.layer.anchorPoint = _ca_anchorPoint;
            self.layer.transform = _ca_transform;
        }else{
            self.layer.anchorPoint = CGPointMake((self.mj_w - 20*CA_H_RATIO_WIDTH)/self.mj_w, 5./self.mj_h);
            
            self.layer.transform = CATransform3DMakeTranslation(self.mj_w/2 - 20*CA_H_RATIO_WIDTH, -(self.mj_h/2 - 5.), 0);
        }
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = [NSNumber numberWithFloat:0.0];
        scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
        scaleAnimation.duration = 0.25f;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        scaleAnimation.removedOnCompletion = NO;
        scaleAnimation.fillMode = kCAFillModeForwards;
        
        [self.layer addAnimation:scaleAnimation forKey:@"show"];
    }
    
}

- (void)hideMenu:(BOOL)animated{
    if (animated) {
        
        if (_tableLayoutBlock) {
            self.layer.anchorPoint = _ca_anchorPoint;
            self.layer.transform = _ca_transform;
        }else{
            self.layer.anchorPoint = CGPointMake((self.mj_w - 20*CA_H_RATIO_WIDTH)/self.mj_w, 5./self.mj_h);
            
            self.layer.transform = CATransform3DMakeTranslation(self.mj_w/2 - 20*CA_H_RATIO_WIDTH, -(self.mj_h/2 - 5.), 0);
        }
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
        scaleAnimation.toValue = [NSNumber numberWithFloat:0.0];
        scaleAnimation.duration = 0.25f;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        scaleAnimation.removedOnCompletion = NO;
        scaleAnimation.fillMode = kCAFillModeForwards;
        scaleAnimation.delegate = self;
        
        [self.layer addAnimation:scaleAnimation forKey:@"hide"];
    }else{
        [self.layer removeAllAnimations];
        [self removeFromSuperview];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}



- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"menu"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_cellBlock) {
        _cellBlock(cell, indexPath);
        return cell;
    }
    
    if (cell.contentView.subviews.count < 2) {
        cell.imageView.sd_resetLayout
        .widthIs(20)
        .heightEqualToWidth()
        .centerYEqualToView(cell.imageView.superview)
        .leftSpaceToView(cell.imageView.superview, 20);
        
        [cell.textLabel setTextColor:CA_H_6GRAYCOLOR];
        [cell.textLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14]];
        cell.textLabel.numberOfLines = 1;
        cell.textLabel.sd_resetLayout
        .leftSpaceToView(cell.imageView, 5)
        .centerYEqualToView(cell.imageView)
        .autoHeightRatio(0);
        [cell.textLabel setMaxNumberOfLinesToShow:1];
        [cell.textLabel setSingleLineAutoResizeWithMaxWidth:45];
    }
    
    cell.textLabel.text = CA_H_LAN(self.data[indexPath.row]);
//    [cell.textLabel setTextColor:CA_H_6GRAYCOLOR];
//    [cell.textLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14]];
    
    //1、首先对image付值
    cell.imageView.image = [UIImage imageNamed:self.dataDic[cell.textLabel.text]];

//    //2、调整大小
//    CGSize itemSize = CGSizeMake(20, 20);
//    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
//    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//    [cell.imageView.image drawInRect:imageRect];
//    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_clickBlock) {
        _clickBlock(indexPath.row);
        _clickBlock = nil;
    }
}






@end
