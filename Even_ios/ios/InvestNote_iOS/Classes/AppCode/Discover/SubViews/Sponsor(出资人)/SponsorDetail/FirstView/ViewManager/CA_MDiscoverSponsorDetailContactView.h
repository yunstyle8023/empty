//
//  CA_MDiscoverSponsorDetailContactView.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/5/16.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CA_MDiscoverSponsorContact_data;

@interface CA_MDiscoverSponsorDetailContactView : UIView
@property (nonatomic,copy) NSString *data_id;
@property (nonatomic,assign) BOOL is_imported;
@property (nonatomic,strong) NSNumber *count;
@property (nonatomic,strong) CA_MDiscoverSponsorContact_data *contact_data;
@property (nonatomic,copy) void(^lookBlock)(NSNumber *count);
@end
