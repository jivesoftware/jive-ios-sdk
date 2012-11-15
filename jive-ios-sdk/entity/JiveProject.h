//
//  JiveProject.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/15/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePlace.h"
#import "JivePerson.h"

@interface JiveProject : JivePlace

// Person that created this social group.
@property(nonatomic, readonly, strong) JivePerson* creator;

// Date by which this project must be completed.
@property(nonatomic, strong) NSDate* dueDate;

// Current status of this project with respect to its schedule. TODO - enumerate values
@property(nonatomic, readonly, copy) NSString* projectStatus;

// Date that this project was (or will be) started.
@property(nonatomic, strong) NSDate* startDate;

// Tags associated with this object. String[]
@property(nonatomic, strong) NSArray* tags;

@end
