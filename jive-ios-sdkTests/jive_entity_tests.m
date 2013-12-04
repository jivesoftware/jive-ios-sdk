//
//  jive_entity_tests.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/24/12.
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

#import "jive_entity_tests.h"
#import "JiveObject.h"
#import "JiveInboxEntry.h"
#import "JiveActivityObject.h"
#import "Jive_internal.h"

@implementation jive_entity_tests

- (id) JSONFromTestFile:(NSString*) filename {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:filename ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSError* error;
    id json  = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    STAssertNil(error, @"Unable to deserialize JSON text data from file '%@'.json", filename);
    return json;
}

- (void) testJiveInboxEntryDeserialize {
    id json = [self JSONFromTestFile:@"inbox_response"];
    Jive *instance = [[Jive alloc] initWithJiveInstance:[NSURL URLWithString:@"https://brewspace.jiveland.com"]
                                  authorizationDelegate:nil];
    NSDictionary* inboxEntryData = [[json objectForKey:@"list"] objectAtIndex:0];
    JiveInboxEntry *inboxEntry = [JiveInboxEntry objectFromJSON:inboxEntryData
                                                     withInstance:instance];
    
    STAssertNotNil(inboxEntry, @"JiveInboxEntry was nil!");
    STAssertNotNil(inboxEntry.object.jiveId, @"JiveId was nil!");
}

- (void) testJiveInboxEntryDeserializeList {
    
    id json = [self JSONFromTestFile:@"inbox_response"];
    Jive *instance = [[Jive alloc] initWithJiveInstance:[NSURL URLWithString:@"https://brewspace.jiveland.com"]
                                  authorizationDelegate:nil];
    id JSONList = [json objectForKey:@"list"];
    JiveInboxEntry *inboxEntry = [JiveInboxEntry objectFromJSON:JSONList withInstance:instance];
    
    STAssertNil(inboxEntry,
                @"JiveInboxEntry should have failed initialization when passed incorrect JSON.");
    
    NSArray* instances = [JiveInboxEntry objectsFromJSONList:JSONList withInstance:instance];
    
    STAssertNotNil(instances, @"JiveInboxEntry list should not be nil!");
    STAssertTrue([instances count] == [JSONList count],
                 @"Incorrect number of JiveInboxEntry objects found in list. Expected %d, found %d.",
                 [JSONList count], [instances count]);
}

@end
