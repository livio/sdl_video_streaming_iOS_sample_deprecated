//
//  VideoManager.m
//  SDLStreamingVideoExample
//
//  Created by Nicole on 8/9/17.
//  Copyright © 2017 Livio. All rights reserved.
//

#import "VideoManager.h"
#import "ProxyManager.h"

@interface VideoManager ()

@property (nonatomic, retain, readwrite) AVPlayer *player;
@property (nonatomic) AVPlayerItem *playerItem;
@property (nonatomic) AVPlayerItemVideoOutput *playerOutput;
@property (nonatomic) Boolean isReadyToPlay;

@end

@implementation VideoManager

static NSString *kStatusKey = @"status";

#pragma mark - Initialization

+ (instancetype)sharedManager {
    static VideoManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[VideoManager alloc] init];
    });

    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self == nil) {
        return nil;
    }

    return self;
}

#pragma mark - Video player setup

/**
 Returns a video player initalized with the provided video url.

 @param videoURL  The location of the video file
 @return  A video player view controller
 */
- (AVPlayerViewController *)setupVideoPlayerWithURL:(NSURL *)videoURL {
    // https://forums.developer.apple.com/thread/27589
    self.player = [self createVideoPlayer:videoURL];
    self.playerOutput = [self createVideoPlayerOutput];
    self.playerItem = [self createVideoPlayerItem:self.player output:self.playerOutput];

    return [self createVideoViewControllerWithPlayer:self.player];
}

/**
 Returns an AVPlayerItemVideoOutput object that coordinates the output of content associated with a Core Video pixel buffer. Images can be grabbed from the video frames and added to a CVPixelBufferRef.

 @return  A coordinator for the output of content associated with a Core Video pixel buffer
 */
- (AVPlayerItemVideoOutput *)createVideoPlayerOutput {
    NSDictionary *settings = @{
                               (NSString*)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32ARGB),
                               (NSString*)kCVPixelBufferOpenGLCompatibilityKey: @YES
                               };
    return [[AVPlayerItemVideoOutput alloc] initWithPixelBufferAttributes:settings];
}

/**
 Returns an AVPlayer object that is responsible for managing the playback and timing of the video

 @param videoURL  The url of the video's location
 @return  A manager for the playback and timing of the video
 */
- (AVPlayer *)createVideoPlayer:(NSURL *)videoURL {
    AVPlayer *player = [AVPlayer playerWithURL:videoURL];
    [player setVolume:0.0];

    // Get notification when player is ready
    [player addObserver:self forKeyPath:kStatusKey options:NSKeyValueObservingOptionInitial context:&kStatusKey];

    return player;
}

/**
 Returns an AVPlayerItem object that provides the interface to seek to various times in the media, determine its presentation size, and many other things.

 @param player  A manager for the playback and timing of the video
 @param output  A coordinator for the output of content associated with a Core Video pixel buffer
 @return  An interface for the video
 */
- (AVPlayerItem *)createVideoPlayerItem:(AVPlayer *)player output:(AVPlayerItemOutput *)output {
    AVPlayerItem *playerItem = player.currentItem;
    [playerItem addOutput:output];

    // Get notification when player item is ready
    [playerItem addObserver:self forKeyPath:kStatusKey options:NSKeyValueObservingOptionInitial context:&kStatusKey];

    return playerItem;
}

/**
 Returns a view controller for displaying the video with built in play/pause/skip controls

 @param player  Manages the playback and timing of the video
 @return  A view controller displaying the video content of the player along with system-supplied playback controls
 */
- (AVPlayerViewController *)createVideoViewControllerWithPlayer:(AVPlayer *)player {
    AVPlayerViewController *videoViewController = [[AVPlayerViewController alloc] init];
    videoViewController.player = player;
    videoViewController.showsPlaybackControls = true;
    return videoViewController;
}

#pragma mark - Play video

/**
 Starts playing the video
 */
- (void)startVideo {
    [self.player play];
}

#pragma mark - Video frame buffer

/**
 Creates an image from the current video frame and passes it to a CVPixelBufferRef
 */
- (CVPixelBufferRef)getPixelBuffer {
    CVPixelBufferRef buffer = NULL;

    if (self.playerItem != nil && self.playerOutput != nil && [self isReadyToPlay]) {
        CFTimeInterval t = CACurrentMediaTime();
        CMTime itemTime = [self.playerOutput itemTimeForHostTime:t];

        if ([self.playerOutput hasNewPixelBufferForItemTime:itemTime]) {
            CMTime presentationTime = kCMTimeZero;
            buffer = [self.playerOutput copyPixelBufferForItemTime:itemTime itemTimeForDisplay:&presentationTime];
        }
    }

    return buffer;
}

/**
 Releases data held in a CVPixelBufferRef. If the data is not released, the app will run out of memory and crash.

 @param buffer  A CVPixelBufferRef
 */
- (void)releasePixelBuffer:(CVPixelBufferRef)buffer {
    // Memory cleanup
    CVPixelBufferUnlockBaseAddress(buffer, kCVPixelBufferLock_ReadOnly);
    CVPixelBufferRelease(buffer);
}

#pragma mark - Video player start KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == &kStatusKey) {
        __weak typeof(self) weakSelf = self;
        AVPlayer *player = self.player;
        AVPlayerItem *playerItem = self.playerItem;

        if (player.status == AVPlayerStatusReadyToPlay && playerItem.status == AVPlayerItemStatusReadyToPlay) {
            weakSelf.isReadyToPlay = true;
        } else {
            weakSelf.isReadyToPlay = false;
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
