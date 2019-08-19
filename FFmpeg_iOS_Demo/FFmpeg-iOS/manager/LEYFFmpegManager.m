//
//  LEYFFmpegManager.m
//  FFmpeg_iOS_Demo
//
//  Created by panf on 2019/8/16.
//  Copyright © 2019 无码科技. All rights reserved.
//

#import "LEYFFmpegManager.h"
#import "ffmpeg.h"


@interface LEYFFmpegManager ()

@property (nonatomic, assign) BOOL isRuning;
@property (nonatomic, assign) BOOL isBegin;
@property (nonatomic, assign) long long fileDuration;
@property (nonatomic, copy) void (^processBlock)(float process);
@property (nonatomic, copy) void (^completionBlock)(NSError *error);

@property (nonatomic, assign) long long originTime;
@property (nonatomic, assign) long long converTotalTime;

@end

@implementation LEYFFmpegManager

+ (LEYFFmpegManager *)shared {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}


- (void)converWithInputPath:(NSString *)inputPath
     outputPath:(NSString *)outpath
     originTime:(long long)originTime
converTotalTime:(long long)converTotalTime
   processBlock:(void (^)(float process))processBlock
            completionBlock:(void (^)(NSError *error))completionBlock {
    self.processBlock = processBlock;
    self.completionBlock = completionBlock;
    self.isBegin = NO;
    
    self.originTime = originTime;
    self.converTotalTime = converTotalTime;
    
    // ffmpeg语法，可根据需求自行更改      !#$ 为分割标记符，也可以使用空格代替
    NSString *commandStr = [NSString stringWithFormat:@"ffmpeg!#$-ss!#$%lld!#$-t!#$%lld!#$-i!#$%@!#$-b:v!#$2000K!#$-y!#$%@",originTime, converTotalTime, inputPath, outpath];

    [[[NSThread alloc] initWithTarget:self selector:@selector(runCmd:) object:commandStr] start];
}



- (void)runCmd:(NSString *)commandStr{
    // 判断转换状态
    if (self.isRuning) {
        NSLog(@"正在转换,稍后重试");
    }
    self.isRuning = YES;

    // 根据 !#$ 将指令分割为指令数组
    NSArray *argv_array = [commandStr componentsSeparatedByString:(@"!#$")];

    
    int argc = (int)argv_array.count;
    char** argv = (char**)malloc(sizeof(char*)*argc);
    for(int i=0; i < argc; i++) {
        argv[i] = (char*)malloc(sizeof(char)*1024);
        strcpy(argv[i],[[argv_array objectAtIndex:i] UTF8String]);
    }
    
    ffmpeg_main(argc,argv);
}





+ (void)setDuration:(long long)time {
    [LEYFFmpegManager shared].fileDuration = time;
}

+ (void)setCurrentTime:(long long)time {
    LEYFFmpegManager *mgr = [LEYFFmpegManager shared];
    mgr.isBegin = YES;
    
    if (mgr.processBlock && mgr.fileDuration) {
        float total = MIN(mgr.fileDuration - mgr.originTime, mgr.converTotalTime);
        float process = time/(total * 1.00);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            mgr.processBlock(process);
        });
    }
}

+ (void)stopRuning {
    LEYFFmpegManager *mgr = [LEYFFmpegManager shared];
    NSError *error = nil;
    if (!mgr.isBegin) {
        // 判断是否开始过，没开始过就设置失败
        error = [NSError errorWithDomain:@"转换失败,请检查源文件的编码格式!"
                                    code:0
                                userInfo:nil];
    }
    if (mgr.completionBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            mgr.completionBlock(error);
        });
    }
    
    mgr.isRuning = NO;
}


@end
