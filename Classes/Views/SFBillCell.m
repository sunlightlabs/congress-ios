//
//  SFBillCell.m
//  Congress
//
//  Created by Daniel Cloud on 2/20/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFBillCell.h"
#import "SFBill.h"

@implementation SFBillCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.opaque = YES;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.textLabel.font = [UIFont systemFontOfSize:19.0];
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse
{
    if (!_bill || !_bill.persist) {
        self.textLabel.textColor = [UIColor blackColor];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.textLabel.backgroundColor = self.backgroundView.backgroundColor;
        self.detailTextLabel.backgroundColor = self.backgroundView.backgroundColor;
    }
}

#pragma mark - SFBill accessors

- (void)setBill:(SFBill *)bill
{
    if (bill != _bill) {
        _bill = bill;
        [self updateDisplay];
    }
}

- (void)updateDisplay
{
    BOOL shortTitleIsNull = [_bill.shortTitle isEqual:[NSNull null]] || _bill.shortTitle == nil;
    self.textLabel.text = (!shortTitleIsNull ? _bill.shortTitle : _bill.officialTitle);
    NSDateFormatter *dateFormatter = nil;
    NSString *dateDescription = @"";
    if (_bill.lastActionAt) {
        if (_bill.lastActionAtIsDateTime) {
            dateFormatter = [NSDateFormatter mediumDateShortTimeFormatter];
        }
        else
        {
            dateFormatter = [NSDateFormatter ISO8601DateOnlyFormatter];
            dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        }
        dateDescription = [dateFormatter stringFromDate:_bill.lastActionAt];
    }
    else if (_bill.introducedOn)
    {
        dateFormatter = [NSDateFormatter ISO8601DateOnlyFormatter];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateDescription = [dateFormatter stringFromDate:_bill.introducedOn];
    }
    self.detailTextLabel.text = dateDescription;
    if (_bill.persist) {
        self.textLabel.textColor = [UIColor colorWithRed:0.337 green:0.627 blue:0.827 alpha:1.000];
        self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.950 alpha:1.000];
    }
    self.textLabel.backgroundColor = self.backgroundView.backgroundColor;
    self.detailTextLabel.backgroundColor = self.backgroundView.backgroundColor;
}

@end
