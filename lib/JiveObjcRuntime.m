//
//  JiveObjcRuntime.m
//  jive-ios-sdk
//
//  Created by Heath Borders on 2/27/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveObjcRuntime.h"
#import <objc/runtime.h>

NSArray *JiveClassGetSubclasses(Class parentClass) {
    int numClasses = objc_getClassList(NULL, 0);
    Class *classes = NULL;
    
    classes = (Class *)malloc(sizeof(Class) * (unsigned long)numClasses);
    numClasses = objc_getClassList(classes, numClasses);
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSInteger i = 0; i < numClasses; i++)
    {
        Class superClass = classes[i];
        do
        {
            superClass = class_getSuperclass(superClass);
        } while(superClass && superClass != parentClass);
        
        if (superClass == nil)
        {
            continue;
        }
        
        [result addObject:classes[i]];
    }
    
    free(classes);
    
    return result;
}
