//
//  JVUtilities.m
//  jive-ios-sdk-tests
//
//  Created by Linh Tran on 1/30/13.
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

#import "JVUtilities.h"

@implementation JVUtilities


//Place
+ (NSString*) get_Place_parent: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"parent"] != nil)
    {
        return   [returnedAPIDic objectForKey:@"parent"];
    }
    
    return nil;
    
}

+ (NSString*) get_Place_type: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"type"] != nil)
    {
        return   [returnedAPIDic objectForKey:@"type"];
    }
    
    return nil;
    
}

+ (NSNumber*) get_Place_childCount: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"childCount"] != nil)
    {
        NSNumber* data = [NSNumber numberWithInt: [[returnedAPIDic objectForKey:@"childCount"] integerValue]];
        return data;
    }
    
    return nil;
    
}

+ (NSString*) get_Place_name: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"name"] != nil)
    {
        return   [returnedAPIDic objectForKey:@"name"];
    }
    
    return nil;
    
}


+ (NSString*) get_Place_displayName: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"displayName"] != nil)
    {
        return   [returnedAPIDic objectForKey:@"displayName"];
    }
    
    return nil;
    
}


+ (NSString*) get_Place_description: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"description"] != nil)
    {
        return   [returnedAPIDic objectForKey:@"description"];
    }
    
    return nil;
    
}


+ (NSString*) get_Place_status: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"status"] != nil)
    {
        return   [returnedAPIDic objectForKey:@"status"];
    }
    
    return nil;
    
}



+ (NSArray*) get_Place_contentTypes: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"contentTypes"] != nil)
    {
        return   [returnedAPIDic objectForKey:@"contentTypes"];
    }
    
    return nil;
    
}


+ (NSDate*) get_Place_published: (id) returnedAPIDic
{
    
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"published"] != nil)
    {
        NSString* dateAPI = [returnedAPIDic objectForKey:@"published"];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        return [dateFormat dateFromString:dateAPI];
    }
    
    return nil;
    
}

+ (NSDate*) get_Place_updated :(id) returnedAPIDic
{
    
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"updated"] != nil)
    {
        NSString* dateAPI = [returnedAPIDic objectForKey:@"updated"];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        return [dateFormat dateFromString:dateAPI];
    }
    
    return nil;
    
}

+ (NSNumber*) get_Place_followerCount: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"followerCount"] != nil)
    {
        NSNumber* data = [NSNumber numberWithInt: [[returnedAPIDic objectForKey:@"followerCount"] integerValue]];
        return data;
    }
    
    return nil;
    
}


+ (NSNumber*) get_Place_viewCount: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"viewCount"] != nil)
    {
        NSNumber* data = [NSNumber numberWithInt: [[returnedAPIDic objectForKey:@"viewCount"] integerValue]];
        return data;
    }
    
    return nil;
    
}


+ (NSString*) get_Place_id: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"id"] != nil)
    {
        return   [returnedAPIDic objectForKey:@"id"];
    }
    
    return nil;
    
}


+ (NSString*) get_Place_ParentPlace_name: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"parentPlace"] != nil && [[returnedAPIDic objectForKey:@"parentPlace"] valueForKey:@"name"] != nil)
    {
        return  [[returnedAPIDic objectForKey:@"parentPlace"] objectForKey:@"name"];
    }
    
    return nil;
    
}

+ (NSString*) get_Place_ParentPlace_id: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"parentPlace"] != nil && [[returnedAPIDic objectForKey:@"parentPlace"] valueForKey:@"id"] != nil)
    {
        return  [[returnedAPIDic objectForKey:@"parentPlace"] objectForKey:@"id"];
    }
    
    return nil;
    
}



+ (NSString*) get_Place_ParentPlace_type: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"parentPlace"] != nil && [[returnedAPIDic objectForKey:@"parentPlace"] valueForKey:@"type"] != nil)
    {
        return  [[returnedAPIDic objectForKey:@"parentPlace"] objectForKey:@"type"];
    }
    
    return nil;
    
}

