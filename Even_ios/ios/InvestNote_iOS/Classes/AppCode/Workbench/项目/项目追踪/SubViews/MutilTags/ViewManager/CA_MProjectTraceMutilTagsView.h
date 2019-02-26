//
//  CA_MProjectTraceMutilTagsView.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/7/17.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TraceType_Tag,
    TraceType_Normal
} TraceCellType;

@interface CA_MProjectTraceMutilTagsView : UIView

-(void)configView:(NSNumber *)project_id
          tagName:(NSString *)tagName
    traceCellType:(TraceCellType)traceCellType;

@end
