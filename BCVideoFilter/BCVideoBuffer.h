//
//  BCVideoBuffer.h
//  BCVideoFilterDemo
//
//  Created by 陈明标 on 8/19/16.
//  Copyright © 2016 陈明标. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

/**
 *  视频处理中的代码块回调
 *
 *  @param buffer   帧像素
 *  @param isFinish 是否处理完成
 *  @param error    处理出错
 */
typedef void(^BCVideoBufferStatus)(CVPixelBufferRef buffer, BOOL isFinish, NSError *error);


@interface BCVideoBuffer : NSObject

/**
 *  初始化视频
 *
 *  @param url          视频URL
 *  @param status       视频处理中回调
 */
- (instancetype)initWithUrl:(NSURL *)url
          completionHandler:(BCVideoBufferStatus)status;


/**
 *  初始化视频
 *
 *  @param asset        视频Asset
 *  @param status       视频处理中回调
 */
- (instancetype)initWithAsset:(AVAsset *)asset
            completionHandler:(BCVideoBufferStatus)status;

/**
 *  开始获取视频帧数
 */
- (void)start;

/**
 *  停止获取视频帧数
 */
- (void)stop;

/**
 *  暂停获取视频帧数
 */
- (void)pause;

/**
 *  恢复获取视频帧数
 */
- (void)resume;

@end
