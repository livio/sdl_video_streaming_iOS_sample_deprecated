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

    [manager sendRequest:[self.class sdlex_addCommandWithManager:manager commandId:(commandId++) menuName:@"Turn by Turn" handler:^{
        [self.class sdlex_showConstantTBT:manager];
    }]];

    NSString *menu2Name = @"Send Alert Maneuver";
    if (useImages) {
        [manager sendRequest:[self.class sdlex_addCommandImageWithManager:manager commandId:(commandId++) menuName:menu2Name handler:^{
            [self.class sdlex_createAlertManeuverWithManager:manager];
        }]];
    } else {
        [manager sendRequest:[self.class sdlex_addCommandWithManager:manager commandId:(commandId++) menuName:menu2Name handler:^{
            [self.class sdlex_createAlertManeuverWithManager:manager];
        }]];
    }
}

#pragma mark - Add Commands

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

#pragma mark - Alert Maneuver

+ (void)sdlex_createAlertManeuverWithManager:(SDLManager *)manager {
    SDLAlertManeuver *alertManeuver = [[SDLAlertManeuver alloc] init];
    alertManeuver.ttsChunks = [SDLTTSChunk textChunksFromString:@"Alert maneuver example"];
    [manager sendRequest:alertManeuver withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if ([response.resultCode isEqualToEnum:SDLResultSuccess]) { return; }
        SDLAlert* alert = [[SDLAlert alloc] init];
        alert.alertText1 = @"Alert Maneuver RPC sent";
        alert.alertText2 = [NSString stringWithFormat:@"Response: %@", response.resultCode];
        [manager sendRequest:alert];
        return;
    }];
}

+ (void)sdlex_showConstantTBT:(SDLManager *)manager {
    SDLShowConstantTBT *constant = [[SDLShowConstantTBT alloc] init];
    [manager sendRequest:constant withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if ([response.resultCode isEqualToEnum:SDLResultSuccess]) { return; }
        SDLAlert* alert = [[SDLAlert alloc] init];
        alert.alertText1 = @"Show Constant RPC sent";
        alert.alertText2 = [NSString stringWithFormat:@"Response: %@", response.resultCode];
        [manager sendRequest:alert];
        return;
    }];
}


@end
