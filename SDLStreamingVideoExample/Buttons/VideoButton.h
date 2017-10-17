//
//  VideoButton.h
//  SDLStreamingVideoExample
//
//  Created by Nicole on 10/17/17.
//  Copyright © 2017 Livio. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CoreGraphics/CGGeometry.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoButton : NSObject

@property (strong, nonatomic) NSString *title;
@property (nonatomic) CGRect frame;
@property (copy, nonatomic, nullable) void (^buttonSelectedHandler)(void);

- (instancetype)initWithTitle:(NSString *)title frame:(CGRect)frame handler:(void (^)(void))buttonSelectedHandler;

@end

NS_ASSUME_NONNULL_END
