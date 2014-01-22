//
//  JiveGenericPersonTests.m
//  jive-ios-sdk
//
//  Created by Janeen Neri on 1/21/14.
//
//    Copyright 2014 Jive Software Inc.
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

#import "JiveObjectTests.h"

@interface JiveGenericPersonTests : JiveObjectTests

@end

@implementation JiveGenericPersonTests

- (void)setUp {
    [super setUp];
    self.object = [[JiveGenericPerson alloc] init];
}

- (JiveGenericPerson *)genericPerson {
    return (JiveGenericPerson *)self.object;
}

- (void)testGenericPersonPersistentJSON {
    NSDictionary *JSON = [self.genericPerson persistentJSON];
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
}

- (void)testGenericPersonPersistentJSON_internal {
    JivePerson *person = [[JivePerson alloc] init];
    [person setValue:@"testDisplayName" forKey:JivePersonAttributes.displayName];
    
    [self.genericPerson setValue:nil forKey:JiveGenericPersonAttributes.name];
    [self.genericPerson setValue:nil forKey:JiveGenericPersonAttributes.email];
    [self.genericPerson setValue:person forKey:JiveGenericPersonAttributes.person];
    
    NSDictionary *JSON = [self.genericPerson persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary had the wrong number of entries");
    
    STAssertEqualObjects([[JSON objectForKey:JiveGenericPersonAttributes.person] objectForKey:JivePersonAttributes.displayName], self.genericPerson.person.displayName, @"Wrong person");
}

- (void)testGenericPersonPersistentJSON_external {
    NSString *name = @"genericPerson testName";
    NSString *email = @"genericPersonEmail@email.com";
    
    [self.genericPerson setValue:nil forKey:JiveGenericPersonAttributes.person];
    [self.genericPerson setValue:name forKey:JiveGenericPersonAttributes.name];
    [self.genericPerson setValue:email forKey:JiveGenericPersonAttributes.email];
    
    NSDictionary *JSON = [self.genericPerson persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    
    STAssertEqualObjects([JSON objectForKey:JiveGenericPersonAttributes.name], self.genericPerson.name, @"Wrong name");
    STAssertEqualObjects([JSON objectForKey:JiveGenericPersonAttributes.email], self.genericPerson.email, @"Wrong email");
}

@end
