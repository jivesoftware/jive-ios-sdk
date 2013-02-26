//
//  JiveAssociationTargetList.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 2/25/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JiveTypedObject.h"

@interface JiveAssociationTargetList : NSObject {
    NSMutableArray *targetURIs;
}

- (void) addAssociationTarget:(JiveTypedObject *)target;

@end
