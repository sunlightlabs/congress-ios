//
//  SFCellDataTransformers.m
//  Congress
//
//  Created by Daniel Cloud on 4/9/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCellDataTransformers.h"
#import "SFDefaultBillCellTransformer.h"
#import "SFBillSearchCellTransformer.h"
#import "SFBillNoExtraDataCellTransformer.h"
#import "SFBillSponsorCellTransformer.h"
#import "SFDefaultLegislatorCellTransformer.h"
#import "SFLegislatorVoteCellTransformer.h"
#import "SFDefaultBillActionCellTransformer.h"
#import "SFDefaultRollCallVoteCellTransformer.h"
#import "SFBasicTextCellTransformer.h"
#import "SFRollCallVoteByLegislatorCellTransformer.h"
#import "SFDefaultCommitteeCellTransformer.h"
#import "SFCommitteeMemberCellTransformer.h"
#import "SFDefaultHearingCellTransformer.h"

NSString * const SFDefaultBillCellTransformerName = @"SFDefaultBillCellTransformerName";
NSString * const SFBillSearchCellTransformerName = @"SFBillSearchCellTransformerName";
NSString * const SFBillNoExtraDataCellTransformerName = @"SFBillNoExtraDataCellTransformerName";
NSString * const SFBillSponsorCellTransformerName = @"SFBillSponsorCellTransformerName";
NSString * const SFDefaultLegislatorCellTransformerName = @"SFDefaultLegislatorCellTransformerName";
NSString * const SFLegislatorVoteCellTransformerName = @"SFLegislatorVoteCellTransformerName";
NSString * const SFDefaultBillActionCellTransformerName = @"SFDefaultBillActionCellTransformerName";
NSString * const SFDefaultRollCallVoteCellTransformerName = @"SFDefaultRollCallVoteCellTransformerName";
NSString * const SFBasicTextCellTransformerName = @"SFBasicTextCellTransformerName";
NSString * const SFRollCallVoteByLegislatorCellTransformerName = @"SFRollCallVoteByLegislatorCellTransformerName";
NSString * const SFDefaultCommitteeCellTransformerName = @"SFDefaultCommitteeCellTransformerName";
NSString * const SFCommitteeMemberCellTransformerName = @"SFCommitteeMemberCellTransformerName";
NSString * const SFDefaultHearingCellTransformerName = @"SFDefaultHearingCellTransformerName";

@implementation SFCellDataTransformers

+ (void)load
{
    [NSValueTransformer setValueTransformer:[SFDefaultBillCellTransformer new] forName:SFDefaultBillCellTransformerName];
    [NSValueTransformer setValueTransformer:[SFBillSearchCellTransformer new] forName:SFBillSearchCellTransformerName];
    [NSValueTransformer setValueTransformer:[SFBillNoExtraDataCellTransformer new] forName:SFBillNoExtraDataCellTransformerName];
    [NSValueTransformer setValueTransformer:[SFBillSponsorCellTransformer new] forName:SFBillSponsorCellTransformerName];
    [NSValueTransformer setValueTransformer:[SFDefaultLegislatorCellTransformer new] forName:SFDefaultLegislatorCellTransformerName];
    [NSValueTransformer setValueTransformer:[SFLegislatorVoteCellTransformer new] forName:SFLegislatorVoteCellTransformerName];
    [NSValueTransformer setValueTransformer:[SFDefaultBillActionCellTransformer new] forName:SFDefaultBillActionCellTransformerName];
    [NSValueTransformer setValueTransformer:[SFDefaultRollCallVoteCellTransformer new] forName:SFDefaultRollCallVoteCellTransformerName];
    [NSValueTransformer setValueTransformer:[SFBasicTextCellTransformer new] forName:SFBasicTextCellTransformerName];
    [NSValueTransformer setValueTransformer:[SFRollCallVoteByLegislatorCellTransformer new] forName:SFRollCallVoteByLegislatorCellTransformerName];
    [NSValueTransformer setValueTransformer:[SFDefaultCommitteeCellTransformer new] forName:SFDefaultCommitteeCellTransformerName];
    [NSValueTransformer setValueTransformer:[SFCommitteeMemberCellTransformer new] forName:SFCommitteeMemberCellTransformerName];
    [NSValueTransformer setValueTransformer:[SFDefaultHearingCellTransformer new] forName:SFDefaultHearingCellTransformerName];
}

@end
