//
//  CA_HAddNoteViewManager.h
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/4/2.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CA_HAddNoteTextView.h"

@interface CA_HAddNoteViewManager : NSObject

@property (nonatomic, strong) UIButton *rightButton;
- (UIBarButtonItem *)barButtonItem:(id)target action:(SEL)action;

@property (nonatomic, strong) CA_HAddNoteTextView *noteView;

@end
