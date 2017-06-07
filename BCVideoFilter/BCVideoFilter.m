//
//  BCVideoFilter.m
//  BCVideoFilterDemo
//
//  Created by 陈明标 on 9/2/16.
//  Copyright © 2016 陈明标. All rights reserved.
//

#import "BCVideoFilter.h"
#import "BCVideoBuffer.h"

#import <ImageIO/ImageIO.h>
#import <QuartzCore/CoreAnimation.h>

@interface BCVideoFilter()
{
    BCVideoBuffer *videoBufferObject;
}

@property (nonatomic, strong) BCFilter *filter;             // 滤镜
@property (nonatomic, strong) NSURL *videoInputUrl;         // 视频输入地址
@property (nonatomic, assign) int frameIndex;               // 视频帧索引
//@property (nonatomic, assign) int frameCount;             // 视频帧数
//@property (nonatomic, strong) NSURL *watermarkInputUrl;   // 水印输入地址

@end

@implementation BCVideoFilter


// 初始化
- (instancetype)initWithFrame:(CGRect)frame
                videoInputUrl:(NSURL *)videoInputUrl
{
    return [self initWithFrame:frame videoInputUrl:videoInputUrl filter:nil];
}

// 初始化
- (instancetype)initWithFrame:(CGRect)frame
                videoInputUrl:(NSURL *)videoInputUrl
                       filter:(BCFilter *)filter
{
    self = [super init];
    if (self) {
        // 判断参数
        if ( videoInputUrl == nil )
        {
            NSLog(@"videoInputUrl is empty");
            return nil;
        }
        // 添加滤镜
        if (filter )
        {
            [self addFilter:filter];
            self.filter = filter;
        }
        
        // 初始化参数
        _frameIndex = 0;
        _videoInputUrl = videoInputUrl;
        _view = [[BCGLKView alloc] initWithFrame:frame];
    }
    return self;
}

#pragma mark - 视频控制

- (void)start {
    [videoBufferObject start];
}

- (void)pause {
    [videoBufferObject pause];
}

- (void)resume {
    [videoBufferObject resume];
}

- (void)stop {
    [videoBufferObject stop];
}

//  添加滤镜
- (void)addFilter:(BCFilter *)filter
{
    self.filter = filter;
}

// 更换滤镜
- (void)changeFilter:(BCFilter *)filter
{
    
    self.filter = filter;
}

// filter set方法重写
- (void)setFilter:(BCFilter *)filter
{
    _filter = filter;
    _currentFilter = [_filter currentFilter];
}

/**
 *  开始加载视频
 */
- (void)processVideoWithBlockCompletionHandler:(BCVideoFilterStatus)status
{
    // 获取原本形变
    AVAsset *videoAsset = [AVAsset assetWithURL:_videoInputUrl];
    NSArray *tracks = [videoAsset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
    CGAffineTransform orginialTransForm = videoTrack.preferredTransform;
    // 根据CoreImage的坐标轴进行转换回正确的角度
    CGFloat middle = orginialTransForm.b;
    orginialTransForm.b = orginialTransForm.c;
    orginialTransForm.c = middle;
    
    __weak BCVideoFilter *weakSelf = self;
    
    videoBufferObject = [[BCVideoBuffer alloc]
                         initWithAsset:videoAsset
                          //initWithUrl:_videoInputUrl
                        completionHandler:^(CVPixelBufferRef buffer, BOOL isFinish, NSError *error)
    {
        
        if(isFinish == NO)
        {
            _frameIndex++;
            
            // buffer转成ciImage
            CIImage *ciImage = [CIImage imageWithCVPixelBuffer:buffer];
            // 添加滤镜
            ciImage = [weakSelf.filter getFilterHanldeImage:ciImage];
            // 应用形变
            ciImage = [ciImage imageByApplyingTransform:orginialTransForm];
            
            // 应用到界面上
            weakSelf.view.image = ciImage;
            [weakSelf.view display];
            
        }else {
            _frameIndex = 0;
        }
        
        status(_frameIndex, isFinish, nil);
        
    }];
}

#pragma mark - 应用视频滤镜

// 将Core Image滤镜应用于视频媒体
- (void)applyingCoreImageFiltersToAVideoAsset {
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    AVVideoComposition *composition = [AVVideoComposition videoCompositionWithAsset: self.asset applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest *request){
        
        // Clamp to avoid blurring transparent pixels at the image edges
        // clamp to 避免在图像边缘模糊透明像素
        CIImage *source = [request.sourceImage imageByClampingToExtent];
        [filter setValue:source forKey:kCIInputImageKey];
        
        // Vary filter parameters based on video timing
        // 基于视频时基的不同滤镜参数
        Float64 seconds = CMTimeGetSeconds(request.compositionTime);
        [filter setValue:@(seconds * 10.0) forKey:kCIInputRadiusKey];
        
        // Crop the blurred output to the bounds of the original image
        // 将模糊输出裁剪到原始图像的边界
        CIImage *output = [filter.outputImage imageByCroppingToRect:request.sourceImage.extent];
        
        // Provide the filter output to the composition
        // 向composition提供滤镜输出
        [request finishWithImage:output context:nil];
    }];
}

#pragma mark - 导出视频

// TODO: 导出视频时合成滤镜
- (void)exportVideoWithVideoOuputPath:(NSString *)videooutputPath {
    
    // 应用视频滤镜
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoCompositionWithAsset:self.asset applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest * _Nonnull request) {
        
        CIImage *source = request.sourceImage;
        CIFilter *filter = [CIFilter filterWithName:self.currentFilter];
        [filter setValue:source forKey:kCIInputBackgroundImageKey];
        
        // 处理image
        [request finishWithImage:filter.outputImage context:nil];
    }];
    // 导出
}

@end
