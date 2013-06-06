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
    NSString *legislatorsVote = [vote.voterDict valueForKey:legislator.bioguideId];
    
    SFCellData *cellData = [SFCellData new];
    cellData.cellIdentifier = @"SFRollCallVoteByLegislatorCell";
    cellData.cellStyle = UITableViewCellStyleSubtitle;

    cellData.textLabelString = vote.questionShort;
//    cellData.textLabelString = [NSString stringWithFormat:@"Voted '%@' on '%@'", legislatorsVote, vote.question];
    cellData.textLabelFont = [UIFont cellTextFont];
    cellData.textLabelColor = [UIColor primaryTextColor];
    cellData.textLabelNumberOfLines = 4;

    cellData.detailTextLabelString = vote.billId;
    cellData.detailTextLabelFont = [UIFont cellDetailTextFont];
    cellData.detailTextLabelColor = [UIColor secondaryTextColor];
    cellData.detailTextLabelNumberOfLines = 1;

    cellData.extraData = [NSMutableDictionary dictionary];
    SFOpticView *view = [[SFOpticView alloc] initWithFrame:CGRectZero];

    NSMutableAttributedString *voteDescription = [[NSMutableAttributedString alloc] initWithString:legislatorsVote attributes:@{NSForegroundColorAttributeName: [UIColor primaryTextColor], NSFontAttributeName: [UIFont cellPanelStrongTextFont]}];

    id forCount = vote.totals[@"Yea"]?: vote.totals[@"Guilty"];
    id againstCount = vote.totals[@"Nay"]?: vote.totals[@"Not Guilty"];
    NSMutableAttributedString *voteDetail = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", vote.result]];
    if (forCount && againstCount) {
        NSString *forLabel = vote.totals[@"Yea"] ? @"Yea" : @"Guilty";
        NSString *againstLabel = vote.totals[@"Nay"] ? @"Nay" : @"Not Guilty";
        NSAttributedString *resultDescription = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@": %@ \u2018%@\u2019 to %@ \u2018%@\u2019", forCount, forLabel, againstCount, againstLabel]];
        [voteDetail appendAttributedString:resultDescription];
    }
    [voteDescription appendAttributedString:voteDetail];

    view.textLabel.attributedText = voteDescription;
    [cellData.extraData setObject:@[view] forKey:@"opticViews"];
    cellData.extraHeight = SFOpticViewHeight + SFOpticViewMarginVertical;

    cellData.selectable = YES;

    return cellData;
}

@end
