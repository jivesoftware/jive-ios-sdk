//
//  JiveTask.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveContent.h"

@interface JiveTask : JiveContent

// Flag indicating that this task has been completed. This field is required during update operations.
@property(nonatomic, strong) NSNumber *completed;

// The date that this task is scheduled to be completed.
@property(nonatomic, strong) NSDate* dueDate;

// The parent task, if this is a sub-task.
@property(nonatomic, copy) NSString* parentTask;

// The sub-tasks of this task. String[]
@property(nonatomic, strong) NSArray* subTasks;

// Tags associated with this object.
@property(nonatomic, readonly, strong) NSArray* tags;

// Flag indicating that this content object is potentially visible to external contributors.
@property(nonatomic, strong) NSNumber *visibleToExternalContributors;


@end
