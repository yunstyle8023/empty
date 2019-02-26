//
//  CA_HMoveListViewModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/11/27.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CA_HMoveListModel.h"

typedef enum : NSUInteger {
    CA_HProjeceTypeMove = 0,
    CA_HProjeceTypeChoose,
    CA_HProjeceTypeChooseToJump,
    CA_HProjeceTypeInput
} CA_HProjeceType;

@interface CA_HMoveListViewModel : NSObject

@property (nonatomic, assign) CA_HProjeceType type;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSNumber *defaultSelected;

@property (nonatomic, strong) UITableView * menuTableView;
@property (nonatomic, assign) CGFloat bottomHeight;

@property (nonatomic, copy) void (^backBlock)(CA_MProjectModel *model);

@property (nonatomic, strong) NSArray<CA_HNoteTypeModel *> *typeData;
@property (nonatomic, copy) void (^noteTypeBlock)(CA_MProjectModel *model, CA_HNoteTypeModel *typeModel);

@property (nonatomic, copy) void (^addBlock)(CA_MProjectModel *model,NSString* content);

@property (nonatomic, copy) void (^onSearchBlock)(void);
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, copy) void (^alertBlock)(CA_MProjectModel *model);

@property (nonatomic, strong) UIView *hudView;

@end
