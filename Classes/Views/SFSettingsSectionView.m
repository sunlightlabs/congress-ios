//
//  SFSettingsSectionView.m
//  Congress
//
//  Created by Daniel Cloud on 4/26/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFSettingsSectionView.h"
#import "SFCongressButton.h"
#import "SFLabel.h"
#import "TTTAttributedLabel.h"

@implementation SFSettingsSectionView
{
    NSMutableArray *_scrollConstraints;
}

@synthesize scrollView;
@synthesize settingsTable = _settingsTable;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
    }
    return self;
}

#pragma mark - SFSettingsSectionView

- (void)_initialize {
    self.contentInset = UIEdgeInsetsMake(16.0f, 32.0f, 16.0f, 32.0f);

    _scrollConstraints = [NSMutableArray array];

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.scrollView];

    self.settingsTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.scrollView addSubview:self.settingsTable];
}

- (void)updateContentConstraints {
    [self.scrollView removeConstraints:_scrollConstraints];
    [_scrollConstraints removeAllObjects];

    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];

    CGFloat verticalPadding = self.contentInset.left + self.contentInset.right;
    CGFloat contentWidth = appFrame.size.width - verticalPadding;
    CGFloat lineWidth = floorf(appFrame.size.width - verticalPadding / 2);
    NSDictionary *metrics = @{ @"offset": @(self.contentInset.left),
                               @"vOffset": @(self.contentInset.top),
                               @"lineOffset": @(self.contentInset.left / 2),
                               @"contentWidth": @(contentWidth),
                               @"lineWidth": @(lineWidth) };

    NSDictionary *views = @{ @"scroll": self.scrollView,
                             @"settingsTable": self.settingsTable};
    
    [_scrollConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(vOffset)-[settingsTable]" options:0 metrics:metrics views:views]];

//    MARK: tableview
    [self.settingsTable sizeToFit];
    CGFloat voteTableHeight = ceilf(self.settingsTable.contentSize.height);
    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:self.settingsTable attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.scrollView attribute:NSLayoutAttributeWidth
                                                              multiplier:1.0f constant:0]];
    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:self.settingsTable attribute:NSLayoutAttributeHeight constant:voteTableHeight]];

    [self.scrollView addConstraints:_scrollConstraints];
//    the viewcontroller must subsequently set the _scrollView.contentSize
    
    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scroll]|" options:0 metrics:metrics views:views]];
    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scroll]|" options:0 metrics:metrics views:views]];
}

@end
