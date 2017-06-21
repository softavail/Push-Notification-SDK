//
//  SCGPush.m
//  SCGPushSDK
//
//  Created by Angel Terziev on 3/13/17.
//  Copyright © 2017 Syniverse. All rights reserved.
//

#import "SCGPush.h"
#import "HttpRedirectDecisionMaker.h"

#import "SCGPushCoreDataManager.h"
#import "SCGPushErrorFactory.h"

#import <MobileCoreServices/UTCoreTypes.h>

static SCGPush *_sharedInstance = nil;

NSInteger const DEFAULT_MAX_RETRY_COUNT = 3;
int64_t const DEFAULT_RETRY_DELAY = 200;
NSInteger const DEFAULT_REQUEST_TIMEOUT_INTERVAL = 30;

@interface SCGPush()

@property (nonatomic, strong) HttpRedirectDecisionMaker* redirectDecisionMaker;
@property (nonatomic, strong) SCGPushCoreDataManager* coreDataManager;

@property (nonatomic, copy, nonnull) NSString* accessTokenInternal;
@property (nonatomic, copy, nonnull) NSString* callbackURIInternal;
@property (nonatomic, copy, nonnull) NSString* appIDInternal;
@property (nonatomic, assign)        NSInteger maxRetryCount;
@property (nonatomic, assign)        int64_t retryDelay; /*in millis*/


@end

@implementation SCGPush

+ (instancetype) sharedInstanceWithDelegate: (id<SCGPushDelegate>) delegate
{
    // 2
    static dispatch_once_t oncePredicate;
    
    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[SCGPush alloc] initWithDelegate: delegate];
    });
    
    return _sharedInstance;
}

+ (instancetype) sharedInstance
{
    return [[self class] sharedInstanceWithDelegate: nil];
}

- (instancetype) initWithDelegate: (id<SCGPushDelegate>) delegate
{
    if (nil != (self = [super init])) {
        NSLog(@"Debug: [SCGPush] Initialzing  <%p>", self);
        _delegate = delegate;
        
        self.accessTokenInternal = @"";
        self.appIDInternal = @"";
        self.callbackURIInternal = @"";
        self.maxRetryCount = DEFAULT_MAX_RETRY_COUNT;
        self.retryDelay = DEFAULT_RETRY_DELAY;
    }
    
    return self;
}

+ (instancetype _Nonnull) startWithAccessToken: (NSString* _Nonnull) accessToken
                                         appId: (NSString* _Nonnull) appId
                                   callbackUri: (NSString* _Nonnull) callbackUri
                                      delegate: (id<SCGPushDelegate> _Nullable) delegate
{
    SCGPush* scgPush = [[self class] sharedInstanceWithDelegate: delegate];
    
    scgPush.accessToken = accessToken;
    scgPush.appID = appId;
    scgPush.callbackURI = callbackUri;
    
    [scgPush initializeInbox];
    
    NSLog(@"Debug: [SCGPush] Successfully registered with access token :%@, appID: %@ and callbackURI: %@", accessToken, appId, callbackUri);
    
    return scgPush;
}


//MARK: - Push Token

- (void) registerPushToken:( NSString* _Nonnull) pushToken
                   session:( NSURLSession* _Nonnull) session
                   request:( NSURLRequest* _Nonnull) request
                retryCount:( NSInteger ) retryCount
     withCompletionHandler:( void (^)(NSString * _Nullable token)) completionBlock
              failureBlock:( void (^)(NSError * _Nullable error)) failureBlock
{
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
            case 503:
            {
                if (retryCount < self.maxRetryCount ) {
                    NSLog(@"Retry registerPushToken: %d", (int)(retryCount+1));
                    int64_t nsec = self.retryDelay * NSEC_PER_MSEC;
                    dispatch_queue_t global_default = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, nsec), global_default, ^{
                        [self registerPushToken:pushToken
                                        session:session
                                        request:request
                                     retryCount:(retryCount+1)
                          withCompletionHandler:completionBlock
                                   failureBlock:failureBlock];
                    });
                } else {
                    if (failureBlock) {
                        NSError* error = [NSError errorWithDomain: @"SCGPush" code: httpResponse.statusCode userInfo: nil];
                        failureBlock(error);
                    }
                }
            }
                break;
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
    
    NSLog(@"Debug: [SCGPush] URL: %@", url.absoluteString);
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = DEFAULT_REQUEST_TIMEOUT_INTERVAL;

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

    [self registerPushToken:pushToken
                    session:session
                    request:request
                 retryCount:0
      withCompletionHandler:completionBlock
               failureBlock:failureBlock];
}


