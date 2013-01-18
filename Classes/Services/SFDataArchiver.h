//
//  SFDataArchiver.h
//  Congress
//
//  Created by Daniel Cloud on 1/18/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFDataArchiver : NSObject
{
    id _saveObjects;
}

+(instancetype)initWithObjectsToSave:(NSArray *)objectsArray;
-(BOOL)save;
-(id)load;

@end
