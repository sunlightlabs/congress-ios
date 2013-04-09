//
//  SFCellDataTransformers.m
//  Congress
//
//  Created by Daniel Cloud on 4/9/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCellDataTransformers.h"
#import "SFDefaultBillCellTransformer.h"

NSString * const SFDefaultBillCellTransformerName = @"SFDefaultBillCellTransformerName";
NSString * const SFBillSearchCellTransformerName = @"SFBillSearchCellTransformerName";
NSString * const SFDefaultLegislatorCellTransformerName = @"SFDefaultLegislatorCellTransformerName";
NSString * const SFDefaultVoteCellTransformerName = @"SFDefaultVoteCellTransformerName";

@implementation SFCellDataTransformers

+ (void)load
{
    [NSValueTransformer setValueTransformer:[SFDefaultBillCellTransformer new] forName:SFDefaultBillCellTransformerName];

}

@end
