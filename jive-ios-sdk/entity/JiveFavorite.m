//
//  JiveFavorite.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
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

#import "JiveFavorite.h"
#import "JiveTypedObject_internal.h"


struct JiveFavoriteAttributes const JiveFavoriteAttributes = {
    .favoriteObject = @"favoriteObject",
    .private = @"private",
};


@implementation JiveFavorite

@synthesize favoriteObject, private;

NSString * const JiveFavoriteType = @"favorite";

+ (void)load {
    if (self == [JiveFavorite class])
        [super registerClass:self forType:JiveFavoriteType];
}

- (NSString *)type {
    return JiveFavoriteType;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:private forKey:JiveFavoriteAttributes.private];
    if (favoriteObject)
        [dictionary setValue:[favoriteObject toJSONDictionary]
                  forKeyPath:JiveFavoriteAttributes.favoriteObject];
    
    return dictionary;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = [super persistentJSON];
    
    if (favoriteObject)
        [dictionary setValue:[favoriteObject persistentJSON]
                  forKeyPath:JiveFavoriteAttributes.favoriteObject];
    
    return dictionary;
}

- (BOOL)isPrivate {
    return [self.private boolValue];
}

+ (id)createFavoriteForContent:(JiveContent *)targetContent
                          name:(NSString *)name
                         notes:(NSString *)notes {
    JiveFavorite *favorite = [JiveFavorite new];
    JiveContentBody *body = [JiveContentBody new];
    JiveExternalURLEntity *urlEntity = [JiveExternalURLEntity new];
    
    urlEntity.url = targetContent.selfRef;
    body.type = @"text/html";
    body.text = notes ? notes : @"";
    favorite.subject = name;
    favorite.favoriteObject = urlEntity;
    favorite.content = body;
    
    return favorite;
}

- (NSString *)notes {
    return self.content.text;
}

- (void)setNotes:(NSString *)notes {
    self.content.text = notes;
}

@end
