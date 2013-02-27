//
//  JiveTypedObject.h
//  
//
//  Created by Orson Bushnell on 2/25/13.
//
//

#import "JiveObject.h"

//! \class JiveTypedObject
//! An iOS specific class with no REST api equivalent.
@interface JiveTypedObject : JiveObject

//! The object type of this object. This field is required when creating new content.
@property(nonatomic, readonly) NSString* type;

//! Resource links (and related permissions for the requesting object) relevant to this object.
@property(nonatomic, readonly, strong) NSDictionary* resources;

@end
