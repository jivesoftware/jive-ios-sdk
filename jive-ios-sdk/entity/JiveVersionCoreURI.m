//
//  JiveVersionCoreURI.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 4/11/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveVersionCoreURI.h"

// Separate tests are not needed as this class is fully tested as part of JiveVersion.

struct JiveVersionCoreURIAttributes const JiveVersionCoreURIAttributes = {
	.version = @"version",
	.revision = @"revision",
	.uri = @"uri",
	.documentation = @"documentation",
};

@implementation JiveVersionCoreURI

@synthesize version, revision, uri, documentation;

@end
