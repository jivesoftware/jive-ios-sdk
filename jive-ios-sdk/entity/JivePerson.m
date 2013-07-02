//
//  JivePerson.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 10/29/12.
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

#import "JivePerson.h"
#import "JivePersonJive.h"
#import "JiveName.h"
#import "JiveAddress.h"
#import "JiveEmail.h"
#import "JivePhoneNumber.h"
#import "JiveTypedObject_internal.h"
#import "AFJSONRequestOperation.h"
#import "Jive_internal.h"
#import "JAPIRequestOperation.h"

struct JivePersonAttributes const JivePersonAttributes = {
	.addresses = @"addresses",
	.displayName = @"displayName",
	.emails = @"emails",
	.followerCount = @"followerCount",
	.followingCount = @"followingCount",
	.jiveId = @"jiveId",
	.jive = @"jive",
	.location = @"location",
	.name = @"name",
	.phoneNumbers = @"phoneNumbers",
	.photos = @"photos",
	.published = @"published",
	.status = @"status",
	.tags = @"tags",
	.thumbnailUrl = @"thumbnailUrl",
	.updated = @"updated"
};

struct JivePersonResourceAttributes {
    __unsafe_unretained NSString *activity;
    __unsafe_unretained NSString *avatar;
    __unsafe_unretained NSString *blog;
    __unsafe_unretained NSString *colleagues;
    __unsafe_unretained NSString *extprops;
    __unsafe_unretained NSString *followers;
    __unsafe_unretained NSString *following;
    __unsafe_unretained NSString *followingIn;
    __unsafe_unretained NSString *html;
    __unsafe_unretained NSString *images;
    __unsafe_unretained NSString *manager;
    __unsafe_unretained NSString *members;
    __unsafe_unretained NSString *reports;
    __unsafe_unretained NSString *streams;
    __unsafe_unretained NSString *tasks;
} const JivePersonResourceAttributes;

struct JivePersonResourceAttributes const JivePersonResourceAttributes = {
    .activity = @"activity",
    .avatar = @"avatar",
    .blog = @"blog",
    .colleagues = @"colleagues",
    .extprops = @"extprops",
    .followers = @"followers",
    .following = @"following",
    .followingIn = @"followingIn",
    .html = @"html",
    .images = @"images",
    .manager = @"manager",
    .members = @"members",
    .reports = @"reports",
    .streams = @"streams",
    .tasks = @"tasks"
};

@implementation JivePerson
@synthesize addresses, displayName, emails, followerCount, followingCount, jiveId, jive, location, name, phoneNumbers, photos, published, status, tags, thumbnailUrl, updated;

static NSString * const JivePersonType = @"person";

+ (void)load {
    if (self == [JivePerson class])
        [super registerClass:self forType:JivePersonType];
}

+ (id)instanceFromJSON:(NSDictionary *)JSON withJive:(Jive *)jive {
    JivePerson *newPerson = [JivePerson instanceFromJSON:JSON];
    
    newPerson.jiveInstance = jive;
    return newPerson;
}

- (NSString *)type {
    return JivePersonType;
}

- (Class) arrayMappingFor:(NSString*) propertyName {
    static NSDictionary *propertyClasses = nil;
    
    if (!propertyClasses)
        propertyClasses = [NSDictionary dictionaryWithObjectsAndKeys:
                           [JiveAddress class], JivePersonAttributes.addresses,
                           [JiveEmail class], JivePersonAttributes.emails,
                           [JivePhoneNumber class], JivePersonAttributes.phoneNumbers,
                           nil];
    
    return [propertyClasses objectForKey:propertyName];
}

