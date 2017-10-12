//
//  TouchManager.m
//  SDLStreamingVideoExample
//
//  Created by Nicole on 10/12/17.
//  Copyright © 2017 Livio. All rights reserved.
//

#import "TouchManager.h"
#import "SmartDeviceLink.h"
#import "ProxyManager.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TouchManager

- (instancetype)init {
    SDLLogV(@"Touch manager init");
    if (self = [super init]) {
        ProxyManager.sharedManager.sdlManager.streamManager.touchManager.touchEventDelegate = self;
    }
    return self;
}

#pragma mark - Tap

/**
 *  Single tap was received
 */
- (void)touchManager:(SDLTouchManager *)manager didReceiveSingleTapForView:(UIView *_Nullable)view atPoint:(CGPoint)point {
    SDLLogD(@"TOUCH MANAGER Single tap at point x: %f, y: %f", point.x, point.y);
}

/**
 *  Double tap was received
 */
- (void)touchManager:(SDLTouchManager *)manager didReceiveDoubleTapForView:(UIView *_Nullable)view atPoint:(CGPoint)point {
    SDLLogD(@"TOUCH MANAGER Double tap at point x: %f, y: %f", point.x, point.y);
}

#pragma mark - Panning

/**
 *  Panning did start
 */
- (void)touchManager:(SDLTouchManager *)manager panningDidStartInView:(UIView *_Nullable)view atPoint:(CGPoint)point {
    SDLLogD(@"TOUCH MANAGER Panning started at point x: %f, y: %f, view: %@", point.x, point.y, view);
}

/**
 *  Panning moved
 */
- (void)touchManager:(SDLTouchManager *)manager didReceivePanningFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint {
    SDLLogD(@"TOUCH MANAGER Panning to x: %f, y: %f; from x: %f, y:%f ", fromPoint.x, fromPoint.y, toPoint.x, toPoint.y);
}

/**
 *  Panning did end
 */
- (void)touchManager:(SDLTouchManager *)manager panningDidEndInView:(UIView *_Nullable)view atPoint:(CGPoint)point {
    SDLLogD(@"TOUCH MANAGER Panning ended at point x: %f, y: %f, view: %@", point.x, point.y, view);
}

/**
 *  Panning canceled
 */
- (void)touchManager:(SDLTouchManager *)manager panningCanceledAtPoint:(CGPoint)point {
    SDLLogD(@"TOUCH MANAGER Panning canceled at point x: %f, y: %f", point.x, point.y);
}

#pragma mark - Pinch

/**
 *  Pinch started
 */
- (void)touchManager:(SDLTouchManager *)manager pinchDidStartInView:(UIView *_Nullable)view atCenterPoint:(CGPoint)point {
    SDLLogD(@"TOUCH MANAGER Pinch started at center point x: %f, y: %f, view: %@", point.x, point.y, view);
}

/**
 *  Pinch moved
 */
- (void)touchManager:(SDLTouchManager *)manager didReceivePinchAtCenterPoint:(CGPoint)point withScale:(CGFloat)scale {
    SDLLogD(@"TOUCH MANAGER Pinch scaled at center point x: %f, y: %f, scale: %f", point.x, point.y, scale);
}

/**
 *  Pinch moved in view
 */
- (void)touchManager:(SDLTouchManager *)manager didReceivePinchInView:(UIView *_Nullable)view atCenterPoint:(CGPoint)point withScale:(CGFloat)scale {
    SDLLogD(@"TOUCH MANAGER Pinch scaled at center point in view x: %f, y: %f, scale: %f, view: %@", point.x, point.y, scale, view);
}

/**
 *  Pinch ended
 */
- (void)touchManager:(SDLTouchManager *)manager pinchDidEndInView:(UIView *_Nullable)view atCenterPoint:(CGPoint)point {
    SDLLogD(@"TOUCH MANAGER Pinch ended at center point in view x: %f, y: %f, view: %@", point.x, point.y, view);
}

/**
 *  Pinch canceled
 */
- (void)touchManager:(SDLTouchManager *)manager pinchCanceledAtCenterPoint:(CGPoint)point {
    SDLLogD(@"TOUCH MANAGER Pinch canceled at center point x: %f, y: %f", point.x, point.y);
}

@end

NS_ASSUME_NONNULL_END
