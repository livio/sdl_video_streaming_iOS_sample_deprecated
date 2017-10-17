//
//  MenuManager.h
//  SDLStreamingVideoExample
//
//  Created by Nicole on 10/12/17.
//  Copyright © 2017 Livio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmartDeviceLink.h"

@interface MenuManager : NSObject

+ (void)sendMenuItemsWithManager:(SDLManager *)manager;
+ (void)sdlex_createAlertManeuverWithManager:(SDLManager *)manager;

@end
