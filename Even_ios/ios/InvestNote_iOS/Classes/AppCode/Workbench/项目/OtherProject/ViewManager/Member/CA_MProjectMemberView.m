
//
//  CA_MProjectMemberView.m
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/2/26.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_MProjectMemberView.h"
#import "CA_MProjectMemberHeaderView.h"
#import "CA_MProjectMemberSectionView.h"
#import "CA_MProjectMemberCell.h"
#import "CA_MProjectAddMemberCell.h"
#import "CA_MProjectMemberModel.h"
#import "CA_MProjectNoManagerCell.h"

#define kWidth 240*CA_H_RATIO_WIDTH

static NSString* const normalMemberKey = @"CA_MProjectMemberCell";
static NSString* const addMemberKey = @"CA_MProjectAddMemberCell";
static NSString* const noManagerKey = @"CA_MProjectNoManagerCell";
@interface CA_MProjectMemberView()
<CAAnimationDelegate,
UITableViewDelegate,
UITableViewDataSource
>
@property(nonatomic,strong)UIToolbar* toolBar;
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)CA_MProjectMemberHeaderView* headerView;
@property (nonatomic,assign,getter=isManager) BOOL manager;
@end

@implementation CA_MProjectMemberView

-(void)dealloc{
    NSLog(@"CA_MProjectMemberView----->dealloc");
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
}

-(void)setupUI{
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;
    [self addSubview:self.toolBar];
    [self addSubview:self.headerView];
    [self addSubview:self.tableView];
}

-(void)setMemberModel:(CA_MProjectMemberModel *)memberModel{
    _memberModel = memberModel;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0){
        
        int rows = 0;
        if (self.member_type_id.intValue == 1 ||
            self.member_type_id.intValue == 2) {//member_type_id 1-管理员 2-主管 3-普通成员 0-其他
            rows = self.memberModel.manager_list.count + 1;
        }
        self.manager = YES;
        if (rows == 0
            &&
            self.member_type_id.intValue != 1
            &&
            self.member_type_id.intValue != 2) {//自己不是管理员或者负责人的情况
            
            self.manager = NO;
            
            if ([NSObject isValueableObject:self.memberModel.manager_list]) {
                rows = self.memberModel.manager_list.count;
            }else{
                rows = 1;
            }
            
        }
        return rows;
    }
    if (self.member_type_id.intValue == 1 ||
        self.member_type_id.intValue == 2) {
        return self.memberModel.member_list.count + 1;
    }
    return self.memberModel.member_list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == (self.memberModel.manager_list.count)) {
        if (self.isManager) {
            CA_MProjectAddMemberCell*
            addCell = [tableView dequeueReusableCellWithIdentifier:addMemberKey];
            if (indexPath.section == 0) {
                addCell.title = @"添加项目主管";
            }else{
                addCell.title = @"添加成员";
            }
            return addCell;
        }else{
            CA_MProjectNoManagerCell *managerCell = [tableView dequeueReusableCellWithIdentifier:noManagerKey];
            return managerCell;
        }
    }
    if (indexPath.section == 1 && indexPath.row == (self.memberModel.member_list.count)) {
        CA_MProjectAddMemberCell*
        addCell = [tableView dequeueReusableCellWithIdentifier:addMemberKey];
        if (indexPath.section == 0) {
            addCell.title = @"添加项目主管";
        }else{
            addCell.title = @"添加成员";
        }
        return addCell;
    }
    CA_MProjectMemberCell* normalCell = [tableView dequeueReusableCellWithIdentifier:normalMemberKey];
    CA_MMemberModel* model = nil;
    if (indexPath.section == 0) {
        model = self.memberModel.manager_list[indexPath.row];
    }else{
        model = self.memberModel.member_list[indexPath.row];
    }
    normalCell.model = model;
    return normalCell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!self.isManager && indexPath.section == 0) {
        return;
    }
    
    //添加项目主管或者成员
    if ((indexPath.section == 0 && indexPath.row == (self.memberModel.manager_list.count))
        ||
        (indexPath.section == 1 && indexPath.row == (self.memberModel.member_list.count))) {
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(addPerson:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (indexPath.section == 0) {
                   [self.delegate addPerson:YES];// 添加主管
                }else{
                  [self.delegate addPerson:NO];//添加成员
                }
            });
        }
    }else{ //普通点击操作
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(didSelectMember:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (indexPath.section == 0 ) {//添加项目主管
                    NSNumber* member_type_id = self.memberModel.manager_list[indexPath.row].member_type_id;
                    [self.delegate didSelectMember:self.memberModel.manager_list[indexPath.row]];
                }else{//添加成员
                    NSNumber* member_type_id = self.memberModel.member_list[indexPath.row].member_type_id;
                    [self.delegate didSelectMember:self.memberModel.member_list[indexPath.row]];
                }
                
            });
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45*CA_H_RATIO_WIDTH;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CA_MProjectMemberSectionView* header = [CA_MProjectMemberSectionView new];
    NSString* title = section == 0 ? @"项目主管" : @"项目成员";
    header.title = title;
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30*CA_H_RATIO_WIDTH;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return ({
        UIView* view = [UIView new];
        view.backgroundColor = kColor(@"#FFFFFF");
        view;
    });
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10*CA_H_RATIO_WIDTH;
}

