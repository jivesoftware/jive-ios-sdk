//
//  JVUtilities.h
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

#import <Foundation/Foundation.h>

@interface JVUtilities : NSObject

//Person

#pragma mark - Person

+ (NSString*) get_Person_DisplayName: (id) returnedAPIDic;
+ (NSString*) get_Person_JiveId: (id) returnedAPIDic;
+ (NSString*) get_Person_giveName: (id) returnedAPIDic;
+ (NSString*) get_Person_familyName: (id) returnedAPIDic;
+ (NSString*) get_Person_formattedName: (id) returnedAPIDic;
+ (NSString*) get_Person_location: (id) returnedAPIDic;
+ (NSString*) get_Person_type: (id) returnedAPIDic;
+ (NSDate*) get_Person_published: (id) returnedAPIDic;
+ (NSArray*) get_Person_tags: (id) returnedAPIDic;
+ (NSNumber*) get_Person_followingCount: (id) returnedAPIDic;
+ (NSString*) get_Person_thurbnailUrl: (id) returnedAPIDic;
+ (NSDate*) get_Person_updated: (id) returnedAPIDic;
+ (NSNumber*) get_Person_followerCount: (id) returnedAPIDic;

//Content

#pragma mark - Content
+ (NSString*) get_Content_type: (id) returnAPIDic;
+ (NSString*) get_Content_subject: (id) returnAPIDic;
+ (NSNumber*) get_Content_replyCount:(id)returnAPIDic;
+ (NSString*) get_Content_JiveId: (id)returnAPIDic;
+ (NSString*) get_Content_parent: (id)returnAPIDic;
+ (NSNumber*) get_Content_likeCount: (id) returnedAPIDic;
+ (NSDate*) get_Content_published: (id) returnedAPIDic;
+ (NSString*) get_Content_status: (id)returnAPIDic;
+ (NSDate*) get_Content_updated: (id) returnedAPIDic;
+ (NSNumber*) get_Content_viewCount: (id) returnedAPIDic;

//Resources

#pragma mark - Resources

+ (NSString*) get_Resource_reports: (id) returnAPIDic;
+ (NSString*) get_Resource_manager: (id) returnAPIDic;
+ (NSString*) get_Resource_self: (id) returnAPIDic;
+ (NSString*) get_Resource_tasks: (id) returnAPIDic;
+ (NSString*) get_Resource_avatar: (id) returnAPIDic;
+ (NSString*) get_Resource_blog: (id) returnAPIDic;
+ (NSString*) get_Resource_colleagues: (id) returnAPIDic;
+ (NSString*) get_Resource_followers: (id) returnAPIDic;
+ (NSString*) get_Resource_following: (id) returnAPIDic;
+ (NSString*) get_Resource_images: (id) returnAPIDic;
+ (NSString*) get_Resource_streams: (id) returnAPIDic;
+ (NSString*) get_Resource_html: (id) returnAPIDic;
+ (NSString*) get_Resource_followingIn: (id) returnAPIDic;
+ (NSString*) get_Resource_activity: (id) returnAPIDic;
+ (NSString*) get_Resource_members: (id) returnAPIDic;
+ (NSString*) get_Resource_place: (id) returnedAPIDic;
+ (NSString*) get_Resource_contents: (id) returnedAPIDic;
+ (NSString*) get_Resource_categories: (id) returnedAPIDic;
+ (NSString*) get_Resource_announcements: (id) returnedAPIDic;

//Place

#pragma mark - Place

