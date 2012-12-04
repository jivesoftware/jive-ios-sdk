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

- (void)addType:(NSString *)type;

@end
