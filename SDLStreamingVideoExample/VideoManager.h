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

@interface VideoManager : NSObject

@property (nonatomic, retain, readonly) AVPlayer *player;

+ (instancetype)sharedManager;
- (AVPlayerViewController *)setupVideoPlayerWithURL:(NSURL *)videoURL;
- (void)startVideo;
- (CVPixelBufferRef)getPixelBuffer;
- (void)releasePixelBuffer:(CVPixelBufferRef)buffer;

@end
