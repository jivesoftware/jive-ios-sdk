//
//  JiveContentRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/3/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePlacesRequestOptions.h"

@interface JiveContentRequestOptions : JivePlacesRequestOptions

@property (nonatomic, strong) NSArray *authors; // one or more person URIs
@property (nonatomic, strong) NSURL *place; // place URI where the content lives

- (void)addAuthor:(NSURL *)url;

@end
