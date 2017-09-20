//
//  TouchManagerHandler.m
//  SDLStreamingVideoExample
//
//  Created by Nicole on 9/6/17.
//  Copyright © 2017 Livio. All rights reserved.
//

#import "TouchManagerHandler.h"
#import "ProxyManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface TouchManagerHandler() <SDLTouchManagerDelegate>

@end

@implementation TouchManagerHandler

#pragma mark - SDLTouchManagerDelegate

- (instancetype)init {
    if (self = [super init]) {
        ProxyManager.sharedManager.sdlManager.streamManager.touchManager.touchEventDelegate = self;
    }
    return self;
}

/**
 *  Single tap was received.
 */
- (void)touchManager:(SDLTouchManager *)manager didReceiveSingleTapAtPoint:(CGPoint)point {
    NSLog(@"Single Tap: x: %f, y: %f", point.x, point.y);
}

/**
 *  Double tap was received.
 */
- (void)touchManager:(SDLTouchManager *)manager didReceiveDoubleTapAtPoint:(CGPoint)point {
    NSLog(@"Double Tap: x: %f, y: %f", point.x, point.y);
}

#pragma mark Panning

/**
 *  Panning did start.
 */
- (void)touchManager:(SDLTouchManager *)manager panningDidStartAtPoint:(CGPoint)point {
    NSLog(@"Panning started: x: %f, y: %f", point.x, point.y);
}

/**
 *  Panning did move.
 */
- (void)touchManager:(SDLTouchManager *)manager didReceivePanningFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint {
    NSLog(@"Panning From x: %f, y: %f, To x: %f, y: %f", fromPoint.x, fromPoint.y, toPoint.x, toPoint.y);
}

/**
 *  Panning did end.
 */
- (void)touchManager:(SDLTouchManager *)manager panningDidEndAtPoint:(CGPoint)point {
    NSLog(@"Panning ended: x: %f, y: %f", point.x, point.y);
}

#pragma mark Pinch

/**
 *  Pinch did start.
 */
- (void)touchManager:(SDLTouchManager *)manager pinchDidStartAtCenterPoint:(CGPoint)point {
    NSLog(@"Pinch started: center x: %f, center y: %f", point.x, point.y);
}

/**
 *  Pinch did move.
 */
- (void)touchManager:(SDLTouchManager *)manager didReceivePinchAtCenterPoint:(CGPoint)point withScale:(CGFloat)scale {
    NSLog(@"Pinch moved: center x: %f, center y: %f, with scale: %f", point.x, point.y, scale);
}

/**
 *  Pinch did end.
 */
- (void)touchManager:(SDLTouchManager *)manager pinchDidEndAtCenterPoint:(CGPoint)point {
    NSLog(@"Pinch ended: center x: %f, center y: %f", point.x, point.y);
}

@end

NS_ASSUME_NONNULL_END
