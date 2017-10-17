//
//  VideoButton.m
//  SDLStreamingVideoExample
//
//  Created by Nicole on 10/17/17.
//  Copyright © 2017 Livio. All rights reserved.
//

#import "VideoButton.h"

NS_ASSUME_NONNULL_BEGIN

@implementation VideoButton

- (instancetype)initWithTitle:(NSString *)title frame:(CGRect)frame handler:(void (^)(void))buttonSelectedHandler {
    self = [super init];
    if (self) {
        _title = title;
        _frame = frame;
        _buttonSelectedHandler = buttonSelectedHandler;
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END