+ (NSString*) get_Place_ParentPlace_uri: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"parentPlace"] != nil && [[returnedAPIDic objectForKey:@"parentPlace"] valueForKey:@"uri"] != nil)
    {
        return  [[returnedAPIDic objectForKey:@"parentPlace"] objectForKey:@"uri"];
    }
    
    return nil;
    
}


+ (NSString*) get_Place_ParentPlace_html: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"parentPlace"] != nil && [[returnedAPIDic objectForKey:@"parentPlace"] objectForKey:@"html"] != nil)
    {
        return  [[returnedAPIDic objectForKey:@"parentPlace"] objectForKey:@"html"];
    }
    
    return nil;
    
}


+ (bool) get_Place_ParentPlace_visibleToExternalContributors: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"visibleToExternalContributors"] != nil)    {
        
        bool data =  [[returnedAPIDic objectForKey:@"visibleToExternalContributors"] boolValue];
        return  data;
    }
    
    return false;
    
}

//Person

+ (NSString*) get_Person_DisplayName: (id) returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"displayName"] != nil)
    {
        return   [returnedAPIDic objectForKey:@"displayName"];
    }

    return nil;
    
}

+ (NSString*) get_Person_JiveId: (id) returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"id"] != nil)
    {
        return   [returnedAPIDic objectForKey:@"id"];
    }

    return nil;
}



+ (NSString*) get_Person_giveName: (id) returnedAPIDic
{
    
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"name"] != nil && [[returnedAPIDic objectForKey:@"name"] valueForKey:@"givenName"] != nil)
    {
        return   [[returnedAPIDic objectForKey:@"name"] objectForKey:@"givenName"];
    }

    return nil;
}


+ (NSString*) get_Person_familyName: (id) returnedAPIDic
{

    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"name"] != nil && [[returnedAPIDic objectForKey:@"name"] valueForKey:@"familyName"] != nil)
    {
        return   [[returnedAPIDic objectForKey:@"name"] objectForKey:@"familyName"];
    }

    return nil;
    
}


+ (NSString*) get_Person_formattedName: (id) returnedAPIDic
{

    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"name"] != nil && [[returnedAPIDic objectForKey:@"name"] valueForKey:@"formatted"] != nil)
    {
        return   [[returnedAPIDic objectForKey:@"name"] objectForKey:@"formatted"];
    }

    return nil;
    
}



+ (NSString*) get_Person_location: (id) returnedAPIDic
{

    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"location"] != nil)
    {
        return   [returnedAPIDic  objectForKey:@"location"];
    }

    return nil;
    
}

+ (NSString*) get_Person_type: (id) returnedAPIDic
{

    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"type"] != nil)
    {
        return   [returnedAPIDic objectForKey:@"type"];
    }

    return nil;
    
}

+ (NSDate*) get_Person_published: (id) returnedAPIDic
{
    
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"published"] != nil)
    {
        NSString* dateAPI = [returnedAPIDic objectForKey:@"published"];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        return [dateFormat dateFromString:dateAPI];
    }

    return nil;

}

+ (NSArray*) get_Person_tags: (id) returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"tags"] != nil)
    {
        return   [returnedAPIDic objectForKey:@"tags"];
    }
    return nil;

    
}

+ (NSNumber*) get_Person_followingCount: (id) returnedAPIDic
{
    
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"followingCount"] != nil)
    {
        NSNumber* data = [NSNumber numberWithInt: [[returnedAPIDic objectForKey:@"followingCount"] integerValue]];
        return data;
    }
    return nil;


}

+ (NSString*) get_Person_thurbnailUrl: (id) returnedAPIDic
{

    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"thumbnailUrl"] != nil)
    {
        return   [returnedAPIDic objectForKey:@"thumbnailUrl"];
    }
    return nil;
    
}

+ (NSDate*) get_Person_updated: (id) returnedAPIDic
{
    
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"updated"] != nil)
    {
        NSString* dateAPI = [returnedAPIDic objectForKey:@"updated"];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        return [dateFormat dateFromString:dateAPI];
    }
    return nil;
    
}

