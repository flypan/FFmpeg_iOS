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
 && 视频转码
 && 从指定的位置截取指定时长的视频

 @param inputPath 输入视频路径
 @param outpath 输出视频路径
 @param originTime 起始位置
 @param converTotalTime 截取的时长
 @param processBlock 进度回调
 @param completionBlock 结束回调
 
 
 -------注意，内部没做校验，起始位置originTime不要超过视频时长-------
 -------注意，内部没做校验，起始位置originTime不要超过视频时长-------
 -------注意，内部没做校验，起始位置originTime不要超过视频时长-------
 *
 */

- (void)converWithInputPath:(NSString *)inputPath
                 outputPath:(NSString *)outpath
                 originTime:(long long)originTime
            converTotalTime:(long long)converTotalTime
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
