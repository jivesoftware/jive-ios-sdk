//
//  JVJiveFactory.h
//  Example
//
//  Created by Orson Bushnell on 7/18/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Jive/Jive.h>

@interface JVJiveFactory : NSObject

+ (void)loginWithName:(NSString *)userName
             password:(NSString *)password
             complete:(JivePersonCompleteBlock)completeBlock
                error:(JiveErrorBlock)errorBlock;
+ (Jive *)jiveInstance;

@end