#pragma mark - JiveObject

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:self.type forKey:@"type"];
    [dictionary setValue:self.jiveId forKey:@"id"];
    [dictionary setValue:self.location forKey:JivePersonAttributes.location];
    [dictionary setValue:self.status forKey:JivePersonAttributes.status];
    [self addArrayElements:addresses toJSONDictionary:dictionary forTag:JivePersonAttributes.addresses];
    [self addArrayElements:emails toJSONDictionary:dictionary forTag:JivePersonAttributes.emails];
    [self addArrayElements:phoneNumbers toJSONDictionary:dictionary
                    forTag:JivePersonAttributes.phoneNumbers];
    if (jive)
        [dictionary setValue:[jive toJSONDictionary] forKey:JivePersonAttributes.jive];
    
    if (name)
        [dictionary setValue:[name toJSONDictionary] forKey:JivePersonAttributes.name];
    
    if (tags)
        [dictionary setValue:[tags copy] forKey:JivePersonAttributes.tags];
    
    return dictionary;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super persistentJSON];
    
    [dictionary setValue:displayName forKey:JivePersonAttributes.displayName];
    
    return dictionary;
}

#pragma mark - Resource methods

- (NSURL *)avatarRef {
    return [self resourceForTag:JivePersonResourceAttributes.avatar].ref;
}

- (NSURL *)activityRef {
    return [self resourceForTag:JivePersonResourceAttributes.activity].ref;
}

- (NSURL *)blogRef {
    return [self resourceForTag:JivePersonResourceAttributes.blog].ref;
}

- (NSURL *)colleaguesRef {
    return [self resourceForTag:JivePersonResourceAttributes.colleagues].ref;
}

- (NSURL *)extPropsRef {
    return [self resourceForTag:JivePersonResourceAttributes.extprops].ref;
}

- (BOOL)canDeleteExtProps {
    return [self resourceHasDeleteForTag:JivePersonResourceAttributes.extprops];
}

- (BOOL)canAddExtProps {
    return [self resourceHasPostForTag:JivePersonResourceAttributes.extprops];
}

- (NSURL *)followersRef {
    return [self resourceForTag:JivePersonResourceAttributes.followers].ref;
}

- (NSURL *)followingRef {
    return [self resourceForTag:JivePersonResourceAttributes.following].ref;
}

- (NSURL *)followingInRef {
    return [self resourceForTag:JivePersonResourceAttributes.followingIn].ref;
}

- (NSURL *)htmlRef {
    return [self resourceForTag:JivePersonResourceAttributes.html].ref;
}

- (NSURL *)imagesRef {
    return [self resourceForTag:JivePersonResourceAttributes.images].ref;
}

- (NSURL *)managerRef {
    return [self resourceForTag:JivePersonResourceAttributes.manager].ref;
}

- (NSURL *)membersRef {
    return [self resourceForTag:JivePersonResourceAttributes.members].ref;
}

- (NSURL *)reportsRef {
    return [self resourceForTag:JivePersonResourceAttributes.reports].ref;
}

- (NSURL *)streamsRef {
    return [self resourceForTag:JivePersonResourceAttributes.streams].ref;
}

- (BOOL)canCreateNewStream {
    return [self resourceHasPostForTag:JivePersonResourceAttributes.streams];
}

- (NSURL *)tasksRef {
    return [self resourceForTag:JivePersonResourceAttributes.tasks].ref;
}

- (BOOL)canCreateNewTask {
    return [self resourceHasPostForTag:JivePersonResourceAttributes.tasks];
}

#pragma mark - Instance methods

- (void) refreshWithOptions:(JiveReturnFieldsRequestOptions *)options
                 onComplete:(JivePersonCompleteBlock)completeBlock
                    onError:(JiveErrorBlock)errorBlock {
    [[self refreshOperationWithOptions:options
                            onComplete:completeBlock
                               onError:errorBlock] start];
}

- (void) managerWithOptions:(JiveReturnFieldsRequestOptions *)options
                 onComplete:(JivePersonCompleteBlock)completeBlock
                    onError:(JiveErrorBlock)errorBlock {
    [[self managerOperationWithOptions:options
                            onComplete:completeBlock
                               onError:errorBlock] start];
}

- (void) deleteOnComplete:(JiveCompletedBlock)completeBlock
                  onError:(JiveErrorBlock)errorBlock {
    [[self deleteOperationOnComplete:completeBlock
                             onError:errorBlock] start];
}

- (void) avatarOnComplete:(JiveImageCompleteBlock)completeBlock
                  onError:(JiveErrorBlock)errorBlock {
    [[self avatarOperationOnComplete:completeBlock
                             onError:errorBlock] start];
}

