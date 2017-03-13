//
//  SCGPush.m
//  SCGPushSDK
//
//  Created by Angel Terziev on 3/13/17.
//  Copyright © 2017 Syniverse. All rights reserved.
//

#import "SCGPush.h"

@implementation SCGPush

+ (instancetype) sharedInstance
{
    // 1
    static SCGPush *_sharedInstance = nil;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[SCGPush alloc] init];
    });
    
    return _sharedInstance;
}

//MARK - Push Token

- (void) registerPushToken:( NSString* _Nonnull) pushToken
     withCompletionHandler:( void (^)(NSString * _Nullable token)) completionBlock
              failureBlock:( void (^)(NSError * _Nullable error)) failureBlock
{
    if (nil == pushToken) {
        if (failureBlock) {
            NSError* error = [NSError errorWithDomain: @"SCGPush" code: 1 userInfo: nil];
            failureBlock(error);
        }
        
        return;
    }
    
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration: configuration];
    NSString* urlString = [NSString stringWithFormat: @"%@/push_tokens/register",
                           self.callbackURI];
    NSURL* url = [NSURL URLWithString: urlString];
    if (nil == url) {
        if (failureBlock) {
            NSError* error = [NSError errorWithDomain: @"SCGPush" code: 2 userInfo: nil];
            failureBlock(error);
        }
        return;
    }
    
    NSLog(@"URL: %@", url.absoluteString);
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 30;

    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString* bearer = [NSString stringWithFormat:@"Bearer %@", self.accessToken];
    [request addValue: bearer forHTTPHeaderField:@"Authorization"];
    NSError* jsonError = nil;
    NSDictionary* params = @{@"app_id": self.appID,
                             @"type": @"APN",
                             @"token": pushToken};
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error: &jsonError];
    if (nil == jsonData) {
        if (failureBlock) {
            failureBlock(jsonError);
        }
        return;
    }
    
    request.HTTPBody = jsonData;
    NSURLSessionDataTask* dataTask =
    [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*) response;
        if (error != nil) {
            if (failureBlock) {
                failureBlock(error);
            }
            return;
        }

        switch (httpResponse.statusCode) {
            case 200:
            case 204:
            {
                if (completionBlock != nil) {
                    completionBlock(pushToken);
                }
            }
                break;
            default:
            {
                if (failureBlock) {
                    NSError* error = [NSError errorWithDomain: @"SCGPush" code: httpResponse.statusCode userInfo: nil];
                    failureBlock(error);
                }
            }
                break;
                
        }
    }];

    [dataTask resume];
}

@end
