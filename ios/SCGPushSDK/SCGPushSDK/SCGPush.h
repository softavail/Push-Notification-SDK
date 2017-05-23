//
//  SCGPush.h
//  SCGPushSDK
//
//  Created by Angel Terziev on 3/13/17.
//  Copyright © 2017 Syniverse. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <SCGPushSDK/SCGPushDelegate.h>
#import <SCGPushSDK/SCGPushMessage.h>

typedef NS_ENUM(NSInteger, MessageState) {
    MessageStateDelivered,
    MessageStateRequested,
    MessageStateRead,
    MessageStateClicked,
    MessageStateConverted
};

@interface SCGPush : NSObject

+ (instancetype _Nonnull) sharedInstance;

+ (instancetype _Nonnull) startWithAccessToken: (NSString* _Nonnull) accessToken
                                         appId: (NSString* _Nonnull) appId
                                   callbackUri: (NSString* _Nonnull) callbackUri
                                      delegate: (id<SCGPushDelegate> _Nullable) delegate;

@property (atomic, copy, nonnull) NSString* accessToken;
@property (atomic, copy, nonnull) NSString* callbackURI;
@property (atomic, copy, nonnull) NSString* appID;

@property (atomic, weak, nullable) id<SCGPushDelegate> delegate;

- (void) registerPushToken:( NSString* _Nonnull) pushToken
     withCompletionHandler:( void (^ _Nullable)(NSString * _Nullable token)) completionBlock
              failureBlock:( void (^ _Nullable)(NSError * _Nullable error)) failureBlock;

- (void) unregisterPushToken:( NSString* _Nonnull) pushToken
       withCompletionHandler:( void (^ _Nullable)(NSString * _Nullable token)) completionBlock
                failureBlock:( void (^ _Nullable)(NSError * _Nullable error)) failureBlock;

- (void) reportStatusWithMessageId: ( NSString* _Nonnull) messageId
                   andMessageState: ( MessageState ) state
                   completionBlock: ( void(^ _Nullable)()    ) completionBlock
                      failureBlock: ( void(^ _Nullable) (NSError* _Nullable error)) failureBlock;

- (void) resolveTrackedLink:(NSString* _Nonnull) url;

- (void) loadAttachmentWithMessageId:(NSString* _Nonnull) messageId
                     andAttachmentId:(NSString* _Nonnull) attachmentId
                     completionBlock:(void(^_Nullable)(NSURL* _Nonnull contentUrl, NSString* _Nonnull contentType))completionBlock
                        failureBlock:(void(^_Nullable)(NSError* _Nullable error))failureBlock;

- (void) resetBadgeForPushToken: (NSString* _Nonnull) pushToken
                completionBlock: (void(^_Nullable)(BOOL success, NSError* _Nullable error)) completionBlock;
    
// MARK: - PushInbox
- (BOOL) pushToInbox: (NSDictionary* _Nonnull) payload;

- (NSUInteger) numberOfMessages;

- (SCGPushMessage* _Nullable) messageAtIndex:(NSUInteger) index;

- (BOOL) deleteMessage: (SCGPushMessage* _Nonnull) message;
- (BOOL) deleteMessageAtIndex: (NSUInteger) index;
- (BOOL) deleteAllMessages;
- (void) loadAttachmentForMessage: (SCGPushMessage* _Nonnull) message
                  completionBlock: (void(^ _Nullable) (SCGPushAttachment* _Nonnull attachment)) completionBlock
                     failureBlock: (void(^ _Nullable) (NSError* _Nullable error)) failureBlock;

- (SCGPushAttachment* _Nullable) getAttachmentForMessage:(SCGPushMessage* _Nonnull) message;

@end
