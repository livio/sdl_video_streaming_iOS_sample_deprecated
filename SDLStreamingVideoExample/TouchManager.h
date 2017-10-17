//
//  TouchManager.h
//  SDLStreamingVideoExample
//
//  Created by Nicole on 10/12/17.
//  Copyright © 2017 Livio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmartDeviceLink.h"
#import "VideoButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface TouchManager : NSObject <SDLTouchManagerDelegate>

- (void)addVideoButton:(VideoButton *)videoButton;
- (void)removeVideoButton:(VideoButton *)videoButton;

@end

NS_ASSUME_NONNULL_END
