//
//  ShareViewController.m
//  ShareExtension
//
//  Created by 野猪哥 on 2018/2/5.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "ShareViewController.h"

#define CA_H_UrlSchemes @"InvestNote://"

@interface ShareViewController ()

@end

@implementation ShareViewController

-(void)viewDidLoad{
    
    [self didSelectPost];
    
    [super viewDidLoad];
    
}

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

- (void)didSelectPost {
    [self.extensionContext.inputItems enumerateObjectsUsingBlock:^(NSExtensionItem * _Nonnull extItem, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [extItem.attachments enumerateObjectsUsingBlock:^(NSItemProvider * _Nonnull itemProvider, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [itemProvider.registeredTypeIdentifiers enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    [itemProvider loadItemForTypeIdentifier:obj options:nil completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                        
                        if ([(NSObject *)item isKindOfClass:[NSURL class]]){
                            NSData* data = [NSData dataWithContentsOfURL:(NSURL *)item];
//                            NSLog(@"分享的data = %@", data);
                            
                            NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.chengantech.InvestNoteZGC.Share"];
                            [userDefaults setObject:data forKey:@"investNote_share_data"];
                            
                            NSString *fileName = [[(NSURL *)item absoluteString] componentsSeparatedByString:@"/"].lastObject;
                            
                            [self.extensionContext completeRequestReturningItems:@[] completionHandler:^(BOOL expired) {
                                [self openAppWithURL:fileName text:@"investNote_share_data"];
                                *stop = YES;
                            }];
                        }
                    }];
                });
            }];
        }];
    }];
}

- (NSArray *)configurationItems {
    return @[];
}

- (void)openAppWithURL:(NSString*)urlString text:(NSString*)text {
    UIResponder* responder = self;
    while ((responder = [responder nextResponder]) != nil) {
        if ([responder respondsToSelector:@selector(openURL:)] == YES) {
            [responder performSelector:@selector(openURL:) withObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", CA_H_UrlSchemes, [self urlStringForShareExtension:urlString text:text]]]];
        }
    }
}

- (NSString*)urlStringForShareExtension:(NSString*)urlString text:(NSString*)text {
    NSString* finalUrl=[NSString stringWithFormat:@"%@____%@", text, urlString];
    finalUrl =  (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                      (CFStringRef)finalUrl,
                                                                                      NULL,
                                                                                      (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                      kCFStringEncodingUTF8 ));
    return finalUrl;
}

@end
