//
//  SFVoteCountTableDataSource.m
//  Congress
//
//  Created by Daniel Cloud on 11/26/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFVoteCountTableDataSource.h"
#import "SFValue1TableCell.h"
#import "SFRollCallVote.h"

@implementation SFVoteCountTableDataSource

@synthesize vote = _vote;

- (void)setVote:(SFRollCallVote *)pVote {
    _vote = pVote;
    self.items = _vote.choices;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == nil || self.vote == nil) return nil;

    NSString *choiceKey = self.vote.choices[indexPath.row];
    NSNumber *totalCount = self.vote.totals[choiceKey];
    NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:SFBasicTextCellTransformerName];
    NSNumber *shouldBeSelectable = [NSNumber numberWithBool:([totalCount integerValue] > 0)];
    NSDictionary *dataObj = @{ @"textLabelString": choiceKey, @"detailTextLabelString": [totalCount stringValue], @"selectable": shouldBeSelectable };
    SFCellData *cellData = [transformer transformedValue:dataObj];

    SFValue1TableCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:[SFValue1TableCell defaultCellIdentifer] forIndexPath:indexPath];

    [cell setCellData:cellData];
    [cell setAccessibilityLabel:@"Vote"];
    [cell setAccessibilityValue:[NSString stringWithFormat:@"%@ %@", totalCount, choiceKey]];

    if ([totalCount integerValue] > 0) {
        if ([choiceKey isEqualToString:@"Not Voting"]) {
            [cell setAccessibilityHint:@"Tap to view legislators that did not vote"];
        }
        else {
            [cell setAccessibilityHint:[NSString stringWithFormat:@"Tap to view legislators that voted %@", choiceKey]];
        }
    }

    CGFloat cellHeight = [cellData heightForWidth:tableView.width];
    [cell setFrame:CGRectMake(0, 0, cell.width, cellHeight)];
    return cell;
}

@end
