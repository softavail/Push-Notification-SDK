//
//  SCGPushCoreDataManager.h
//  SCGPushSDK
//
//  Created by Angel Terziev on 3/15/17.
//  Copyright © 2017 Syniverse. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SCGPushMessage.h"

@interface SCGPushCoreDataManager : NSObject

+ (instancetype _Nonnull) sharedInstance;

- (NSUInteger) numberOfMessages;

- (SCGPushMessage* _Nullable) messageAtIndex:(NSUInteger) index;

- (BOOL) addNewMessage: (SCGPushMessage* _Nonnull) message;
- (BOOL) deleteMessage: (SCGPushMessage* _Nonnull) message;
- (BOOL) deleteMessageAtIndex: (NSUInteger) index;
- (BOOL) deleteAllMessages;
- (SCGPushAttachment* _Nullable) loadAttachmentForMessage: (SCGPushMessage* _Nonnull) message;

- (BOOL) updateAttachment: (SCGPushAttachment* _Nonnull) attachment;
- (SCGPushAttachment* _Nullable) createAttachmentWithId: (NSString*_Nullable) attachmentId;

@end
