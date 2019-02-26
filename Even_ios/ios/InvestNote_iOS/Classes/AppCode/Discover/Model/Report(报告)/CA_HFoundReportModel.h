//
//  CA_HFoundReportModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/5/30.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

@interface CA_HFoundReportData: CA_HBaseModel

@property (nonatomic, copy) NSString *report_id;
@property (nonatomic, strong) NSNumber *report_date;//1526572800,
@property (nonatomic, copy) NSString *report_name;//"易观：《中国网络视频市场年度盘点分析2018 》.pdf",
@property (nonatomic, copy) NSString *report_size;//"3.34MB",
@property (nonatomic, copy) NSString *report_url;//"http://co-image.qichacha.com/upload/chacha/att/20180518/1526623108336879.pdf",
@property (nonatomic, copy) NSString *file_icon;//"https://even-static-public.oss-cn-beijing.aliyuncs.com/mobile/fileicon/icons_file_rar%403x.png",
@property (nonatomic, copy) NSString *reseacher;
@property (nonatomic, strong) NSNumber *status;

@property(nonatomic, copy) NSAttributedString *report_name_attributedText;
@property(nonatomic, copy) NSAttributedString *reseacher_attributedText;
@property(nonatomic, copy) NSAttributedString *content_attributedText;

@property (nonatomic, assign) BOOL saved;
- (void)checkSaved;


@end

@interface CA_HFoundReportModel : CA_HBaseModel

@property (nonatomic, strong) NSNumber *page_size;
@property (nonatomic, strong) NSNumber *page_num;
@property (nonatomic, copy) NSString *data_type;
@property (nonatomic, strong) NSNumber *total_count;
@property (nonatomic, strong) NSNumber *total_page;
@property (nonatomic, strong) NSArray<CA_HFoundReportData *> *data_list;

@end
