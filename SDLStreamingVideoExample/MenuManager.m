//
//  MenuManager.m
//  SDLStreamingVideoExample
//
//  Created by Nicole on 10/12/17.
//  Copyright © 2017 Livio. All rights reserved.
//

#import "MenuManager.h"
#import "ImageManager.h"

@implementation MenuManager

+ (void)sendMenuItemsWithManager:(SDLManager *)manager {
    __weak typeof(self) weakSelf = self;

    // When an image is used in a menu, the image MUST be uploaded successfully before it can be used in the menu
    [manager.fileManager uploadFiles:[ImageManager allImages] completionHandler:^(NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        if (error != nil) {
            SDLLogE(@"Images were not uploaded successfully (%@)", error);
            [strongSelf sdlex_sendMenuItemsWithManager:manager useImages:NO];
        } else {
            [strongSelf sdlex_sendMenuItemsWithManager:manager useImages:YES];
        }
    }];
}

+ (void)sdlex_sendMenuItemsWithManager:(SDLManager *)manager useImages:(BOOL)useImages {
    int commandId = 1000;

    [manager sendRequest:[self.class sdlex_addCommandWithManager:manager commandId:(commandId++) menuName:@"Menu Item 1" handler:^{
        // TODO: do something
    }]];

    if (useImages) {
        [manager sendRequest:[self.class sdlex_addCommandImageWithManager:manager commandId:(commandId++) menuName:@"Menu Item 2" handler:^{
            // TODO: do something here
        }]];
    } else {
        [manager sendRequest:[self.class sdlex_addCommandWithManager:manager commandId:(commandId++) menuName:@"Menu Item 2" handler:^{
            // TODO: do something
        }]];
    }
}

#pragma mark - Private methods

+ (SDLAddCommand *)sdlex_addCommandWithManager:(SDLManager *)manager commandId:(int)commandId menuName:(NSString *)menuName handler:(void (^)(void))handler {
    SDLAddCommand *addCommand = [[SDLAddCommand alloc] initWithId:commandId vrCommands:@[menuName] menuName:menuName handler:^(SDLOnCommand * _Nonnull command) {
        if (handler == nil) { return; }
        handler();
    }];

    return addCommand;
}

+ (SDLAddCommand *)sdlex_addCommandImageWithManager:(SDLManager *)manager commandId:(int)commandId menuName:(NSString *)menuName handler:(void (^)(void))handler {
    SDLAddCommand *addCommandWithImage = [[SDLAddCommand alloc] initWithId:commandId vrCommands:@[menuName] menuName:menuName parentId:0 position:1 iconValue:[ImageManager starImageName] iconType:SDLImageTypeDynamic handler:^(SDLOnCommand * _Nonnull command) {
        if (handler == nil) { return; }
        handler();
    }];

    return addCommandWithImage;
}

+ (SDLDeleteCommand *)sdlex_deleteCommandWithId:(int)commandId {
    return [[SDLDeleteCommand alloc] initWithId:commandId];
}

@end
