//
//  SFTextActivityItemSource.m
//  Congress
//
//  Created by Jeremy Carbaugh on 10/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFTextActivityItemSource.h"

@implementation SFTextActivityItemSource

@synthesize defaultText = _defaultText;

#pragma mark - public

- (id)initWithText:(NSString *)text {
    self = [super init];
    if (self) {
        [self setDefaultText:text];
    }
    return self;
}

- (NSString *)facebookText:(NSString *)text {
    return [NSString stringWithFormat:@"%@ via Sunlight Foundation's Congress for iOS", text];
}

- (NSString *)twitterText:(NSString *)text {
    return [NSString stringWithFormat:@"%@ via @congress_app", text];
}

#pragma mark - UIActivityItemSource

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return _defaultText;
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    if (activityType == UIActivityTypePostToFacebook) {
        return [self facebookText:_defaultText];
    }
    else if (activityType == UIActivityTypePostToTwitter) {
        return [self twitterText:_defaultText];
    }
    else {
        return _defaultText;
    }
}

@end
