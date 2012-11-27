//
//  JiveReturnFieldsRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveReturnFieldsRequestOptions.h"

@implementation JiveReturnFieldsRequestOptions

@synthesize fields;

- (NSString *)toQueryString {
    
    if (!fields)
        return nil;
    
    return [NSString stringWithFormat:@"fields=%@", [fields componentsJoinedByString:@","]];
}

- (void)addField:(NSString *)newField {
    
    if (!fields)
        fields = [NSArray arrayWithObject:newField];
    else
        fields = [fields arrayByAddingObject:newField];
}

@end
