//
//  CA_HAddButton.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/6/26.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HAddButton.h"

@interface CA_HAddButton ()

@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) CALayer *shadowLayer;

@property (nonatomic, strong) UIView *oldSuperView;

@end

@implementation CA_HAddButton

+ (CA_HAddButton *)newAdd {
    CA_HAddButton *button = [CA_HAddButton new];
    
    [button setTitle:@"添加" forState:UIControlStateNormal];
    [button setTitleColor:CA_H_TINTCOLOR forState:UIControlStateNormal];
    
    button.titleLabel.font = CA_H_FONT_PFSC_Regular(14);
    
    button.titleLabel.sd_resetLayout
    .spaceToSuperView(UIEdgeInsetsMake(10*CA_H_RATIO_WIDTH, 48*CA_H_RATIO_WIDTH, 10*CA_H_RATIO_WIDTH, 10*CA_H_RATIO_WIDTH));
    
    button.selectString = @"取消";
    button.iconImageView.image = [UIImage imageNamed:@"add"];
    
    return button;
}

#pragma mark --- Action

- (void)onButton:(CA_HAddButton *)sender {
    
    [self changeSender:sender];
    
    CGFloat angle = sender.selected?(-0.75 * M_PI):0;
    [UIView animateWithDuration:0.1575f animations:^{
        sender.iconImageView.transform = CGAffineTransformMakeRotation(angle);
    }];
    
    if (_onButtonBlock) {
        _onButtonBlock(sender);
    } else {
        UIView *backTool = [sender.backView viewWithTag:123];
        if (sender.selected) {
            
            [CA_H_MANAGER.mainWindow addSubview:sender.backView];
            sender.oldSuperView = sender.superview;
            CGRect frame = [sender.superview convertRect:sender.frame toView:sender.backView];
            for (UIButton *button in self.buttons) {
                button.frame = frame;
                button.alpha = 1;
                button.layer.cornerRadius = frame.size.height/2.;
                [sender.backView addSubview:button];
            }
            
            [sender removeFromSuperviewAndClearAutoLayoutSettings];
            [sender.backView addSubview:sender];
            sender.frame = frame;
            [UIView animateWithDuration:0.0618f*3 delay:0.0618f*2 options:UIViewAnimationOptionCurveEaseIn animations:^{
                backTool.alpha = 0.35;
                for (NSInteger i = 0; i<self.buttons.count; i++) {
                    UIButton *button = self.buttons[self.buttons.count-i-1];
                    CGRect frame = button.frame;
                    frame.origin.y -= (frame.size.height+15*CA_H_RATIO_WIDTH)*(i+1);
                    button.frame = frame;
                }
            } completion:^(BOOL finished) {
                
            }];
            
        } else {
            
            CGRect frame = [sender.superview convertRect:sender.frame toView:sender.oldSuperView];
            [UIView animateWithDuration:0.0618f*3 delay:0.0618f*2 options:UIViewAnimationOptionCurveEaseOut animations:^{
                backTool.alpha = 0;
                for (UIButton *button in self.buttons) {
                    button.frame = sender.frame;
                }
            } completion:^(BOOL finished) {
                [sender removeFromSuperview];
                sender.frame = frame;
                [sender.oldSuperView addSubview:sender];
                sender.oldSuperView = nil;
                [sender.backView removeFromSuperview];
            }];
            
        }
    }
}

- (void)onItem:(UIButton *)sender {
    if (_onItemBlock) {
        
        UIView *backTool = [self.backView viewWithTag:123];
        CGRect frame = [self.superview convertRect:self.frame toView:self.oldSuperView];
        NSInteger index = sender.tag-100;
        
        if (self.noItemAnimate) {
            
            [UIView animateWithDuration:0.0618f*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.alpha = 0.0f;
                backTool.alpha = 0.0f;
                for (UIButton *button in self.buttons) {
                    button.alpha = 0.0f;
                }
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
                [self changeSender:self];
                self.iconImageView.transform = CGAffineTransformIdentity;
                self.frame = frame;
                self.alpha = 1.0f;
                [self.oldSuperView addSubview:self];
                self.oldSuperView = nil;
                [self.backView removeFromSuperview];
                self.onItemBlock(index, self.items[index], sender);
            }];
            
            return;
        }
        
        
        UILabel *label = sender.titleLabel.deepCopy;
        [sender addSubview:label];
        UIImageView *imageView = sender.imageView.deepCopy;
        [sender addSubview:imageView];
        
        [UIView animateWithDuration:0.0618f*5 animations:^{
            sender.transform = CGAffineTransformMakeScale(3, 3);
            sender.alpha = 0.0f;
        } completion:^(BOOL finished) {
            sender.transform = CGAffineTransformIdentity;
            [label removeFromSuperview];
            [imageView removeFromSuperview];
        }];
        
        [UIView animateWithDuration:0.0618f*2 animations:^{
            self.transform = CGAffineTransformMakeScale(0, 0);
            self.alpha = 0.0f;
            for (UIButton *button in self.buttons) {
                if (button != sender) {
                    button.transform = CGAffineTransformMakeScale(0, 0);
                    button.alpha = 0.0f;
                }
            }
        } completion:^(BOOL finished) {
            self.transform = CGAffineTransformIdentity;
            self.iconImageView.transform = CGAffineTransformIdentity;
            for (UIButton *button in self.buttons) {
                if (button != sender) {
                    button.transform = CGAffineTransformIdentity;
                }
            }
        }];
        
        
        [UIView animateWithDuration:0.0618f*3 delay:0.0618f*2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            backTool.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [self changeSender:self];
            self.frame = frame;
            self.alpha = 1.0f;
            [self.oldSuperView addSubview:self];
            self.oldSuperView = nil;
            [self.backView removeFromSuperview];
        }];
        
        _onItemBlock(index, self.items[index], sender);
    }
}

