//
//  HomeViewController.m
//  SDLStreamingVideoExample
//
//  Created by Nicole on 8/4/17.
//  Copyright © 2017 Livio. All rights reserved.
//

#import "HomeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "VideoManager.h"

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPlayer];
}

- (void)setupPlayer {
    AVPlayerViewController *playerViewController = [VideoManager.sharedManager setupVideoPlayerWithURL:[[self class] testVideoURL]];
    playerViewController.view.frame = self.view.bounds;
    [self addChildViewController:playerViewController];
    [self.view addSubview:playerViewController.view];

    [VideoManager.sharedManager startVideo];
}

/**
 The URL for a local video to be used for testing

 @return The url for the test video
 */
+ (NSURL *)testVideoURL {
    NSString *videoName = @"DrivingAtNight";
    NSString *videoFormat = @"m4v";
    return [self filePathForVideoWithName:videoName videoFormat:videoFormat];
}

/**
 A file path for a local video file

 @param videoName The name of the video
 @param videoFormat The format of the video
 @return The url for the file path of the video
 */
+ (NSURL *)filePathForVideoWithName:(NSString *)videoName videoFormat:(NSString *)videoFormat {
    NSString *videoFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:videoName ofType:videoFormat];
    return [[NSURL alloc] initFileURLWithPath:videoFilePath];
}

@end
