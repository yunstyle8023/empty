
//
//  CA_MDiscoverSponsorDetailViewManager.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/9.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MDiscoverSponsorDetailViewManager.h"
#import "CA_MDiscoverSponsorDetailHeaderView.h"
#import "CA_MDiscoverSponsorDetailBottomView.h"
#import "CA_MDiscoverSponsorDetailContactView.h"
#import "CA_MDiscoverSponsorDetailItemCell.h"
#import "CA_MDiscoverSponsorDetailinfoCell.h"
#import "CA_MDiscoverSponsorDetailMemberCell.h"
#import "CA_MDiscoverSponsorDetailuUnfoldCell.h"
#import "CA_MDiscoverSponsorDetailModel.h"

@interface CA_MDiscoverSponsorDetailViewManager ()
@property (nonatomic,assign) CGFloat headerHeight;
@end

@implementation CA_MDiscoverSponsorDetailViewManager

-(void)configViewManager:(CA_MDiscoverSponsorDetailModel *)model block:(void (^)(CGFloat height))block{
    self.titleLb.text = model.base_info.lp_name;
    CGFloat headerHeight = [self.headerView configView:model];
    self.headerHeight = headerHeight;
    block(headerHeight);
}

- (void)customNaviViewWithTarget:(id)target action:(SEL)action{
    UIButton *back = [UIButton new];
    back.tag = 100;
    [back addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [back setImage:kImage(@"backicon_white") forState:UIControlStateNormal];
    [back setImage:kImage(@"backicon_white") forState:UIControlStateSelected];
    back.imageView.sd_resetLayout
    .widthIs(18)
    .heightEqualToWidth()
    .leftSpaceToView(back.imageView.superview, 20*CA_H_RATIO_WIDTH)
    .centerYEqualToView(back.imageView.superview);
    
    [self.naviView addSubview:back];
    back.sd_layout
    .widthIs(18+50*CA_H_RATIO_WIDTH)
    .heightIs(30)
    .topSpaceToView(self.naviView, CA_H_MANAGER.xheight+27)
    .leftEqualToView(self.naviView);
    
    UIButton *share = [self button:@"icons_share2" tag:101 target:target action:action];
    [self.naviView addSubview:share];
    share.sd_layout
    .widthIs(24)
    .heightEqualToWidth()
    .rightSpaceToView(self.naviView, 20*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.naviView, CA_H_MANAGER.xheight+30);
    
    UIButton *pic = [self button:@"icons_pic_share" tag:102 target:target action:action];
    [self.naviView addSubview:pic];
    pic.sd_layout
    .widthIs(24)
    .heightEqualToWidth()
    .rightSpaceToView(share, 20*CA_H_RATIO_WIDTH)
    .topSpaceToView(self.naviView, CA_H_MANAGER.xheight+30);
    
    [self.naviView addSubview:self.titleLb];
    self.titleLb.sd_layout
    .centerXEqualToView(self.naviView)
    .centerYEqualToView(back)
    .leftSpaceToView(self.naviView, 20*CA_H_RATIO_WIDTH+18+10*CA_H_RATIO_WIDTH)
    .rightSpaceToView(pic, 5*2*CA_H_RATIO_WIDTH)
    .heightIs(12*2*CA_H_RATIO_WIDTH);
    
}

- (UIButton *)button:(NSString *)imageName tag:(NSInteger)tag target:(id)target action:(SEL)action {
    UIButton *button = [UIButton new];
    button.tag = tag;
    [button setImage:kImage(imageName) forState:UIControlStateNormal];
    [button setImage:kImage(imageName) forState:UIControlStateSelected];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIImage *)collectionShot {
    
    self.tableView.sd_closeAutoLayout = YES;
    
    CGSize contentSize = CGSizeMake(self.tableView.width, self.tableView.contentSize.height+self.headerHeight);
    
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(contentSize.width, contentSize.height+64+CA_H_MANAGER.xheight), YES, 0.0);
    
    //保存tableView当前的偏移量
    CGPoint savedContentOffset = self.tableView.contentOffset;
    CGRect saveFrame = self.tableView.frame;
    
    //将tableView的偏移量设置为(0,0)
    self.tableView.contentOffset = CGPointMake(0, -self.headerHeight);
    self.tableView.frame = CGRectMake(0, 64+CA_H_MANAGER.xheight, contentSize.width, contentSize.height);
    [self.tableView.delegate scrollViewDidScroll:self.tableView];
    
    //在当前上下文中渲染出tableView
    [self.tableView.superview.layer renderInContext: UIGraphicsGetCurrentContext()];
    //截取当前上下文生成Image
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    //恢复tableView的偏移量
    self.tableView.contentOffset = savedContentOffset;
    self.tableView.frame = saveFrame;
    [self.tableView.delegate scrollViewDidScroll:self.tableView];
    
    UIGraphicsEndImageContext();
    
    self.tableView.sd_closeAutoLayout = NO;
    
    if (image != nil) {
        return [image imageByCropToRect:CGRectMake(0, 64+CA_H_MANAGER.xheight-6*CA_H_RATIO_WIDTH, contentSize.width, contentSize.height)];
    }else {
        return nil;
    }
}

#pragma mark - getter and setter
-(UIImage *)image{
    return [self collectionShot];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView newTableViewGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[CA_MDiscoverSponsorDetailItemCell class] forCellReuseIdentifier:@"SponsorDetailItemCell"];
        [_tableView registerClass:[CA_MDiscoverSponsorDetailinfoCell class] forCellReuseIdentifier:@"SponsorDetailinfoCell"];
        [_tableView registerClass:[CA_MDiscoverSponsorDetailuUnfoldCell class] forCellReuseIdentifier:@"SponsorDetailuUnfoldCell"];
        [_tableView registerClass:[CA_MDiscoverSponsorDetailMemberCell class] forCellReuseIdentifier:@"SponsorDetailMemberCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}
-(CA_MDiscoverSponsorDetailContactView *)contactView{
    if (!_contactView) {
        _contactView = [CA_MDiscoverSponsorDetailContactView new];
    }
    return _contactView;
}
-(CA_MDiscoverSponsorDetailBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [CA_MDiscoverSponsorDetailBottomView new];
    }
    return _bottomView;
}
-(CA_MDiscoverSponsorDetailHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [CA_MDiscoverSponsorDetailHeaderView new];
    }
    return _headerView;
}
-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.alpha = 0.;
        [_titleLb configText:@""
                   textColor:kColor(@"#FFFFFF")
                        font:18];
    }
    return _titleLb;
}
-(UIView *)naviView{
    if (!_naviView) {
        _naviView = [UIView new];
        _naviView.backgroundColor = CA_H_TINTCOLOR;
    }
    return _naviView;
}
@end