#pragma mark - getter and setter

-(CA_MProjectMemberHeaderView *)headerView{
    if (_headerView) {
        return _headerView;
    }
    _headerView = [[CA_MProjectMemberHeaderView alloc] initWithFrame:CGRectMake(kScreenWidth - kWidth, 0, kWidth, 88)];
    return _headerView;
}

-(UITableView *)tableView{
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(CA_H_SCREEN_WIDTH - kWidth, 88, kWidth, CA_H_SCREEN_HEIGHT-88) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = kColor(@"#FFFFFF");
    _tableView.rowHeight = 40 * CA_H_RATIO_WIDTH;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView registerClass:[CA_MProjectMemberCell class] forCellReuseIdentifier:normalMemberKey];
    [_tableView registerClass:[CA_MProjectAddMemberCell class] forCellReuseIdentifier:addMemberKey];
    [_tableView registerClass:[CA_MProjectNoManagerCell class] forCellReuseIdentifier:noManagerKey];
    return _tableView;
}

-(UIToolbar *)toolBar{
    if (_toolBar) {
        return _toolBar;
    }
    _toolBar = [[UIToolbar alloc] init];
    _toolBar.barStyle = UIBarStyleBlack;
    _toolBar.alpha = 0.35;
    return _toolBar;
}

#pragma mark - 动画效果

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (UITouch * touch in touches) {
        if (touch.view != self.tableView) {
            [self hideMember:YES];
        }
    }
}

- (void)showMember:(BOOL)animated{
    
    self.hidden = NO;
    
    if (animated) {
        CABasicAnimation * translationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
        translationAnimation.fromValue = [NSNumber numberWithFloat:self.tableView.mj_w];
        translationAnimation.toValue = [NSNumber numberWithFloat:0.0];
        translationAnimation.duration = 0.25f;
        translationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        translationAnimation.removedOnCompletion = NO;
        translationAnimation.fillMode = kCAFillModeForwards;

        [self.tableView.layer addAnimation:translationAnimation forKey:@"show"];
        
        [self.headerView.layer addAnimation:translationAnimation forKey:@"show"];

    }
}

- (void)hideMember:(BOOL)animated{
    
    if (animated) {
        CABasicAnimation * translationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
        translationAnimation.fromValue = [NSNumber numberWithFloat:0.0];
        translationAnimation.toValue = [NSNumber numberWithFloat:self.tableView.mj_w];
        translationAnimation.duration = 0.25f;
        translationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        translationAnimation.removedOnCompletion = NO;
        translationAnimation.fillMode = kCAFillModeForwards;
        translationAnimation.delegate = self;

        [self.tableView.layer addAnimation:translationAnimation forKey:@"hide"];
        
        [self.headerView.layer addAnimation:translationAnimation forKey:@"hide"];
    }else{
        [self removeFromSuperview];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self removeFromSuperview];
}

@end
