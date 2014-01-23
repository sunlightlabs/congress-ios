//
//  SFLegislatorActivityItemSource.m
//  Congress
//
//  Created by Jeremy Carbaugh on 10/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorActivityItemSource.h"
#import "SFCongressURLService.h"

@implementation SFLegislatorTextActivityItemSource

- (id)initWithLegislator:(SFLegislator *)legislator {
    return [super initWithText:legislator.titledName];
}

@end


@implementation SFLegislatorURLActivityItemSource

@synthesize legislator = _legislator;

- (id)initWithLegislator:(SFLegislator *)legislator {
    self = [super init];
    if (self) {
        [self setLegislator:legislator];
    }
    return self;
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return [SFCongressURLService landingPageForLegislatorWithId:_legislator.bioguideId];
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    if (activityType == UIActivityTypeAirDrop) {
        return [SFCongressURLService appScreenForLegislatorWithId:_legislator.bioguideId];
    }
    return [SFCongressURLService landingPageForLegislatorWithId:_legislator.bioguideId];
}

@end
