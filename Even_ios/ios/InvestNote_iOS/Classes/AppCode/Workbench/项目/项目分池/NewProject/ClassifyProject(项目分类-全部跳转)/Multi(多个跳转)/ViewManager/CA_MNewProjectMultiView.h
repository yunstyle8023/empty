//
//  CA_MNewProjectMultiView.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/30.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CA_MEmptyView;
@class CA_MNewProjectSingleViewModel;

@interface CA_MNewProjectMultiView : UIView

@property (nonatomic,strong) CA_MEmptyView *emptyView;

@property (nonatomic,strong) CA_MNewProjectSingleViewModel *viewModel;

-(void)configViewWithPool_id:(NSNumber *)pool_id
                      tag_id:(NSNumber *)tag_id;

-(void)resetLayout:(BOOL)isRecover;

@end