+ (NSNumber*) get_Person_followerCount: (id) returnedAPIDic
{

    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"followerCount"] != nil)
    {
        NSNumber* data = [NSNumber numberWithInt:[ [returnedAPIDic objectForKey:@"followerCount"] integerValue]];
        return   data;
    }
    return nil;
    
}



//Content
+ (NSString*) get_Content_type: (id) returnedAPIDic
{
    
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"type"] != nil)
    {
        return   [returnedAPIDic objectForKey:@"type"];
    }
    return nil;
}

+ (NSString*) get_Content_subject: (id) returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"subject"] != nil)
    {
        return   [returnedAPIDic objectForKey:@"subject"];
    }
    return nil;
}


+ (NSNumber*) get_Content_replyCount:(id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"replyCount"] != nil)
    {
        NSNumber* data = [NSNumber numberWithInt:[ [returnedAPIDic objectForKey:@"replyCount"] integerValue]];
        return   data;
    }
    return nil;
    
}
+ (NSString*) get_Content_JiveId: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"id"] != nil)
    {
        return   [returnedAPIDic objectForKey:@"id"];
    }
    return nil;
}

+ (NSString*) get_Content_parent: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"parent"] != nil)
    {
        return   [returnedAPIDic objectForKey:@"parent"];
    }
    return nil;
    
}

+ (NSNumber*) get_Content_likeCount: (id) returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"likeCount"] != nil)
    {
        NSNumber* data = [NSNumber numberWithInt:[ [returnedAPIDic objectForKey:@"likeCount"] integerValue]];
        return   data;
    }
    return nil;
}

+ (NSDate*) get_Content_published: (id) returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"published"] != nil)
    {
        NSString* dateAPI = [returnedAPIDic objectForKey:@"published"];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        return [dateFormat dateFromString:dateAPI];
    }
    
    return nil;
}

+ (NSString*) get_Content_status: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"status"] != nil)
    {
        return   [returnedAPIDic objectForKey:@"status"];
    }
    return nil;
}

+ (NSDate*) get_Content_updated: (id) returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"updated"] != nil)
    {
        NSString* dateAPI = [returnedAPIDic objectForKey:@"updated"];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        return [dateFormat dateFromString:dateAPI];
    }
    
    return nil;
    
}
+ (NSNumber*) get_Content_viewCount: (id) returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"viewCount"] != nil)
    {
        NSNumber* data = [NSNumber numberWithInt:[ [returnedAPIDic objectForKey:@"viewCount"] integerValue]];
        return   data;
    }
    return nil;
    
}

//Resources

+ (NSString*) get_Resource_reports: (id) returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"resources"] != nil && [[returnedAPIDic objectForKey:@"resources"] valueForKey:@"reports"] != nil &&
        [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"reports"] valueForKey:@"ref"] != nil)
    {
        return  [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"reports"] objectForKey:@"ref"];
    }
    
    return nil;

}

+ (NSString*) get_Resource_manager: (id) returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"resources"] != nil && [[returnedAPIDic objectForKey:@"resources"] valueForKey:@"manager"] != nil &&
        [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"manager"] valueForKey:@"ref"] != nil)
    {
        return  [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"manager"] objectForKey:@"ref"];
    }
    
    return nil;
}

