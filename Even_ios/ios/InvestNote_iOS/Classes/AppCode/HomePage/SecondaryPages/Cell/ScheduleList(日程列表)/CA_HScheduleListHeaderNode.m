//
//  CA_HScheduleListHeaderNode.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/11/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HScheduleListHeaderNode.h"

#import "CA_HParticipantsModel.h"

@interface CA_HScheduleListHeaderNode ()

@property (nonatomic, strong) ASButtonNode *btnNode;
@property (nonatomic, strong) ASButtonNode *btnRightNode;

@property (nonatomic, strong) ASImageNode *imageNode;
@property (nonatomic, strong) ASImageNode *imageRightNode;

@property (nonatomic, strong) NSArray *userIds;

@end

@implementation CA_HScheduleListHeaderNode


#pragma mark --- Action

- (void)onBtn:(ASButtonNode *)sender {
    if (!sender.selected) {
        sender.selected = true;
        
        NSString *objectString = @"time_screening";
        ASImageNode *imageNode = _imageNode;
        
        if (sender == _btnRightNode) {
            objectString = @"user_screening";
            imageNode = _imageRightNode;
        }
        imageNode.image = [UIImage imageNamed:@"icons_arrow2"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"schedule_screening" object: objectString userInfo:@{@"user_ids":self.userIds?self.userIds:@[]}];
    }
}

#pragma mark --- Lazy

#pragma mark --- LifeCircle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithStart:(NSNumber *)start end:(NSNumber *)end userIds:(NSArray *)userIds userName:(NSString *)userName {
    self = [super init];
    if (self) {
        self.userIds = userIds;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(schedule_screeningChange:)  name:@"schedule_screeningChange" object:nil];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *show = @"时间筛选";
        if (start&&end) {
            show = [NSString stringWithFormat:@"%@至%@", [[NSDate dateWithTimeIntervalSince1970:start.doubleValue] stringWithFormat:@"MM月dd日"], [[NSDate dateWithTimeIntervalSince1970:end.doubleValue] stringWithFormat:@"MM月dd日"]];
        }
        ASButtonNode *node = [ASButtonNode new];
        [self addSubnode:node];
        [node setTitle:show withFont:CA_H_FONT_PFSC_Regular(14) withColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
        [node addTarget:self action:@selector(onBtn:) forControlEvents:ASControlNodeEventTouchUpInside];
        node.contentEdgeInsets = UIEdgeInsetsMake(0, 10*CA_H_RATIO_WIDTH, 0, 10*CA_H_RATIO_WIDTH);
        node.contentHorizontalAlignment = ASHorizontalAlignmentLeft;
        node.cornerRadius = 6*CA_H_RATIO_WIDTH;
        node.borderWidth = 2*CA_H_RATIO_WIDTH;
        node.borderColor = CA_H_F8COLOR.CGColor;
        _btnNode = node;
        
        _imageNode = [ASImageNode new];
        _imageNode.image = [UIImage imageNamed:@"icons_arrow"];
        [self addSubnode:_imageNode];
        
        NSString *rightShow;
        switch (userIds.count) {
            case 0:
                rightShow = @"筛选参与人";
                break;
            case 1:
                rightShow = userName?:@"";
                break;
            default:
                rightShow = [NSString stringWithFormat:@"%@ +%ld",userName?:@"",userIds.count-1];
                break;
        }
        _btnRightNode = [ASButtonNode new];
        [self addSubnode:_btnRightNode];
        [_btnRightNode setTitle:rightShow withFont:CA_H_FONT_PFSC_Regular(14) withColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
        [_btnRightNode addTarget:self action:@selector(onBtn:) forControlEvents:ASControlNodeEventTouchUpInside];
        _btnRightNode.contentEdgeInsets = UIEdgeInsetsMake(0, 10*CA_H_RATIO_WIDTH, 0, 27*CA_H_RATIO_WIDTH);
        _btnRightNode.contentHorizontalAlignment = ASHorizontalAlignmentLeft;
        _btnRightNode.cornerRadius = 6*CA_H_RATIO_WIDTH;
        _btnRightNode.borderWidth = 2*CA_H_RATIO_WIDTH;
        _btnRightNode.borderColor = CA_H_F8COLOR.CGColor;
        
        _imageRightNode = [ASImageNode new];
        _imageRightNode.image = [UIImage imageNamed:@"icons_arrow"];
        [self addSubnode:_imageRightNode];
    }
    return self;
}

