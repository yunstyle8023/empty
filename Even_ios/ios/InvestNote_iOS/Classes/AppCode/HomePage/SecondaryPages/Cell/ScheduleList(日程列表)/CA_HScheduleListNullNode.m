//
//  CA_HScheduleListNullNode.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/11/13.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HScheduleListNullNode.h"

#import "CA_HNullView.h"

@interface CA_HScheduleListNullNode ()

@property (nonatomic, strong) ASDisplayNode *node;

@end

@implementation CA_HScheduleListNullNode


#pragma mark --- Action

#pragma mark --- Lazy

#pragma mark --- LifeCircle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        ASDisplayNode *node = [ASDisplayNode new];
        [self addSubnode:node];
        _node = node;
    }
    return self;
}

- (void)didLoad {
    [super didLoad];
    
    CA_HNullView *nullView =[CA_HNullView newTitle:@"合理规划工作安排" buttonTitle:@"添加日程" top:99*CA_H_RATIO_WIDTH onButton:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"schedule_pushToAdd" object: @"pushToAdd" userInfo:@{}];
    } imageName:@"empty_schedule"];
    nullView.frame = CGRectMake(0, 0, CA_H_SCREEN_WIDTH, CA_H_SCREEN_WIDTH*1.2);
    [_node.view addSubview:nullView];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {

    _node.style.preferredSize = CGSizeMake(CA_H_SCREEN_WIDTH, CA_H_SCREEN_WIDTH*1.2);
    ASWrapperLayoutSpec * spec = [ASWrapperLayoutSpec wrapperWithLayoutElement:_node];

    return spec;
}

#pragma mark --- Custom

#pragma mark --- Delegate


@end