+ (NSString*) get_Resource_self: (id) returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"resources"] != nil && [[returnedAPIDic objectForKey:@"resources"] valueForKey:@"self"] != nil &&
        [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"self"] valueForKey:@"ref"] != nil)
    {
        return  [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"self"] objectForKey:@"ref"];
    }
    
    return nil;
}
+ (NSString*) get_Resource_tasks: (id) returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"resources"] != nil && [[returnedAPIDic objectForKey:@"resources"] valueForKey:@"tasks"] != nil &&
        [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"tasks"] valueForKey:@"ref"] != nil)
    {
        return  [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"tasks"] objectForKey:@"ref"];
    }
    
    return nil;
}
+ (NSString*) get_Resource_avatar: (id) returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"resources"] != nil && [[returnedAPIDic objectForKey:@"resources"] valueForKey:@"avatar"] != nil &&
        [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"avatar"] valueForKey:@"ref"] != nil)
    {
        return  [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"avatar"] objectForKey:@"ref"];
    }
    
    return nil;
}
+ (NSString*) get_Resource_blog: (id) returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"resources"] != nil && [[returnedAPIDic objectForKey:@"resources"] valueForKey:@"blog"] != nil &&
        [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"manager"] valueForKey:@"ref"] != nil)
    {
        return  [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"blog"] objectForKey:@"ref"];
    }
    
    return nil;
}

+ (NSString*) get_Resource_colleagues: (id) returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"resources"] != nil && [[returnedAPIDic objectForKey:@"resources"] valueForKey:@"colleagues"] != nil &&
        [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"colleagues"] valueForKey:@"ref"] != nil)
    {
        return  [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"colleagues"] objectForKey:@"ref"];
    }
    
    return nil;
}


+ (NSString*) get_Resource_followers: (id) returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"resources"] != nil && [[returnedAPIDic objectForKey:@"resources"] valueForKey:@"followers"] != nil &&
        [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"followers"] valueForKey:@"ref"] != nil)
    {
        return  [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"followers"] objectForKey:@"ref"];
    }
    
    return nil;
    
}

+ (NSString*) get_Resource_following: (id) returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"resources"] != nil && [[returnedAPIDic objectForKey:@"resources"] valueForKey:@"following"] != nil &&
        [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"following"] valueForKey:@"ref"] != nil)
    {
        return  [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"following"] objectForKey:@"ref"];
    }
    
    return nil;
   
}
+ (NSString*) get_Resource_images: (id) returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"resources"] != nil && [[returnedAPIDic objectForKey:@"resources"] valueForKey:@"images"] != nil &&
        [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"images"] valueForKey:@"ref"] != nil)
    {
        return  [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"images"] objectForKey:@"ref"];
    }
    
    return nil;
    
}
+ (NSString*) get_Resource_streams: (id) returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"resources"] != nil && [[returnedAPIDic objectForKey:@"resources"] valueForKey:@"streams"] != nil &&
        [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"streams"] valueForKey:@"ref"] != nil)
    {
        return  [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"streams"] objectForKey:@"ref"];
    }
    
    return nil;
}
+ (NSString*) get_Resource_html: (id) returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"resources"] != nil && [[returnedAPIDic objectForKey:@"resources"] valueForKey:@"html"] != nil &&
        [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"html"] valueForKey:@"ref"] != nil)
    {
        return  [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"html"] objectForKey:@"ref"];
    }
    
    return nil;
}
+ (NSString*) get_Resource_followingIn: (id) returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"resources"] != nil && [[returnedAPIDic objectForKey:@"resources"] valueForKey:@"followingIn"] != nil &&
        [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"followingIn"] valueForKey:@"ref"] != nil)
    {
        return  [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"followingIn"] objectForKey:@"ref"];
    }
    
    return nil;
}
+ (NSString*) get_Resource_activity: (id) returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"resources"] != nil && [[returnedAPIDic objectForKey:@"resources"] valueForKey:@"activity"] != nil &&
        [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"activity"] valueForKey:@"ref"] != nil)
    {
        return  [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"activity"] objectForKey:@"ref"];
    }
    
    return nil;
    
}
+ (NSString*) get_Resource_members: (id) returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"resources"] != nil && [[returnedAPIDic objectForKey:@"resources"] valueForKey:@"members"] != nil &&
        [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"members"] valueForKey:@"ref"] != nil)
    {
        return  [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"members"] objectForKey:@"ref"];
    }
    
    return nil;
    
}


