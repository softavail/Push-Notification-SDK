//
//  SCGPushErrorFactory.h
//  SCGPushSDK
//
//  Created by Angel Terziev on 3/17/17.
//  Copyright © 2017 Syniverse. All rights reserved.
//

#ifndef SCGPushErrorInternal_h
#define SCGPushErrorInternal_h

#import <Foundation/Foundation.h>

#import "SCGPushError.h"

@interface SCGPushErrorFactory : NSObject

+ (NSError* _Nonnull) pushErrorWithCode: (SCGPushErrorCode) code;
+ (NSError* _Nonnull) pushInboxErrorWithCode: (SCGPushInboxErrorCode) code;

@end


#endif /* SCGPushErrorInternal_h */
