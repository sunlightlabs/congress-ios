//
//  SFCommitteeActivityItemSource.h
//  Congress
//
//  Created by Jeremy Carbaugh on 10/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFCommittee.h"
#import "SFTextActivityItemSource.h"

@interface SFCommitteeTextActivityItemSource : SFTextActivityItemSource

- (id)initWithCommittee:(SFCommittee *)committee;

@end


@interface SFCommitteeURLActivityItemSource : NSObject <UIActivityItemSource>

@property (nonatomic, retain) SFCommittee *committee;

- (id)initWithCommittee:(SFCommittee *)committee;

@end
