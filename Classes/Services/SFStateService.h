//
//  SFStateService.h
//  Congress
//
//  Created by Daniel Cloud on 12/12/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFStateService : NSObject
{
    NSDictionary *_states;
}

+ (id)sharedInstance;
- (NSString *)getStateNameForAbbrevation:(NSString *)abbreviation;
- (NSArray *)getStateNames;
- (NSDictionary *)getStates;

@end