- (void) updateOnComplete:(JivePersonCompleteBlock)completeBlock
                  onError:(JiveErrorBlock)errorBlock {
    [[self updateOperationOnComplete:completeBlock
                             onError:errorBlock] start];
}

- (void) follow:(JivePerson *)target
     onComplete:(JiveCompletedBlock)completeBlock
        onError:(JiveErrorBlock)errorBlock {
    [[self followOperation:target
                onComplete:completeBlock
                   onError:errorBlock] start];
}

- (void) activitiesWithOptions:(JiveDateLimitedRequestOptions *)options
                    onComplete:(JiveArrayCompleteBlock)completeBlock
                       onError:(JiveErrorBlock)errorBlock {
    [[self activitiesOperationWithOptions:options
                               onComplete:completeBlock
                                  onError:errorBlock] start];
}

- (void) colleguesWithOptions:(JivePagedRequestOptions *)options
                   onComplete:(JiveArrayCompleteBlock)completeBlock
                      onError:(JiveErrorBlock)errorBlock {
    [[self colleguesOperationWithOptions:options
                              onComplete:completeBlock
                                 onError:errorBlock] start];
}

- (void) followersWithOptions:(JivePagedRequestOptions *)options
                   onComplete:(JiveArrayCompleteBlock)completeBlock
                      onError:(JiveErrorBlock)errorBlock {
    [[self followersOperationWithOptions:options
                              onComplete:completeBlock
                                 onError:errorBlock] start];
}

- (void) reportsWithOptions:(JivePagedRequestOptions *)options
                 onComplete:(JiveArrayCompleteBlock)completeBlock
                    onError:(JiveErrorBlock)errorBlock {
    [[self reportsOperationWithOptions:options
                            onComplete:completeBlock
                               onError:errorBlock] start];
}

- (void) followingWithOptions:(JivePagedRequestOptions *)options
                   onComplete:(JiveArrayCompleteBlock)completeBlock
                      onError:(JiveErrorBlock)errorBlock {
    [[self followingOperationWithOptions:options
                              onComplete:completeBlock
                                 onError:errorBlock] start];
}

- (void) followingInWithOptions:(JiveReturnFieldsRequestOptions *)options
                     onComplete:(JiveArrayCompleteBlock)completeBlock
                        onError:(JiveErrorBlock)errorBlock {
    [[self followingInOperationWithOptions:options
                                onComplete:completeBlock
                                   onError:errorBlock] start];
}

- (void) updateFollowingIn:(NSArray *)followingInStreams
               withOptions:(JiveReturnFieldsRequestOptions *)options
                onComplete:(JiveArrayCompleteBlock)completeBlock
                   onError:(JiveErrorBlock)errorBlock {
    [[self updateFollowingInOperation:followingInStreams
                          withOptions:options
                           onComplete:completeBlock
                              onError:errorBlock] start];
}

- (void) streamsWithOptions:(JiveReturnFieldsRequestOptions *)options
                 onComplete:(JiveArrayCompleteBlock)completeBlock
                    onError:(JiveErrorBlock)errorBlock {
    [[self streamsOperationWithOptions:options
                            onComplete:completeBlock
                               onError:errorBlock] start];
}

- (void) tasksWithOptions:(JiveSortedRequestOptions *)options
               onComplete:(JiveArrayCompleteBlock)completeBlock
                  onError:(JiveErrorBlock)errorBlock {
    [[self tasksOperationWithOptions:options
                          onComplete:completeBlock
                             onError:errorBlock] start];
}

- (void) blogWithOptions:(JiveReturnFieldsRequestOptions *)options
              onComplete:(JiveBlogCompleteBlock)completeBlock
                 onError:(JiveErrorBlock)errorBlock {
    [[self blogOperationWithOptions:options
                         onComplete:completeBlock
                            onError:errorBlock] start];
}

- (void) createTask:(JiveTask *)task
        withOptions:(JiveReturnFieldsRequestOptions *)options
         onComplete:(JiveTaskCompleteBlock)completeBlock
            onError:(JiveErrorBlock)errorBlock {
    [[self createTaskOperation:task
                   withOptions:options
                    onComplete:completeBlock
                       onError:errorBlock] start];
}

