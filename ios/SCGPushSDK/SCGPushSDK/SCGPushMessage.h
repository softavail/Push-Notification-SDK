//
//  SCGPushMessage.h
//  SCGPushSDK
//
//  Created by Angel Terziev on 3/15/17.
//  Copyright © 2017 Syniverse. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <SCGPushSDK/SCGPushAttachment.h>

@interface SCGPushMessage : NSObject

- (instancetype) initWithId: (NSString *) identifier
                dateCreated: (NSDate   *) created
                    andBody: (NSString *) body;

@property (nonatomic, strong, readonly) NSString* identifier;
@property (nonatomic, strong, readonly) NSDate* created;
@property (nonatomic, strong, readonly) NSString* body;

@property (nonatomic, strong) NSString* deepLink;
@property (nonatomic, assign) BOOL showNotification;
@property (nonatomic, strong) NSString* attachmentId;

@property (nonatomic, assign, readonly) BOOL hasAttachment;

@end
