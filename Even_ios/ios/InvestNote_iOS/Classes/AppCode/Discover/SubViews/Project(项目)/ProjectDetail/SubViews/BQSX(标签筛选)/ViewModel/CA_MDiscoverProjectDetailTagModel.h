//
//  CA_MDiscoverProjectDetailTagModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/14.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

@interface CA_MDiscoverProjectDetailTagModel : CA_HBaseModel
// = "eeb047a1-700e-4c43-9961-4ea86744b3e5",
// = "众安保险是一家基于数据的互联网保险公司，致力于提供家庭财产保险、货运保险、责任保险、信用保证保险等服务。",
// = "#5E69C7",
// = "http://img.qichacha.com/Product/eeb047a1-700e-4c43-9961-4ea86744b3e5.jpg",
// = "众安保险",
// = "IPO"
@property (nonatomic,copy) NSString *data_id;
@property (nonatomic,copy) NSString *brief_intro;
@property (nonatomic,copy) NSString *project_color;
@property (nonatomic,copy) NSString *project_logo;
@property (nonatomic,copy) NSString *project_name;
@property (nonatomic,copy) NSString *invest_stage;
@end
