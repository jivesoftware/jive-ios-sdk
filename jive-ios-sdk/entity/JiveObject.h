//
//  JiveObject.h
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/24/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JiveObject : NSObject
+ (id) instanceFromJSON:(NSDictionary*) JSON;
+ (NSArray*) instancesFromJSONList:(NSArray*) JSON;

@property (readonly) BOOL extraFieldsDetected;

- (NSDictionary *) parseDictionaryForProperty:(NSString*)property fromJSON:(id)JSON;

- (id)toJSONDictionary;

@end
