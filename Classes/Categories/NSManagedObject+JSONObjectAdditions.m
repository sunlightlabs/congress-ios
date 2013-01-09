//
//  NSManagedObject+JSONObjectAdditions.m
//  Congress
//
//  Created by Daniel Cloud on 1/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "NSManagedObject+JSONObjectAdditions.h"

@implementation NSManagedObject (JSONObjectAdditions)

- (void)setValuesForKeysWithJSONDictionary:(NSDictionary *)keyedValues
{
    NSMutableSet *updatingKeys = [NSMutableSet setWithArray:[keyedValues allKeys]];
    NSDictionary *objectAttributes = [[self entity] attributesByName];
    [updatingKeys intersectSet:[NSSet setWithArray:[objectAttributes allKeys]]];

    
    NSString *key;
    for (key in updatingKeys) {
        NSAttributeDescription *desc = [objectAttributes valueForKey:key];
        id value = [keyedValues valueForKey:key];
        if (value == nil || [value isEqual:[NSNull null]]) {
            continue;
        }
        int attributeType = [desc attributeType];
        if (attributeType == NSDateAttributeType) {
            [self setValue:[NSDate dateFromDateOnlyString:value] forKey:key];
        }
        else if ((attributeType == NSInteger16AttributeType) || (attributeType == NSInteger32AttributeType) || (attributeType == NSInteger64AttributeType) || (attributeType == NSBooleanAttributeType))
        {
            [self setValue:(NSNumber *)value forKey:key];
        }
        else if (attributeType == NSStringAttributeType)
        {
            [self setValue:(NSString *)value forKey:key];
        }
        else
        {
            [self setPrimitiveValue:value forKey:key];
        }
    }

    
}

@end
