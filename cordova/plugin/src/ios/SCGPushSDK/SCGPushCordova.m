//
//  SCGPushCordova.m
//  SCGPushSDK
//
//  Created by Slav Sarafski on 23/5/17.
//  Copyright © 2017 Syniverse. All rights reserved.
//

#import "SCGPushCordova.h"
#import "SCGPush.h"
#import <Cordova/CDVPlugin.h>

@implementation SCGPushCordova

- (void)pluginInitialize{
    NSString* setting;
    NSString* accessToken = @"";
    NSString* appID = @"";
    NSString* callbackUri = @"";
    
    setting  = @"AccessToken";
    if ([self settingForKey:setting]) {
        accessToken = [self settingForKey:setting];
    }
    
    setting  = @"AppID";
    if ([self settingForKey:setting]) {
        appID = [self settingForKey:setting];
    }
    
    setting  = @"CallbackUri";
    if ([self settingForKey:setting]) {
        callbackUri = [self settingForKey:setting];
    }
    
    [SCGPush startWithAccessToken:accessToken
                            appId:appID
                      callbackUri:callbackUri
                         delegate:nil];
}

- (void)cdv_registerPushToken:(CDVInvokedUrlCommand *)command
{
    NSString* pushToken = [command.arguments objectAtIndex:0];
    
    if (pushToken != nil && [pushToken length] > 0) {
        [SCGPush.sharedInstance registerPushToken:pushToken
                            withCompletionHandler:^(NSString * _Nullable token) {
                                      CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                                                        messageAsString:token];
                                      [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                  }
                                     failureBlock:^(NSError * _Nullable error) {
                                      CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                                                        messageAsString:error.localizedDescription];
                                      [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                  }];
    } else {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (void)cdv_unregisterPushToken:(CDVInvokedUrlCommand *)command
{
    NSString* pushToken = [command.arguments objectAtIndex:0];
    
    if (pushToken != nil && [pushToken length] > 0) {
        [SCGPush.sharedInstance unregisterPushToken: pushToken
                              withCompletionHandler:^(NSString * _Nullable token) {
                                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                                                      messageAsString:token];
                                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                }
                                       failureBlock:^(NSError * _Nullable error) {
                                    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                                                      messageAsString:error.localizedDescription];
                                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                }];
    } else {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}
    
- (void)cdv_reportStatus:(CDVInvokedUrlCommand *)command
{
    NSString* messageID = [command.arguments objectAtIndex:0];
    int state = [[command.arguments objectAtIndex:1] intValue];
    MessageState messageState = (MessageState)state;
    
    if (messageID != nil && [messageID length] > 0) {
        [SCGPush.sharedInstance reportStatusWithMessageId:messageID
                                          andMessageState:messageState
                                          completionBlock:^{
                                              CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                                              [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                          }
                                             failureBlock:^(NSError * _Nullable error) {
                                                 CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                                                                   messageAsString:error.localizedDescription];
                                                 [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                             }];
    } else {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}
    
- (void)cdv_resolveTrackedLink:(CDVInvokedUrlCommand *)command
{
    NSString* link = [command.arguments objectAtIndex:0];
    
    if (link != nil && [link length] > 0) {
        [SCGPush.sharedInstance resolveTrackedLink:link];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    } else {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}
    
- (void)cdv_resetBadge:(CDVInvokedUrlCommand *)command
{
    NSString* pushToken = [command.arguments objectAtIndex:0];
    
    if (pushToken != nil && [pushToken length] > 0) {
        [SCGPush.sharedInstance resetBadgeForPushToken:pushToken
                                       completionBlock:^(BOOL success, NSError * _Nullable error) {
                                           if (success) {
                                               CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                                               [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                           }
                                           else {
                                               CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                                                                 messageAsString:error.localizedDescription];
                                               [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                           }
                                       }];
    } else {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}
    
- (void)cdv_loadAttachment:(CDVInvokedUrlCommand *)command
{
    NSString* messageId = [command.arguments objectAtIndex:0];
    NSString* attachmentId = [command.arguments objectAtIndex:1];
    
    if (messageId != nil && [messageId length] > 0 && attachmentId != nil && [attachmentId length] > 0) {
        [SCGPush.sharedInstance loadAttachmentWithMessageId:messageId
                                            andAttachmentId:attachmentId
                                            completionBlock:^(NSURL * _Nonnull contentUrl, NSString * _Nonnull contentType) {
                                                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                                                                   messageAsArray:@[contentUrl, contentType]];
                                                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                            }
                                               failureBlock:^(NSError * _Nullable error) {
                                                   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                                                                     messageAsString:error.localizedDescription];
                                                   [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                               }];
    } else {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (id)settingForKey:(NSString*)key
{
    return [self.commandDelegate.settings objectForKey:[key lowercaseString]];
}
    
@end