- (void) unregisterPushToken:( NSString* _Nonnull) pushToken
                     session:( NSURLSession* _Nonnull) session
                     request:( NSURLRequest* _Nonnull) request
                  retryCount:( NSInteger ) retryCount
       withCompletionHandler:( void (^)(NSString * _Nullable token)) completionBlock
                failureBlock:( void (^)(NSError * _Nullable error)) failureBlock
{
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
            case 503:
            {
                if (retryCount < self.maxRetryCount ) {
                    NSLog(@"Retry unregisterPushToken: %d", (int)(retryCount+1));
                    int64_t nsec = self.retryDelay * NSEC_PER_MSEC;
                    dispatch_queue_t global_default = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, nsec), global_default, ^{
                        [self unregisterPushToken:pushToken
                                          session:session
                                          request:request
                                       retryCount:(retryCount+1)
                            withCompletionHandler:completionBlock
                                     failureBlock:failureBlock];
                    });
                } else {
                    if (failureBlock) {
                        NSError* error = [NSError errorWithDomain: @"SCGPush" code: httpResponse.statusCode userInfo: nil];
                        failureBlock(error);
                    }
                }
            }
                break;
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

- (void) unregisterPushToken:( NSString* _Nonnull) pushToken
       withCompletionHandler:( void (^ _Nullable)(NSString * _Nullable token)) completionBlock
                failureBlock:( void (^ _Nullable)(NSError * _Nullable error)) failureBlock
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
    NSString* urlString = [NSString stringWithFormat: @"%@/push_tokens/unregister",
                           self.callbackURI];
    NSURL* url = [NSURL URLWithString: urlString];
    if (nil == url) {
        if (failureBlock) {
            NSError* error = [NSError errorWithDomain: @"SCGPush" code: 2 userInfo: nil];
            failureBlock(error);
        }
        return;
    }
    
    NSLog(@"Debug: [SCGPush] URL: %@", url.absoluteString);
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = DEFAULT_REQUEST_TIMEOUT_INTERVAL;
    
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

    [self unregisterPushToken:pushToken
                      session:session
                      request:request
                   retryCount:0
        withCompletionHandler:completionBlock
                 failureBlock:failureBlock];
}

// MARK: - Report Status
- (NSString*) messageStateToString: (MessageState) state {

    NSString* stateAsString = nil;
    switch (state) {
        case MessageStateDelivered:
            stateAsString = @"DELIVERED";
            break;
        case MessageStateRequested:
            stateAsString = @"MEDIA_REQUESTED";
            break;
        case MessageStateRead:
            stateAsString = @"READ";
            break;
        case MessageStateClicked:
            stateAsString = @"CLICKTHRU";
            break;
        case MessageStateConverted:
            stateAsString = @"CONVERTED";
            break;
        default:
            break;
    }
    
    return stateAsString;
}

