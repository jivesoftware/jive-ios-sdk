//
//  JivePlacesRequestOptions.h
//  
//
//  Created by Orson Bushnell on 12/19/12.
//
//

#import "JivePlacePlacesRequestOptions.h"

@interface JivePlacesRequestOptions : JivePlacePlacesRequestOptions

@property (nonatomic, strong) NSArray *entityDescriptor; // one or more objectType,objectID pairs (this filter is likely only useful to those developing the Jive UI itself)

- (void)addEntityType:(NSString *)entityType descriptor:(NSString *)descriptor;

@end
