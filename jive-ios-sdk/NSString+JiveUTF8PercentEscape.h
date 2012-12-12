//
//  NSString+JiveUTF8PercentEscape.h
//  jive-ios-sdk
//
//  Created by Heath Borders on 12/12/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JiveUTF8PercentEscape)

- (NSString *) jive_encodeWithUTF8PercentEscaping;
- (NSString *) jive_decodeWithUTF8PercentEscaping;

@end
