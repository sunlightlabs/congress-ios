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
    SSLineView *_headerLine;
    NSMutableArray *_scrollConstraints;
}

@synthesize scrollView = _scrollView;
@synthesize headerLabel = _headerLabel;
@synthesize analyticsOptOutSwitch = _analyticsOptOutSwitch;
@synthesize disclaimerLabel = _disclaimerLabel;

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
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView.backgroundColor = [UIColor primaryBackgroundColor];
    [self addSubview:_scrollView];
    
    _headerLine = [[SSLineView alloc] initWithFrame:CGRectZero];
    _headerLine.translatesAutoresizingMaskIntoConstraints = NO;
    _headerLine.lineColor = [UIColor detailLineColor];
    [_scrollView addSubview:_headerLine];

    _headerLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _headerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _headerLabel.textColor = [UIColor subtitleColor];
    _headerLabel.textAlignment = NSTextAlignmentCenter;
    _headerLabel.backgroundColor = [UIColor primaryBackgroundColor];
    _headerLabel.text = @"Settings";
    [_scrollView addSubview:_headerLabel];

    _analyticsOptOutSwitchLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _analyticsOptOutSwitchLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _analyticsOptOutSwitchLabel.font = [UIFont subitleFont];
    _analyticsOptOutSwitchLabel.textColor = [UIColor subtitleColor];
    _analyticsOptOutSwitchLabel.backgroundColor = [UIColor clearColor];
    _analyticsOptOutSwitchLabel.numberOfLines = 0;
    [_scrollView addSubview:_analyticsOptOutSwitchLabel];

    _analyticsOptOutSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    _analyticsOptOutSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    _analyticsOptOutSwitch.backgroundColor = [UIColor primaryBackgroundColor];
    [_analyticsOptOutSwitch setOn:![[SFAppSettings sharedInstance] googleAnalyticsOptOut]];
    [_scrollView addSubview:_analyticsOptOutSwitch];

    _disclaimerLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _disclaimerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _disclaimerLabel.font = [UIFont subitleFont];
    _disclaimerLabel.textColor = [UIColor subtitleColor];
    _disclaimerLabel.backgroundColor = [UIColor clearColor];
    _disclaimerLabel.numberOfLines = 0;
    [_scrollView addSubview:_disclaimerLabel];
}

- (void)updateContentConstraints
{
    [_scrollView removeConstraints:_scrollConstraints];
    [_scrollConstraints removeAllObjects];
    
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];

    CGFloat verticalPadding = self.contentInset.left+self.contentInset.right;
    CGFloat contentWidth = appFrame.size.width - verticalPadding;
    CGFloat lineWidth = floorf(appFrame.size.width - verticalPadding/2);
    NSDictionary *metrics = @{@"offset": @(self.contentInset.left),
                              @"lineOffset": @(self.contentInset.left/2),
                              @"contentWidth": @(contentWidth),
                              @"lineWidth": @(lineWidth)};
    
    NSDictionary *views = @{@"scroll": _scrollView,
                            @"header": _headerLabel,
                            @"headerLine": _headerLine,
                            @"optOut": _analyticsOptOutSwitch,
                            @"disclaimer": _disclaimerLabel,
                            @"optOutLabel": _analyticsOptOutSwitchLabel };
    
    [_headerLabel sizeToFit];
    [_disclaimerLabel sizeToFit];
    [_analyticsOptOutSwitchLabel sizeToFit];
    
    [_scrollConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(offset)-[header]-(16)-[optOut]-(16)-[disclaimer]" options:0 metrics:metrics views:views]];

//    MARK: _disclaimerLabel
    CGSize disclaimerSize = [_disclaimerLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_disclaimerLabel attribute:NSLayoutAttributeLeft
                                                                  toItem:_analyticsOptOutSwitchLabel]];
    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_disclaimerLabel attribute:NSLayoutAttributeWidth
                                                                constant:disclaimerSize.width]];
    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_disclaimerLabel attribute:NSLayoutAttributeHeight
                                                                constant:disclaimerSize.height]];

//    MARK: _headerLabel and _headerLine
    [_scrollConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(offset)-[header]" options:0 metrics:metrics views:views]];
    [_scrollConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(lineOffset)-[headerLine(>=lineWidth)]-(lineOffset)-|" options:0 metrics:metrics views:views]];
    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_headerLine
                                                               attribute:NSLayoutAttributeCenterY
                                                                  toItem:_headerLabel]];
    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_headerLine
                                                               attribute:NSLayoutAttributeHeight
                                                                constant:1.0]];
    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_headerLabel
                                                               attribute:NSLayoutAttributeWidth
                                                                constant:_headerLabel.width + 12.0]];

//    MARK: _analyticsOptOutSwitchLabel and _analyticsOptOutSwitch
    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_analyticsOptOutSwitchLabel
                                                               attribute:NSLayoutAttributeCenterY
                                                                  toItem:_analyticsOptOutSwitch]];
    [_scrollConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(offset)-[optOutLabel]" options:0 metrics:metrics views:views]];
    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_analyticsOptOutSwitch attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                  toItem:_analyticsOptOutSwitchLabel attribute:NSLayoutAttributeRight
                                                              multiplier:1.0 constant:self.contentInset.left]];

    [_scrollView addConstraints:_scrollConstraints];
    
    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scroll]|" options:0 metrics:metrics views:views]];
    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scroll]|" options:0 metrics:metrics views:views]];
}

@end
