//
//  JiveAssociationsRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/7/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JivePagedRequestOptions.h"

@interface JiveAssociationsRequestOptions : JivePagedRequestOptions

@property (nonatomic, strong) NSArray *types; // Filter by object type(s) (document, group, etc.)

- (void)addType:(NSString *)newType;

// Internal method referenced by derived classes.
- (NSMutableArray *)buildFilter;

@end
