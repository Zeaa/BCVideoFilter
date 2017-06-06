//
//  BCVideoBuffer.h
//  BCVideoFilterDemo
//
//  Created by 陈明标 on 8/19/16.
//  Copyright © 2016 陈明标. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVAsset;
@interface BCVideoBuffer : NSObject

typedef void(^BCVideoBufferStatus)(CVPixelBufferRef buffer, BOOL isFinish, NSError *error);

/**
 *  初始化视频
 *
 *  @param url          视频URL
 *  @param status       回调
 *
 *  @return self
 */
- (instancetype)initWithUrl:(NSURL *)url
          completionHandler:(BCVideoBufferStatus)status;


/**
 *  初始化视频
 *
 *  @param asset        视频Asset
 *  @param status       回调
 *
 *  @return self
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
