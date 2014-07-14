//
//  SFRollCallVoteByLegislatorCellTransformer.m
//  Congress
//
//  Created by Daniel Cloud on 6/5/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFRollCallVoteByLegislatorCellTransformer.h"
#import "SFCellData.h"
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

    NSMutableString *voteDescription = [NSMutableString string];
    if ([vote.questionParts count] > 2) {
        if (vote.billId) {
            [voteDescription appendString:[[NSValueTransformer valueTransformerForName:SFBillIdTransformerName] transformedValue:vote.billId]];
            [voteDescription appendString:@" — "];
        }
        NSString *questionLast = [[vote.questionParts lastObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [voteDescription appendString:questionLast];
    }
    else if (vote.bill && vote.bill.shortTitle) {
        [voteDescription appendString:vote.bill.shortTitle];
    }
    else {
        [voteDescription appendString:vote.question];
    }

    NSString *voteMetaDescription = vote.questionShort ? : vote.question;

    SFCellData *cellData = [SFCellData new];
    cellData.cellStyle = UITableViewCellStyleSubtitle;

    if (![vote.questionShort isEqualToString:vote.question]) {
        cellData.decorativeHeaderLabelString = voteMetaDescription;
    }

    cellData.textLabelString = voteDescription;
    cellData.textLabelNumberOfLines = 0;

    cellData.detailTextLabelNumberOfLines = 3;
    cellData.detailTextLabelString = legislatorsVoteDescription;

    cellData.selectable = YES;

    return cellData;
}

@end
