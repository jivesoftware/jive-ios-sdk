//
//  JiveContentRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/3/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePlacePlacesRequestOptions.h"

@interface JiveContentRequestOptions : JivePlacePlacesRequestOptions

@property (nonatomic, strong) NSArray *authors; // one or more person URIs
@property (nonatomic, strong) NSURL *place; // place URI where the content lives
@property (nonatomic, strong) NSArray *entityDescriptor; // one or more objectType,objectID pairs (this filter is likely only useful to those developing the Jive UI itself)

- (void)addAuthor:(NSURL *)url;
- (void)addEntityType:(NSString *)entityType descriptor:(NSString *)descriptor;

@end