- (void)setItems:(NSArray<NSDictionary *> *)items {
    _items = items;
    
    [self.buttons removeAllObjects];
    for (NSDictionary *dic in items) {
        
        NSString *title = dic[@"title"]?:@"";
        UIImage *image = dic[@"image"];
        NSString *size = dic[@"size"];
        UIFont *font = dic[@"font"];
        
        UIButton *button = [UIButton new];
        button.tag = 100+self.buttons.count;
        button.backgroundColor = [UIColor whiteColor];
        button.layer.masksToBounds = YES;
        
        [button addTarget:self action:@selector(onItem:) forControlEvents:UIControlEventTouchUpInside];
        
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:self.titleLabel.textColor forState:UIControlStateNormal];
        button.titleLabel.font = font?:self.titleLabel.font;
        button.titleLabel.sd_resetLayout
        .spaceToSuperView(UIEdgeInsetsMake(10*CA_H_RATIO_WIDTH, 48*CA_H_RATIO_WIDTH, 10*CA_H_RATIO_WIDTH, 10*CA_H_RATIO_WIDTH));
        
        
        if (image) {
            CGSize imageSize = size?CGSizeFromString(size):CGSizeMake(20*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH);
            [button setImage:image forState:UIControlStateNormal];
            [button setImage:image forState:UIControlStateHighlighted];
            button.imageView.sd_resetLayout
            .widthIs(imageSize.width)
            .heightIs(imageSize.height)
            .centerYEqualToView(button.imageView.superview)
            .leftSpaceToView(button.imageView.superview, 30*CA_H_RATIO_WIDTH-imageSize.width/2.);
        }
        
        [self.buttons addObject:button];
    }
}

#pragma mark --- Lazy

- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray new];
    }
    return _buttons;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        UIImageView *imageView = [UIImageView new];
        _iconImageView = imageView;
        
        imageView.frame = CGRectMake(22.5*CA_H_RATIO_WIDTH, 12.5*CA_H_RATIO_WIDTH, 15*CA_H_RATIO_WIDTH, 15*CA_H_RATIO_WIDTH);
        [self addSubview:imageView];
    }
    return _iconImageView;
}

- (CALayer *)shadowLayer {
    if (!_shadowLayer) {
        UIColor *shadowColor = CA_H_SHADOWCOLOR;
        
        CALayer *shadowLayer=[CALayer layer];
        _shadowLayer = shadowLayer;
        shadowLayer.backgroundColor=[UIColor whiteColor].CGColor;
        shadowLayer.masksToBounds = NO;
        shadowLayer.shadowColor = shadowColor.CGColor;//shadowColor阴影颜色
        shadowLayer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
        shadowLayer.shadowOpacity = 0.5;//阴影透明度，默认0
        shadowLayer.shadowRadius = 6*CA_H_RATIO_WIDTH;//阴影半径，默认3
    }
    return _shadowLayer;
}

- (UIView *)backView {
    if (!_backView) {
        UIView *view = [UIView new];
        _backView = view;
        
        view.backgroundColor = [UIColor clearColor];
        view.frame = CA_H_MANAGER.mainWindow.bounds;
        
        UIToolbar *toolbar = [UIToolbar new];
        toolbar.tag = 123;
        toolbar.barStyle = UIBarStyleBlack;
        toolbar.alpha = 0;
        [view addSubview:toolbar];
        toolbar.sd_layout
        .spaceToSuperView(UIEdgeInsetsZero);
    }
    return _backView;
}

#pragma mark --- LifeCircle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self upView];
    }
    return self;
}

#pragma mark --- Custom

- (void)upView {
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    [self addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showShadowLayer {
    self.layer.cornerRadius = self.frame.size.height/2.;
    self.shadowLayer.frame = self.frame;
    self.shadowLayer.cornerRadius = self.frame.size.height/2.;
    [self.superview.layer insertSublayer:self.shadowLayer below:self.layer];
}

- (void)changeSender:(CA_HAddButton *)sender {
    sender.selected = !sender.selected;
    
    if (self.selectString) {
        NSString *title = sender.titleLabel.text;
        [sender setTitle:self.selectString forState:UIControlStateNormal];
        self.selectString = title;
    }
}

#pragma mark --- Delegate

@end
