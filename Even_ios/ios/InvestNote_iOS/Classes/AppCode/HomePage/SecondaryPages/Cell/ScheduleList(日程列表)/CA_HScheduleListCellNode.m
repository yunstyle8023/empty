//
//  CA_HScheduleListCellNode.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/11/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HScheduleListCellNode.h"

#import "CA_HScheduleListModel.h"

@interface CA_HScheduleListCellNode ()

@property (nonatomic, strong) ASTextNode *titleNode;
@property (nonatomic, strong) ASTextNode *leftNode;
@property (nonatomic, strong) ASTextNode *rightNode;

@property (nonatomic, strong) ASImageNode *leftIconNode;
@property (nonatomic, strong) ASImageNode *rightIconNode;

@property (nonatomic, strong) ASDisplayNode *bottomLine;

@property (nonatomic, assign) BOOL isPrivacy;
@property (nonatomic, strong) ASTextNode *privacyNode;

@end

@implementation CA_HScheduleListCellNode

#pragma mark --- Action

#pragma mark --- Lazy

#pragma mark --- LifeCircle

- (instancetype)initWithModel:(CA_HScheduleListModel *)model {
    self = [super init];
    if (self) {
        self.isPrivacy = [model.privacy_typ isEqualToNumber:@(1)]&&[model.is_participate isEqualToNumber:@(0)];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.isPrivacy) {
            self.backgroundColor = UIColorHex(0xFAFAFA);
            NSMutableAttributedString *text = [NSMutableAttributedString new];
            
            [text appendString:@"隐私"];
            text.font = CA_H_FONT_PFSC_Medium(10);
            text.color = [UIColor whiteColor];
            text.minimumLineHeight = 14*CA_H_RATIO_WIDTH;
            
            ASTextNode *node = [ASTextNode new];
            _privacyNode = node;
            node.attributedText = text;
            node.maximumNumberOfLines = 1;
            node.backgroundColor = UIColorHex(0xD1D1D1);
            node.cornerRadius = 2*CA_H_RATIO_WIDTH;
            node.clipsToBounds = YES;
            node.textContainerInset = UIEdgeInsetsMake(CA_H_RATIO_WIDTH, 5*CA_H_RATIO_WIDTH, 2*CA_H_RATIO_WIDTH, 5*CA_H_RATIO_WIDTH);
            [self addSubnode:node];
        }
        
        {
            ASDisplayNode *node = [ASDisplayNode new];
            node.backgroundColor = CA_H_BACKCOLOR;
            [self addSubnode:node];
            _bottomLine = node;
            _bottomLine.style.flexGrow = 1.0;
            _bottomLine.style.height = ASDimensionMakeWithPoints(CA_H_LINE_Thickness);
        }
        
        {
            NSMutableAttributedString *text = [NSMutableAttributedString new];
            
            [text appendString:[NSString stringWithFormat:@"%@", model.title]];
            text.font = CA_H_FONT_PFSC_Medium(16);
            text.color = UIColorHex(0x414042);
            text.minimumLineHeight = 21*CA_H_RATIO_WIDTH;
            
            ASTextNode *node = [ASTextNode new];
            _titleNode = node;
            node.attributedText = text;
            node.maximumNumberOfLines = 1;
            node.style.flexShrink = 1.0;
            [self addSubnode:node];
        }
        
        {
            ASImageNode *node = [ASImageNode new];
            node.image = [UIImage imageNamed:@"Schedule list_time"];
            _leftIconNode = node;
            node.style.preferredSize = CGSizeMake(13*CA_H_RATIO_WIDTH, 13*CA_H_RATIO_WIDTH);
            [self addSubnode:node];
        }
        
        {
            ASImageNode *node = [ASImageNode new];
            node.image = model.address.length?[UIImage imageNamed:@"Schedule list_location"]:nil;
            _rightIconNode = node;
            node.style.preferredSize = CGSizeMake(10*CA_H_RATIO_WIDTH, 14*CA_H_RATIO_WIDTH);
            [self addSubnode:node];
        }
        
        {
            NSMutableAttributedString *text = [NSMutableAttributedString new];
            [text appendString:[NSString stringWithFormat:@"%@ 至 %@", model.start_time_show, model.end_time_show]];
            text.font = CA_H_FONT_PFSC_Light(12);
            text.color = UIColorHex(0x424242);
            
            ASTextNode *node = [ASTextNode new];
            _leftNode = node;
            node.attributedText = text;
            node.maximumNumberOfLines = 1;
            node.style.flexShrink = 1.0;
            [self addSubnode:node];
        }
        
        {
            NSMutableAttributedString *text = [NSMutableAttributedString new];
            [text appendString:[NSString stringWithFormat:@"%@", model.address?:@""]];
            text.font = CA_H_FONT_PFSC_Light(12);
            text.color = UIColorHex(0x424242);
            
            ASTextNode *node = [ASTextNode new];
            _rightNode = node;
            node.attributedText = text;
            node.maximumNumberOfLines = 1;
            node.style.flexShrink = 1.0;
            [self addSubnode:node];
        }
    }
    return self;
}

- (void)didLoad {
    [super didLoad];
    
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    ASStackLayoutSpec *left = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:4*CA_H_RATIO_WIDTH justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[_leftIconNode,_leftNode]];
    left.style.flexBasis = ASDimensionMake(@"50%");
    
    ASStackLayoutSpec *right = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:4*CA_H_RATIO_WIDTH justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[_rightIconNode,_rightNode]];
    right.style.flexBasis = ASDimensionMake(@"50%");
    right.style.flexShrink = 1.0;
    
    ASStackLayoutSpec *content = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:5*CA_H_RATIO_WIDTH justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[left,right]];
    
    ASInsetLayoutSpec *contentInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH, 15*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH) child:content];
    id title;
    if (self.isPrivacy) {
        ASStackLayoutSpec *titleStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:5*CA_H_RATIO_WIDTH justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[_titleNode, _privacyNode]];
        titleStack.style.flexShrink = 1.0;
        title = titleStack;
    } else {
        title = self.titleNode;
    }
    ASInsetLayoutSpec *titleInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(15*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH, 0, 20*CA_H_RATIO_WIDTH) child:title];
    
    return [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:0 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[titleInset, contentInset, _bottomLine]];
    
}

#pragma mark --- Custom

#pragma mark --- Delegate

@end
