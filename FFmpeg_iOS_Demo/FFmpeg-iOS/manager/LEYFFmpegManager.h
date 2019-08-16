//
//  LEYFFmpegManager.h
//  FFmpeg_iOS_Demo
//
//  Created by panf on 2019/8/16.
//  Copyright © 2019 无码科技. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LEYFFmpegManager : NSObject

+ (LEYFFmpegManager *)shared;


/**
 转换视频

 @param inputPath 输入视频路径
 @param outpath 输出视频路径
 @param processBlock 进度回调
 @param completionBlock 结束回调
 */
- (void)converWithInputPath:(NSString *)inputPath
                 outputPath:(NSString *)outpath
               processBlock:(void (^)(float process))processBlock
            completionBlock:(void (^)(NSError *error))completionBlock;










/*监听进度使用*/
//设置总时长
+ (void)setDuration:(long long)time;

// 设置当前时间
+ (void)setCurrentTime:(long long)time;

// 转换停止
+ (void)stopRuning;

@end

NS_ASSUME_NONNULL_END