- (AFJSONRequestOperation *) refreshOperationWithOptions:(JiveReturnFieldsRequestOptions *)options
                                              onComplete:(JivePersonCompleteBlock)completeBlock
                                                 onError:(JiveErrorBlock)errorBlock {
    NSURLRequest *request = [self.jiveInstance requestWithOptions:options
                                                      andTemplate:[self.selfRef path], nil];
    
    return [self updateJiveTypedObject:self
                           withRequest:request
                            onComplete:completeBlock
                               onError:errorBlock];
}

- (AFJSONRequestOperation *) managerOperationWithOptions:(JiveReturnFieldsRequestOptions *)options
                                              onComplete:(JivePersonCompleteBlock)completeBlock
                                                 onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *request = [self.jiveInstance requestWithOptions:options
                                                             andTemplate:[self.managerRef path], nil];
    
    return [Jive operationWithRequest:request
                           onComplete:completeBlock
                              onError:errorBlock
                      responseHandler:^id(id JSON) {
                          JivePerson *manager = [JivePerson instanceFromJSON:JSON];
                          
                          manager.jiveInstance = self.jiveInstance;
                          return manager;
                      }];
}

- (AFJSONRequestOperation *) deleteOperationOnComplete:(JiveCompletedBlock)completeBlock
                                               onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *request = [self.jiveInstance requestWithOptions:nil
                                                             andTemplate:[self.selfRef path], nil];
    
    [request setHTTPMethod:@"DELETE"];
    return [self emptyResponseOperationWithRequest:request
                                        onComplete:completeBlock
                                           onError:errorBlock];
}

- (AFImageRequestOperation *) avatarOperationOnComplete:(JiveImageCompleteBlock)completeBlock
                                                onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *mutableURLRequest = [self.jiveInstance requestWithOptions:nil
                                                                       andTemplate:[self.avatarRef path], nil];
    void (^heapCompleteBlock)(UIImage *) = [completeBlock copy];
    void (^heapErrorBlock)(NSError *) = [errorBlock copy];
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:mutableURLRequest
                                                                              imageProcessingBlock:NULL
                                                                                           success:(^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        if (heapCompleteBlock) {
            heapCompleteBlock(image);
        }
    })
                                                                                           failure:(^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        if (heapErrorBlock) {
            heapErrorBlock(error);
        }
    })];
    return operation;
}

- (AFJSONRequestOperation *) updateOperationOnComplete:(JivePersonCompleteBlock)completeBlock
                                               onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *request = [self.jiveInstance requestWithOptions:nil
                                                             andTemplate:[self.selfRef path], nil];
    NSData *body = [NSJSONSerialization dataWithJSONObject:self.toJSONDictionary
                                                   options:0
                                                     error:nil];
    
    [request setHTTPBody:body];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%i", [[request HTTPBody] length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"PUT"];
    return [self updateJiveTypedObject:self
                           withRequest:request
                            onComplete:completeBlock
                               onError:errorBlock];
}

- (AFJSONRequestOperation *) followOperation:(JivePerson *)target
                                  onComplete:(JiveCompletedBlock)completeBlock
                                     onError:(JiveErrorBlock)errorBlock {
    NSString *path = [[self.followingRef path] stringByAppendingPathComponent:target.jiveId];
    NSMutableURLRequest *request = [self.jiveInstance requestWithOptions:nil andTemplate:path, nil];
    
    [request setHTTPMethod:@"PUT"];
    return [self emptyResponseOperationWithRequest:request
                                        onComplete:completeBlock
                                           onError:errorBlock];
}

- (AFJSONRequestOperation *) activitiesOperationWithOptions:(JiveDateLimitedRequestOptions *)options
                                                 onComplete:(JiveArrayCompleteBlock)completeBlock
                                                    onError:(JiveErrorBlock)errorBlock {
    NSURLRequest *request = [self.jiveInstance requestWithOptions:options
                                                      andTemplate:[self.activityRef path], nil];
    
    return [self.jiveInstance listOperationForClass:[JiveActivity class]
                                            request:request
                                         onComplete:completeBlock
                                            onError:errorBlock];
}

