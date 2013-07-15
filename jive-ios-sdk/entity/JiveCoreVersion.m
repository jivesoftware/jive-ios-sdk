//
//  JiveCoreVersion.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 4/11/13.
//
//    Copyright 2013 Jive Software Inc.
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.
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
