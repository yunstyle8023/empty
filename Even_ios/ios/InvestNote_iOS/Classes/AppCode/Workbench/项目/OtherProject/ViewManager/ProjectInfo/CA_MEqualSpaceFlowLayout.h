//
//  EqualSpaceFlowLayout.h
//  InvestNote_iOS
//
//  Created by 野猪哥 on 2018/2/28.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  CA_MEqualSpaceFlowLayoutDelegate<UICollectionViewDelegateFlowLayout>

@end

@interface CA_MEqualSpaceFlowLayout : UICollectionViewFlowLayout
@property (nonatomic,weak) id<CA_MEqualSpaceFlowLayoutDelegate> delegate;
@end
