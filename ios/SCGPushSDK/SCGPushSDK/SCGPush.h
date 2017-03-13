//
//  SCGPush.h
//  SCGPushSDK
//
//  Created by Angel Terziev on 3/13/17.
//  Copyright © 2017 Syniverse. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <SCGPushDelegate.h>

@interface SCGPush : NSObject

+ (instancetype _Nonnull) sharedInstance;

@property (nonatomic, assign, nullable) id <SCGPushDelegate> delegate;

@property (atomic, copy, nonnull) NSString* accessToken;
@property (atomic, copy, nonnull) NSString* callbackURI;
@property (atomic, copy, nonnull) NSString* appID;
@property (atomic, copy, nullable) NSString* groupBundle;

@end
