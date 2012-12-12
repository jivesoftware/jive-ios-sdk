//
//  NSString+JiveUTF8PercentEscape.m
//  jive-ios-sdk
//
//  Created by Heath Borders on 12/12/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "NSString+JiveUTF8PercentEscape.h"

@implementation NSString (JiveUTF8PercentEscape)

- (NSString *) jive_encodeWithUTF8PercentEscaping {
    CFStringRef percentEncdedStringRef = CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8);
    NSString *percentEncodedString = (NSString *)CFBridgingRelease(percentEncdedStringRef);
    return percentEncodedString;
}

- (NSString *) jive_decodeWithUTF8PercentEscaping {
    NSString *spaceDecodedString = [(NSString *)self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    NSString *percentDecodedString = [spaceDecodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return percentDecodedString;
}

@end
