//
//  JiveRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JiveRequestOptions <NSObject>

- (NSString *)toQueryString;

@end
