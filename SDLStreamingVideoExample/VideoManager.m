//
//  VideoManager.m
//  SDLStreamingVideoExample
//
//  Created by Nicole on 8/9/17.
//  Copyright © 2017 Livio. All rights reserved.
//

#import "VideoManager.h"
#import "ProxyManager.h"
#import "SmartDeviceLink.h"
#import "ImageManager.h"

@interface VideoManager ()

@property (nonatomic, retain, readwrite) AVPlayer *player;
@property (nonatomic) AVPlayerItem *playerItem;
@property (nonatomic) AVPlayerItemVideoOutput *playerOutput;
@property (nonatomic) Boolean isReadyToPlay;
@property (nonatomic) VideoStreamingState videoStreamingState;

@end

@implementation VideoManager

static NSString *kStatusKey = @"status";
static NSString *kRateKey = @"rate";

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

    _player = nil;
    _playerItem = nil;
    _playerOutput = nil;
    _isReadyToPlay = false;
    _videoStreamingState = VideoStreamingStateNone;

    return self;
}

/**
 *  This method should be called when the proxy manager disconnects from the SDL Core. This is done because setup should be performed each time the proxy manager reconnects to the SDL Core during the same session.
 */
- (void)reset {
    self.videoStreamingState = VideoStreamingStateNone;
}

- (void)dealloc {
    [self.playerItem removeObserver:self forKeyPath:kStatusKey];
    [self.player removeObserver:self forKeyPath:kStatusKey];
    [self.player removeObserver:self forKeyPath:kRateKey];
}

#pragma mark - Video player setup

/**
 *  Returns a video player initalized with the provided video url.
 *
 *  @param videoURL  The location of the video file
 *  @return  A video player view controller
 */
- (AVPlayerViewController *)setupVideoPlayerWithURL:(NSURL *)videoURL {
    // https://forums.developer.apple.com/thread/27589
    self.player = [self createVideoPlayer:videoURL];
    self.playerOutput = [self createVideoPlayerOutput];
    self.playerItem = [self createVideoPlayerItem:self.player output:self.playerOutput];

    return [self createVideoViewControllerWithPlayer:self.player];
}

/**
 *  Returns an AVPlayerItemVideoOutput object that coordinates the output of content associated with a Core Video pixel buffer. Images can be grabbed from the video frames and added to a CVPixelBufferRef.
 *
 *  @return  A coordinator for the output of content associated with a Core Video pixel buffer
 */
- (AVPlayerItemVideoOutput *)createVideoPlayerOutput {
    NSDictionary *settings = @{
                               (NSString*)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32ARGB),
                               (NSString*)kCVPixelBufferOpenGLCompatibilityKey: @YES
                               };
    return [[AVPlayerItemVideoOutput alloc] initWithPixelBufferAttributes:settings];
}

/**
 *  Returns an AVPlayer object that is responsible for managing the playback and timing of the video
 *
 *  @param videoURL  The url of the video's location
 *  @return  A manager for the playback and timing of the video
 */
- (AVPlayer *)createVideoPlayer:(NSURL *)videoURL {
    AVPlayer *player = [AVPlayer playerWithURL:videoURL];
    [player setVolume:0.0];

    // Get notification when player is ready
    [player addObserver:self forKeyPath:kStatusKey options:NSKeyValueObservingOptionInitial context:&kStatusKey];

    // Get notification when player play/pauses
    [player addObserver:self forKeyPath:kRateKey options:NSKeyValueObservingOptionInitial context:&kRateKey];

    return player;
}

/**
 *  Returns an AVPlayerItem object that provides the interface to seek to various times in the media, determines its presentation size, and many other things.

 *  @param player  A manager for the playback and timing of the video
 *  @param output  A coordinator for the output of content associated with a Core Video pixel buffer
 *  @return  An interface for the video
 */
- (AVPlayerItem *)createVideoPlayerItem:(AVPlayer *)player output:(AVPlayerItemOutput *)output {
    AVPlayerItem *playerItem = player.currentItem;

    // Get notification when player item is ready
    [playerItem addObserver:self forKeyPath:kStatusKey options:NSKeyValueObservingOptionInitial context:&kStatusKey];

    return playerItem;
}

/**
 *  Returns a view controller for displaying the video with built in play/pause/skip controls
 *
 *  @param player  Manages the playback and timing of the video
 *  @return  A view controller displaying the video content of the player along with system-supplied playback controls
 */
- (AVPlayerViewController *)createVideoViewControllerWithPlayer:(AVPlayer *)player {
    AVPlayerViewController *videoViewController = [[AVPlayerViewController alloc] init];
    videoViewController.player = player;
    videoViewController.showsPlaybackControls = true;
    return videoViewController;
}

#pragma mark - Play video

/**
 *  Starts playing the video
 */
