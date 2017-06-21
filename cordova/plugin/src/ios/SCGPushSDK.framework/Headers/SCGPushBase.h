//
//  SCGPushBase.h
//  SCGPushSDK
//
//  Created by Angel Terziev on 3/16/17.
//  Copyright © 2017 Syniverse. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#ifdef __cplusplus
#define SCG_EXTERN extern "C" __attribute__((visibility("default")))
#else
#define SCG_EXTERN extern __attribute__((visibility("default")))
#endif

#define SCG_CLASS_AVAILABLE(...) SCG_EXTERN API_AVAILABLE(__VA_ARGS__)

#define SCGBundleIdentifier "com.syniverse.scg.push.sdk"

NS_ASSUME_NONNULL_END

