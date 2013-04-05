//
//  JiveOutcomeRequestOptions.h
//  jive-ios-sdk
//
//  Created by Taylor Case on 4/5/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JivePagedRequestOptions.h"

@interface JiveOutcomeRequestOptions : JivePagedRequestOptions

//! Flag to indicate if child outcomes should be returned as well
@property (nonatomic) BOOL includeChildrenOutcomes;


@end