- (void)startVideo {
    [self.player play];
    if (self.videoStreamingStartedHandler == nil) {
        SDLLogE(@"Video started playing... Nothing to notify, returning");
        return;
    }
    SDLLogD(@"Video started playing... notifying");
    self.videoStreamingStartedHandler();
}

#pragma mark - Video frame buffer

/**
 *  Creates an image from the current video frame and passes it to a CVPixelBufferRef
 */
- (CVPixelBufferRef)getPixelBuffer {
    CVPixelBufferRef buffer = nil;

    if (self.playerItem != nil && self.playerOutput != nil && [self isReadyToPlay]) {
        CFTimeInterval t = CACurrentMediaTime();
        CMTime itemTime = [self.playerOutput itemTimeForHostTime:t];

        if ([self.playerOutput hasNewPixelBufferForItemTime:itemTime]) {
            CMTime presentationTime = kCMTimeZero;
            buffer = [self.playerOutput copyPixelBufferForItemTime:itemTime itemTimeForDisplay:&presentationTime];
        }
    }

    if (buffer == nil) {
        return buffer;
    }

    // Draw star on buffer
    // buffer = [self drawRectangleOnPixelBuffer:buffer];

    return buffer;
}

/**
 *  Releases data held in a CVPixelBufferRef. If the data is not released, the app will run out of memory and crash.
 *
 *  @param buffer  A CVPixelBufferRef
 */
- (void)releasePixelBuffer:(CVPixelBufferRef)buffer {
    CVPixelBufferUnlockBaseAddress(buffer, kCVPixelBufferLock_ReadOnly);
    CVPixelBufferRelease(buffer);
}

#pragma mark - Drawing

- (CVPixelBufferRef)drawStarOnPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    UIImage *star = [UIImage imageNamed:@"star_black_icon"];
    CGFloat imageWidth = CGImageGetWidth(star.CGImage);
    CGFloat imageHeight = CGImageGetHeight(star.CGImage);

    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    void *data = CVPixelBufferGetBaseAddress(pixelBuffer);
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(data, imageWidth, imageHeight,
                                                 8, CVPixelBufferGetBytesPerRow(pixelBuffer), rgbColorSpace,
                                                 kCGBitmapByteOrder32Little |
                                                 kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth,
                                           imageHeight), star.CGImage);
    CGColorSpaceRelease(rgbColorSpace);

    CGContextRelease(context);

    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);

    return pixelBuffer;
}

- (CVPixelBufferRef)drawRectangleOnPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    UIImage *rectangle = [ImageManager rectangleWithColor:UIColor.redColor width:50.0 height:50.0];
    CGFloat imageWidth = CGImageGetWidth(rectangle.CGImage);
    CGFloat imageHeight = CGImageGetHeight(rectangle.CGImage);

    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    void *data = CVPixelBufferGetBaseAddress(pixelBuffer);
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(data, imageWidth, imageHeight,
                                                 8, CVPixelBufferGetBytesPerRow(pixelBuffer), rgbColorSpace,
                                                 kCGImageAlphaNoneSkipFirst);

    //  If the image is larger than the pixel buffer, this will crash
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth,
                                           imageHeight), rectangle.CGImage);
    CGColorSpaceRelease(rgbColorSpace);

    CGContextRelease(context);

    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);

    return pixelBuffer;
}

#pragma mark - Video player start KVO

/**
 *  Observe the AVPlayer for when it is first setup and ready to be used and also for the first time the player is played.
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == &kStatusKey) {
        __weak typeof(self) weakSelf = self;
        if (weakSelf.player.status == AVPlayerStatusReadyToPlay && weakSelf.playerItem.status == AVPlayerItemStatusReadyToPlay) {
            weakSelf.isReadyToPlay = true;
            // Call addOutput:(AVPlayerItemOutput *)output only AFTER the status of the AVPlayerItem has changed to AVPlayerItemStatusReadyToPlay.
            // https://stackoverflow.com/questions/24800742/iosavplayeritemvideooutput-hasnewpixelbufferforitemtime-doesnt-work-correctly
            [self.playerItem addOutput:self.playerOutput];
        } else {
            weakSelf.isReadyToPlay = false;
        }
    } else if (context == &kRateKey) {
        __weak typeof(self) weakSelf = self;
        // A value of 0.0 means the video is paused, while a value of 1.0 means the video is playing at its natural rate
        if (weakSelf.player.rate == 1.0 && weakSelf.videoStreamingState == VideoStreamingStateNone) {
            weakSelf.videoStreamingState = VideoStreamingStateStreaming;
            [weakSelf startVideo];
        } else if (weakSelf.player.rate == 1.0 && weakSelf.videoStreamingState != VideoStreamingStateNone) {
            weakSelf.videoStreamingState = VideoStreamingStateStreaming;
        } else if (weakSelf.player.rate == 0.0 && weakSelf.videoStreamingState != VideoStreamingStateNone) {
            weakSelf.videoStreamingState = VideoStreamingStateNotStreaming;
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