- (void) reportStatusWithMessageId: ( NSString* _Nonnull) messageId
                   andMessageState: ( MessageState ) state
                   completionBlock: ( void(^ _Nullable)()    ) completionBlock
                     failureBlock : ( void(^ _Nullable) (NSError* _Nullable error)) failureBlock
{

    NSString* stringifiedMessageState = [self messageStateToString: state];
    if (nil == stringifiedMessageState) {
        if (failureBlock) {
            NSError* error = [NSError errorWithDomain: @"SCGPush" code: 1 userInfo: nil];
            failureBlock(error);
        }
        return;
    }
    
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration: configuration];
    NSString* urlString = [NSString stringWithFormat: @"%@/messages/%@/confirm/%@",
                           self.callbackURI,
                           messageId,
                           stringifiedMessageState];

    NSURL* url = [NSURL URLWithString: urlString];
    if (nil == url) {
        if (failureBlock) {
            NSError* error = [NSError errorWithDomain: @"SCGPush" code: 2 userInfo: nil];
            failureBlock(error);
        }
        return;
    }
    
    NSLog(@"Debug: [SCGPush] URL: %@", url.absoluteString);
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = DEFAULT_REQUEST_TIMEOUT_INTERVAL;
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString* bearer = [NSString stringWithFormat:@"Bearer %@", self.accessToken];
    [request addValue: bearer forHTTPHeaderField:@"Authorization"];

    [self reportStatusWithMessageId:messageId
                    andMessageState:state
                            session:session
                            request:request
                         retryCount:0
                    completionBlock:completionBlock
                       failureBlock:failureBlock];
}

- (void) reportStatusWithMessageId: ( NSString* _Nonnull) messageId
                   andMessageState: ( MessageState ) state
                           session: ( NSURLSession* _Nonnull) session
                           request: ( NSURLRequest* _Nonnull) request
                        retryCount: ( NSInteger ) retryCount
                   completionBlock: ( void(^ _Nullable)()    ) completionBlock
                     failureBlock : ( void(^ _Nullable) (NSError* _Nullable error)) failureBlock
{
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
            case 503:
            {
                if (retryCount < self.maxRetryCount ) {
                    NSLog(@"Retry reportStatusWithMessageId: %d", (int)(retryCount+1));
                    int64_t nsec = self.retryDelay * NSEC_PER_MSEC;
                    dispatch_queue_t global_default = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, nsec), global_default, ^{
                        [self reportStatusWithMessageId:messageId
                                        andMessageState:state
                                                session:session
                                                request:request
                                             retryCount:retryCount+1
                                        completionBlock:completionBlock
                                           failureBlock:failureBlock];
                    });
                } else {
                    if (failureBlock) {
                        NSError* error = [NSError errorWithDomain: @"SCGPush" code: httpResponse.statusCode userInfo: nil];
                        failureBlock(error);
                    }
                }
            }
                break;
            case 200:
            case 204:
            {
                if (completionBlock != nil) {
                    completionBlock();
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

// MARK: Resolve Tracked Link
- (void) resolveTrackedLink:(NSString* _Nonnull) urlString
{
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:configuration delegate:self.redirectDecisionMaker delegateQueue:nil];
    NSURL* url = [NSURL URLWithString: urlString];

    NSLog(@"Debug: [SCGPush] URL: %@", url.absoluteString);
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: url];
    request.HTTPMethod = @"HEAD";
    request.timeoutInterval = DEFAULT_REQUEST_TIMEOUT_INTERVAL;
    
    [self resolveTrackedLink:urlString
                     session:session
                     request:request
                  retryCount:0];
}

- (void) resolveTrackedLink: (NSString* _Nonnull) urlString
                    session: ( NSURLSession* _Nonnull) session
                    request: ( NSURLRequest* _Nonnull) request
                 retryCount: ( NSInteger ) retryCount
{
    NSURLSessionDataTask* dataTask =
    [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*) response;
        if (error != nil) {
            return;
        }
        
        switch (httpResponse.statusCode) {
            case 503:
            {
                if (retryCount < self.maxRetryCount ) {
                    NSLog(@"Retry resolveTrackedLink: %d", (int)(retryCount+1));
                    int64_t nsec = self.retryDelay * NSEC_PER_MSEC;
                    dispatch_queue_t global_default = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, nsec), global_default, ^{
                        [self resolveTrackedLink:urlString
                                         session:session
                                         request:request
                                      retryCount:retryCount+1];
                    });
                } else {
                    if (self.delegate != nil) {
                        if ([self.delegate respondsToSelector:@selector(resolveTrackedLinkHasNotRedirect:)])
                            [self.delegate resolveTrackedLinkHasNotRedirect:request];
                    }
                }
            }
                break;
            case 300:
            case 301:
            case 307:
            {
                if (self.delegate != nil) {
                    
                    NSString* redirectLocation = httpResponse.allHeaderFields[@"Location"];
                    if (nil != redirectLocation) {
                        if ([self.delegate respondsToSelector:@selector(resolveTrackedLinkDidSuccess:withrequest:)])
                            [self.delegate resolveTrackedLinkDidSuccess:redirectLocation withrequest:request];
                    } else {
                        if ([self.delegate respondsToSelector:@selector(resolveTrackedLinkHasNotRedirect:)])
                            [self.delegate resolveTrackedLinkHasNotRedirect:request];
                    }
                }
            }
                break;
            default:
            {
                if (self.delegate != nil) {
                    if ([self.delegate respondsToSelector:@selector(resolveTrackedLinkHasNotRedirect:)])
                        [self.delegate resolveTrackedLinkHasNotRedirect:request];
                }
            }
                break;
        }
    }];
    
    [dataTask resume];
}

