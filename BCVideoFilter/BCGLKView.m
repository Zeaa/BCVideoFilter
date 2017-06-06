//
//  BCCoreImageView.m
//  BCVideoFilterDemo
//
//  Created by 陈明标 on 8/19/16.
//  Copyright © 2016 陈明标. All rights reserved.
//

#import "BCGLKView.h"

#import <GLKit/GLKit.h>

@interface BCGLKView () {
    CIContext *coreImageContext;
}

@end

@implementation BCGLKView

- (instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        self = [self initWithFrame:frame context:context];
    }
    
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame context:(EAGLContext *)context {
    self = [super initWithFrame:frame context:context];
    
    if (self) {
        coreImageContext = [CIContext contextWithEAGLContext:context];
        [self setEnableSetNeedsDisplay:false];
    }
    
    return self;
}

- (void) drawRect:(CGRect)rect {
    
    CGRect origninalRect = CGRectMake(0, 0, self.drawableWidth, self.drawableHeight);
    [coreImageContext drawImage:self.image inRect:origninalRect fromRect:self.image.extent];
    
}

@end

