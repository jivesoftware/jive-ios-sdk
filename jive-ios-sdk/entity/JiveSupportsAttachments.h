//
//  JiveSupportsAttachments.h
//  jive-ios-sdk
//
//  Created by Matthew Finlayson on 1/15/15.
//  Copyright (c) 2015 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JiveSupportsAttachments <NSObject>
//! List of attachments to this message (if any). JiveAttachment[]
@property(nonatomic, strong) NSArray* attachments;
@end
