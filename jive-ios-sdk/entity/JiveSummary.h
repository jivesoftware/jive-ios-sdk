//
//  JiveSummary.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveObject.h"

@interface JiveSummary : JiveObject

// The URI of the HTML representation of the summarized object.
@property(nonatomic, readonly, copy) NSString* html;

// The object ID of the summarized object.
@property(nonatomic, readonly, copy) NSString* jiveId;

// The name of the summarized object.
@property(nonatomic, readonly, copy) NSString* name;

// The type of the summarized object.
@property(nonatomic, readonly, copy) NSString* type;

// The URI of the JSON representation of the summarized object.
@property(nonatomic, readonly, copy) NSString* uri;

@end
