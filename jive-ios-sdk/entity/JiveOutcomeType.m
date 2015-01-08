//
//  JiveOutcomeType.m
//  jive-ios-sdk
//
//  Created by Taylor Case on 4/4/13.
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

#import "JiveOutcomeType.h"

struct JiveOutcomeTypeAttributes const JiveOutcomeTypeAttributes = {
	.fields = @"fields",
	.jiveId = @"jiveId",
	.name = @"name",
	.communityAudience = @"communityAudience",
	.confirmExclusion = @"confirmExclusion",
	.confirmUnmark = @"confirmUnmark",
	.generalNote = @"generalNote",
	.noteRequired = @"noteRequired",
	.shareable = @"shareable",
	.urlAllowed = @"urlAllowed",
	.resources = @"resources"
};

@implementation JiveOutcomeType

@synthesize fields, jiveId, name, resources, communityAudience, confirmExclusion, confirmUnmark;
@synthesize generalNote, noteRequired, shareable, urlAllowed;

#pragma mark - JiveObject

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:jiveId forKey:@"id"];
    
    return dictionary;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super persistentJSON];
    
    [dictionary setValue:[fields copy] forKey:JiveOutcomeTypeAttributes.fields];
    [dictionary setValue:name forKey:JiveOutcomeTypeAttributes.name];
    [dictionary setValue:[resources copy] forKey:JiveOutcomeTypeAttributes.resources];
    [dictionary setValue:communityAudience forKey:JiveOutcomeTypeAttributes.communityAudience];
    [dictionary setValue:confirmExclusion forKey:JiveOutcomeTypeAttributes.confirmExclusion];
    [dictionary setValue:confirmUnmark forKey:JiveOutcomeTypeAttributes.confirmUnmark];
    [dictionary setValue:generalNote forKey:JiveOutcomeTypeAttributes.generalNote];
    [dictionary setValue:noteRequired forKey:JiveOutcomeTypeAttributes.noteRequired];
    [dictionary setValue:shareable forKey:JiveOutcomeTypeAttributes.shareable];
    [dictionary setValue:urlAllowed forKey:JiveOutcomeTypeAttributes.urlAllowed];
    
    return dictionary;
}

- (BOOL)canConfirmExclusion {
    return [self.confirmExclusion boolValue];
}

- (BOOL)canConfirmUnmark {
    return [self.confirmUnmark boolValue];
}

- (BOOL)isGeneralNote {
    return [self.generalNote boolValue];
}

- (BOOL)isNoteRequired {
    return [self.noteRequired boolValue];
}

- (BOOL)isShareable {
    return [self.shareable boolValue];
}

- (BOOL)isUrlAllowed {
    return [self.urlAllowed boolValue];
}

@end
