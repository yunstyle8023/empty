//
//  YZGButton.m
//  ceshi
//  Created by yezhuge on 2017/11/18.
//  God bless me without no bugs.
//

#import "CA_MButton.h"

@interface CA_MButton()

@end

@implementation CA_MButton

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if(self.titleLabel.text && self.imageView.image){
        CGFloat marginH = (self.frame.size.height - self.imageView.frame.size.height - self.titleLabel.frame.size.height)/3;
        //图片
        CGPoint imageCenter = self.imageView.center;
        imageCenter.x = self.frame.size.width/2;
        imageCenter.y = self.imageView.frame.size.height/2 + marginH;
        self.imageView.center = imageCenter;
        //文字
        CGRect newFrame = self.titleLabel.frame;
        newFrame.origin.x = 0;
//        if (isIPhone5) {
//            newFrame.origin.y = self.frame.size.height - newFrame.size.height - marginH ;
//        }else{
        newFrame.origin.y = self.frame.size.height - newFrame.size.height - marginH + 3 ;
//        }
        
        newFrame.size.width = self.frame.size.width;
        self.titleLabel.frame = newFrame;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
}

@end
