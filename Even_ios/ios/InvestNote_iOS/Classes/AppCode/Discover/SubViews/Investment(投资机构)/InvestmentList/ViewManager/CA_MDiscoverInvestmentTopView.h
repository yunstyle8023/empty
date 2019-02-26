//
//  CA_MDiscoverInvestmentTopView.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/24.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CA_MDiscoverInvestmentTopView : UIView

@property (nonatomic,strong) UIButton *firstBtn;

@property (nonatomic,strong) UIButton *secondBtn;

@property (nonatomic,strong) UIButton *thirdBtn;

@property (nonatomic,strong) UIButton *fourBtn;

@property (nonatomic,strong) NSMutableArray *buttons;

-(instancetype)initWithAreaBtnTitle:(NSString *)areaBtnTitle
                       typeBtnTitle:(NSString *)typeBtnTitle;

-(instancetype)initWithAreaBtnTitle:(NSString *)areaBtnTitle
                       typeBtnTitle:(NSString *)typeBtnTitle
                      roundBtnTitle:(NSString *)roundBtnTitle
                       timeBtnTitle:(NSString *)timeBtnTitle;

@property (nonatomic,copy) void(^didSelected)(UIButton *button);

@end
