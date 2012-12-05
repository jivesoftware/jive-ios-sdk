//
//  JiveSearchTypesRequestOptions.h
//  
//
//  Created by Orson Bushnell on 12/4/12.
//
//

#import "JiveSearchRequestOptions.h"

@interface JiveSearchTypesRequestOptions : JiveSearchRequestOptions

@property (nonatomic, strong) NSArray *types; // Select entries of the specified type. One or more types can be specified.
@property (nonatomic) BOOL collapse; // Flag indicating that search results should be "collapsed" if they have the same parent

- (void)addType:(NSString *)type;

@end
