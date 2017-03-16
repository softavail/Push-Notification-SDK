//
//  SCGPushError.h
//  SCGPushSDK
//
//  Created by Angel Terziev on 3/16/17.
//  Copyright © 2017 Syniverse. All rights reserved.
//
//
//  CXError.h
//  CallKit
//
//  Copyright © 2016 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SCGPushSDK/SCGPushBase.h>

NS_ASSUME_NONNULL_BEGIN

SCG_EXTERN NSString *const SCGPushErrorDomain;
SCG_EXTERN NSString *const SCGPushInboxErrorDomain;

typedef NS_ENUM(NSInteger, SCGPushErrorCode) {
    SCGPushErrorCodeUnknown = 0,
};

typedef NS_ENUM(NSInteger, SCGPushInboxErrorCode) {
    SCGPushInboxErrorCodeUnknown = 0,
    SCGPushInboxErrorCodeUnentitled = 1,
};

NS_ASSUME_NONNULL_END
