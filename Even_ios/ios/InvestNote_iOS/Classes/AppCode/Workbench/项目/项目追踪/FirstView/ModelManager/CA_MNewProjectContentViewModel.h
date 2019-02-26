//
//  CA_MNewProjectContentViewModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/3.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CA_MProjectModel;
@class CA_MProjectMemberModel;

@interface CA_MNewProjectContentViewModel : NSObject

@property (nonatomic,strong) UIView *loadingView;

@property (nonatomic,strong) NSNumber *pId;

@property (nonatomic,strong) CA_MProjectModel *model;

@property (nonatomic,copy) dispatch_block_t loadMemberDataBlock;

@property (nonatomic,strong) CA_MProjectMemberModel *memberModel;

@property (nonatomic,copy) dispatch_block_t memberBlock;

@property (nonatomic,copy) dispatch_block_t loadDataBlock;

@property (nonatomic,assign,getter=isFinished) BOOL finished;

@property (nonatomic,copy) dispatch_block_t finishedBlock;

-(void)updateMemberRoleWithPid:(NSNumber *)pid
                       user_id:(NSNumber *)user_id
                member_type_id:(NSNumber *)member_type_id
                         block:(void (^)(void))block;

-(void)deleteMemberWithPid:(NSNumber *)pid
                   user_id:(NSNumber *)user_id
                     block:(void (^)(void))block;
 
 -(void)updateFollowProjectWithPid:(NSNumber *)pid
                         is_follow:(BOOL)is_follow
                             block:(void (^)(void))block;

-(void)updateProjectPrivacyWithPid:(NSNumber *)pid
                           privacy:(NSString *)privacy
                            block:(void (^)(NSString *result))block;

-(void)deleteOrQuitProjectWithPid:(NSNumber *)pid
                            isDel:(BOOL)isDel
                            block:(void (^)(void))block;

@end
