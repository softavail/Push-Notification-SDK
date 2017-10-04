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
    } else if (NSOrderedSame == [_contentType caseInsensitiveCompare: (NSString*) kUTTypePNG]) {
        return [_identifier stringByAppendingPathExtension: @"png"];
    } else if (NSOrderedSame == [_contentType caseInsensitiveCompare: (NSString*) kUTTypeGIF]) {
        return [_identifier stringByAppendingPathExtension: @"gif"];
    } else if (NSOrderedSame == [_contentType caseInsensitiveCompare: (NSString*) kUTTypeMPEG]) {
        return [_identifier stringByAppendingPathExtension: @"mpg"];
    } else if (NSOrderedSame == [_contentType caseInsensitiveCompare: (NSString*) kUTTypeMPEG4]) {
        return [_identifier stringByAppendingPathExtension: @"mp4"];
    } else if (NSOrderedSame == [_contentType caseInsensitiveCompare: (NSString*) kUTTypeAVIMovie]) {
        return [_identifier stringByAppendingPathExtension: @"avi"];
    } else if (NSOrderedSame == [_contentType caseInsensitiveCompare: (NSString*) kUTTypeQuickTimeMovie]) {
        return [_identifier stringByAppendingPathExtension: @"mov"];
    } else if (NSOrderedSame == [_contentType caseInsensitiveCompare: (NSString*) kUTTypeWaveformAudio]) {
        return [_identifier stringByAppendingPathExtension: @"wav"];
    } else if (NSOrderedSame == [_contentType caseInsensitiveCompare: (NSString*) kUTTypeAudioInterchangeFileFormat]) {
        return [_identifier stringByAppendingPathExtension: @"aif"];
    } else if (NSOrderedSame == [_contentType caseInsensitiveCompare: (NSString*) kUTTypeMP3]) {
        return [_identifier stringByAppendingPathExtension: @"mp3"];
    } else if (NSOrderedSame == [_contentType caseInsensitiveCompare: (NSString*) kUTTypeMPEG4Audio]) {
        return [_identifier stringByAppendingPathExtension: @"m4a"];
    }

    return @"noname.txt";
}

@end