+ (NSString*) get_Resource_place: (id) returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"resources"] != nil && [[returnedAPIDic objectForKey:@"resources"] valueForKey:@"places"] != nil &&
        [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"places"] valueForKey:@"ref"] != nil)
    {
        return  [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"places"] objectForKey:@"ref"];
    }
    
    return nil;
}
+ (NSString*) get_Resource_contents: (id) returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"resources"] != nil && [[returnedAPIDic objectForKey:@"resources"] valueForKey:@"categories"] != nil &&
        [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"categories"] valueForKey:@"ref"] != nil)
    {
        return  [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"categories"] objectForKey:@"ref"];
    }
    
    return nil;
}
+ (NSString*) get_Resource_categories: (id) returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"resources"] != nil && [[returnedAPIDic objectForKey:@"resources"] valueForKey:@"contents"] != nil &&
        [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"contents"] valueForKey:@"ref"] != nil)
    {
        return  [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"contents"] objectForKey:@"ref"];
    }
    
    return nil;
}
+ (NSString*) get_Resource_announcements: (id) returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"resources"] != nil && [[returnedAPIDic objectForKey:@"resources"] valueForKey:@"announcements"] != nil &&
        [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"announcements"] valueForKey:@"ref"] != nil)
    {
        return  [[[returnedAPIDic objectForKey:@"resources"] objectForKey:@"announcements"] objectForKey:@"ref"];
    }
    
    return nil;
    
}


+ (id) getAPIJsonResponse: (NSString *) userId pw: (NSString*) password URL:(NSString*)urlStr
{
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    
    NSData* data = [[NSString stringWithFormat:@"%@:%@", userId, password]
                    dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *authHeader = [NSString stringWithFormat:@"Basic %@", [data base64Encoding]];
    
    [mutableRequest addValue:authHeader forHTTPHeaderField:@"Authorization"];
    
    NSError *my_error;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:mutableRequest returningResponse:nil error:&my_error];
    
    if (my_error)
    {
        NSLog(@"%@ ", [my_error localizedDescription]);
        return nil;
        
    }
    
    // Handle cases where API call is to Jive, by removing "throw 'allowIllegalResourceCall is false.';"
    NSData* header = [@"throw 'allowIllegalResourceCall is false.'" dataUsingEncoding:NSUTF8StringEncoding];
    NSRange headerRange = [responseData rangeOfData:header options:0 range:NSMakeRange(0, header.length)];
    NSData *cleanData;
    if(headerRange.location != NSNotFound) {
        cleanData = [responseData subdataWithRange:NSMakeRange(headerRange.length+1, responseData.length - headerRange.length - 1)];
        
    }
    
    NSError* jsonParsingError = nil;
    id  return_json = [NSJSONSerialization JSONObjectWithData:cleanData options:0 error:&jsonParsingError];
    
    
    if(jsonParsingError) {
        NSLog(@"Error: %@", jsonParsingError);
        return nil;
    }
    
    
    return return_json;
    
    
    
}

/***************
    Inbox
 *************/


+ (NSString*) get_Inbox_title: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"title"] != nil)
    {
        return [returnedAPIDic objectForKey:@"title"];
    }
    
    return nil;
    
}
+ (NSDate*) get_Inbox_updated: (id)returnedAPIDic
{

    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic objectForKey:@"updated"] != nil)    {
        NSString* dateAPI = [[returnedAPIDic objectForKey:@"object"] objectForKey:@"updated"] ;
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        return [dateFormat dateFromString:dateAPI];
    }
    return nil;
    
}
+ (NSString*) get_Inbox_content: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"content"] != nil)
    {
        return [returnedAPIDic objectForKey:@"content"] ;
    }
    
    return nil;
}
+ (NSURL*) get_Inbox_url: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"url"] != nil)
    {
        NSURL *url = [[NSURL alloc] initWithString:[returnedAPIDic objectForKey:@"url"]];
        return url;
    }
    
    return nil;
}
+ (NSDate*) get_Inbox_published: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"published"] != nil)    {
        NSString* dateAPI = [[returnedAPIDic objectForKey:@"object"] objectForKey:@"published"] ;
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        return [dateFormat dateFromString:dateAPI];
    }
    return nil;
    
}
+ (NSString*) get_Inbox_verb: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"verb"] != nil)
    {
        return [returnedAPIDic objectForKey:@"verb"];
    }
    
    return nil;
}
+ (NSString*) get_Inbox_actor_id: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"actor"] != nil && [[returnedAPIDic objectForKey:@"actor"] valueForKey:@"id"] != nil)    {
        return  [[returnedAPIDic objectForKey:@"actor"] objectForKey:@"id"] ;
    }
    
    return nil;
}

