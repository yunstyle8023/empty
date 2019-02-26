//
//  CA_HNoteDetailModel.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/3/15.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HBaseModel.h"

#import "CA_HTodoDetailModel.h"

@interface CA_HNoteDetailContentModel : CA_HBaseModel

@property (nonatomic, copy) NSString *type;//": "image",
@property (nonatomic, copy) NSString *content;//": "",# 对于文本类型, 只有此字段有效
@property (nonatomic, strong) NSNumber *img_width;//": 90,# 图片需要上传宽高
@property (nonatomic, strong) NSNumber *img_height;//": 90,
@property (nonatomic, strong) NSNumber *file_id;//": 1,
@property (nonatomic, copy) NSString *file_name;//": "blabla.jpg",
@property (nonatomic, copy) NSString *file_type;//": "jpg",
@property (nonatomic, strong) NSNumber *file_size;//": 100,# 单位为kb
@property (nonatomic, copy) NSString *file_url;//": "http://example.com/1/blabla.jpg",
@property (nonatomic, copy) NSString *file_preview_url;//": "http://example.com/1/blabla.jpg", # 图片的file_url 与file_preview_url 相同
@property (nonatomic, strong) NSNumber *record_duration;//": 0,# 单位为秒

@property (nonatomic, copy) NSAttributedString *attributedContent;

@end


@interface CA_HNoteDetailModel : CA_HBaseModel

@property (nonatomic, strong) NSNumber *note_id;//": 1,
@property (nonatomic, strong) NSNumber *object_id;//": 1,
@property (nonatomic, copy) NSString *object_type;//": "project",
@property (nonatomic, copy) NSString *object_name;//": "测试项目01",
@property (nonatomic, strong) NSNumber *note_type_id;//": 3,
@property (nonatomic, copy) NSString *note_type_name;//": "测试笔记类型01",
@property (nonatomic, copy) NSString *note_title;//": "note_title",
@property (nonatomic, strong) CA_HParticipantsModel *creator;//": {
@property (nonatomic, strong) NSNumber *word_count;//": 100,                      # 字数统计
@property (nonatomic, strong) NSNumber *char_count;//": 150,                      # 字符统计
@property (nonatomic, strong) NSNumber *reading_time;//": 40,                     # 阅读时间, 单位是秒
@property (nonatomic, strong) NSNumber *paragraph_count;//": 5,                   # 段落统计
@property (nonatomic, strong) NSArray<NSString *> *location;//": ["中国", "北京"],                                   # 笔记创建地点
@property (nonatomic, strong) NSArray<NSString *> *privilege;//": ["comment", "edit", "delete", "move", "jump"                   # 对于笔记详情的更多权限comment为评论,edit为编辑,delete为删除,move为移动,jump为跳转],
@property (nonatomic, strong) NSNumber *ts_create;//": "1527777777",                            # 笔记创建时间
@property (nonatomic, strong) NSNumber *ts_update;//": "1527777777",                            # 笔记更新时间
@property (nonatomic, strong) NSArray<CA_HNoteDetailContentModel *> *content;//": [

@property (nonatomic, strong) NSMutableArray<CA_HTodoDetailCommentModel *> *comment_list;//": [

@end
