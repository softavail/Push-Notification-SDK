//
//  SCGPush.h
//  SCGPushSDK
//
//  Created by Angel Terziev on 3/13/17.
//  Copyright © 2017 Syniverse. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <SCGPushSDK/SCGPushDelegate.h>

typedef NS_ENUM(NSInteger, MessageState) {
    MessageStateDelivered,
    MessageStateRequested,
    MessageStateRead,
    MessageStateClicked,
    MessageStateConverted
};

@interface SCGPush : NSObject

+ (instancetype _Nonnull) sharedInstance;

@property (nonatomic, assign, nullable) id <SCGPushDelegate> delegate;

@property (atomic, copy, nonnull) NSString* accessToken;
@property (atomic, copy, nonnull) NSString* callbackURI;
@property (atomic, copy, nonnull) NSString* appID;
@property (atomic, copy, nullable) NSString* groupBundle;

- (void) registerPushToken:( NSString* _Nonnull) pushToken
     withCompletionHandler:( void (^ _Nullable)(NSString * _Nullable token)) completionBlock
              failureBlock:( void (^ _Nullable)(NSError * _Nullable error)) failureBlock;

- (void) reportStatusWithMessageId: ( NSString* _Nonnull) messageId
                   andMessageState: ( MessageState ) state
                   completionBlock: ( void(^ _Nullable)()    ) completionBlock
                     failureBlock : ( void(^ _Nullable) (NSError* _Nullable error)) failureBlock;

- (void) resolveTrackedLink:(NSString* _Nonnull) url;

- (void) loadAttachmentWithMessageId:(NSString* _Nonnull) messageId
                     andAttachmentId:(NSString* _Nonnull) attachmentId
                     completionBlock:(void(^_Nullable)(NSURL* _Nonnull contentUrl, NSString* _Nonnull contentType))completionBlock
                        failureBlock:(void(^_Nullable)(NSError* _Nullable error))failureBlock;

- (void) saveDeviceToken: (NSString* _Nonnull) token;
- (void) saveDeviceTokenData: (NSData* _Nonnull) tokenData;

@end