+ (NSString*) get_Place_parent: (id)returnedAPIDic;
+ (NSString*) get_Place_type: (id)returnedAPIDic;
+ (NSNumber*) get_Place_childCount: (id)returnedAPIDic;
+ (NSString*) get_Place_name: (id)returnedAPIDic;
+ (NSString*) get_Place_displayName: (id)returnedAPIDic;
+ (NSString*) get_Place_description: (id)returnedAPIDic;
+ (NSString*) get_Place_status: (id)returnedAPIDic;
+ (NSArray*) get_Place_contentTypes: (id)returnedAPIDic;
+ (NSDate*) get_Place_published: (id) returnedAPIDic;
+ (NSDate*) get_Place_updated :(id) returnedAPIDic;
+ (NSNumber*) get_Place_followerCount: (id)returnedAPIDic;
+ (NSString*) get_Place_id: (id)returnedAPIDic;
+ (NSString*) get_Place_ParentPlace_name: (id)returnedAPIDic;
+ (NSString*) get_Place_ParentPlace_id: (id)returnedAPIDic;
+ (NSString*) get_Place_ParentPlace_type: (id)returnedAPIDic;
+ (NSString*) get_Place_ParentPlace_uri: (id)returnedAPIDic;
+ (NSString*) get_Place_ParentPlace_html: (id)returnedAPIDic;
+ (bool) get_Place_ParentPlace_visibleToExternalContributors: (id)returnedAPIDic;
+ (NSNumber*) get_Place_viewCount: (id)returnedAPIDic;
+ (NSString*) get_Project_task_subject: (id)returnedAPIDic;

//Inbox

#pragma mark - Inbox

+ (NSString*) get_Inbox_object_id: (id)returnedAPIDic;
+ (NSString*) get_Inbox_object_displayName: (id)returnedAPIDic;
+ (NSString*) get_Inbox_object_objectType: (id)returnedAPIDic;
+ (NSString*) get_Inbox_object_summary: (id)returnedAPIDic;
+ (NSURL*) get_Inbox_object_url: (id)returnedAPIDic;
+ (NSDate*) get_Inbox_object_published: (id)returnedAPIDic;
+ (NSDate*) get_Inbox_object_updated: (id)returnedAPIDic;
+ (NSString*) get_Inbox_title: (id)returnedAPIDic;
+ (NSDate*) get_Inbox_updated: (id)returnedAPIDic;
+ (NSString*) get_Inbox_content: (id)returnedAPIDic;
+ (NSURL*) get_Inbox_url: (id)returnedAPIDic;
+ (NSDate*) get_Inbox_published: (id)returnedAPIDic;
+ (NSString*) get_Inbox_verb: (id)returnedAPIDic;
+ (NSString*) get_Inbox_actor_id: (id)returnedAPIDic;
+ (NSString*) get_Inbox_actor_displayName: (id)returnedAPIDic;
+ (NSString*) get_Inbox_actor_objectType: (id)returnedAPIDic;
+ (NSURL*) get_Inbox_actor_url: (id)returnedAPIDic;
+ (NSDate*) get_Inbox_actor_published: (id)returnedAPIDic;
+ (NSDate*) get_Inbox_actor_updated: (id)returnedAPIDic;
+ (NSURL*) get_Inbox_actor_image_url: (id)returnedAPIDic;
+ (NSString*) get_Inbox_jive_update: (id)returnedAPIDic;
+ (NSNumber*) get_Inbox_jive_read: (id)returnedAPIDic;
+ (NSString*) get_Inbox_jive_collection: (id)returnedAPIDic;
+ (NSDate*) get_Inbox_jive_collectionUpdated: (id)returnedAPIDic;
+ (NSString*) get_Inbox_provider_displayName: (id)returnedAPIDic;
+ (NSString*) get_Inbox_provider_objectType: (id)returnedAPIDic;
+ (NSString*) get_Inbox_provider_url: (id)returnedAPIDic;

//Activity

#pragma mark - Activity

+ (NSString*) get_Activity_actor_displayName: (id)returnedAPIDic;
+ (NSString*) get_Activity_title: (id)returnedAPIDic;
+ (NSNumber*) get_Activity_replyCount: (id)returnedAPIDic;
+ (NSNumber*) get_Activity_canComment: (id)returnedAPIDic;

//Stream

#pragma mark - Stream

+ (NSString*) get_Stream_name: (id)returnedAPIDic;

//Error

#pragma mark - Error

+ (long) get_Error_status: (id)returnedAPIDic;
+ (NSString*) get_Error_code: (id)returnedAPIDic;
+ (NSString*) get_Error_message: (id)returnedAPIDic;

+ (id) getAPIJsonResponse: (NSString *) userId pw: (NSString*) password URL:(NSString*)urlString;
@end
