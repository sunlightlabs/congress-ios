//
//  SFVoteDetailView.m
//  Congress
//
//  Created by Daniel Cloud on 2/7/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFVoteDetailView.h"
#import "SFCalloutBackgroundView.h"
#import "SFCongressButton.h"
#import "SFLineView.h"

@implementation SFVoteDetailView
{
    SFCalloutBackgroundView *_calloutBackground;
    SFLineView *_decorativeLine;
}

@synthesize titleLabel = _titleLabel;
@synthesize dateLabel = _dateLabel;
@synthesize resultLabel = _resultLabel;
@synthesize voteTable = _voteTable;
@synthesize followedVoterLabel = _followedVoterLabel;
@synthesize followedVoterTable = _followedVoterTable;
@synthesize billButton = _billButton;
@synthesize scrollView = _scrollView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)updateContentConstraints {
    NSDictionary *views = @{ @"callout": _calloutBackground,
                             @"title": _titleLabel,
                             @"result": _resultLabel,
                             @"date": _dateLabel,
                             @"billButton": _billButton,
                             @"scroll": _scrollView,
                             @"votes": _voteTable,
                             @"followed": _followedVoterTable,
                             @"followedLabel": _followedVoterLabel,
                             @"line": _decorativeLine };


    CGFloat calloutInset = _calloutBackground.contentInset.top + self.contentInset.top;
    CGFloat spacer = 15.0f;
    CGFloat calloutBottomConstant = calloutInset + _calloutBackground.contentInset.bottom + spacer;
    NSDictionary *metrics = @{ @"calloutInset": @(calloutInset),
                               @"contentInset": @(self.contentInset.left),
                               @"spacer": @(spacer) };

//    MARK: _calloutBackground and _scrollView
    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[callout]"
                                                                                         options:0
                                                                                         metrics:metrics views:views]];

    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[callout]|"
                                                                                         options:0
                                                                                         metrics:metrics views:views]];
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:_calloutBackground attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                       toItem:_dateLabel attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0f constant:calloutBottomConstant]];

    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scroll]|"
                                                                                         options:0
                                                                                         metrics:metrics views:views]];

//    MARK: Vertical items
    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(calloutInset)-[title]-(spacer)-[result]-(spacer)-[date]"
                                                                                         options:0
                                                                                         metrics:metrics views:views]];

//    MARK: _titleLabel
//  FIXME: size of _titleLabel  [_titleLabel sizeToFit];
    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(calloutInset)-[title]-(calloutInset)-|"
                                                                                         options:0
                                                                                         metrics:metrics views:views]];

//    MARK: _resultLabel and _decorativeLine
    [_resultLabel sizeToFit];
    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(calloutInset)-[line]-(calloutInset)-|"
                                                                                         options:0 metrics:metrics views:views]];
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:_decorativeLine attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_resultLabel attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0f constant:0]];
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:_decorativeLine
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0
                                                                     constant:1.0]];
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:_resultLabel attribute:NSLayoutAttributeCenterX toItem:self]];
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:_resultLabel attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f constant:(_resultLabel.width + 20)]];

//    MARK: _dateLabel and _billButton
    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(calloutInset)-[date]-[billButton]-(calloutInset)-|"
                                                                                         options:NSLayoutFormatAlignAllCenterY
                                                                                         metrics:metrics views:views]];
//    MARK: _scrollView
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_calloutBackground attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0f constant:-_calloutBackground.contentInset.bottom]];
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0f constant:0]];
    [_scrollView removeConstraints:_scrollView.constraints];
    NSMutableArray *scrollConstraints = [NSMutableArray array];
    [scrollConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[votes]-[followedLabel]-[followed]-|" options:0 metrics:metrics views:views]];
//    MARK: _scrollView's _voteTable
    [_voteTable sizeToFit];
    CGFloat voteTableHeight = _voteTable.contentSize.height;
    [scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_voteTable attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_scrollView attribute:NSLayoutAttributeWidth
                                                             multiplier:1.0f constant:0]];
    [scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_voteTable attribute:NSLayoutAttributeHeight constant:voteTableHeight]];

