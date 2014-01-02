//
//  JiveExternalObject.h
//  Pods
//
//  Created by Janeen Neri on 12/18/13.
//
//    Copyright 2013 Jive Software Inc.
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.
//

#import "JiveContent.h"
#import "JiveActivityObject.h"

extern struct JiveExternalObjectAttributes {
    __unsafe_unretained NSString *object;
    __unsafe_unretained NSString *productIcon;
    __unsafe_unretained NSString *productName;
} const JiveExternalObjectAttributes;

extern NSString * const JiveExternalType;

//! \class JiveExternalObject
//! No online docs yet.
@interface JiveExternalObject : JiveContent

//! Contains some information about the originating object
@property(nonatomic, readonly, strong) JiveActivityObject* object;

//! Icon for the external service this comes from
@property(nonatomic, readonly, strong) NSURL* productIcon;

//! Name of the external service, e.g. "Twitter" or "Chatter"
@property(nonatomic, readonly, strong) NSString* productName;

@end
