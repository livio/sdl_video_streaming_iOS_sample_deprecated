//
//  TouchManagerHandler.h
//  SDLStreamingVideoExample
//
//  Created by Nicole on 9/6/17.
//  Copyright © 2017 Livio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmartDeviceLink.h"

NS_ASSUME_NONNULL_BEGIN

@class TouchManagerHandler;

@protocol TouchManagerHandlerDelegate <NSObject>

/**
 *  Inform the delegate that the map should zoom in.
 *
 *  @param handler  Reference to the SDLTouchManagerHandler.
 */
- (void)touchManagerHandlerShouldZoomIn:(TouchManagerHandler *)handler;

@end


@interface TouchManagerHandler : NSObject <SDLTouchManagerDelegate>

/**
 *  Delegate that the touch manager will call.
 */
@property (nonatomic, weak, nullable) id<TouchManagerHandlerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