// MARK: - Load Attachment
- (NSString*) translateContentTypeHeader: (NSHTTPURLResponse* _Nonnull) httpResponse
{
    NSString* translatedContentType = @"";
    NSString* contentType = httpResponse.allHeaderFields[@"Content-Type"];
    
    if (contentType != nil) {
        if (NSOrderedSame == [contentType caseInsensitiveCompare: @"video/mpeg"]) {
            translatedContentType = (NSString*) kUTTypeMPEG4;
        } else if (NSOrderedSame == [contentType caseInsensitiveCompare: @"video/mp4"]) {
            translatedContentType = (NSString*) kUTTypeMPEG4;
        } else if (NSOrderedSame == [contentType caseInsensitiveCompare: @"video/webm"]) {
            translatedContentType = (NSString*) kUTTypeVideo;
        } else if (NSOrderedSame == [contentType caseInsensitiveCompare: @"video/ogg"]) {
            translatedContentType = (NSString*) kUTTypeVideo;
        } else if (NSOrderedSame == [contentType caseInsensitiveCompare: @"audio/ogg"]) {
            translatedContentType = (NSString*) kUTTypeAudio;
        } else if (NSOrderedSame == [contentType caseInsensitiveCompare: @"audio/webm"]) {
            translatedContentType = (NSString*) kUTTypeAudio;
        } else if (NSOrderedSame == [contentType caseInsensitiveCompare: @"audio/mpeg"]) {
            translatedContentType = (NSString*) kUTTypeAudio;
        } else if (NSOrderedSame == [contentType caseInsensitiveCompare: @"audio/mp3"]) {
            translatedContentType = (NSString*) kUTTypeMP3;
        } else if (NSOrderedSame == [contentType caseInsensitiveCompare: @"image/gif"]) {
            translatedContentType = (NSString*) kUTTypeGIF;
        } else if (NSOrderedSame == [contentType caseInsensitiveCompare: @"image/png"]) {
            translatedContentType = (NSString*) kUTTypePNG;
        } else if (NSOrderedSame == [contentType caseInsensitiveCompare: @"image/jpeg"]) {
            translatedContentType = (NSString*) kUTTypeJPEG;
        }
    }
    
    return translatedContentType;
    
}

