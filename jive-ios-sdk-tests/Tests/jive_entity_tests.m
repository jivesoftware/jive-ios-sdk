//
//  jive_entity_tests.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/24/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "jive_entity_tests.h"
#import "JiveObject.h"
#import "JiveInboxEntry.h"
#import "JiveActivityObject.h"

@implementation jive_entity_tests

- (id) JSONFromTestFile:(NSString*) filename {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:[filename stringByDeletingPathExtension] ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSError* error;
    id json  = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    GHAssertNil(error, @"Unable to deserialize JSON text data from file '%@'.json", filename);
    return json;
}

- (void) testJiveInboxEntryDeserialize {
    id json = [self JSONFromTestFile:@"inbox_response.json"];
    NSDictionary* inboxEntryData = [[json objectForKey:@"list"] objectAtIndex:0];
    JiveInboxEntry *inboxEntry = [JiveInboxEntry instanceFromJSON:inboxEntryData];
    GHAssertNotNil(inboxEntry, @"JiveInboxEntry was nil!");
    GHAssertNotNil(inboxEntry.object.jiveId, @"JiveId was nil!");
}

- (void) testJiveInboxEntryDeserializeList {
    
    id json = [self JSONFromTestFile:@"inbox_response.json"];
    
    JiveInboxEntry *inboxEntry = [JiveInboxEntry instanceFromJSON:[json objectForKey:@"list"]];
    
    GHAssertNil(inboxEntry, @"JiveInboxEntry should have failed initialization when passed incorrect JSON.");
    
    NSArray* instances = [JiveInboxEntry instancesFromJSONList:[json objectForKey:@"list"]];
    
    GHAssertNotNil(instances, @"JiveInboxEntry list should not be nil!");
    GHAssertTrue([instances count] == [[json objectForKey:@"list"] count], @"Incorrect number of JiveInboxEntry objects found in list. Expected %d, found %d.", [[json objectForKey:@"list"] count], [instances count]);
    
    // More checks needed for data correctness
    for(JiveInboxEntry* entry in instances) {
        NSLog(@"%@", entry);
    }
}

@end
