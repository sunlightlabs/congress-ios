//
//  SFBillCell.m
//  Congress
//
//  Created by Daniel Cloud on 2/20/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFBillCell.h"
#import "SFBill.h"
#import "SFBillAction.h"
#import "SFOpticView.h"

@implementation SFBillCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.textLabel.numberOfLines = 3;

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (!selected && _bill.persist) {
        [self _setPersistStyle];
        for (UIView *subview in [self.contentView subviews]) {
            [subview setNeedsDisplay];
        }
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    _bill = nil;
    [self _reset];
}

#pragma mark - SFBill accessors

- (void)setBill:(SFBill *)bill
{
    if (bill != _bill) {
        _bill = bill;
        if (bill.lastAction) {
            SFOpticView *panel = [[SFOpticView alloc] initWithFrame:CGRectZero];
            panel.textLabel.text = [NSString stringWithFormat:@"%@: %@", bill.lastAction.typeDescription, bill.lastAction.text];
            [self addPanelView:panel];
        }
        [self updateDisplay];
    }
}

- (void)updateDisplay
{
    BOOL shortTitleIsNull = [_bill.shortTitle isEqual:[NSNull null]] || _bill.shortTitle == nil;
    self.textLabel.text = (!shortTitleIsNull ? _bill.shortTitle : _bill.officialTitle);

    self.detailTextLabel.text = _bill.displayName;
    if (_bill.persist) {
        [self _setPersistStyle];
    }
}

- (void)_reset
{
    self.textLabel.textColor = [UIColor primaryTextColor];
    self.backgroundView.backgroundColor = [UIColor primaryBackgroundColor];
    self.textLabel.opaque = YES;
    self.textLabel.backgroundColor = self.backgroundView.backgroundColor;
    self.detailTextLabel.opaque = YES;
    self.detailTextLabel.backgroundColor = self.backgroundView.backgroundColor;
}

- (void)_setPersistStyle
{
    self.textLabel.textColor = [UIColor colorWithRed:0.337 green:0.627 blue:0.827 alpha:1.000];
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.950 alpha:1.000];
    self.textLabel.opaque = NO;
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.opaque = NO;
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
}

@end
