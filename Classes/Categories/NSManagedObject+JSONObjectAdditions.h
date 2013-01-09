//
//  NSManagedObject+JSONObjectAdditions.h
//  Congress
//
//  Created by Daniel Cloud on 1/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (JSONObjectAdditions)

- (void)setValuesForKeysWithJSONDictionary:(NSDictionary *)keyedValues;

@end
