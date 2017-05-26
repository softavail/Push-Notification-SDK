//
//  SCGPushErrorFactory.m
//  SCGPushSDK
//
//  Created by Angel Terziev on 3/17/17.
//  Copyright © 2017 Syniverse. All rights reserved.
//

#import "SCGPushErrorFactory.h"

// SCGPushErrorDescription
extern NSString *const SCGPushErrorDescriptionUnknown;

// SCGPushInboxErrorDescription
extern NSString *const SCGPushInboxErrorDescriptionUnknown;
extern NSString *const SCGPushInboxErrorDescriptionUnentitled;
extern NSString *const SCGPushInboxErrorDescriptionNoAttachment;
extern NSString *const SCGPushInboxErrorDescriptionAttachmentDownloadAlreadyInProgress;
extern NSString *const SCGPushInboxErrorDescriptionAttachmentDownloadTemporaryFailure;
extern NSString *const SCGPushInboxErrorDescriptionAttachmentDownloadPermanentFailure;

@implementation SCGPushErrorFactory


+ (NSError* _Nonnull) pushErrorWithCode: (SCGPushErrorCode) code
{
    NSError* error;
    NSDictionary* userInfo;
    
    switch (code) {
        case SCGPushErrorCodeUnknown:
        default:
        {
            userInfo = @{NSLocalizedDescriptionKey: SCGPushErrorDescriptionUnknown};
        }
            break;
    }

    error = [[NSError alloc] initWithDomain: SCGPushInboxErrorDomain
                                       code: code
                                   userInfo: userInfo];
    return error;
}

+ (NSError* _Nonnull) pushInboxErrorWithCode: (SCGPushInboxErrorCode) code
{
    NSError* error;
    NSDictionary* userInfo;
    
    switch (code) {
        case SCGPushInboxErrorCodeUnentitled:
        {
            userInfo = @{NSLocalizedDescriptionKey: SCGPushInboxErrorDescriptionUnentitled};
        }
            break;
        case SCGPushInboxErrorCodeNoAttachment:
        {
            userInfo = @{NSLocalizedDescriptionKey: SCGPushInboxErrorDescriptionNoAttachment};
        }
            break;
        case SCGPushInboxErrorCodeAttachmentDownloadAlreadyInProgress:
        {
            userInfo = @{NSLocalizedDescriptionKey: SCGPushInboxErrorDescriptionAttachmentDownloadAlreadyInProgress};
        }
            break;
        case SCGPushInboxErrorCodeAttachmentDownloadTemporaryFailure:
        {
            userInfo = @{NSLocalizedDescriptionKey: SCGPushInboxErrorDescriptionAttachmentDownloadTemporaryFailure};
        }
            break;
        case SCGPushInboxErrorCodeAttachmentDownloadPermanentFailure:
        {
            userInfo = @{NSLocalizedDescriptionKey: SCGPushInboxErrorDescriptionAttachmentDownloadPermanentFailure};
        }
            break;
        case SCGPushInboxErrorCodeUnknown:
        default:
        {
            userInfo = @{NSLocalizedDescriptionKey: SCGPushInboxErrorDescriptionUnknown};
        }
            break;
    }
    
    error = [[NSError alloc] initWithDomain: SCGPushInboxErrorDomain
                                       code: code
                                   userInfo: userInfo];
    return error;
}

@end
