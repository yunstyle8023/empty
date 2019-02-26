//
//  CA_HNoteModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/1/12.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

typedef enum : NSUInteger {
    CA_HAddNoteTypeString = 0,
    CA_HAddNoteTypeImage,
    CA_HAddNoteTypeFile,
    CA_HAddNoteTypeRecord,
} CA_HAddNoteType;

@interface CA_HNoteContentModel : CA_HBaseModel

@property (nonatomic, assign) CA_HAddNoteType enumType;
@property (nonatomic, copy) NSString *type; //: 'string',
@property (nonatomic, copy) NSString *content; //: '文本内容',          # 对于文本类型, 只有此字段有效
@property (nonatomic, strong) NSNumber *img_width; //: 0,
@property (nonatomic, strong) NSNumber *img_height; //': 0,
@property (nonatomic, strong) NSNumber *file_id; //: 0,
@property (nonatomic, copy) NSString *file_name; //: '',
@property (nonatomic, copy) NSString *file_type; //: '',
@property (nonatomic, strong) NSNumber *file_size; //: 0,# 单位为kb
@property (nonatomic, copy) NSString *file_url; //: '',
@property (nonatomic, copy) NSString *file_preview_url; //: '',
@property (nonatomic, strong) NSNumber *record_duration; //: 0, # 单位为秒

@property (nonatomic, strong) id file;

@end

@interface CA_HNoteModel : CA_HBaseModel

@property (nonatomic, copy) NSNumber *note_id;
@property (nonatomic, copy) NSString *object_typel;
@property (nonatomic, copy) NSNumber *object_id; //': 1,
@property (nonatomic, copy) NSNumber *note_type_id; //': 3,
@property (nonatomic, copy) NSString *note_title; //': 'note_title',
@property (nonatomic, copy) NSString *location; //': ['中国', '北京'],           # 根据多种条件获得的地址位置
@property (nonatomic, strong) NSMutableArray<CA_HNoteContentModel *> *content; //: [

@end