- (void) loadInboxAttachmentForMessage: (SCGPushMessage* _Nonnull) message
                       completionBlock:(void(^_Nullable)(SCGPushAttachment* _Nonnull attachment))completionBlock
                          failureBlock:(void(^_Nullable)(NSError* _Nullable error))failureBlock
{
    NSLog(@"Debug: [SCGPush] '<%p>', will load inbox attachment '%@' for message '%@'",
          self,
          message.attachmentId,
          message.identifier);
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:configuration];
    NSString* urlString = [NSString stringWithFormat: @"%@/attachment/%@/%@",
                           self.callbackURI,
                           message.identifier,
                           message.attachmentId];
    NSURL* url = [NSURL URLWithString: urlString];
    
    NSLog(@"Debug: [SCGPush] URL: %@", url.absoluteString);
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: url];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = DEFAULT_REQUEST_TIMEOUT_INTERVAL;
    
    NSString* bearer = [NSString stringWithFormat:@"Bearer %@", self.accessToken];
    [request addValue: bearer forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDownloadTask* downloadTask =
    [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location,
                                                                 NSURLResponse * _Nullable response,
                                                                 NSError * _Nullable error) {
        if (error != nil) {
            if (failureBlock) {
                failureBlock(error);
            }
            return;
        }

        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*) response;
        if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
            NSString* contentType = [self translateContentTypeHeader: httpResponse];
            
            if (nil != location && contentType != nil) {
                // Move temporary file to remove .tmp extension
                SCGPushAttachment* a = [[SCGPushAttachment alloc] initWithIdentifier: message.attachmentId];
                a.contentType = contentType;
                NSData* data = [NSData dataWithContentsOfURL: location];
                if (data) {a.data = data;}

                if (completionBlock)
                    completionBlock(a);
            } else {
                if (failureBlock) {
                    NSError* error = [NSError errorWithDomain: NSURLErrorDomain code: httpResponse.statusCode userInfo: nil];
                    failureBlock(error);
                }
            }
        } else {
            if (failureBlock) {
                NSError* error = [NSError errorWithDomain: NSURLErrorDomain code: httpResponse.statusCode userInfo: nil];
                failureBlock(error);
            }
        }
    }];
    
    [downloadTask resume];
}

- (void) loadAttachmentWithMessageId: (NSString* _Nonnull) messageId
                     andAttachmentId: (NSString* _Nonnull) attachmentId
                     completionBlock: (void(^_Nullable)(NSURL* _Nonnull contentUrl, NSString* _Nonnull contentType))completionBlock
                        failureBlock: (void(^_Nullable)(NSError* _Nullable error))failureBlock
{
    NSLog(@"Debug: [SCGPush] '<%p>', will load attachment '%@' for message '%@'",
          self,
          attachmentId,
          messageId);
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:configuration];
    NSString* urlString = [NSString stringWithFormat: @"%@/attachment/%@/%@",
                           self.callbackURI,
                           messageId,
                           attachmentId];
    NSURL* url = [NSURL URLWithString: urlString];
    
    NSLog(@"Debug: [SCGPush] URL: %@", url.absoluteString);
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: url];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = DEFAULT_REQUEST_TIMEOUT_INTERVAL;

    NSString* bearer = [NSString stringWithFormat:@"Bearer %@", self.accessToken];
    [request addValue: bearer forHTTPHeaderField:@"Authorization"];

    [self loadAttachmentWithURL:url
                        session:session
                        request:request
                     retryCount:0
                completionBlock:completionBlock
                   failureBlock:failureBlock];
}

