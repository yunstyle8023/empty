//
//  CA_MSettingPanelViewModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CA_MSettingPanelModel;

@interface CA_MSettingPanelViewModel : NSObject

@property (nonatomic,strong) UIView *loadingView;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,copy) dispatch_block_t finishedBlock;

-(void)editPanelSettingWithData:(NSArray<CA_MSettingPanelModel *> *)data_list
                        success:(void(^)(void))resultBlock;
@end
