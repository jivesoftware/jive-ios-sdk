//
//  JiveTargetList_internal.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/15/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveTargetList.h"

@interface JiveTargetList (internal)

- (NSArray *)toJSONArray:(BOOL)restricted;

@end
