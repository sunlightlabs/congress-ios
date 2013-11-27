//
//  SFLegislatorVoteTableDataSource.h
//  Congress
//
//  Created by Daniel Cloud on 11/25/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFDataTableDataSource.h"

@class SFRollCallVote;

@interface SFLegislatorVoteTableDataSource : SFDataTableDataSource <SFCellDataSource>

@property (nonatomic, strong) SFRollCallVote *vote;

@end
