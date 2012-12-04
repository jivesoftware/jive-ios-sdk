//
//  JiveStateRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/3/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePagedRequestOptions.h"

@interface JiveStateRequestOptions : JivePagedRequestOptions

@property (nonatomic, strong) NSArray *states;

- (void)addState:(NSString *)state;

@end
