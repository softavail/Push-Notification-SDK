//
//  SCGPushAttachment.h
//  SCGPushSDK
//
//  Created by Angel Terziev on 3/15/17.
//  Copyright © 2017 Syniverse. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SCGPushAttachmentDownloadState) {
    SCGPushAttachmentDownloadNotStarted = 0,
    SCGPushAttachmentDownloadInProgress = 1,
    SCGPushAttachmentDownloadSucceeded  = 2,
    SCGPushAttachmentDownloadFailed     = 3,
    SCGPushAttachmentDownloadError      = 4,
};

@interface SCGPushAttachment : NSObject

- (instancetype) initWithIdentifier: (NSString*) identifier;

@property (nonatomic, copy, readonly ) NSString* identifier;

@property (nonatomic, copy, nullable  ) NSString* contentType;
@property (nonatomic ) SCGPushAttachmentDownloadState state;
@property (nonatomic ) NSInteger retryCount;

@property (nonatomic, copy, nullable ) NSData*   data;

@property (nonatomic, readonly ) NSString* fileName;

@end

NS_ASSUME_NONNULL_END
