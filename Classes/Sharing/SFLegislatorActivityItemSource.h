//
//  SFLegislatorActivityItemSource.h
//  Congress
//
//  Created by Jeremy Carbaugh on 10/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFLegislator.h"
#import "SFTextActivityItemSource.h"

@interface SFLegislatorTextActivityItemSource : SFTextActivityItemSource

- (id)initWithLegislator:(SFLegislator *)legislator;

@end


@interface SFLegislatorURLActivityItemSource : NSObject <UIActivityItemSource>

@property (nonatomic, strong) SFLegislator *legislator;

- (id)initWithLegislator:(SFLegislator *)legislator;

@end
