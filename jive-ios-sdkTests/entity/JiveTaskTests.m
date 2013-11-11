//
//  JiveTaskTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/28/12.
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

#import "JiveTaskTests.h"

@implementation JiveTaskTests

- (void)setUp {
    [super setUp];
    self.object = [[JiveTask alloc] init];
}

- (JiveTask *)task {
    return (JiveTask *)self.content;
}

- (void)testType {
    STAssertEqualObjects(self.task.type, @"task", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.task.type forKey:@"type"];
    
    STAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.task class], @"Task class not registered with JiveTypedObject.");
    STAssertEqualObjects([JiveContent entityClass:typeSpecifier], [self.task class], @"Task class not registered with JiveContent.");
}

- (void)testTaskToJSON {
    NSString *subTask = @"subTask";
    NSString *tag = @"wordy";
    NSDictionary *JSON = [self.task toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], @"task", @"Wrong type");
    
    [self.task setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"dueDate"];
    self.task.parentTask = @"parentTask";
    self.task.subTasks = [NSArray arrayWithObject:subTask];
    [self.task setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    self.task.visibleToExternalContributors = [NSNumber numberWithBool:YES];
    
    JSON = [self.task toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)6, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.task.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"parentTask"], self.task.parentTask, @"Wrong parentTask");
    STAssertEqualObjects([JSON objectForKey:@"completed"], self.task.completed, @"Wrong completed");
    STAssertEqualObjects([JSON objectForKey:@"visibleToExternalContributors"], self.task.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEqualObjects([JSON objectForKey:@"dueDate"], @"1970-01-01T00:00:00.000+0000", @"Wrong dueDate");
    
    NSArray *tagsJSON = [JSON objectForKey:@"tags"];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
    
    NSArray *subTasksJSON = [JSON objectForKey:@"subTasks"];
    
    STAssertTrue([[subTasksJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([subTasksJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([subTasksJSON objectAtIndex:0], subTask, @"Wrong value");
}

- (void)testTaskToJSON_alternate {
    NSString *subTask = @"76543";
    NSString *tag = @"concise";
    
    [self.task setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"dueDate"];
    self.task.parentTask = @"23456";
    self.task.subTasks = [NSArray arrayWithObject:subTask];
    [self.task setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    self.task.completed = [NSNumber numberWithBool:YES];
    
    NSDictionary *JSON = [self.task toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)6, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.task.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"parentTask"], self.task.parentTask, @"Wrong parentTask");
    STAssertEqualObjects([JSON objectForKey:@"completed"], self.task.completed, @"Wrong completed");
    STAssertEqualObjects([JSON objectForKey:@"visibleToExternalContributors"], self.task.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEqualObjects([JSON objectForKey:@"dueDate"], @"1970-01-01T00:16:40.123+0000", @"Wrong dueDate");
    
    NSArray *tagsJSON = [JSON objectForKey:@"tags"];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
    
    NSArray *subTasksJSON = [JSON objectForKey:@"subTasks"];
    
    STAssertTrue([[subTasksJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([subTasksJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([subTasksJSON objectAtIndex:0], subTask, @"Wrong value");
}

- (void)testPostParsing {
    NSString *subTask = @"subTask";
    NSString *tag = @"wordy";
    
    [self.task setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"dueDate"];
    self.task.parentTask = @"parentTask";
    self.task.subTasks = [NSArray arrayWithObject:subTask];
    [self.task setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    self.task.visibleToExternalContributors = [NSNumber numberWithBool:YES];
    
    id JSON = [self.task toJSONDictionary];
    JiveTask *newContent = [JiveTask objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.task class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.task.type, @"Wrong type");
    STAssertEqualObjects(newContent.parentTask, self.task.parentTask, @"Wrong parentTask");
    STAssertEqualObjects(newContent.dueDate, self.task.dueDate, @"Wrong dueDate");
    STAssertEqualObjects(newContent.completed, self.task.completed, @"Wrong completed");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.task.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newContent.tags count], [self.task.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
    STAssertEquals([newContent.subTasks count], [self.task.subTasks count], @"Wrong number of subTasks");
    STAssertEqualObjects([newContent.subTasks objectAtIndex:0], subTask, @"Wrong subTask");
}

- (void)testPostParsingAlternate {
    NSString *subTask = @"76543";
    NSString *tag = @"concise";
    
    [self.task setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"dueDate"];
    self.task.parentTask = @"23456";
    self.task.subTasks = [NSArray arrayWithObject:subTask];
    [self.task setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    self.task.completed = [NSNumber numberWithBool:YES];
    
    id JSON = [self.task toJSONDictionary];
    JiveTask *newContent = [JiveTask objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.task class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.task.type, @"Wrong type");
    STAssertEqualObjects(newContent.parentTask, self.task.parentTask, @"Wrong parentTask");
    STAssertEqualObjects(newContent.dueDate, self.task.dueDate, @"Wrong dueDate");
    STAssertEqualObjects(newContent.completed, self.task.completed, @"Wrong completed");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.task.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newContent.tags count], [self.task.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
    STAssertEquals([newContent.subTasks count], [self.task.subTasks count], @"Wrong number of subTasks");
    STAssertEqualObjects([newContent.subTasks objectAtIndex:0], subTask, @"Wrong subTask");
}

@end
