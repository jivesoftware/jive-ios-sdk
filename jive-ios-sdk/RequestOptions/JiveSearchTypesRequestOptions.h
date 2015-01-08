//
//  JiveSearchTypesRequestOptions.h
//  
//
//  Created by Orson Bushnell on 12/4/12.
//
//

#import "JiveSearchRequestOptions.h"

//! \class JiveSearchTypesRequestOptions
@interface JiveSearchTypesRequestOptions : JiveSearchRequestOptions

//! Select entries of the specified type. One or more types can be specified.
@property (nonatomic, strong) NSArray *types;
//! Flag indicating that search results should be "collapsed" if they have the same parent
@property (nonatomic) BOOL collapse;

//! Helper method to simplify adding a type to the types array.
- (void)addType:(NSString *)type;

@end
