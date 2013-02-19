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

//! \class JiveTask
//! https://developers.jivesoftware.com/api/v3/rest/TaskEntity.html
@interface JiveTask : JiveContent

//! Flag indicating that this task has been completed. This field is required during update operations.
@property(nonatomic, strong) NSNumber *completed;

//! The date that this task is scheduled to be completed.
@property(nonatomic, strong) NSDate* dueDate;

//! The parent task, if this is a sub-task.
@property(nonatomic, copy) NSString* parentTask;

//! The sub-tasks of this task. String[]
@property(nonatomic, strong) NSArray* subTasks;

//! Tags associated with this object.
@property(nonatomic, readonly, strong) NSArray* tags;

//! Flag indicating that this content object is potentially visible to external contributors.
@property(nonatomic, strong) NSNumber *visibleToExternalContributors;


@end
