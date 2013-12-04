//
//  JiveObjectTests.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/2/13.
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

#import <SenTestingKit/SenTestingKit.h>
#import "JiveObject_internal.h"
#import "Jive.h"

@interface JiveObjectTests : SenTestCase <JiveAuthorizationDelegate>

@property (nonatomic, strong) NSURL *serverURL; // Used to initialize both the instance url and the platform version url. Once the instance is created changing this will change just the platform version url.
@property (nonatomic, strong) NSString *apiPath;
@property (nonatomic, strong) Jive *instance;
@property (nonatomic, strong) JiveObject *object;

@end
