//
//  CA_MSelectModelDetail.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/3/26.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"
#import "CA_MProjectDetailModel.h"

@interface CA_MSelectModelDetail : CA_HBaseModel
//"data_type": "project",
//"data_id": "xxxxxx",
//"project_logo": "项目logo URL",
//"project_name": "项目名称",
//"project_area": [
//                 "北京",
//                 "朝阳"
//                 ],
//"project_category": []， # 行业分类，qcc接口未返回此数据，APP对接返回空list
//"project_source": ""， #项目来源，qcc接口未返回此数据，APP对接返回字符串为空
//"source_note": "",  #项目来源备注，qcc接口未返回此数据，APP对接返回字符串为空
//"valuation": "", #估值，qcc接口未返回此数据，APP对接返回字符串为空
//"currency": ""，#币种，qcc接口未返回此数据，APP对接返回字符串为空
//"valuation_mode": "", #估值方式，qcc接口未返回此数据，APP对接返回字符串为空
//"privacy_setting": "", #隐私设置，qcc接口未返回此数据，APP对接返回字符串为空
//"project_manager": "",  #项目管理员，qcc接口未返回此数据，APP对接返回字符串为空
//"project_flow": "", # 项目流程，qcc接口未返回此数据，APP对接返回字符串为空
//"project_invest_stage": "项目最新融资轮次"，
//"tag_list": ["xxx", "xxx", ...], # 项目标签
//"project_intro": "项目简介"，
//"invest_history_list": [
//                        {
//                            "invest_date": "投资时间",
//                            "invest_stage": "轮次",
//                            "invest_money": "融资金融",
//                            "investor " : "DCM、零一创投、君上资本",    #投资机构
//                        } ...
//                        ]

@property (nonatomic,copy) NSString *data_type;
@property (nonatomic,copy) NSString *data_id;
@property (nonatomic,copy) NSString *project_logo;
@property (nonatomic,copy) NSString *project_name;
@property (nonatomic,copy) NSString *project_area;
@property (nonatomic,strong) NSArray *project_category;
@property (nonatomic,copy) NSString *project_source;
@property (nonatomic,copy) NSString *source_note;
@property (nonatomic,copy) NSString *valuation;
@property (nonatomic,copy) NSString *currency;
@property (nonatomic,copy) NSString *valuation_mode;
@property (nonatomic,copy) NSString *privacy_setting;
@property (nonatomic,copy) NSString *project_manager;
@property (nonatomic,copy) NSString *project_flow;
@property (nonatomic,copy) NSString *project_invest_stage;
@property (nonatomic,strong) NSNumber *invest_stage_id;
@property (nonatomic,strong) NSArray *tag_list;
@property (nonatomic,copy) NSString *project_intro;
@property (nonatomic,strong) NSArray<CA_MInvest_history*> *invest_history_list;
@end
