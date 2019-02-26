//
//  CA_MProjectMemberView.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/2/26.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CA_MProjectModel.h"
#import "CA_MProjectMemberModel.h"

@protocol CA_MProjectMemberViewDelegate <NSObject>
@optional
- (void)addPerson:(BOOL)isAddManage;
- (void)didSelectMember:(CA_MMemberModel*)model;
@end

@interface CA_MProjectMemberView : UIView
@property (nonatomic,strong) NSNumber *member_type_id;
@property (nonatomic,strong) CA_MProjectMemberModel *memberModel;
@property(nonatomic,weak)id<CA_MProjectMemberViewDelegate> delegate;
- (void)showMember:(BOOL)animated;
- (void)hideMember:(BOOL)animated;
@end
