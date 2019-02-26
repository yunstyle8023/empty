//
//  CA_MSelectModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/24.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

@interface CA_MSelectModel : CA_HBaseModel
//data_id = 32446,
//brief_intro = "iDream Career 2012年成立于印度，是一家为学生提供职业规划服务和教育的机构。",
//project_logo = "https://cdn.itjuzi.com/images/a2083b37d942e74ff3d4b9ddd060a633.png?imageView2/0/w/100/q/100",
//project_name = "iDream Career",
//invest_stage = "天使轮"
@property (nonatomic,copy) NSString *data_id;
@property (nonatomic,copy) NSString *brief_intro;
@property (nonatomic,copy) NSString *project_logo;
@property (nonatomic,copy) NSString *project_name;
@property (nonatomic,copy) NSString *invest_stage;
@end
