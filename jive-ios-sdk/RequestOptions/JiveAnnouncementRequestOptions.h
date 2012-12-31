//
//  JiveAnnouncementRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/31/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePagedRequestOptions.h"

@interface JiveAnnouncementRequestOptions : JivePagedRequestOptions

@property (nonatomic) BOOL activeOnly; // Flag indicating whether only active system announcements should be returned.

@end
