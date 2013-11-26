//
//  SFLegislatorVotingRecordDataSource.h
//  Congress
//
//  Created by Daniel Cloud on 11/26/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFDataTableDataSource.h"

@class SFLegislator;

@interface SFLegislatorVotingRecordDataSource : SFDataTableDataSource

@property (nonatomic, strong) SFLegislator *legislator;

@end
