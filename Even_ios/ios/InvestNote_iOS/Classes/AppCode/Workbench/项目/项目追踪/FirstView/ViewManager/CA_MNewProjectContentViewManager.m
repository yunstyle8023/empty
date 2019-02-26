//
//  CA_MNewProjectContentViewManager.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/3.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MNewProjectContentViewManager.h"
#import "CA_MProjectContentSelectView.h"
#import "CA_MProjectContentScrollView.h"
#import "CA_MProjectMemberView.h"

@implementation CA_MNewProjectContentViewManager

-(CA_MProjectMemberView *)memberView{
    if (!_memberView) {
        _memberView = [CA_MProjectMemberView new];
        _memberView.frame = CA_H_MANAGER.mainWindow.bounds;
    }
    return _memberView;
}

-(NSMutableArray<UIBarButtonItem *> *)barButtonItems{
    if (!_barButtonItems) {
        _barButtonItems = @[].mutableCopy;
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = 20;
        [_barButtonItems addObjectsFromArray:@[self.settingItem,spaceItem,self.memberItem]];
    }
    return _barButtonItems;
}

-(void)clickMemberBtnAction:(UIButton *)sender{
    self.memberBlock?self.memberBlock():nil;
}

-(void)clickSettingBtnAction:(UIButton *)sender{
    self.settingBlock?self.settingBlock():nil;
}

-(UIBarButtonItem *)memberItem{
    if (!_memberItem) {
        UIButton *memberButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [memberButton setImage:kImage(@"project_me") forState:UIControlStateNormal];
        [memberButton setImage:kImage(@"project_me") forState:UIControlStateHighlighted];
        [memberButton sizeToFit];
        [memberButton addTarget: self action: @selector(clickMemberBtnAction:) forControlEvents: UIControlEventTouchUpInside];
        _memberItem = [[UIBarButtonItem alloc] initWithCustomView:memberButton];
    }
    return _memberItem;
}
-(UIBarButtonItem *)settingItem{
    if (!_settingItem) {
        UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [settingButton setImage:kImage(@"setting_icon") forState:UIControlStateNormal];
        [settingButton setImage:kImage(@"setting_icon") forState:UIControlStateHighlighted];
        [settingButton sizeToFit];
        [settingButton addTarget: self action: @selector(clickSettingBtnAction:) forControlEvents: UIControlEventTouchUpInside];
        _settingItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    }
    return _settingItem;
}

-(CA_MProjectContentSelectView *)topView{
    if (!_topView) {
        _topView = [CA_MProjectContentSelectView new];
    }
    return _topView;
}

-(CA_MProjectContentScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[CA_MProjectContentScrollView alloc] initWithFrame:CGRectZero pId:self.pId];
    }
    return _scrollView;
}

@end
