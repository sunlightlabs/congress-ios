//
//  SFLegislatorSegmentedViewController.h
//  Congress
//
//  Created by Daniel Cloud on 6/3/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFShareableViewController.h"

@class SFLegislator;

@interface SFLegislatorSegmentedViewController : SFShareableViewController <UIViewControllerRestoration>

@property (nonatomic, strong, setter = setLegislator :) SFLegislator *legislator;
@property (nonatomic, readonly) NSArray *segmentTitles;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil bioguideId:(NSString *)bioguideId;
- (void)setLegislatorWithBioguideId:(NSString *)bioguideId;
- (void)setVisibleSegment:(NSString *)segmentName;

@end
