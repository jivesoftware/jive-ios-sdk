//
//  JiveSizeRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JiveRequestOptions.h"

@interface JiveSizeRequestOptions : NSObject<JiveRequestOptions>

- (NSString *)toQueryString;

@property (nonatomic) int size;

@end