- (void) loadAttachmentWithURL: ( NSURL* _Nonnull) url
                       session: ( NSURLSession* _Nonnull) session
                       request: ( NSURLRequest* _Nonnull) request
                    retryCount: ( NSInteger ) retryCount
               completionBlock: ( void(^_Nullable)(NSURL* _Nonnull contentUrl, NSString* _Nonnull contentType))completionBlock
                  failureBlock: ( void(^_Nullable)(NSError* _Nullable error))failureBlock
{
    NSURLSessionDownloadTask* downloadTask =
    [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location,
                                                                 NSURLResponse * _Nullable response,
                                                                 NSError * _Nullable error) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*) response;
        if (error != nil) {
            if (failureBlock) {
                failureBlock(error);
            }
            return;
        }
        
        NSURL* contentUrl;
        NSString* contentType = [self translateContentTypeHeader: httpResponse];
        
        if (nil != location ) {
            // Move temporary file to remove .tmp extension
            NSString* tmpDirectory = NSTemporaryDirectory();
            NSString*  tmpFile = [[@"file://" stringByAppendingString:tmpDirectory] stringByAppendingString:url.lastPathComponent];
            NSURL* tmpUrl = [NSURL URLWithString:tmpFile];
            if ([[NSFileManager defaultManager] fileExistsAtPath:tmpUrl.path isDirectory:nil])
                [[NSFileManager defaultManager] removeItemAtURL:tmpUrl error:nil];
            
            [[NSFileManager defaultManager] moveItemAtURL:location toURL:tmpUrl error:nil];
            contentUrl = tmpUrl;
        }
        
        switch (httpResponse.statusCode) {
            case 503:
            {
                if (retryCount < self.maxRetryCount ) {
                    NSLog(@"Retry loadAttachmentWithMessageId: %d", (int)(retryCount+1));
                    int64_t nsec = self.retryDelay * NSEC_PER_MSEC;
                    dispatch_queue_t global_default = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, nsec), global_default, ^{
                        [self loadAttachmentWithURL:url
                                            session:session
                                            request:request
                                         retryCount:retryCount+1
                                    completionBlock:completionBlock
                                       failureBlock:failureBlock];
                    });
                } else {
                    if (failureBlock) {
                        NSError* error = [NSError errorWithDomain: @"SCGPush" code: httpResponse.statusCode userInfo: nil];
                        failureBlock(error);
                    }
                }
            }
                break;
            case 200:
            case 204:
            {
                if (completionBlock != nil) {
                    completionBlock(contentUrl, contentType);
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
    
    [downloadTask resume];
}

// MARK: - Reset Badge
- (void) resetBadgeForPushToken: (NSString* _Nonnull) pushToken
                completionBlock: (void(^_Nullable)(BOOL success, NSError* _Nullable error)) completionBlock
{
    if (nil == pushToken) {
        if (completionBlock) {
            NSError* error = [NSError errorWithDomain: @"SCGPush" code: 1 userInfo: nil];
            completionBlock(NO, error);
        }
        return;
    }
    
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration: configuration];
    NSString* urlString = [NSString stringWithFormat: @"%@/push_tokens/reset_badges_counter",
                           self.callbackURI];
    NSURL* url = [NSURL URLWithString: urlString];
    if (nil == url) {
        if (completionBlock) {
            NSError* error = [NSError errorWithDomain: @"SCGPush" code: 2 userInfo: nil];
            completionBlock(NO, error);
        }
        return;
    }
    
    NSLog(@"Debug: [SCGPush] URL: %@", url.absoluteString);
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = DEFAULT_REQUEST_TIMEOUT_INTERVAL;
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString* bearer = [NSString stringWithFormat:@"Bearer %@", self.accessToken];
    [request addValue: bearer forHTTPHeaderField:@"Authorization"];
    NSError* jsonError = nil;
    NSDictionary* params = @{@"app_id": self.appID,
                             @"type": @"APN",
                             @"token": pushToken};
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error: &jsonError];
    if (nil == jsonData) {
        if (completionBlock) {
            completionBlock(NO, jsonError);
        }
        return;
    }
    
    request.HTTPBody = jsonData;
    
    [self resetBadgeForPushToken:pushToken
                         session:session
                         request:request
                      retryCount:0
                 completionBlock:completionBlock];
}

- (void) resetBadgeForPushToken: (NSString* _Nonnull) pushToken
                        session: ( NSURLSession* _Nonnull) session
                        request: ( NSURLRequest* _Nonnull) request
                     retryCount: ( NSInteger ) retryCount
                completionBlock: (void(^_Nullable)(BOOL success, NSError* _Nullable error)) completionBlock
{
    NSURLSessionDataTask* dataTask =
    [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*) response;
        if (error != nil) {
            if (completionBlock) {
                completionBlock(NO, error);
            }
            return;
        }
        
        switch (httpResponse.statusCode) {
            case 503:
            {
                if (retryCount < self.maxRetryCount ) {
                    NSLog(@"Retry resetBadgeForPushToken: %d", (int)(retryCount+1));
                    int64_t nsec = self.retryDelay * NSEC_PER_MSEC;
                    dispatch_queue_t global_default = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, nsec), global_default, ^{
                        [self resetBadgeForPushToken:pushToken
                                             session:session
                                             request:request
                                          retryCount:retryCount+1
                                     completionBlock:completionBlock];
                    });
                } else {
                    if (completionBlock) {
                        NSError* error = [NSError errorWithDomain: @"SCGPush" code: httpResponse.statusCode userInfo: nil];
                        completionBlock(NO, error);
                    }
                }
            }
                break;
            case 200:
            case 204:
            {
                if (completionBlock != nil) {
                    completionBlock(YES, nil);
                }
            }
                break;
            default:
            {
                if (completionBlock) {
                    NSError* error = [NSError errorWithDomain: @"SCGPush" code: httpResponse.statusCode userInfo: nil];
                    completionBlock(NO, error);
                }
            }
                break;
                
        }
    }];
    
    [dataTask resume];
}

