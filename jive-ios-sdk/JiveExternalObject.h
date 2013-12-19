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

extern NSString * const JiveExternalType;

//! \class JiveExternalObject
//! No online docs yet.
@interface JiveExternalObject : JiveContent

//! Icon for the external service this comes from
@property(nonatomic, strong) NSURL* productIcon;

//! Name of the external service, e.g. "Twitter" or "Chatter"
@property(nonatomic, strong) NSString* productName;

@end
