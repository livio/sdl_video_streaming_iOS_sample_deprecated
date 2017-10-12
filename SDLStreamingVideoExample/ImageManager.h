//
//  ImageManager.h
//  SDLStreamingVideoExample
//
//  Created by Nicole on 10/12/17.
//  Copyright © 2017 Livio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmartDeviceLink.h"

@interface ImageManager : NSObject

+ (NSArray<SDLArtwork *> *)allImages;

+ (SDLImage *)starImage;

+ (NSString *)starImageName;

@end
