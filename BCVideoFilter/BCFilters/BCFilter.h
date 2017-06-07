//
//  BCFilter.h
//  BCVideoFilterDemo
//
//  Created by 陈明标 on 9/2/16.
//  Copyright © 2016 陈明标. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCFilter : NSObject

@property (nonatomic, copy) NSString *currentFilter;    // 当前滤镜
//@property (nonatomic, copy) NSArray *parameters;      // 滤镜参数

/**
 *  获取处理后的图片
 *
 *  @param image 处理前的图片
 *
 *  @return 处理后的图片
 */
- (CIImage *)getFilterHanldeImage:(CIImage *)image;

@end
