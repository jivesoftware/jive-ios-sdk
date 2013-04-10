//
//  NSURLRequest+Jive.h
//  jive-ios-sdk
//
//  Created by Heath Borders on 4/10/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (Jive)

+ (instancetype)requestWithString:(NSString *)string
                  relativeToURL:(NSURL *)URL;

@end
