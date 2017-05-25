//
//  SCGPushAttachment.m
//  SCGPushSDK
//
//  Created by Angel Terziev on 3/15/17.
//  Copyright © 2017 Syniverse. All rights reserved.
//

#import "SCGPushAttachment.h"

#import <MobileCoreServices/UTCoreTypes.h>

@implementation SCGPushAttachment

- (instancetype) initWithIdentifier: (NSString*) identifier
{
    if (nil != (self = [super init])) {
        _identifier = [identifier copy];
    }
    
    return self;
}

-(NSString *)fileName {
    if (NSOrderedSame == [_contentType caseInsensitiveCompare: (NSString*) kUTTypeJPEG]) {
        return [_identifier stringByAppendingPathExtension: @"jpg"];
    }
    else if (NSOrderedSame == [_contentType caseInsensitiveCompare: (NSString*) kUTTypePNG]) {
        return [_identifier stringByAppendingPathExtension: @"png"];
    }
    else if (NSOrderedSame == [_contentType caseInsensitiveCompare: (NSString*) kUTTypeGIF]) {
        return [_identifier stringByAppendingPathExtension: @"gif"];
    }
    
    return @"noname.txt";
}

@end
