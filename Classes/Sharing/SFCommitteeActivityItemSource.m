//
//  SFCommitteeActivityItemSource.m
//  Congress
//
//  Created by Jeremy Carbaugh on 10/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCommitteeActivityItemSource.h"
#import "SFCongressURLService.h"

@implementation SFCommitteeTextActivityItemSource

- (id)initWithCommittee:(SFCommittee *)committee {
    return [super initWithText:[NSString stringWithFormat:@"%@ %@", committee.prefixName, committee.primaryName]];
}

@end


@implementation SFCommitteeURLActivityItemSource

@synthesize committee = _committee;

- (id)initWithCommittee:(SFCommittee *)committee {
    self = [super init];
    if (self) {
        [self setCommittee:committee];
    }
    return self;
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return [SFCongressURLService landingPageForCommitteeWithId:_committee.committeeId];
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    if (activityType == UIActivityTypeAirDrop) {
        return [SFCongressURLService appScreenForCommitteeWithId:_committee.committeeId];
    }
    return [SFCongressURLService landingPageForCommitteeWithId:_committee.committeeId];
}

@end
