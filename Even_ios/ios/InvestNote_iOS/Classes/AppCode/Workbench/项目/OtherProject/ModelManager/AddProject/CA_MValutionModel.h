//
//  CA_MValutionModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/6/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CA_MValutionModel : NSObject
//label = "市场法",
//value = "市场法",
//children = (
//            {
//                label = "最近融资价格法",
//                value = "最近融资价格法"
//            },
//            {
//                label = "市场乘数法",
//                value = "市场乘数法",
//                children = (
//                            {
//                                label = "市盈率(P/E)",
//                                value = "市盈率(P/E)"
//                            },
//                            {
//                                label = "市净率(P/B)",
//                                value = "市净率(P/B)"
//                            },
//                            {
//                                label = "企业价值/销售收入(EV/Sales)",
//                                value = "企业价值/销售收入(EV/Sales)"
//                            },
//                            {
//                                label = "企业价值/息税折摊前利润(EV/EBITDA)",
//                                value = "企业价值/息税折摊前利润(EV/EBITDA)"
//                            },
//                            {
//                                label = "企业价值/息税前利润(EV/EBIT)",
//                                value = "企业价值/息税前利润(EV/EBIT)"
//                            }
//                            )
//            },
//            {
//                label = "行业指标法",
//                value = "行业指标法"
//            }
//            )

@property (nonatomic,copy) NSString *label;
@property (nonatomic,copy) NSString *value;
@property (nonatomic,strong) NSArray<CA_MValutionModel *> *children;

@property (nonatomic,assign,getter=isSelected) BOOL selected;
@end
