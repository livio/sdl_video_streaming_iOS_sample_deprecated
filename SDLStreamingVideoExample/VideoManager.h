//
//  VideoManager.h
//  SDLStreamingVideoExample
//
//  Created by Nicole on 8/9/17.
//  Copyright © 2017 Livio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

typedef NS_ENUM(NSUInteger, VideoStreamingState) {
    VideoStreamingStateNone,
    VideoStreamingStateStreaming,
    VideoStreamingStateNotStreaming
};

@interface VideoManager : NSObject

@property (nonatomic, retain, readonly) AVPlayer *player;
@property (nonatomic, copy) void (^videoStreamingStartedHandler)(void);

+ (instancetype)sharedManager;
- (void)reset;
- (AVPlayerViewController *)setupVideoPlayerWithURL:(NSURL *)videoURL;
- (void)startVideo;
- (CVPixelBufferRef)getPixelBuffer;
- (void)releasePixelBuffer:(CVPixelBufferRef)buffer;

@end
