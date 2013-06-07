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

    NSDictionary *legVoteTextAttributes = @{NSForegroundColorAttributeName: [UIColor primaryTextColor], NSFontAttributeName: [UIFont cellPanelStrongTextFont]};
    NSAttributedString *legislatorsVote = [[NSAttributedString alloc] initWithString:[vote.voterDict valueForKey:legislator.bioguideId] attributes:legVoteTextAttributes];
    NSDictionary *voteTextAttributes = @{NSForegroundColorAttributeName: [UIColor primaryTextColor], NSFontAttributeName: [UIFont cellPanelTextFont]};
    NSMutableAttributedString *voteDescription = [[NSMutableAttributedString alloc] initWithString:@"Voted " attributes:voteTextAttributes];
    [voteDescription appendAttributedString:legislatorsVote];
    
    NSMutableString *primaryDescription = [NSMutableString string];
    NSMutableString *secondaryDescription = [NSMutableString string];
    NSString *billInfo;
    if ([vote.questionParts count] > 2) {
        billInfo = [vote.questionParts lastObject];
    }
    else if (vote.bill && vote.bill.shortTitle) {
        billInfo = vote.bill.shortTitle;
    }

    if (billInfo) {
        [primaryDescription appendString:[[NSValueTransformer valueTransformerForName:SFBillIdTransformerName] transformedValue:vote.billId]];
        [primaryDescription appendString:[NSString stringWithFormat:@" — %@", billInfo]];
    }
    else {
        [primaryDescription appendString:vote.question];
    }
    
    if (vote.rollType) {
        [secondaryDescription appendString:vote.rollType];
    }


    SFCellData *cellData = [SFCellData new];
    cellData.cellIdentifier = @"SFRollCallVoteByLegislatorCell";
    cellData.cellStyle = UITableViewCellStyleSubtitle;


    cellData.textLabelString = primaryDescription;
    cellData.textLabelFont = [UIFont cellTextFont];
    cellData.textLabelColor = [UIColor primaryTextColor];
    cellData.textLabelNumberOfLines = 0;

    cellData.detailTextLabelString = secondaryDescription;
    cellData.detailTextLabelFont = [UIFont cellDetailTextFont];
    cellData.detailTextLabelColor = [UIColor secondaryTextColor];
    cellData.detailTextLabelNumberOfLines = 1;

    cellData.extraData = [NSMutableDictionary dictionary];
    SFOpticView *view = [[SFOpticView alloc] initWithFrame:CGRectZero];


    id forCount = vote.totals[@"Yea"]?: vote.totals[@"Guilty"];
    id againstCount = vote.totals[@"Nay"]?: vote.totals[@"Not Guilty"];
    NSMutableAttributedString *voteDetail = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", vote.result]];
    if (forCount && againstCount) {
        NSString *forLabel = vote.totals[@"Yea"] ? @"Yea" : @"Guilty";
        NSString *againstLabel = vote.totals[@"Nay"] ? @"Nay" : @"Not Guilty";
        NSAttributedString *resultDescription = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" with %@ \%@ to %@ %@", forCount, forLabel, againstCount, againstLabel]];
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