+ (NSString*) get_Inbox_actor_displayName: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"actor"] != nil && [[returnedAPIDic objectForKey:@"actor"] valueForKey:@"displayName"] != nil)    {
        return  [[returnedAPIDic objectForKey:@"actor"] objectForKey:@"displayName"] ;
    }
    
    return nil;
}
+ (NSString*) get_Inbox_actor_objectType: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"actor"] != nil && [[returnedAPIDic objectForKey:@"actor"] valueForKey:@"objectType"] != nil)    {
        return  [[returnedAPIDic objectForKey:@"actor"] objectForKey:@"objectType"] ;
    }
    
    return nil;
}
+ (NSURL*) get_Inbox_actor_url: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"actor"] != nil && [[returnedAPIDic objectForKey:@"actor"] valueForKey:@"url"] != nil)    {
        return   [[NSURL alloc] initWithString:[[returnedAPIDic objectForKey:@"actor"] objectForKey:@"url"]]; 
    }
    
    return nil;
}
+ (NSDate*) get_Inbox_actor_published: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"actor"] != nil && [[returnedAPIDic objectForKey:@"actor"] valueForKey:@"published"] != nil)    {
        NSString* dateAPI = [[returnedAPIDic objectForKey:@"actor"] objectForKey:@"published"] ;
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        return [dateFormat dateFromString:dateAPI];
    }
    
    return nil;
}
+ (NSDate*) get_Inbox_actor_updated: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"actor"] != nil && [[returnedAPIDic objectForKey:@"actor"] valueForKey:@"updated"] != nil)    {
        NSString* dateAPI = [[returnedAPIDic objectForKey:@"actor"] objectForKey:@"updated"] ;
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        return [dateFormat dateFromString:dateAPI];
    }
    
    return nil;
}
+ (NSURL*) get_Inbox_actor_image_url: (id)returnedAPIDic;
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"actor"] != nil && [[returnedAPIDic objectForKey:@"actor"] valueForKey:@"image"] != nil &&
         [[[returnedAPIDic objectForKey:@"actor"] objectForKey:@"image"] valueForKey:@"url"]  != nil )  {
        NSString* temp=   [[[returnedAPIDic objectForKey:@"actor"] objectForKey:@"image"] valueForKey:@"url"];
        NSURL *url = [[NSURL alloc] initWithString:temp];
        return  url;
    }
    
    return nil;
    
}

+ (NSString*) get_Inbox_jive_update: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"jive"] != nil && [[returnedAPIDic objectForKey:@"jive"] valueForKey:@"update"] != nil)    {
       return [[returnedAPIDic objectForKey:@"jive"] objectForKey:@"update"] ;
    }
    
    return nil;
}
+ (NSNumber*) get_Inbox_jive_read: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"jive"] != nil && [[returnedAPIDic objectForKey:@"jive"] valueForKey:@"read"] != nil)
    {
        
        NSString* temp = [[returnedAPIDic objectForKey:@"jive"] valueForKey:@"read"];
        BOOL boolVal = [temp boolValue];

        return [NSNumber numberWithBool: boolVal];
    }
    
    return nil;
    
}
+ (NSString*) get_Inbox_jive_collection: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"jive"] != nil && [[returnedAPIDic objectForKey:@"jive"] valueForKey:@"collection"] != nil)    {
        return [[returnedAPIDic objectForKey:@"jive"] objectForKey:@"collection"] ;
    }
    
    return nil;
    
}
+ (NSDate*) get_Inbox_jive_collectionUpdated: (id)returnedAPIDic;
{
    {
        if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"jive"] != nil && [[returnedAPIDic objectForKey:@"jive"] valueForKey:@"collectionUpdated"] != nil )
        {
            NSString* dateAPI = [[returnedAPIDic objectForKey:@"jive"] objectForKey:@"collectionUpdated"] ;
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
            [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            
            return [dateFormat dateFromString:dateAPI];
        }
        
        return nil;
        
    }
    
}