- (AFJSONRequestOperation *) colleguesOperationWithOptions:(JivePagedRequestOptions *)options
                                                onComplete:(JiveArrayCompleteBlock)completeBlock
                                                   onError:(JiveErrorBlock)errorBlock {
    return [self peopleListOperation:self.colleaguesRef
                         withOptions:options
                          onComplete:completeBlock
                             onError:errorBlock];
}

- (AFJSONRequestOperation *) followersOperationWithOptions:(JivePagedRequestOptions *)options
                                                onComplete:(JiveArrayCompleteBlock)completeBlock
                                                   onError:(JiveErrorBlock)errorBlock {
    return [self peopleListOperation:self.followersRef
                         withOptions:options
                          onComplete:completeBlock
                             onError:errorBlock];
}

- (AFJSONRequestOperation *) reportsOperationWithOptions:(JivePagedRequestOptions *)options
                                              onComplete:(JiveArrayCompleteBlock)completeBlock
                                                 onError:(JiveErrorBlock)errorBlock {
    return [self peopleListOperation:self.reportsRef
                         withOptions:options
                          onComplete:completeBlock
                             onError:errorBlock];
}

- (AFJSONRequestOperation *) followingOperationWithOptions:(JivePagedRequestOptions *)options
                                                onComplete:(JiveArrayCompleteBlock)completeBlock
                                                   onError:(JiveErrorBlock)errorBlock {
    return [self peopleListOperation:self.followingRef
                         withOptions:options
                          onComplete:completeBlock
                             onError:errorBlock];
}

- (AFJSONRequestOperation *) followingInOperationWithOptions:(JiveReturnFieldsRequestOptions *)options
                                                  onComplete:(JiveArrayCompleteBlock)completeBlock
                                                     onError:(JiveErrorBlock)errorBlock {
    return [self streamsListOperation:self.followingInRef
                          withOptions:options
                           onComplete:completeBlock
                              onError:errorBlock];
}

- (AFJSONRequestOperation *)updateFollowingInOperation:(NSArray *)followingInStreams
                                           withOptions:(JiveReturnFieldsRequestOptions *)options
                                            onComplete:(JiveArrayCompleteBlock)completeBlock
                                               onError:(JiveErrorBlock)errorBlock {
    NSString *targetURIKeyPath = [NSString stringWithFormat:@"%@.%@.%@.%@",
                                  NSStringFromSelector(@selector(resources)),
                                  JiveResourceAttributes.selfKey,
                                  NSStringFromSelector(@selector(ref)),
                                  NSStringFromSelector(@selector(absoluteString))];
    NSArray *targetURIs = [followingInStreams count] ? [followingInStreams valueForKeyPath:targetURIKeyPath] : [NSArray array];
    NSMutableURLRequest *request = [self.jiveInstance requestWithOptions:options
                                                             andTemplate:[self.followingInRef path], nil];
    NSData *body = [NSJSONSerialization dataWithJSONObject:targetURIs options:0 error:nil];
    
    [request setHTTPBody:body];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%i", request.HTTPBody.length]
   forHTTPHeaderField:@"Content-Length"];
    return [self.jiveInstance listOperationForClass:[JiveStream class]
                                            request:request
                                         onComplete:completeBlock
                                            onError:errorBlock];
}

- (AFJSONRequestOperation *) streamsOperationWithOptions:(JiveReturnFieldsRequestOptions *)options
                                              onComplete:(JiveArrayCompleteBlock)completeBlock
                                                 onError:(JiveErrorBlock)errorBlock {
    return [self streamsListOperation:self.streamsRef
                          withOptions:options
                           onComplete:completeBlock
                              onError:errorBlock];
}

- (AFJSONRequestOperation *) tasksOperationWithOptions:(JiveSortedRequestOptions *)options
                                            onComplete:(JiveArrayCompleteBlock)completeBlock
                                               onError:(JiveErrorBlock)errorBlock {
    NSURLRequest *request = [self.jiveInstance requestWithOptions:options
                                                      andTemplate:[self.tasksRef path], nil];
    
    return [self.jiveInstance listOperationForClass:[JiveContent class]
                                            request:request
                                         onComplete:completeBlock
                                            onError:errorBlock];
}

