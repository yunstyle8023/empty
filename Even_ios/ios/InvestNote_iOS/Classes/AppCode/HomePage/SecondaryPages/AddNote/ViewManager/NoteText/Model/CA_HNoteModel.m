//
//  CA_HNoteModel.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/1/12.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HNoteModel.h"

@implementation CA_HNoteContentModel

- (void)setEnumType:(CA_HAddNoteType)enumType{
    _enumType = enumType;
    
    switch (enumType) {
        case CA_HAddNoteTypeImage:
            _type = @"image";
            break;
        case CA_HAddNoteTypeRecord:
            _type = @"record";
            break;
        case CA_HAddNoteTypeFile:
            _type = @"attach";
            break;
        default:
            _type = @"string";
            break;
    }
}

- (void)setType:(NSString *)type{
    _type = type;
    
    if ([type isEqualToString:@"string"]) {
        _enumType = CA_HAddNoteTypeString;
    }else if ([type isEqualToString:@"image"]) {
        _enumType = CA_HAddNoteTypeImage;
    }else if ([type isEqualToString:@"record"]) {
        _enumType = CA_HAddNoteTypeRecord;
    }else if ([type isEqualToString:@"attach"]) {
        _enumType = CA_HAddNoteTypeFile;
    }
}

@end

@implementation CA_HNoteModel

- (void)setContent:(NSMutableArray<CA_HNoteContentModel *> *)content{
    if (![content isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dic in content) {
        
        if ([dic isKindOfClass:[CA_HNoteContentModel class]]) {
            [array addObject:dic];
        }else{
            [array addObject:[CA_HNoteContentModel modelWithDictionary:dic]];
        }
    }
    _content = array;
}

@end
