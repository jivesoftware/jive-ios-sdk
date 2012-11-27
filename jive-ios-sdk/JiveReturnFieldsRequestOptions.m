//
//  JiveReturnFieldsRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveReturnFieldsRequestOptions.h"

@implementation JiveReturnFieldsRequestOptions

@synthesize field;

- (NSString *)optionsInURLFormat
{
    return field ? [NSString stringWithFormat:@"fields=%@", [field componentsJoinedByString:@","]] : @"";
}

- (void)addField:(NSString *)newField
{
    if (!field)
        field = [NSArray arrayWithObject:newField];
    else
        field = [field arrayByAddingObject:newField];
}

@end
