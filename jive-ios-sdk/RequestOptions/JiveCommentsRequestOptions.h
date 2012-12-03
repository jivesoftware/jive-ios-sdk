//
//  JiveCommentsRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/30/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePagedRequestOptions.h"

@interface JiveCommentsRequestOptions : JivePagedRequestOptions

@property (nonatomic, strong) NSURL *anchor;

@end
