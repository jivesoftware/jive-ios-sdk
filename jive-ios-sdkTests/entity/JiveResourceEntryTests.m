//
//  JiveResourceEntryTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/18/12.
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

#import "JiveResourceEntryTests.h"
#import "JiveResourceEntry.h"
#import "Jive_internal.h"

@implementation JiveResourceEntryTests

- (void)setUp {
    self.instance = [[Jive alloc] initWithJiveInstance:[NSURL URLWithString:@"https://dummy.com"]
                                 authorizationDelegate:self];
    self.object = [JiveResourceEntry new];
}

- (void)testInstanceFromJSON {
    NSMutableDictionary *JSON = [NSMutableDictionary dictionaryWithCapacity:2];
    NSArray *allowedJSON = [NSArray arrayWithObject:@"GET"];
    NSURL *ref = [NSURL URLWithString:@"https://dummy.com/testing.html"];
    
    [JSON setValue:[ref absoluteString] forKey:@"ref"];
    [JSON setValue:allowedJSON forKey:@"allowed"];
    
    JiveResourceEntry *resource = [JiveResourceEntry objectFromJSON:JSON withInstance:self.instance];
    
    STAssertNotNil(resource, @"Object not created");
    STAssertEqualObjects(resource.ref, ref, @"Wrong ref");
    STAssertEquals(resource.allowed.count, allowedJSON.count, @"Wrong number of allowed entries");
    STAssertEqualObjects([resource.allowed objectAtIndex:0], [allowedJSON objectAtIndex:0], @"Wrong allowed entry");
}

@end
