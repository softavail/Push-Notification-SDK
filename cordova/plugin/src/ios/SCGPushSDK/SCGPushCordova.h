//
//  SCGPushCordova.h
//  SCGPushSDK
//
//  Created by Slav Sarafski on 23/5/17.
//  Copyright © 2017 Syniverse. All rights reserved.
//

#import <Cordova/CDVPlugin.h>

@interface SCGPushCordova : CDVPlugin

// MARK: Cordova
    
- (void)cdv_registerPushToken:(CDVInvokedUrlCommand*_Nonnull)command;
- (void)cdv_unregisterPushToken:(CDVInvokedUrlCommand*_Nonnull)command;
- (void)cdv_reportStatus:(CDVInvokedUrlCommand*_Nonnull)command;
- (void)cdv_resolveTrackedLink:(CDVInvokedUrlCommand*_Nonnull)command;
- (void)cdv_loadAttachment:(CDVInvokedUrlCommand*_Nonnull)command;
- (void)cdv_resetBadge:(CDVInvokedUrlCommand*_Nonnull)command;
    
@end
