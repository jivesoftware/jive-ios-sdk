//
//  JiveError.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 2/28/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JiveError : NSError

@property (nonatomic, readonly) NSNumber *jiveStatus;

- (id)initWithNSError:(NSError *)originalError withJSON:(NSDictionary *)json;

@end
