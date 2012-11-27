//
//  JivePagedRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePageCountRequestOptions.h"

@interface JivePagedRequestOptions : JivePageCountRequestOptions

@property (nonatomic) int startIndex; // Zero-relative index of the first instance to be returned

@end
