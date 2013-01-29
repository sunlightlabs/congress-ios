//
//  SFLegislatorListView.m
//  Congress
//
//  Created by Daniel Cloud on 1/28/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorsSectionView.h"

@implementation SFLegislatorsSectionView

@synthesize tableView = _tableView;
@synthesize scopeBar = _scopeBar;
@synthesize scopeBarSegmentTitles;

#pragma mark - UIView init methods

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		[self _initialize];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)layoutSubviews
{
    CGSize size = self.bounds.size;
    [_scopeBar sizeToFit];
    _scopeBar.frame = CGRectMake(1.0f, 1.0f, (size.width-2.0f), _scopeBar.frame.size.height);

    CGFloat offset_y = _scopeBar.frame.origin.y + _scopeBar.frame.size.height;
    _tableView.frame = CGRectMake(0.0f, offset_y, size.width, (size.height - offset_y));
}

#pragma mark - Private

- (void)_initialize
{
    self.backgroundColor = [UIColor whiteColor];
	self.opaque = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    _scopeBar = [[UISegmentedControl alloc] initWithFrame:CGRectZero];
    _scopeBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _scopeBar.segmentedControlStyle = UISegmentedControlStyleBar;
    [self addSubview:_scopeBar];

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [self addSubview:_tableView];
}

#pragma mark - SFLegislatorView

- (void)setScopeBarSegmentTitles:(NSArray *)segments
{
    if (_scopeBar) {
        NSUInteger index = 0;
        for (NSString *segmentTitle in segments) {
            [_scopeBar insertSegmentWithTitle:segmentTitle atIndex:index animated:NO];
            index++;
        }
    }
}


@end
