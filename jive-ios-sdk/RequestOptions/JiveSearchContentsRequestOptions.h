//
//  JiveSearchContentsRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/4/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveSearchRequestOptions.h"

@interface JiveSearchContentsRequestOptions : JiveSearchRequestOptions

@property (nonatomic, strong) NSArray *types; // Select entries of the specified type. One or more types can be specified.
@property (nonatomic) BOOL subjectOnly;

- (void)addType:(NSString *)type;

@end
