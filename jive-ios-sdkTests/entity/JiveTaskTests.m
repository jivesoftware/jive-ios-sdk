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
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.task.type
                                                                            forKey:JiveTypedObjectAttributes.type];
    
    STAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.task class], @"Task class not registered with JiveTypedObject.");
    STAssertEqualObjects([JiveContent entityClass:typeSpecifier], [self.task class], @"Task class not registered with JiveContent.");
}

- (void)initializeTask {
    NSString *subTask = @"subTask";
    
    self.task.dueDate = [NSDate dateWithTimeIntervalSince1970:0];
    self.task.parentTask = @"parentTask";
    self.task.subTasks = @[subTask];
    self.task.owner = @"/person/12345";
    
}

- (void)initializeAlternateTask {
    NSString *subTask = @"76543";
    
    self.task.dueDate = [NSDate dateWithTimeIntervalSince1970:1000.123];
    self.task.parentTask = @"23456";
    self.task.subTasks = @[subTask];
    self.task.owner = @"/person/54321";
    self.task.completed = @YES;
    
}

- (void)testTaskToJSON {
    NSDictionary *JSON = [self.task toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], @"task", @"Wrong type");
    
    [self initializeTask];
    
    JSON = [self.task toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.task.type, @"Wrong type");
    STAssertEqualObjects(JSON[JiveTaskAttributes.parentTask], self.task.parentTask, @"Wrong parentTask");
    STAssertEqualObjects(JSON[JiveTaskAttributes.completed], self.task.completed, @"Wrong completed");
    STAssertEqualObjects(JSON[JiveTaskAttributes.owner], self.task.owner, @"Wrong owner");
    STAssertEqualObjects(JSON[JiveTaskAttributes.dueDate], @"1970-01-01T00:00:00.000+0000", @"Wrong dueDate");
    
    NSArray *subTasksJSON = JSON[JiveTaskAttributes.subTasks];
    
    STAssertTrue([[subTasksJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([subTasksJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([subTasksJSON objectAtIndex:0], self.task.subTasks[0], @"Wrong value");
}

- (void)testTaskToJSON_alternate {
    [self initializeAlternateTask];
    
    NSDictionary *JSON = [self.task toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)6, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.task.type, @"Wrong type");
    STAssertEqualObjects(JSON[JiveTaskAttributes.parentTask], self.task.parentTask, @"Wrong parentTask");
    STAssertEqualObjects(JSON[JiveTaskAttributes.completed], self.task.completed, @"Wrong completed");
    STAssertEqualObjects(JSON[JiveTaskAttributes.owner], self.task.owner, @"Wrong owner");
    STAssertEqualObjects(JSON[JiveTaskAttributes.dueDate], @"1970-01-01T00:16:40.123+0000", @"Wrong dueDate");
    
    NSArray *subTasksJSON = JSON[JiveTaskAttributes.subTasks];
    
    STAssertTrue([[subTasksJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([subTasksJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([subTasksJSON objectAtIndex:0], self.task.subTasks[0], @"Wrong value");
}

- (void)testPostParsing {
    [self initializeTask];
    
    id JSON = [self.task toJSONDictionary];
    JiveTask *newContent = [JiveTask objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.task class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.task.type, @"Wrong type");
    STAssertEqualObjects(newContent.parentTask, self.task.parentTask, @"Wrong parentTask");
    STAssertEqualObjects(newContent.dueDate, self.task.dueDate, @"Wrong dueDate");
    STAssertEqualObjects(newContent.completed, self.task.completed, @"Wrong completed");
    STAssertEqualObjects(newContent.owner, self.task.owner, @"Wrong owner");
    STAssertEquals([newContent.subTasks count], [self.task.subTasks count], @"Wrong number of subTasks");
    STAssertEqualObjects([newContent.subTasks objectAtIndex:0], self.task.subTasks[0], @"Wrong subTask");
}

- (void)testPostParsingAlternate {
    [self initializeAlternateTask];
    
    id JSON = [self.task toJSONDictionary];
    JiveTask *newContent = [JiveTask objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.task class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.task.type, @"Wrong type");
    STAssertEqualObjects(newContent.parentTask, self.task.parentTask, @"Wrong parentTask");
    STAssertEqualObjects(newContent.dueDate, self.task.dueDate, @"Wrong dueDate");
    STAssertEqualObjects(newContent.completed, self.task.completed, @"Wrong completed");
    STAssertEqualObjects(newContent.owner, self.task.owner, @"Wrong owner");
    STAssertEquals([newContent.subTasks count], [self.task.subTasks count], @"Wrong number of subTasks");
    STAssertEqualObjects([newContent.subTasks objectAtIndex:0], self.task.subTasks[0], @"Wrong subTask");
}

@end
