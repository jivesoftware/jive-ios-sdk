//
//  JiveTask.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
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

#import "JiveContent.h"


extern NSString * const JiveTaskType;


extern struct JiveTaskAttributes {
    __unsafe_unretained NSString *completed;
    __unsafe_unretained NSString *dueDate;
    __unsafe_unretained NSString *owner;
    __unsafe_unretained NSString *parentTask;
    __unsafe_unretained NSString *subTasks;
} const JiveTaskAttributes;


//! \class JiveTask
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/TaskEntity.html
@interface JiveTask : JiveContent

//! Flag indicating that this task has been completed. This field is required during update operations.
@property(nonatomic, strong) NSNumber *completed;

//! The date that this task is scheduled to be completed.
@property(nonatomic, strong) NSDate* dueDate;

//! The owner of this task. This is typically the person responsible for accomplishing the task. For personal tasks this can only be the user that created the task. If none was specified for project tasks then the user creating or updating the task will become the owner.
@property(nonatomic, copy) NSString *owner;

//! The parent task, if this is a sub-task.
@property(nonatomic, copy) NSString* parentTask;

//! The sub-tasks of this task. String[]
@property(nonatomic, strong) NSArray* subTasks;

@end
