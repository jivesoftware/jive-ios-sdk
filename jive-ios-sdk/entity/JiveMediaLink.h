//
//  JiveMediaLink.h
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/24/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JiveObject.h"

@interface JiveMediaLink : JiveObject

// Hint to the consumer about the length, in seconds, of the media resource identified by the url field.
@property(nonatomic, readonly) NSInteger duration;

// Hint to the consumer about the height, in pixels, of the media resource identified by the url field.
@property(nonatomic, readonly) NSInteger height;

// Hint to the consumer about the width, in pixels, of the media resource identified by the url field.
@property(nonatomic, readonly) NSInteger width;

// URI of the media resource being linked.
@property(nonatomic, readonly) NSURL* url;

@end