// MARK: - Save Device Token
- (void) saveDeviceToken: (NSString* _Nonnull) token
{
}

- (void) saveDeviceTokenData: (NSData* _Nonnull) tokenData
{
}

//MARK: - PushInbox
- (void) initializeInbox
{
    self.coreDataManager = [SCGPushCoreDataManager sharedInstance];
}

- (BOOL) pushToInbox: (NSDictionary* _Nonnull) payload
{
    BOOL fOk = NO;
    id identifier = payload[@"scg-message-id"];
    id body = payload[@"body"];
    id deepLink = payload[@"deep_link"];
    id attachmentId = payload[@"scg-attachment-id"];
    id showNotification = payload[@"show-notification"];
    
    if (nil == identifier || ![identifier isKindOfClass: [NSString class]])
        return fOk;
    
    NSString* messageId = (NSString*) identifier;
    NSString* messageBody = @"";
    
    if (nil != body && [body isKindOfClass:[NSString class]]) {
        messageBody = (NSString*) body;
    }
    
    SCGPushMessage* message =
    [[SCGPushMessage alloc] initWithId: messageId
                           dateCreated: [NSDate date]
                               andBody: messageBody];
    
    if (!message)
        return fOk;
    
    if (deepLink && [deepLink isKindOfClass:[NSString class]]) {
        message.deepLink = (NSString*) deepLink;
    }
    if (attachmentId && [attachmentId isKindOfClass:[NSString class]]) {
        message.attachmentId = (NSString*) attachmentId;
    }
    
    if (showNotification && [showNotification isKindOfClass:[NSNumber class]]) {
        message.showNotification = [showNotification boolValue];
    }
    
    fOk = [self.coreDataManager addNewMessage: message];
    
    return fOk;
}

- (NSUInteger) numberOfMessages
{
    return [self.coreDataManager numberOfMessages];
}

- (SCGPushMessage* _Nullable) messageAtIndex:(NSUInteger) index
{
    return [self.coreDataManager messageAtIndex: index];
}

- (BOOL) deleteMessage: (SCGPushMessage* _Nonnull) message
{
    return [self.coreDataManager deleteMessage:message];
}

- (BOOL) deleteMessageAtIndex: (NSUInteger) index
{
    return [self.coreDataManager deleteMessageAtIndex:index];
}

- (BOOL) deleteAllMessages
{
    return [self.coreDataManager deleteAllMessages];
}

