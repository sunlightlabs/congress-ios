//
//  SFCellDataTransformers.m
//  Congress
//
//  Created by Daniel Cloud on 4/9/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCellDataTransformers.h"

#import "SFDefaultBillActionCellTransformer.h"
#import "SFDefaultBillCellTransformer.h"
#import "SFBillNoExtraDataCellTransformer.h"
#import "SFDefaultCommitteeCellTransformer.h"
#import "SFDefaultHearingCellTransformer.h"
#import "SFDefaultLegislatorCellTransformer.h"
#import "SFDefaultRollCallVoteCellTransformer.h"

#import "SFBasicTextCellTransformer.h"
#import "SFBillSearchCellTransformer.h"
#import "SFBillSponsorCellTransformer.h"
#import "SFCommitteeHearingCellTransformer.h"
#import "SFCommitteeMemberCellTransformer.h"
#import "SFLegislatorVoteCellTransformer.h"
#import "SFRollCallVoteByLegislatorCellTransformer.h"

NSString *const SFDefaultBillActionCellTransformerName = @"SFDefaultBillActionCellTransformerName";
NSString *const SFDefaultBillCellTransformerName = @"SFDefaultBillCellTransformerName";
NSString * const SFBillNoExtraDataCellTransformerName = @"SFBillNoExtraDataCellTransformerName";
NSString *const SFDefaultCommitteeCellTransformerName = @"SFDefaultCommitteeCellTransformerName";
NSString *const SFDefaultHearingCellTransformerName = @"SFDefaultHearingCellTransformerName";
NSString *const SFDefaultLegislatorCellTransformerName = @"SFDefaultLegislatorCellTransformerName";
NSString *const SFDefaultRollCallVoteCellTransformerName = @"SFDefaultRollCallVoteCellTransformerName";

NSString *const SFBasicTextCellTransformerName = @"SFBasicTextCellTransformerName";
NSString *const SFBillSearchCellTransformerName = @"SFBillSearchCellTransformerName";
NSString *const SFBillSponsorCellTransformerName = @"SFBillSponsorCellTransformerName";
NSString *const SFCommitteeHearingCellTransformerName = @"SFCommitteeHearingCellTransformerName";
NSString *const SFCommitteeMemberCellTransformerName = @"SFCommitteeMemberCellTransformerName";
NSString *const SFLegislatorVoteCellTransformerName = @"SFLegislatorVoteCellTransformerName";
NSString *const SFRollCallVoteByLegislatorCellTransformerName = @"SFRollCallVoteByLegislatorCellTransformerName";

@implementation SFCellDataTransformers

+ (void)load {
    [NSValueTransformer setValueTransformer:[SFDefaultBillActionCellTransformer new] forName:SFDefaultBillActionCellTransformerName];
    [NSValueTransformer setValueTransformer:[SFDefaultBillCellTransformer new] forName:SFDefaultBillCellTransformerName];
    [NSValueTransformer setValueTransformer:[SFBillNoExtraDataCellTransformer new] forName:SFBillNoExtraDataCellTransformerName];
    [NSValueTransformer setValueTransformer:[SFDefaultCommitteeCellTransformer new] forName:SFDefaultCommitteeCellTransformerName];
    [NSValueTransformer setValueTransformer:[SFDefaultHearingCellTransformer new] forName:SFDefaultHearingCellTransformerName];
    [NSValueTransformer setValueTransformer:[SFDefaultLegislatorCellTransformer new] forName:SFDefaultLegislatorCellTransformerName];
    [NSValueTransformer setValueTransformer:[SFDefaultRollCallVoteCellTransformer new] forName:SFDefaultRollCallVoteCellTransformerName];

    [NSValueTransformer setValueTransformer:[SFBasicTextCellTransformer new] forName:SFBasicTextCellTransformerName];
    [NSValueTransformer setValueTransformer:[SFBillSearchCellTransformer new] forName:SFBillSearchCellTransformerName];
    [NSValueTransformer setValueTransformer:[SFBillSponsorCellTransformer new] forName:SFBillSponsorCellTransformerName];
    [NSValueTransformer setValueTransformer:[SFCommitteeHearingCellTransformer new] forName:SFCommitteeHearingCellTransformerName];
    [NSValueTransformer setValueTransformer:[SFCommitteeMemberCellTransformer new] forName:SFCommitteeMemberCellTransformerName];
    [NSValueTransformer setValueTransformer:[SFLegislatorVoteCellTransformer new] forName:SFLegislatorVoteCellTransformerName];
    [NSValueTransformer setValueTransformer:[SFRollCallVoteByLegislatorCellTransformer new] forName:SFRollCallVoteByLegislatorCellTransformerName];
}

@end
