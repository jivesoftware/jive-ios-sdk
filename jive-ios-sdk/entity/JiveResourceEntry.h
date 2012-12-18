//
//  JiveResourceEntry.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/18/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveObject.h"

@interface JiveResourceEntry : JiveObject

@property (nonatomic, readonly) NSURL *ref; // URL for this service.
@property (nonatomic, readonly) NSArray *allowed; // Access types allowed by this service.

@end
