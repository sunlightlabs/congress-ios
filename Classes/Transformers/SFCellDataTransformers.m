//
//  SFCellDataTransformers.m
//  Congress
//
//  Created by Daniel Cloud on 4/9/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCellDataTransformers.h"
#import "SFDefaultBillCellTransformer.h"
#import "SFDefaultLegislatorCellTransformer.h"
#import "SFLegislatorVoteCellTransformer.h"
#import "SFDefaultBillActionCellTransformer.h"
#import "SFDefaultRollCallVoteCellTransformer.h"

NSString * const SFDefaultBillCellTransformerName = @"SFDefaultBillCellTransformerName";
NSString * const SFBillSearchCellTransformerName = @"SFBillSearchCellTransformerName";
NSString * const SFDefaultLegislatorCellTransformerName = @"SFDefaultLegislatorCellTransformerName";
NSString * const SFLegislatorVoteCellTransformerName = @"SFLegislatorVoteCellTransformerName";
NSString * const SFDefaultBillActionCellTransformerName = @"SFDefaultBillActionCellTransformerName";
NSString * const SFDefaultRollCallVoteCellTransformerName = @"SFDefaultRollCallVoteCellTransformerName";


@implementation SFCellDataTransformers

+ (void)load
{
    [NSValueTransformer setValueTransformer:[SFDefaultBillCellTransformer new] forName:SFDefaultBillCellTransformerName];
    [NSValueTransformer setValueTransformer:[SFDefaultLegislatorCellTransformer new] forName:SFDefaultLegislatorCellTransformerName];
    [NSValueTransformer setValueTransformer:[SFLegislatorVoteCellTransformer new] forName:SFLegislatorVoteCellTransformerName];
    [NSValueTransformer setValueTransformer:[SFDefaultBillActionCellTransformer new] forName:SFDefaultBillActionCellTransformerName];
    [NSValueTransformer setValueTransformer:[SFDefaultRollCallVoteCellTransformer new] forName:SFDefaultRollCallVoteCellTransformerName];
}

@end
