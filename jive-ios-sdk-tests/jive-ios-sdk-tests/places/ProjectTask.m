//
//  TaskInProject.m
//  jive-ios-sdk-tests
//
//  Created by Sherry Zhou on 6/24/14.
//  Copyright (c) 2014 Jive Software. All rights reserved.
//


#import "JiveTestCase.h"
#import "JVUtilities.h"

@interface ProjectTask : JiveTestCase
@property (strong,nonatomic)  JivePlace *testProject;
@property (strong,nonatomic)  NSString *testProjectID;
@property (strong,nonatomic)  NSString *projectName;
@end

@implementation ProjectTask

- (void)setUp {
    
    [super setUp];
    
    //Find project named 'iosAutoGroup1'
    _projectName=@"iosautoGroup1-Project1";
    JiveSearchPlacesRequestOptions* options = [[JiveSearchPlacesRequestOptions alloc]init];
    [options addSearchTerm:_projectName];
    
    __block NSArray *returnedPlaces = nil;
    
    waitForTimeout(^(dispatch_block_t finishBlock0) {
        [jive1 searchPlaces:options onComplete:^(NSArray *results) {
            returnedPlaces = results;
            finishBlock0();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock0();
        }];
    });
    
    for (JivePlace *place in returnedPlaces) {
        NSLog(@"type ==%@", place.type);
        if ( [place.name isEqualToString: _projectName] && [ place.type isEqualToString:@"project" ])   {
            _testProject = place;
            _testProjectID = place.placeID;
        }
    }
    STAssertTrue([[_testProject class] isSubclassOfClass:[JiveProject class]], @"Test failed at setup. Wrong class");
    STAssertTrue(_testProjectID != nil,  @"Test failed at setup. project %@ not found", _projectName);
    
}

- (void)testTasksForPlace {
    JiveSortedRequestOptions *options = [[JiveSortedRequestOptions alloc] init];
    options.sort = JiveSortOrderTitleAsc;
    
    __block NSArray *returnedTasksFromSDK = nil;
    waitForTimeout(^(dispatch_block_t finishBlock0) {
        [jive1 tasksForPlace:_testProject options:options onComplete:^(NSArray *tasks) {
            returnedTasksFromSDK = tasks;
            finishBlock0();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock0();
        }];
    });

    
    NSString* tasksForPlaceAPIURL =[ NSString stringWithFormat:@"%@%@%@%s", server, @"/api/core/v3/places/", _testProjectID, "/tasks?sort=titleAsc"];
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:tasksForPlaceAPIURL];
    
    NSArray* returnedtTasksListFromAPI = [jsonResponseFromAPI objectForKey:@"list"];
    
    
    //verify the number returned rows between API and SDK
    STAssertEquals([returnedTasksFromSDK count], [returnedtTasksListFromAPI count], @"The number returned rows of SDK and API are not matched.  SDK = %i and API = %i", [returnedTasksFromSDK count], [returnedtTasksListFromAPI count]);
    
    NSUInteger i = 0;
    
    for (JiveTask* aTaskFromSDK in returnedTasksFromSDK ) {
        
        id taskFromAPI = [returnedtTasksListFromAPI objectAtIndex:i];
        
        NSString* aTaskSubjectFromAPI = [JVUtilities get_Project_task_subject:taskFromAPI];
        
        STAssertEqualObjects( aTaskFromSDK.subject, aTaskSubjectFromAPI , @"Expecting same results from SDK and v3 API for recent places for this user, sdk = '%@' , api = '%@' !",   aTaskFromSDK.subject, aTaskSubjectFromAPI);
 
        i++;
    }
}

- (void)testCreateTaskInPlace {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"subject"];
    
    // Create a task
    JiveTask *newTask = [[JiveTask alloc] init];
    NSString *subject = [NSString stringWithFormat:@"task-%d", (arc4random() % 1500000)];
    newTask.subject = subject;
    newTask.dueDate = [NSDate date];
    
    __block JiveTask *returnedTask = nil;
    waitForTimeout(^(dispatch_block_t finishBlock1)   {
        [jive1 createTask:newTask forPlace:_testProject withOptions:options onComplete:^(JiveTask *task) {
            returnedTask = task;
            finishBlock1();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock1();
        }];
    });
    
    //Verify task is created successfully
    JiveSortedRequestOptions *sortOptions = [[JiveSortedRequestOptions alloc] init];
    sortOptions.sort = JiveSortOrderTitleAsc;

    __block NSArray *returnedTasksFromSDK = nil;
    waitForTimeout(^(dispatch_block_t finishBlock0) {
        [jive1 tasksForPlace:_testProject options:sortOptions onComplete:^(NSArray *tasks) {
            returnedTasksFromSDK = tasks;
            finishBlock0();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock0();
        }];
    });
    
    BOOL found = FALSE;
    for (JiveTask* task in returnedTasksFromSDK) {
        if ([task isKindOfClass:[JiveTask class]]) {
            if ([task.subject isEqualToString:subject]) {
                STAssertEqualObjects(task.jiveId, returnedTask.jiveId, nil);
                found = true;
                NSLog(@"task subject=%@", task.subject);
            }
        }
    }
    
    STAssertTrue(found, @"Task was not created successfully.");
    
    if (returnedTask != nil) {
        waitForTimeout(^(dispatch_block_t finishBlock1)   {
            [jive1 deleteContent:returnedTask onComplete:^ {
                finishBlock1();
            } onError:^(NSError *error) {
                STFail([error localizedDescription]);
                finishBlock1();
            }];
        });
    }
}
@end
