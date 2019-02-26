//
//  CA_HSpacingFlowLayout.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/27.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HSpacingFlowLayout.h"

@implementation CA_HSpacingFlowLayout

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    if (attributes.count == 0) {
        return attributes;
    }
    
    UICollectionViewLayoutAttributes *current = attributes[0];
    CGRect myFrame = current.frame;
    myFrame.origin.x = self.sectionInset.left;
    current.frame = myFrame;
    
    for(int i = 1; i < [attributes count]; ++i) {
        UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
        UICollectionViewLayoutAttributes *prevLayoutAttributes = attributes[i - 1];
        double maximumSpacing = _maximumSpacing;
        double origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        
        CGRect frame = currentLayoutAttributes.frame;
        if(prevLayoutAttributes.indexPath.section == currentLayoutAttributes.indexPath.section
           &&
           origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width - self.sectionInset.right) {
            frame.origin.x = origin + maximumSpacing;
        }else{
            frame.origin.x = self.sectionInset.left;//[attributes.firstObject frame].origin.x;
        }
        currentLayoutAttributes.frame = frame;
    }
    
    return attributes;
}

@end