- (AFJSONRequestOperation *) blogOperationWithOptions:(JiveReturnFieldsRequestOptions *)options
                                           onComplete:(JiveBlogCompleteBlock)completeBlock
                                              onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *request = [self.jiveInstance requestWithOptions:options
                                                             andTemplate:[self.blogRef path], nil];
    
    return [self entityOperationForClass:[JiveBlog class]
                                 request:request
                              onComplete:completeBlock
                                 onError:errorBlock];
}

- (AFJSONRequestOperation *) createTaskOperation:(JiveTask *)task
                                     withOptions:(JiveReturnFieldsRequestOptions *)options
                                      onComplete:(JiveTaskCompleteBlock)completeBlock
                                         onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *request = [self.jiveInstance requestWithJSONBody:task
                                                                  options:options
                                                              andTemplate:[self.tasksRef path], nil];
    
    [request setHTTPMethod:@"POST"];
    return [self updateJiveTypedObject:task
                           withRequest:request
                            onComplete:completeBlock
                               onError:errorBlock];
}

#pragma mark - helper methods

- (JAPIRequestOperation *)updateJiveTypedObject:(JiveTypedObject *)target
                                    withRequest:(NSURLRequest *)request
                                     onComplete:(void (^)(id))completeBlock
                                        onError:(JiveErrorBlock)errorBlock
{
    return [Jive operationWithRequest:request
                           onComplete:completeBlock
                              onError:errorBlock
                      responseHandler:^id(id JSON) {
                          if (![target.type isEqualToString:JSON[JiveTypedObjectAttributes.type]])
                              @throw [NSException exceptionWithName:@"Wrong class"
                                                             reason:@"The server returned a response with the wrong type"
                                                           userInfo:nil];
                          
                          [target deserialize:JSON];
                          return target;
                      }];
}

- (AFJSONRequestOperation *) peopleListOperation:(NSURL *)url
                                     withOptions:(JivePagedRequestOptions *)options
                                      onComplete:(JiveArrayCompleteBlock)completeBlock
                                         onError:(JiveErrorBlock)errorBlock {
    NSMutableURLRequest *request = [self.jiveInstance requestWithOptions:options
                                                             andTemplate:[url path], nil];
    
    return [Jive operationWithRequest:request
                           onComplete:completeBlock
                              onError:errorBlock
                      responseHandler:(^id(id JSON) {
        NSArray *people = [JivePerson instancesFromJSONList:[JSON objectForKey:@"list"]];
        
        for (JivePerson *person in people) {
            person.jiveInstance = self.jiveInstance;
        }
        
        return people;
    })];
}

- (AFJSONRequestOperation *) streamsListOperation:(NSURL *)url
                                      withOptions:(JiveReturnFieldsRequestOptions *)options
                                       onComplete:(JiveArrayCompleteBlock)completeBlock
                                          onError:(JiveErrorBlock)errorBlock {
    NSURLRequest *request = [self.jiveInstance requestWithOptions:options
                                                      andTemplate:[url path], nil];
    
    return [self.jiveInstance listOperationForClass:[JiveStream class]
                                            request:request
                                         onComplete:completeBlock
                                            onError:errorBlock];
}

- (JAPIRequestOperation *)entityOperationForClass:(Class)clazz
                                          request:(NSURLRequest *)request
                                       onComplete:(void (^)(id))completeBlock
                                          onError:(JiveErrorBlock)errorBlock
{
    return [Jive operationWithRequest:request
                           onComplete:completeBlock
                              onError:errorBlock
                      responseHandler:^id(id JSON) {
                          return [clazz instanceFromJSON:JSON];
                      }];
}

- (AFJSONRequestOperation *) emptyResponseOperationWithRequest:(NSURLRequest *)request
                                                    onComplete:(JiveCompletedBlock)completeBlock
                                                       onError:(JiveErrorBlock)errorBlock {
    void (^nilObjectComplete)(id) = !completeBlock ? nil : ^(id nilObject) {
        completeBlock();
    };
    
    return [Jive operationWithRequest:request
                           onComplete:nilObjectComplete
                              onError:errorBlock
                      responseHandler:^id(id JSON) {
                          return nil;
                      }];
}

@end
