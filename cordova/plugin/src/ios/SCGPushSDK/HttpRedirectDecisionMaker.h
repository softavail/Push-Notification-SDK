//
//  HttpRedirectDecisionMaker.h
//  SCGPushSDK
//
//  Created by Angel Terziev on 3/14/17.
//  Copyright © 2017 Syniverse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRedirectDecisionMaker : NSObject < NSURLSessionTaskDelegate >

@property (nonatomic, readonly, assign) BOOL preventRedirect;

- (instancetype) initWithPreventRedirect: (BOOL) shouldPreventRedirect;

@end
