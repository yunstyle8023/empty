//
//  CA_MDiscoverInvestmentManageFoundsModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/31.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"
#import "CA_MDiscoverProjectDetailModel.h"

@interface  CA_MDiscoverInvestmentBusiness_TraceModel : CA_HBaseModel
//"invest_data": "2018-05-30 07:49:58",
//"invest_enterprise": "北京和谐超越投资中心（有限合伙）",
//"invested_enterprise": "北京微名天下科技有限公司",
//"keyno": "cdaec51cca52bffa69a7e5a5998d0770"
@property (nonatomic,copy) NSString *invest_date;
@property (nonatomic,copy) NSString *invest_enterprise;
@property (nonatomic,copy) NSString *invested_enterprise;
@property (nonatomic,copy) NSString *keyno;

@end

@interface  CA_MDiscoverInvestmentPublic_Investment_EventdModel : CA_HBaseModel
//"data_id": "2f791072-b68d-4d1f-afe6-388abac96e93",
//"data_type": "project",
//"found_date": null,
//"invest_money": "1350万美元",
//"project_intro": "Castbox是一款主打出海市场的手机播客类应用，软件主攻欧美日韩等市场，为用户提供音频、播客服务。用户可以在线查看并订阅各类新闻、流行播客等自己喜欢的内容。用户可以自选主题，平台也会根据用户兴趣推荐内容。",
//"project_logo": "http://img.qichacha.com/Product/2f791072-b68d-4d1f-afe6-388abac96e93.jpg",
//"project_name": "CastBox",
//"project_round": "B轮",
//"tag_list": [
//             "文化娱乐",
//             "招聘活跃",
//             "北大系",
//             "360系",
//             "小米系",
//             "知名风投",
//             "团队优秀",
//             "内容",
//             "出海",
//             "海外"
//             ]
@property (nonatomic,copy) NSString *data_id;
@property (nonatomic,copy) NSString *data_type;
@property (nonatomic,copy) NSString *found_date;
@property (nonatomic,copy) NSString *invest_money;
@property (nonatomic,copy) NSString *project_intro;
@property (nonatomic,copy) NSString *project_logo;
@property (nonatomic,copy) NSString *project_name;
@property (nonatomic,copy) NSString *project_round;
@property (nonatomic,strong) NSArray *tag_list;
@end

@interface CA_MDiscoverInvestmentManaged_FundModel : CA_HBaseModel

//"enterprise_name": "IDG资本投资顾问（北京）有限公司",
//"found_date": "2006-03-20 00:00:00",
//"keyno": "ffa456e0a4ffab86691847b57f92377c",
//"oper_name": "熊晓鸽 (SHONG  HUGO)",
//"regist_capi": "300万美元"

@property (nonatomic,copy) NSString *enterprise_name;
@property (nonatomic,copy) NSString *found_date;
@property (nonatomic,copy) NSString *keyno;
@property (nonatomic,copy) NSString *oper_name;
@property (nonatomic,copy) NSString *regist_capi;
@end

@interface CA_MDiscoverInvestmentInvestor_ListModel : CA_HBaseModel
@property (nonatomic,copy) NSString *enterprise_name;
@property (nonatomic,copy) NSString *keyno;
@property (nonatomic,copy) NSString *ratio;
@end

@interface CA_MDiscoverInvestmentInvestment_FundModel : CA_MDiscoverInvestmentManaged_FundModel

//"enterprise_name": "珠海爱奇道口投资管理中心(有限合伙)",
//"found_date": "2017-03-22 00:00:00",
//"investor_list": [
//                  {
//                      "enterprise_name": "和谐爱奇投资管理（北京）有限公司",
//                      "keyno": "ea93a6eb790ce51c7486909c84dd0ced",
//                      "ratio": "59.94%"
//                  }
//                  ],
//"keyno": "7e26357ebecca18a813f89c04fc9d12d",
//"oper_name": "珠海爱奇道口投资管理有限公司(委派代表:钟秋月)",
//"regist_capi": ""
@property (nonatomic,strong) NSMutableArray<CA_MDiscoverInvestmentInvestor_ListModel *> *investor_list;
@end


@interface CA_MDiscoverInvestmentRequestModel : CA_HBaseModel
//"data_type": "member",
//"gp_id": "xxxxxx1",
//"page_size": 10,
//"page_num": 1
@property (nonatomic,copy) NSString *data_type;
@property (nonatomic,copy) NSString *gp_id;
@property (nonatomic,strong) NSNumber *page_size;
@property (nonatomic,strong) NSNumber *page_num;
@end


@interface CA_MDiscoverInvestmentManageFoundsModel : CA_HBaseModel
//"data_list": [
//              {
//                  "member_intro": "熊生课程。1996年毕业于哈佛大学商学院高级管理班。",
//                  "member_logo": "http://qichacha.oss-cn-qingdao.aliyuncs.com/Investment/personImg/0c2a1b8eada4803abd90386df241cbf3_熊晓鸽.jpg",
//                  "member_name": "熊晓鸽",
//                  "member_position": "创始合伙人"
//              }...
//              ],
//"page_num": 1,
//"page_size": 10,
//"total_count": 49
@property (nonatomic,strong) NSMutableArray<CA_MDiscoverMember_list *> *data_list;
@property (nonatomic,strong) NSNumber *page_num;
@property (nonatomic,strong) NSNumber *page_size;
@property (nonatomic,strong) NSNumber *total_count;
@end
