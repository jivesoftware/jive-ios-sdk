//
//  JiveActionLink.h
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/24/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JiveObject.h"

@interface JiveActionLink : JiveObject

// Hint that MAY be used by the presentation layer to allow interaction with the user (for example, the label text for a button).
@property(nonatomic, copy) NSString* caption;

// HTTP operation to perform against the actionable resource. Should be one of GET, PUT, POST, DELETE, or other standard HTTP verb. If not present, defaults to GET.
@property(nonatomic, copy) NSString* httpVerb;

// URI representing the target web hook endpoint to be invoked with the specified HTTP verb.
@property(nonatomic, readonly, strong) NSURL *target;

@end
