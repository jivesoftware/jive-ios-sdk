//
//  NSThread+JiveISO8601DateFormatter.h
//  jive-ios-sdk
//
//  Created by Heath Borders on 12/12/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSThread (JiveISO8601DateFormatter)

@property (nonatomic, readonly) NSDateFormatter *jive_ISO8601DateFormatter;

@end
