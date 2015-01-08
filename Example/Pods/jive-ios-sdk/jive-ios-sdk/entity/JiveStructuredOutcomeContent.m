//
//  JiveStructuredOutcomeContent.m
//  
//
//  Created by Orson Bushnell on 5/7/14.
//
//    Copyright 2014 Jive Software Inc.
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

#import "JiveStructuredOutcomeContent.h"
#import "JiveOutcomeType.h"
#import "JiveObject_internal.h"


struct JiveStructuredOutcomeContentAttributes const JiveStructuredOutcomeContentAttributes = {
    .outcomeCounts = @"outcomeCounts",
    .outcomeTypeNames = @"outcomeTypeNames",
    .outcomeTypes = @"outcomeTypes",
};


@implementation JiveStructuredOutcomeContent

@synthesize outcomeCounts, outcomeTypeNames, outcomeTypes;

- (Class) arrayMappingFor:(NSString*) propertyName {
    if ([propertyName isEqualToString:JiveStructuredOutcomeContentAttributes.outcomeTypes]) {
        return [JiveOutcomeType class];
    }
    
    return [super arrayMappingFor:propertyName];
}

- (NSDictionary *)parseDictionaryForProperty:(NSString *)property
                                    fromJSON:(id)JSON
                                fromInstance:(Jive *)jiveInstance {
    if ([property isEqualToString:JiveStructuredOutcomeContentAttributes.outcomeCounts]) {
        return JSON;
    }
    
    return [super parseDictionaryForProperty:property fromJSON:JSON fromInstance:jiveInstance];
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:outcomeTypeNames
                  forKey:JiveStructuredOutcomeContentAttributes.outcomeTypeNames];
    
    return dictionary;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = [super persistentJSON];
    
    [self addArrayElements:outcomeTypes
    toPersistentDictionary:dictionary
                    forTag:JiveStructuredOutcomeContentAttributes.outcomeTypes];
    [dictionary setValue:outcomeCounts forKey:JiveStructuredOutcomeContentAttributes.outcomeCounts];
    
    return dictionary;
}

@end
