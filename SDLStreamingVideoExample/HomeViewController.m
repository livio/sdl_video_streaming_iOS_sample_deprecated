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

@interface HomeViewController ()

@property (nonatomic, retain) AVPlayer *videoPlayer;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self playVideo];
}

- (void)playVideo {
    NSURL *videoURL = [self videoURLForVideoName:@"PreciousInterspeciesAnimalFriendship" videoFormat:@"mp4"];

    if (videoURL == nil) {
        NSLog(@"A video does not exist at the url");
        return;
    }

    self.videoPlayer = [AVPlayer playerWithURL:videoURL];

    AVPlayerViewController *videoViewController = [[AVPlayerViewController alloc] init];
    videoViewController.view.frame = self.view.bounds;
    videoViewController.player = self.videoPlayer;
    videoViewController.showsPlaybackControls = true;

    [self addChildViewController:videoViewController];
    [self.view addSubview:videoViewController.view];

    [self.videoPlayer pause];
    [self.videoPlayer play];
}

- (NSURL *)videoURLForVideoName:(NSString *)videoName videoFormat:(NSString *)videoFormat {
    NSString *videoFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:videoName ofType:videoFormat];
    return [[NSURL alloc] initFileURLWithPath:videoFilePath];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