- (void)didLoad {
    [super didLoad];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    _btnNode.style.height = ASDimensionMakeWithPoints(30.0*CA_H_RATIO_WIDTH);
    _btnRightNode.style.height = ASDimensionMakeWithPoints(30.0*CA_H_RATIO_WIDTH);
    
    _imageNode.style.preferredSize = CGSizeMake(9*CA_H_RATIO_WIDTH, 6*CA_H_RATIO_WIDTH);
    ASInsetLayoutSpec *overInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 0, 0, 9*CA_H_RATIO_WIDTH) child:_imageNode];
    ASStackLayoutSpec *overStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:0 justifyContent:ASStackLayoutJustifyContentEnd alignItems:ASStackLayoutAlignItemsCenter children:@[overInset]];
    ASOverlayLayoutSpec *over = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:_btnNode overlay:overStack];
    over.style.flexBasis = ASDimensionMake(@"50%");
    
    _imageRightNode.style.preferredSize = CGSizeMake(9*CA_H_RATIO_WIDTH, 6*CA_H_RATIO_WIDTH);
    ASInsetLayoutSpec *overRightInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 0, 0, 9*CA_H_RATIO_WIDTH) child:_imageRightNode];
    ASStackLayoutSpec *overRightStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:0 justifyContent:ASStackLayoutJustifyContentEnd alignItems:ASStackLayoutAlignItemsCenter children:@[overRightInset]];
    ASOverlayLayoutSpec *overRight = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:_btnRightNode overlay:overRightStack];
    overRight.style.flexBasis = ASDimensionMake(@"50%");
    
    ASStackLayoutSpec *stack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:10*CA_H_RATIO_WIDTH justifyContent:ASStackLayoutJustifyContentCenter alignItems:ASStackLayoutAlignItemsCenter children:@[over, overRight]];
    stack.style.flexGrow = 1.0;
    
    ASInsetLayoutSpec *spec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(19*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH, 10*CA_H_RATIO_WIDTH, 20*CA_H_RATIO_WIDTH) child:stack];
    
    return spec;
}

#pragma mark --- Custom

#pragma mark --- Delegate

- (void)schedule_screeningChange:(NSNotification*)notification{
    NSString *nameString = [notification name];
    NSString *objectString = [notification object];
    NSDictionary *dictionary = [notification userInfo];//为nil要有这行代码哦
    // 当你拿到这些数据的时候你可以去做一些操作
    
    _btnNode.selected = false;
    _btnRightNode.selected = false;
    _imageNode.image = [UIImage imageNamed:@"icons_arrow"];
    _imageRightNode.image = [UIImage imageNamed:@"icons_arrow"];
    
    if ([objectString isEqualToString:@"reset"]) {
        [_btnNode setTitle:@"时间筛选" withFont:CA_H_FONT_PFSC_Regular(14) withColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
    } else if ([objectString isEqualToString:@"sure"]) {
        NSDate *start = dictionary[@"start"];
        NSDate *end = dictionary[@"end"];
        if (start&&end) {
            NSString *show = [NSString stringWithFormat:@"%@ 至 %@", [start stringWithFormat:@"MM月dd日"], [end stringWithFormat:@"MM月dd日"]];
            [_btnNode setTitle:show withFont:CA_H_FONT_PFSC_Regular(14) withColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
        }
    } else if ([objectString isEqualToString:@"user_sure"]) {
        NSArray *user_ids = dictionary[@"user_ids"];
        NSString *rightShow;
        switch (user_ids.count) {
            case 0:
                rightShow = @"筛选参与人";
                break;
            case 1:
                rightShow = [user_ids.firstObject chinese_name]?:@"";
                break;
            default:
                rightShow = [NSString stringWithFormat:@"%@ +%ld",[user_ids.firstObject chinese_name]?:@"",user_ids.count-1];
                break;
        }
        [_btnRightNode setTitle:rightShow withFont:CA_H_FONT_PFSC_Regular(14) withColor:CA_H_9GRAYCOLOR forState:UIControlStateNormal];
    }
}


@end
