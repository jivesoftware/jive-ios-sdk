//
//  JVPersonCell.m
//  Example
//
//  Created by Orson Bushnell on 7/19/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JVPersonCell.h"
#import <Jive/Jive.h>

@interface JVPersonCell ()

@property (nonatomic, weak) IBOutlet UIImageView *avatar;
@property (nonatomic, weak) IBOutlet UILabel *name;

@end

@implementation JVPersonCell

- (void)setPerson:(JivePerson *)person {
    if (_person != person) {
        static NSMutableDictionary *avatarCache = nil;
        
        if (!avatarCache) {
            avatarCache = [NSMutableDictionary dictionary];
        }
        
        NSURL *avatarRef = person.avatarRef;
        UIImage *storedAvatarImage = avatarCache[avatarRef];
        
        _person = person;
        self.name.text = person.displayName;
        self.avatar.image = storedAvatarImage;
        if (!storedAvatarImage) {
            [person avatarOnComplete:^(UIImage *avatarImage) {
                avatarCache[avatarRef] = avatarImage;
                if (self.person.avatarRef == avatarRef) {
                    self.avatar.image = avatarImage;
                }
            } onError:nil];
        }
    }
}

@end