//MARK: - Load Attachment
- (void) loadAttachmentForMessage: (SCGPushMessage* _Nonnull) message
                  completionBlock: (void(^ _Nullable) (SCGPushAttachment* _Nonnull attachment)) completionBlock
                     failureBlock: (void(^ _Nullable) (NSError* _Nullable error)) failureBlock
{
    if( !message.attachmentId.length ) {
        if (failureBlock) {
            NSError* error = [SCGPushErrorFactory pushInboxErrorWithCode:SCGPushInboxErrorCodeNoAttachment];
            failureBlock(error);
        }
        
        return;
    }
    
    SCGPushAttachment* attachment = [self.coreDataManager loadAttachmentForMessage: message];
    
    if (attachment == nil) {
        // No attachment found, lets try to download it now
        attachment = [self.coreDataManager createAttachmentWithId: message.attachmentId];
        if (nil == attachment) {
            if (failureBlock) {
                NSError* error =
                [SCGPushErrorFactory pushInboxErrorWithCode: SCGPushInboxErrorCodeNoAttachment];
                
                failureBlock(error);
            }
            return;
        }
    }
    
    if (attachment.state == SCGPushAttachmentDownloadNotStarted ||
        attachment.state == SCGPushAttachmentDownloadFailed)
    {
        [self loadInboxAttachmentForMessage:message
                            completionBlock:^(SCGPushAttachment * _Nonnull loadedAttachment) {
                                // success
                                loadedAttachment.state = SCGPushAttachmentDownloadSucceeded;
                                [self.coreDataManager updateAttachment: loadedAttachment];
                                
                                if (completionBlock)
                                    completionBlock(loadedAttachment);
                            }
                               failureBlock:^(NSError * _Nullable error) {
                                   //failure. mark the attachment as failed temp or perm
                                   attachment.retryCount += 1;
                                   if (attachment.retryCount < 3)
                                       attachment.state = SCGPushAttachmentDownloadFailed;
                                   else
                                       attachment.state = SCGPushAttachmentDownloadError;

                                   [self.coreDataManager updateAttachment: attachment];

                                   if (failureBlock) {
                                       NSError* error;
                                       if (attachment.state == SCGPushAttachmentDownloadFailed)
                                           error = [SCGPushErrorFactory pushInboxErrorWithCode: SCGPushInboxErrorCodeAttachmentDownloadTemporaryFailure];
                                       else
                                           error = [SCGPushErrorFactory pushInboxErrorWithCode: SCGPushInboxErrorCodeAttachmentDownloadPermanentFailure];

                                       failureBlock(error);
                                   }
                             }];
    } else if (attachment.state == SCGPushAttachmentDownloadInProgress) {
        if (failureBlock) {
            NSError* error = [SCGPushErrorFactory pushInboxErrorWithCode: SCGPushInboxErrorCodeAttachmentDownloadAlreadyInProgress];
            failureBlock(error);
        }
    } else if (attachment.state == SCGPushAttachmentDownloadSucceeded) {
        if (completionBlock)
            completionBlock(attachment);
    } else {
        if (failureBlock) {
            NSError* error = [SCGPushErrorFactory pushInboxErrorWithCode: SCGPushInboxErrorCodeAttachmentDownloadPermanentFailure];
            failureBlock(error);
        }
    }
}

- (SCGPushAttachment* _Nullable) getAttachmentForMessage:(SCGPushMessage* _Nonnull) message
{
    return [self.coreDataManager loadAttachmentForMessage: message];
}


//MARK: - accessors
- (HttpRedirectDecisionMaker *)redirectDecisionMaker {

    if (nil == _redirectDecisionMaker) {
        _redirectDecisionMaker = [[HttpRedirectDecisionMaker alloc] initWithPreventRedirect: YES];
    }
    
    return _redirectDecisionMaker;
}

-(void)setAccessToken:(NSString *)newValue {
    @synchronized (self) {
        if ([newValue length]) {
            NSLog(@"Debug: [SCGPush] set accessToken %@", newValue);
            self.accessTokenInternal = [newValue copy];
        } else{
            NSLog(@"Debug: [SCGPush] clear accessToken");
            self.accessTokenInternal = [@"" copy];
        }
    }
}

-(NSString *)accessToken {
    @synchronized (self) {
        return self.accessTokenInternal;
    }
}

-(void)setAppID:(NSString *)newValue {
    @synchronized (self) {
        if ([newValue length]) {
            NSLog(@"Debug: [SCGPush] set appID %@", newValue);
            self.appIDInternal = [newValue copy];
        } else{
            NSLog(@"Debug: [SCGPush] clear appID");
            self.appIDInternal = [@"" copy];
        }
    }
}

-(NSString *)appID {
    @synchronized (self) {
        return self.appIDInternal;
    }
}

-(void)setCallbackURI:(NSString *)newValue{
    @synchronized (self) {
        if ([newValue length]) {
            NSLog(@"Debug: [SCGPush] set callbackURI %@", newValue);
            self.callbackURIInternal = [newValue copy];
        } else{
            NSLog(@"Debug: [SCGPush] clear callbackURI");
            self.callbackURIInternal = [@"" copy];
        }
    }
    
}

-(NSString *)callbackURI {
    @synchronized (self) {
        return self.callbackURIInternal;
    }
}
@end
