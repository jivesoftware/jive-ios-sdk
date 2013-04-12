//
//  JiveCoreVersion.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 4/11/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveCoreVersion.h"

// Separate tests are not needed as this class is fully tested as part of JiveVersion.

struct JiveCoreVersionAttributes const JiveCoreVersionAttributes = {
	.version = @"version",
	.revision = @"revision",
	.uri = @"uri",
	.documentation = @"documentation",
};

@implementation JiveCoreVersion

@synthesize version, revision, uri, documentation;

@end
