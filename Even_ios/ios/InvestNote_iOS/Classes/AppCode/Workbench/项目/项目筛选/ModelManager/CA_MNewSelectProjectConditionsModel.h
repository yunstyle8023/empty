//
//  CA_MNewSelectProjectConditionsModel.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/24.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

@interface CA_MNewSelectProjectConditionsDataListModel  : CA_HBaseModel
@property (nonatomic,strong) NSNumber *ids;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign,getter=isSelected) BOOL selected;
@end

@interface CA_MNewSelectProjectConditionsModel : CA_HBaseModel
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *field;
@property (nonatomic,strong) NSMutableArray<CA_MNewSelectProjectConditionsDataListModel *> *data_list;

@property (nonatomic,assign) int selectedCount;
@property (nonatomic,assign,getter=isSelected) BOOL selected;
@end

//"data_list": [
//              {
//                  "id": 0,
//                  "name": "全部"
//              },
//              {
//                  "id": -1,
//                  "name": "我参与的"
//              },
//              {
//                  "id": 7,
//                  "name": "系统管理员"
//              },
//              ],
//"field": "user_ids",
//"name": "人员筛选"
