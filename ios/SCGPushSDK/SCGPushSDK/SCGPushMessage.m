//
//  SCGPushMessage.m
//  SCGPushSDK
//
//  Created by Angel Terziev on 3/15/17.
//  Copyright © 2017 Syniverse. All rights reserved.
//

#import "SCGPushMessage.h"

@implementation SCGPushMessage

- (instancetype) initWithId: (NSString *) identifier
                dateCreated: (NSDate   *) created
                    andBody: (NSString *) body
{
    if (nil != (self = [super init])) {
        _identifier = identifier;
        _created = created;
        _body = body;
    }
    
    return self;
}

@end
