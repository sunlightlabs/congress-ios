//
//  SFBillActivityItemSource.m
//  Congress
//
//  Created by Jeremy Carbaugh on 10/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFBillActivityItemSource.h"
#import "SFCongressURLService.h"

@implementation SFBillTextActivityItemSource

- (id)initWithBill:(SFBill *)bill {
    NSString *defaultText;

    if (bill.shortTitle) {
        if ([bill.shortTitle length] > 150) {
            defaultText = [NSString stringWithFormat:@"%@ %@...", bill.displayName, [bill.shortTitle substringToIndex:150]];
        }
        else {
            defaultText = [NSString stringWithFormat:@"%@ %@", bill.displayName, bill.shortTitle];
        }
    }
    else {
        defaultText = bill.displayName;
    }

    return [super initWithText:defaultText];
}

@end


@implementation SFBillURLActivityItemSource

@synthesize bill = _bill;

- (id)initWithBill:(SFBill *)bill {
    self = [super init];
    if (self) {
        [self setBill:bill];
    }
    return self;
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return [SFCongressURLService landingPageForBillWithId:_bill.billId];
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    if (activityType == UIActivityTypeAirDrop) {
        return [SFCongressURLService appScreenForBillWithId:_bill.billId];
    }
    return [SFCongressURLService landingPageForBillWithId:_bill.billId];
}

@end
