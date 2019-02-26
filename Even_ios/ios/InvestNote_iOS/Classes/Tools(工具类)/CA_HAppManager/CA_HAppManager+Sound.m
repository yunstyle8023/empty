//
//  CA_HAppManager+Sound.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2017/12/5.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "CA_HAppManager+Sound.h"

#import <AVKit/AVKit.h>

@implementation CA_HAppManager (Sound)

- (void)startRecord{
    
    AVAudioSession *session =[AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if (session == nil) {
        
        NSLog(@"Error creating session: %@",[sessionError description]);
        
    }else{
        [session setActive:YES error:nil];
        
    }
    
    
    //1.获取沙盒地址
    NSString *homeDocumentPath = NSTemporaryDirectory();
    NSString *path = [homeDocumentPath stringByAppendingString:@"record/"];
    
    NSString * recordFileName = [NSString stringWithFormat:@"RRecord%@.wav", [[NSDate date] stringWithFormat:@"HHmmss"]];//@"RRecord.wav";
    self.recordFileName = recordFileName;
    
//    if (self.recordFileName.length) {
//        recordFileName = self.recordFileName;
//    }else{
//        recordFileName = [NSString stringWithFormat:@"RRecord%@.wav", [[NSDate date] stringWithFormat:@"HHmmss"]];//@"RRecord.wav";
//        self.recordFileName = recordFileName;
//    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString * filePath = [path stringByAppendingString:recordFileName];

//    while ([manager fileExistsAtPath:filePath]) {
//        recordFileName = [@"0" stringByAppendingString:recordFileName];
//        filePath = [path stringByAppendingString:recordFileName];
//        self.recordFileName = recordFileName;
//    }
    
    //2.获取文件路径
    NSURL * recordFileUrl = [NSURL fileURLWithPath:filePath];
    
    //设置参数
    NSDictionary * recordSetting = [self audioRecordingSettings];
    
    
    NSError * recorderError;
    self.recorder = [[AVAudioRecorder alloc] initWithURL:recordFileUrl settings:recordSetting error:&recorderError];
    
    
    if (self.recorder) {
        
        self.recorder.meteringEnabled = YES;
        [self.recorder prepareToRecord];
        [self.recorder record];
        
    }else{
        NSLog(@"音频格式和文件存储格式不匹配,无法初始化Recorder");
    }
}
- (void)stopRecord{
    
    if ([self.recorder isRecording]) {
        [self.recorder stop];
    }
    
}
- (void)playRecord:(NSURL *)recordUrl viewController:(UIViewController *)viewController{
    
    if ([self.recorder isRecording]) {
        if (self.recorderStopBlock) {
            self.recorderStopBlock();
        }
    }
    [self.recorder stop];
    
//    //1.获取沙盒地址
//    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/"];
//    NSString * filePath = [path stringByAppendingString:recordFileName];
//
//    //2.获取文件路径
//    NSURL * recordFileUrl = [NSURL fileURLWithPath:filePath];
    
    AVPlayerViewController * vc = [AVPlayerViewController new];
    vc.player = [AVPlayer playerWithURL:recordUrl];
    [viewController presentViewController:vc animated:YES completion:^{
        [vc.player play];
    }];
    
}

- (NSDictionary *)audioRecordingSettings{
    
    NSDictionary *result = nil;
    
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    //设置录音格式 AVFormatIDKey==kAudioFormatLinearPCM
//    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
//    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEGLayer3] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:11025.0] forKey:AVSampleRateKey];
    //录音通道数 1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    //线性采样位数 8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    result = [NSDictionary dictionaryWithDictionary:recordSetting];
    return result;
}



@end
