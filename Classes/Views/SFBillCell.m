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
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBill:(SFBill *)bill
{
    if (bill != _bill) {
        _bill = bill;
        BOOL shortTitleIsNull = [bill.shortTitle isEqual:[NSNull null]] || bill.shortTitle == nil;
        self.textLabel.text = (!shortTitleIsNull ? bill.shortTitle : bill.officialTitle);
        NSDateFormatter *dateFormatter = nil;
        NSString *dateDescription = @"";
        if (bill.lastActionAt) {
            if (bill.lastActionAtIsDateTime) {
                dateFormatter = [NSDateFormatter mediumDateShortTimeFormatter];
            }
            else
            {
                dateFormatter = [NSDateFormatter ISO8601DateOnlyFormatter];
                dateFormatter.dateStyle = NSDateFormatterMediumStyle;
            }
            dateDescription = [dateFormatter stringFromDate:bill.lastActionAt];
        }
        else if (bill.introducedOn)
        {
            dateFormatter = [NSDateFormatter ISO8601DateOnlyFormatter];
            dateFormatter.dateStyle = NSDateFormatterMediumStyle;
            dateDescription = [dateFormatter stringFromDate:bill.introducedOn];
        }
        self.detailTextLabel.text = dateDescription;
    }
}

@end
