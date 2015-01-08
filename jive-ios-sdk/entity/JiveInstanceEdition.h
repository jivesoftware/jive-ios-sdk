//
//  JiveInstanceEdition.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 3/18/14.
//  Copyright (c) 2014 Jive Software. All rights reserved.
//

#import "JiveObject.h"

//! \class JiveInstanceEdition
//! Instance data
@interface JiveInstanceEdition : JiveObject

//! Instance type
@property (nonatomic, readonly) NSString *product;

//! Instance tier
@property (nonatomic, readonly) NSNumber *tier;

@end
