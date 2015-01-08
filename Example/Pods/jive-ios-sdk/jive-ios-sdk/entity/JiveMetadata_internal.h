//
//  JiveMetadata_internal.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 8/15/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveMetadata.h"

@class Jive;

@interface JiveMetadata ()

@property (nonatomic, weak) Jive *instance;

- (id)initWithInstance:(Jive *)instance;

@end
