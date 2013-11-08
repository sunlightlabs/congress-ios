//
//  SFRollCallVoteByLegislatorCellTransformer.m
//  Congress
//
//  Created by Daniel Cloud on 6/5/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFRollCallVoteByLegislatorCellTransformer.h"
#import "SFCellData.h"
#import "SFPanopticCell.h"
#import "SFOpticView.h"
#import "SFRollCallVote.h"
#import "SFLegislator.h"
#import "SFBill.h"
#import "SFBillIdTransformer.h"

@implementation SFRollCallVoteByLegislatorCellTransformer

+ (Class)transformedValueClass {
    return [SFCellData class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

- (id)transformedValue:(id)value {
    if (value == nil) return nil;
    if (![value isKindOfClass:[NSDictionary class]]) return nil;

    SFRollCallVote *vote = (SFRollCallVote *)[value valueForKey:@"vote"];
    SFLegislator *legislator = (SFLegislator *)[value valueForKey:@"legislator"];

    NSMutableString *legislatorsVoteDescription = [NSMutableString stringWithFormat:@"Voted %@", [vote.voterDict valueForKey:legislator.bioguideId]];
    NSMutableString *voteDetail = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@": %@", vote.result]];
    [legislatorsVoteDescription appendString:voteDetail];

    NSMutableString *voteMetaDescription = [NSMutableString string];
    NSString *billInfo;
    if ([vote.questionParts count] > 2) {
        billInfo = [vote.questionParts lastObject];
    }
    else if (vote.bill && vote.bill.shortTitle) {
        billInfo = vote.bill.shortTitle;
    }

    if (billInfo) {
        [voteMetaDescription appendString:[[NSValueTransformer valueTransformerForName:SFBillIdTransformerName] transformedValue:vote.billId]];
        [voteMetaDescription appendString:[NSString stringWithFormat:@" — %@", billInfo]];
    }
    else {
        [voteMetaDescription appendString:vote.question];
    }

    SFCellData *cellData = [SFCellData new];
    cellData.cellIdentifier = @"SFRollCallVoteByLegislatorCell";
    cellData.cellStyle = UITableViewCellStyleSubtitle;

    if (![voteMetaDescription isEqualToString:vote.question]) {
        cellData.decorativeHeaderLabelFont = [UIFont cellDetailTextFont];
        cellData.decorativeHeaderLabelColor = [UIColor secondaryTextColor];
        cellData.decorativeHeaderLabelString = voteMetaDescription;
    }

    cellData.textLabelString = vote.question;
    cellData.textLabelFont = [UIFont cellTextFont];
    cellData.textLabelColor = [UIColor primaryTextColor];
    cellData.textLabelNumberOfLines = 0;

    cellData.detailTextLabelFont = [UIFont cellPanelTextFont];
    cellData.detailTextLabelColor = [UIColor secondaryTextColor];
    cellData.detailTextLabelNumberOfLines = 3;
    cellData.detailTextLabelString = legislatorsVoteDescription;

    cellData.selectable = YES;

    return cellData;
}

@end
