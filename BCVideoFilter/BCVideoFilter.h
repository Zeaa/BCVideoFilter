//
//  BCVideoFilter.h
//  BCVideoFilterDemo
//
//  Created by 陈明标 on 9/2/16.
//  Copyright © 2016 陈明标. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "BCFilter.h"
#import "BCGLKView.h"

@interface BCVideoFilter : NSObject

// OpenGL ES2 视图
@property (nonatomic, strong) BCGLKView *view;

@property (nonatomic, strong) AVAsset *asset;

// 当前的滤镜
@property (nonatomic, copy, readonly) NSString *currentFilter;

typedef void(^BCVideoFilterStatus)(float progress, BOOL isFinish, NSError *error);

#pragma mark - 初始化操作

/**
 *  初始化方法
 */
- (instancetype)initWithFrame:(CGRect)frame
                videoInputUrl:(NSURL *)videoInputUrl;

/**
 *  初始化方法
 */
- (instancetype)initWithFrame:(CGRect)frame
                videoInputUrl:(NSURL *)videoInputUrl
                       filter:(BCFilter *)filter;


#pragma mark - 播放控制

/** 开始获取视频帧数*/
- (void)start;

/** 停止获取视频帧数*/
- (void)stop;

/** 暂停获取视频帧数*/
- (void)pause;

/** 恢复获取视频帧数*/
- (void)resume;

#pragma mark - 滤镜切换

/** 添加滤镜*/
- (void)addFilter:(BCFilter *)filter;

/** 更换滤镜*/
- (void)changeFilter:(BCFilter *)filter;

/**
 *  开始加载视频
 */
- (void)processVideoWithBlockCompletionHandler:(BCVideoFilterStatus)status;

/**
 *  导出视频
 */
- (void)exportVideoWithVideoOuputPath:(NSString *)videooutputPath;

@end
