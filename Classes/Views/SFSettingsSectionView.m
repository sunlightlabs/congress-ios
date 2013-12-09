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
#import "SFAppSettings.h"
#import "TTTAttributedLabel.h"

@implementation SFSettingsSectionView
{
//    SSLineView *_headerLine;
    NSMutableArray *_scrollConstraints;
}

@synthesize scrollView;
//@synthesize headerLabel;
@synthesize settingsTable = _settingsTable;
@synthesize analyticsOptOutSwitch;
@synthesize disclaimerLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
    }
    return self;
}

#pragma mark - SFSettingsSectionView

- (void)_initialize
{
    self.contentInset = UIEdgeInsetsMake(16.0f, 32.0f, 16.0f, 32.0f);

    _scrollConstraints = [NSMutableArray array];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.scrollView];
    
//    _headerLine = [[SSLineView alloc] initWithFrame:CGRectZero];
//    _headerLine.translatesAutoresizingMaskIntoConstraints = NO;
//    _headerLine.lineColor = [UIColor detailLineColor];
//    [self.scrollView addSubview:_headerLine];
//
//    self.headerLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
//    self.headerLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    self.headerLabel.textColor = [UIColor subtitleColor];
//    self.headerLabel.textAlignment = NSTextAlignmentCenter;
//    self.headerLabel.backgroundColor = [UIColor primaryBackgroundColor];
//    self.headerLabel.text = @"Settings";
//    [self.scrollView addSubview:self.headerLabel];

    self.analyticsOptOutSwitchLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    self.analyticsOptOutSwitchLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.analyticsOptOutSwitchLabel.font = [UIFont subitleFont];
    self.analyticsOptOutSwitchLabel.textColor = [UIColor subtitleColor];
    self.analyticsOptOutSwitchLabel.backgroundColor = [UIColor clearColor];
    self.analyticsOptOutSwitchLabel.numberOfLines = 0;
    [self.scrollView addSubview:self.analyticsOptOutSwitchLabel];

    self.analyticsOptOutSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    self.analyticsOptOutSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    self.analyticsOptOutSwitch.backgroundColor = [UIColor primaryBackgroundColor];
    [self.analyticsOptOutSwitch setOn:![[SFAppSettings sharedInstance] googleAnalyticsOptOut]];
    [self.scrollView addSubview:self.analyticsOptOutSwitch];

    self.disclaimerLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    self.disclaimerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.disclaimerLabel.font = [UIFont subitleFont];
    self.disclaimerLabel.textColor = [UIColor subtitleColor];
    self.disclaimerLabel.backgroundColor = [UIColor clearColor];
    self.disclaimerLabel.numberOfLines = 0;
    [self.scrollView addSubview:self.disclaimerLabel];

    self.settingsTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.scrollView addSubview:self.settingsTable];
}

- (void)updateContentConstraints
{
    [self.scrollView removeConstraints:_scrollConstraints];
    [_scrollConstraints removeAllObjects];
    
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];

    CGFloat verticalPadding = self.contentInset.left+self.contentInset.right;
    CGFloat contentWidth = appFrame.size.width - verticalPadding;
    CGFloat lineWidth = floorf(appFrame.size.width - verticalPadding/2);
    NSDictionary *metrics = @{@"offset": @(self.contentInset.left),
                              @"vOffset": @(self.contentInset.top),
                              @"lineOffset": @(self.contentInset.left/2),
                              @"contentWidth": @(contentWidth),
                              @"lineWidth": @(lineWidth)};
    
    NSDictionary *views = @{@"scroll": self.scrollView,
//                            @"header": self.headerLabel,
//                            @"headerLine": _headerLine,
                            @"optOut": self.analyticsOptOutSwitch,
                            @"disclaimer": self.disclaimerLabel,
                            @"optOutLabel": self.analyticsOptOutSwitchLabel,
                            @"settingsTable": self.settingsTable};
    
//    [self.headerLabel sizeToFit];
    [self.disclaimerLabel sizeToFit];
    [self.analyticsOptOutSwitchLabel sizeToFit];
    
    [_scrollConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(vOffset)-[optOut]-(16)-[disclaimer]-[settingsTable]" options:0 metrics:metrics views:views]];

//    MARK: self.disclaimerLabel
    CGSize disclaimerSize = [self.disclaimerLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:self.disclaimerLabel attribute:NSLayoutAttributeLeft
                                                                  toItem:self.analyticsOptOutSwitchLabel]];
    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:self.disclaimerLabel attribute:NSLayoutAttributeWidth
                                                                constant:disclaimerSize.width]];
    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:self.disclaimerLabel attribute:NSLayoutAttributeHeight
                                                                constant:disclaimerSize.height]];

//    MARK: self.headerLabel and _headerLine
//    [_scrollConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(offset)-[header]" options:0 metrics:metrics views:views]];
//    [_scrollConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(lineOffset)-[headerLine(>=lineWidth)]-(lineOffset)-|" options:0 metrics:metrics views:views]];
//    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_headerLine
//                                                               attribute:NSLayoutAttributeCenterY
//                                                                  toItem:self.headerLabel]];
//    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_headerLine
//                                                               attribute:NSLayoutAttributeHeight
//                                                                constant:1.0]];
//    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:self.headerLabel
//                                                               attribute:NSLayoutAttributeWidth
//                                                                constant:self.headerLabel.width + 12.0]];

//    MARK: self.analyticsOptOutSwitchLabel and self.analyticsOptOutSwitch
    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:self.analyticsOptOutSwitchLabel
                                                               attribute:NSLayoutAttributeCenterY
                                                                  toItem:self.analyticsOptOutSwitch]];
    [_scrollConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(offset)-[optOutLabel]" options:0 metrics:metrics views:views]];
    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:self.analyticsOptOutSwitch attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.analyticsOptOutSwitchLabel attribute:NSLayoutAttributeRight
                                                              multiplier:1.0 constant:self.contentInset.left]];

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