+ (NSString*) get_Inbox_provider_displayName: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"provider"] != nil && [[returnedAPIDic objectForKey:@"provider"] valueForKey:@"displayName"] != nil)    {
        return [[returnedAPIDic objectForKey:@"provider"] objectForKey:@"displayName"] ;
    }
    
    return nil;
}
+ (NSString*) get_Inbox_provider_objectType: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"provider"] != nil && [[returnedAPIDic objectForKey:@"provider"] valueForKey:@"displayName"] != nil)    {
        return [[returnedAPIDic objectForKey:@"provider"] objectForKey:@"displayName"] ;
    }
    
    return nil;
    
}
+ (NSURL*) get_Inbox_provider_url: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"provider"] != nil && [[returnedAPIDic objectForKey:@"provider"] valueForKey:@"url"] != nil)    {
        return [[NSURL alloc] initWithString:[[returnedAPIDic objectForKey:@"provider"] objectForKey:@"objectType"]];
    }
    
    return nil;
    
}

+ (NSString*) get_Inbox_object_id: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"object"] != nil && [[returnedAPIDic objectForKey:@"object"] valueForKey:@"id"] != nil)    {
        return  [[returnedAPIDic objectForKey:@"object"] objectForKey:@"id"] ;
    }
    
    return nil;
    
}

+ (NSString*) get_Inbox_object_displayName: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"object"] != nil && [[returnedAPIDic objectForKey:@"object"] valueForKey:@"displayName"] != nil)    {
        return  [[returnedAPIDic objectForKey:@"object"] objectForKey:@"displayName"] ;
    }
    
    return nil;
    
}

+ (NSString*) get_Inbox_object_objectType: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"object"] != nil && [[returnedAPIDic objectForKey:@"object"] valueForKey:@"objectType"] != nil)    {
        return  [[returnedAPIDic objectForKey:@"object"] objectForKey:@"objectType"] ;
    }
    
    return nil;
    
}
+ (NSString*) get_Inbox_object_summary: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"object"] != nil && [[returnedAPIDic objectForKey:@"object"] valueForKey:@"summary"] != nil)    {
        return  [[returnedAPIDic objectForKey:@"object"] objectForKey:@"summary"] ;
    }
    
    return nil;
}
+ (NSURL*) get_Inbox_object_url: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"object"] != nil && [[returnedAPIDic objectForKey:@"object"] valueForKey:@"url"] != nil)    {
        NSString* temp = [[returnedAPIDic objectForKey:@"object"] objectForKey:@"url"] ;
        NSURL *url = [[NSURL alloc] initWithString:temp];
        return  url;
    }
    
    return nil;
    
}
+ (NSDate*) get_Inbox_object_published: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"object"] != nil && [[returnedAPIDic objectForKey:@"object"] valueForKey:@"published"] != nil)    {
        NSString* dateAPI = [[returnedAPIDic objectForKey:@"object"] objectForKey:@"published"] ;
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        return [dateFormat dateFromString:dateAPI];
    }
    
    return nil;
}
+ (NSDate*) get_Inbox_object_updated: (id)returnedAPIDic
{
    if ([returnedAPIDic isKindOfClass:[NSDictionary class]] && [returnedAPIDic valueForKey:@"object"] != nil && [[returnedAPIDic objectForKey:@"object"] valueForKey:@"updated"] != nil)    {
        NSString* dateAPI =[[returnedAPIDic objectForKey:@"object"] objectForKey:@"updated"] ;
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        return [dateFormat dateFromString:dateAPI];
    }
    
    return nil;
    
    
}


@end

