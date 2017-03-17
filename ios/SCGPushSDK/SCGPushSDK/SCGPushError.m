//
//  SCGPushError.m
//  SCGPushSDK
//
//  Created by Angel Terziev on 3/16/17.
//  Copyright © 2017 Syniverse. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <SCGPushSDK/SCGPushBase.h>

NSString *const SCGPushErrorDomain = @"com.syniverse.scg.push.sdk.SCGPushError";
NSString *const SCGPushInboxErrorDomain = @"com.syniverse.scg.push.sdk.SCGPushInboxError";



// SCGPushErrorDescription
NSString *const SCGPushErrorDescriptionUnknown      = @"Unknown error";

// SCGPushInboxErrorDescription
NSString *const SCGPushInboxErrorDescriptionUnknown        = @"Unknown error";
NSString *const SCGPushInboxErrorDescriptionUnentitled     = @"Unentitled error";
NSString *const SCGPushInboxErrorDescriptionNoAttachment   = @"Message does not contain attachment";

NSString *const SCGPushInboxErrorDescriptionAttachmentDownloadAlreadyInProgress =
                @"Loading attachment already initiated and is still in progress";
NSString *const SCGPushInboxErrorDescriptionAttachmentDownloadTemporaryFailure  =
                @"Load attachment temporarily failed. Pleas try again later";
NSString *const SCGPushInboxErrorDescriptionAttachmentDownloadPermanentFailure  =
                @"Load attachment failed permanently.";