//    MARK: _scrollView's _followedVoterLabel
    [scrollConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(contentInset)-[followedLabel]-(contentInset)-|" options:0 metrics:metrics views:views]];
//    MARK: _scrollView's _followedVoterTable
    [_followedVoterTable sizeToFit];
    CGFloat followedvoterTableHeight = _followedVoterTable.contentSize.height;
    [scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_followedVoterTable attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_scrollView attribute:NSLayoutAttributeWidth
                                                             multiplier:1.0f constant:0]];
    [scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_followedVoterTable attribute:NSLayoutAttributeHeight constant:followedvoterTableHeight]];
    [_scrollView addConstraints:scrollConstraints];
    [_scrollView updateConstraints];
//    the viewcontroller must subsequently set the _scrollView.contentSize
}

- (void)setVoteTable:(UITableView *)voteTable {
    if (_voteTable) {
        [_voteTable removeFromSuperview];
    }
    _voteTable = voteTable;
    _voteTable.scrollEnabled = NO;
    _voteTable.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:_voteTable];
}

- (void)setFollowedVoterTable:(UITableView *)followedVoterTable {
    if (_followedVoterTable) {
        [_followedVoterTable removeFromSuperview];
    }
    _followedVoterTable = followedVoterTable;
    _followedVoterTable.scrollEnabled = NO;
    _followedVoterTable.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:_followedVoterTable];
}

#pragma mark - Private

- (void)_initialize {
    self.opaque = YES;
    self.translatesAutoresizingMaskIntoConstraints = NO;

    self.contentInset = UIEdgeInsetsMake(8.0f, 8.0f, 8.0f, 8.0f);

    _calloutBackground = [[SFCalloutBackgroundView alloc] initWithFrame:CGRectZero];
    _calloutBackground.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_calloutBackground];

    CGRect lineRect = CGRectMake(0, 0, 2.0f, 1.0f);
    _decorativeLine = [[SFLineView alloc] initWithFrame:lineRect];
    _decorativeLine.translatesAutoresizingMaskIntoConstraints = NO;
    _decorativeLine.lineColor = [UIColor detailLineColor];
    [self addSubview:_decorativeLine];

    _titleLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont billTitleFont];
    _titleLabel.textColor = [UIColor primaryTextColor];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_titleLabel setAccessibilityLabel:@"Roll call"];
    [self addSubview:_titleLabel];

    _resultLabel = [[SAMLabel alloc] initWithFrame:CGRectZero];
    _resultLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _resultLabel.numberOfLines = 1;
    _resultLabel.font = [UIFont subitleEmFont];
    _resultLabel.textColor = [UIColor primaryTextColor];
    _resultLabel.backgroundColor = [UIColor secondaryBackgroundColor];
    _resultLabel.textAlignment = NSTextAlignmentCenter;
    [_resultLabel setAccessibilityLabel:@"Result of roll call"];
    [self addSubview:_resultLabel];

    _dateLabel = [[SAMLabel alloc] initWithFrame:CGRectZero];
    _dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _dateLabel.font = [UIFont subitleFont];
    _dateLabel.textColor = [UIColor subtitleColor];
    _dateLabel.backgroundColor = [UIColor clearColor];
    _dateLabel.textAlignment = NSTextAlignmentLeft;
    [_dateLabel setAccessibilityLabel:@"Date of roll call"];
    [self addSubview:_dateLabel];

    _billButton = [SFCongressButton buttonWithTitle:@"View Bill"];
    _billButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_billButton setAccessibilityLabel:@"View bill"];
    [_billButton setAccessibilityHint:@"Tap to view bill overview"];
    [self addSubview:_billButton];

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_scrollView];

    _followedVoterLabel = [[SAMLabel alloc] initWithFrame:CGRectZero];
    _followedVoterLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _followedVoterLabel.font = [UIFont systemFontOfSize:16.0f];
    _followedVoterLabel.textColor = [UIColor primaryTextColor];
    _followedVoterLabel.backgroundColor = self.backgroundColor;
    _followedVoterLabel.textAlignment = NSTextAlignmentLeft;
    [_scrollView addSubview:_followedVoterLabel];

    _voteTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _voteTable.backgroundColor = self.backgroundColor;
    _voteTable.translatesAutoresizingMaskIntoConstraints = NO;
    _voteTable.scrollEnabled = NO;
    [_scrollView addSubview:_voteTable];

    _followedVoterTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _followedVoterTable.backgroundColor = self.backgroundColor;
    _followedVoterTable.translatesAutoresizingMaskIntoConstraints = NO;
    _followedVoterTable.scrollEnabled = NO;
    [_scrollView addSubview:_followedVoterTable];
}

@end
