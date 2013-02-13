//
//  JiveSearchParams.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/13/12.
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

#import "JiveSearchParams.h"

#import <objc/runtime.h>

@implementation JiveSearchParams

- (NSString *) facet {
    return nil;
}

- (NSString *) toQueryString {
    NSMutableArray* params = [[NSMutableArray alloc] init];
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char* propName = property_getName(property);
        if(propName) {
    		NSString *propertyName = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
            id value = [self valueForKey:propertyName];
            if (value) {
                [params addObject:[self encodeParam:propertyName withValue:value]];
            }
    	}
    }
    free(properties);
    
    return [params componentsJoinedByString:@"&"];
}


// a list of the properties in the params class which are filters
- (NSArray *)filterParams
{
    static NSArray *filters = nil;
    if (!filters) {
        filters = [[NSArray alloc] init];
    }
    return filters;
}

- (NSString*) urlEscapeString:(NSString *)unencodedString
{
    CFStringRef originalStringRef = (__bridge_retained CFStringRef)unencodedString;
    NSString *s = (__bridge_transfer NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, originalStringRef, NULL, NULL, kCFStringEncodingUTF8);
    CFRelease(originalStringRef);
    return s;
}

- (NSDateFormatter*) dateFormatter {
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter) {
        dateFormatter   = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    }
    return dateFormatter;
}


- (NSString*) encodeParam:(NSString*)property withValue:(id) value {
    Class cls = [self lookupPropertyClass:property];
    
    if(cls == [NSDate class]) {
        value = [[self dateFormatter] stringFromDate:(NSDate *)value];
    }
    
    if (cls == [NSArray class]) {
        value = [(NSArray*)value componentsJoinedByString:@","];
    }
    
    bool isFilter = [[self filterParams] indexOfObject:property] != NSNotFound;
    NSString *format = isFilter ? @"filter=%@(%@)" : @"%@=%@";
    
    return [NSString stringWithFormat:format, [self urlEscapeString:property], [self urlEscapeString:value]];
}



- (Class) lookupPropertyClass:(NSString*) propertyName {
    
    if(![propertyName isKindOfClass:[NSString class]])
        return nil;
    
    Ivar ivar = class_getInstanceVariable([self class], [propertyName cStringUsingEncoding:NSUTF8StringEncoding]);
    return [self lookupClassTypeFromIvar:ivar];
}

- (Class) lookupClassTypeFromIvar:(Ivar) ivar {
    
    if(!ivar) {
        return nil;
    }
    
    const char* typeCStr = ivar_getTypeEncoding(ivar);
    
    NSString* classType = [NSString stringWithCString:typeCStr encoding:NSUTF8StringEncoding];
    
    if([classType length] > 0 && [classType length] <= 3) {
        // Probably a primitive
        return nil;
    }
    
    // Clean up leading '@"' and trailing '"' that will make NSClassFromString fail
    classType = [classType substringWithRange:NSMakeRange(2, [classType length]-3)];
    
    return NSClassFromString(classType);
    
}
@end
