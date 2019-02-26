//
//  CA_MDiscoverRelatedPersonTableView.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/4/24.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CA_MDiscoverRelatedPersonData_list;

@interface CA_MDiscoverRelatedPersonTableView : UITableView
@property (nonatomic,copy) NSString *enterprise_str;
@property (nonatomic,copy) NSString *person_name;
@property (nonatomic,copy) NSString *position_type;
@property (nonatomic,copy) void(^pushBlock)(CA_MDiscoverRelatedPersonData_list *model);
-(void)requestData;
@end

