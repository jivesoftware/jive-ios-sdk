//
//  JiveProjectTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/31/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveProjectTests.h"

@implementation JiveProjectTests

- (void)setUp {
    self.place = [[JiveProject alloc] init];
}

- (JiveProject *)project {
    return (JiveProject *)self.place;
}

- (void)testTaskToJSON {
    JivePerson *creator = [[JivePerson alloc] init];
    NSString *tag = @"wordy";
    NSDictionary *JSON = [self.project toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], @"project", @"Wrong type");
    
    creator.location = @"Harold";
    [self.project setValue:creator forKey:@"creator"];
    [self.project setValue:@"started" forKey:@"projectStatus"];
    [self.project setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"dueDate"];
    [self.project setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"startDate"];
    [self.project setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    
    JSON = [self.project toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)6, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.project.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"projectStatus"], self.project.projectStatus, @"Wrong projectStatus");
    STAssertEqualObjects([JSON objectForKey:@"dueDate"], @"1970-01-01T00:00:00.000+0000", @"Wrong due date");
    STAssertEqualObjects([JSON objectForKey:@"startDate"], @"1970-01-01T00:16:40.123+0000", @"Wrong start date");
    
    NSArray *tagsJSON = [JSON objectForKey:@"tags"];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
    
    NSDictionary *creatorJSON = [JSON objectForKey:@"creator"];
    
    STAssertTrue([[creatorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([creatorJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([creatorJSON objectForKey:@"location"], creator.location, @"Wrong value");
}

- (void)testTaskToJSON_alternate {
    JivePerson *creator = [[JivePerson alloc] init];
    NSString *tag = @"concise";
    
    creator.location = @"Maud";
    [self.project setValue:creator forKey:@"creator"];
    [self.project setValue:@"complete" forKey:@"projectStatus"];
    [self.project setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"dueDate"];
    [self.project setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"startDate"];
    [self.project setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    
    NSDictionary *JSON = [self.project toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)6, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.project.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"projectStatus"], self.project.projectStatus, @"Wrong projectStatus");
    STAssertEqualObjects([JSON objectForKey:@"dueDate"], @"1970-01-01T00:16:40.123+0000", @"Wrong due date");
    STAssertEqualObjects([JSON objectForKey:@"startDate"], @"1970-01-01T00:00:00.000+0000", @"Wrong start date");
    
    NSArray *tagsJSON = [JSON objectForKey:@"tags"];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
    
    NSDictionary *creatorJSON = [JSON objectForKey:@"creator"];
    
    STAssertTrue([[creatorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([creatorJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([creatorJSON objectForKey:@"location"], creator.location, @"Wrong value");
}

- (void)testPostParsing {
    JivePerson *creator = [[JivePerson alloc] init];
    NSString *tag = @"wordy";
    
    creator.location = @"Harold";
    [self.project setValue:creator forKey:@"creator"];
    [self.project setValue:@"started" forKey:@"projectStatus"];
    [self.project setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"dueDate"];
    [self.project setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"startDate"];
    [self.project setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    
    id JSON = [self.project toJSONDictionary];
    JiveProject *newProject = [JiveProject instanceFromJSON:JSON];
    
    STAssertTrue([[newProject class] isSubclassOfClass:[self.project class]], @"Wrong item class");
    STAssertEqualObjects(newProject.type, self.project.type, @"Wrong type");
    STAssertEqualObjects(newProject.projectStatus, self.project.projectStatus, @"Wrong projectStatus");
    STAssertEqualObjects(newProject.dueDate, self.project.dueDate, @"Wrong due date");
    STAssertEqualObjects(newProject.startDate, self.project.startDate, @"Wrong start date");
    STAssertEquals([newProject.tags count], [self.project.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newProject.tags objectAtIndex:0], tag, @"Wrong tag");
    STAssertEqualObjects(newProject.creator.location, creator.location, @"Wrong creator location");
}

- (void)testPostParsingAlternate {
    JivePerson *creator = [[JivePerson alloc] init];
    NSString *tag = @"concise";
    
    creator.location = @"Maud";
    [self.project setValue:creator forKey:@"creator"];
    [self.project setValue:@"complete" forKey:@"projectStatus"];
    [self.project setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"dueDate"];
    [self.project setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"startDate"];
    [self.project setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    
    id JSON = [self.project toJSONDictionary];
    JiveProject *newProject = [JiveProject instanceFromJSON:JSON];
    
    STAssertTrue([[newProject class] isSubclassOfClass:[self.project class]], @"Wrong item class");
    STAssertEqualObjects(newProject.type, self.project.type, @"Wrong type");
    STAssertEqualObjects(newProject.projectStatus, self.project.projectStatus, @"Wrong projectStatus");
    STAssertEqualObjects(newProject.dueDate, self.project.dueDate, @"Wrong due date");
    STAssertEqualObjects(newProject.startDate, self.project.startDate, @"Wrong start date");
    STAssertEquals([newProject.tags count], [self.project.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newProject.tags objectAtIndex:0], tag, @"Wrong tag");
    STAssertEqualObjects(newProject.creator.location, creator.location, @"Wrong creator location");
}

@end
