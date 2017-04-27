//
//  SCGPushDelegate.h
//  SCGPushSDK
//
//  Created by Angel Terziev on 3/13/17.
//  Copyright © 2017 Syniverse. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCGPushDelegate <NSObject>

@optional

- (void) resolveTrackedLinkHasNotRedirect: (NSURLRequest* )request;

- (void) resolveTrackedLinkDidSuccess: (NSString*) redirectLocation
                          withrequest: (NSURLRequest* )request;

@end
