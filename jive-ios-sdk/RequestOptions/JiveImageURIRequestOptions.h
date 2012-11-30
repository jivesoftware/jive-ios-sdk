//
//  JiveImageURIRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/28/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveRequestOptions.h"

@interface JiveImageURIRequestOptions : NSObject<JiveRequestOptions>

@property (nonatomic, strong) NSURL *uri;

- (NSString *)toQueryString;

@end
