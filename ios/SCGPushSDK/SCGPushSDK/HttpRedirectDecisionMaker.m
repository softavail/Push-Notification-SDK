//
//  HttpRedirectDecisionMaker.m
//  SCGPushSDK
//
//  Created by Angel Terziev on 3/14/17.
//  Copyright © 2017 Syniverse. All rights reserved.
//

#import "HttpRedirectDecisionMaker.h"

@implementation HttpRedirectDecisionMaker

- (instancetype) initWithPreventRedirect: (BOOL) shouldPreventRedirect
{
    if (nil != (self = [super init])) {
        _preventRedirect = shouldPreventRedirect;
    }
        
    return self;
}

- (void)        URLSession:(NSURLSession *)session
                      task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
                newRequest:(NSURLRequest *)request
         completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler
{
    if (_preventRedirect) {
        completionHandler(nil);
    }
}

@end
