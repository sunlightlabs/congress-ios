//
//  SFCommitteeActivityItemProvider.m
//  Congress
//
//  Created by Jeremy Carbaugh on 8/28/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCommitteeActivityItemProvider.h"
#import "SFCommittee.h"

@implementation SFCommitteeActivityItemProvider

- (id)item
{
    SFCommittee *committee= self.placeholderItem;
    NSString *defaultText = [NSString stringWithFormat:@"%@ %@", committee.prefixName, committee.primaryName];
    
    if (self.activityType == UIActivityTypePostToFacebook)
    {
        return [self facebookStringWithText:defaultText];
    }
    else if (self.activityType == UIActivityTypePostToTwitter)
    {
        return [self twitterStringWithText:defaultText];
    }
    return defaultText;
}

@end
