//
//  SFBillActivityItemProvider.m
//  Congress
//
//  Created by Jeremy Carbaugh on 8/27/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFBillActivityItemProvider.h"
#import "SFBill.h"

@implementation SFBillActivityItemProvider

- (id)item
{
    SFBill *bill = self.placeholderItem;
    NSString *defaultText = nil;
    
    if (bill.shortTitle) {
        if ([bill.shortTitle length] > 150) {
            defaultText = [NSString stringWithFormat:@"%@ %@...", bill.displayName, [bill.shortTitle substringToIndex:150]];
        } else {
            defaultText = [NSString stringWithFormat:@"%@ %@", bill.displayName, bill.shortTitle];
        }
    } else {
        defaultText = bill.displayName;
    }
    
    if (self.activityType == UIActivityTypePostToFacebook)
    {
        return [self facebookStringWithText:defaultText];
    }
    else if (self.activityType == UIActivityTypePostToTwitter)
    {
        return [self twitterStringWithText:bill.displayName];
    }
    return defaultText;
}

@end
