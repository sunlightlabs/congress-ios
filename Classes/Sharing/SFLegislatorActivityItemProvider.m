//
//  SFLegislatorActivityItemProvider.m
//  Congress
//
//  Created by Jeremy Carbaugh on 8/28/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorActivityItemProvider.h"
#import "SFLegislator.h"

@implementation SFLegislatorActivityItemProvider

- (id)item
{
    SFLegislator *legislator = self.placeholderItem;
    NSString *defaultText = legislator.titledName;
    
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
