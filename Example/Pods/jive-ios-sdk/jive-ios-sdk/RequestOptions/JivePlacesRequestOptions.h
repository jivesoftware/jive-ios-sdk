//
//  JivePlacesRequestOptions.h
//  
//
//  Created by Orson Bushnell on 12/19/12.
//
//

#import "JivePlacePlacesRequestOptions.h"

//! \class JivePlacesRequestOptions
//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#getPlaces(List<String>,%20String,%20int,%20int,%20String)
@interface JivePlacesRequestOptions : JivePlacePlacesRequestOptions

//! one or more objectType,objectID pairs (this filter is likely only useful to those developing the Jive UI itself)
@property (nonatomic, strong) NSArray *entityDescriptor;

//! Helper method to add an objectType,objectID pair to the entity descriptors array.
- (void)addEntityType:(NSString *)entityType descriptor:(NSString *)descriptor;

@end
