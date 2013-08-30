//
//  SFHearingDetailViewController.m
//  Congress
//
//  Created by Jeremy Carbaugh on 8/23/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFHearingDetailViewController.h"
#import "SFCalloutView.h"

@implementation SFHearingDetailViewController {
    SSLoadingView *_loadingView;
    SFHearing *_hearing;
    UIView *_containerView;
    UIScrollView *_scrollView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.screenName = @"Hearing Detail Screen";
        self.restorationIdentifier = NSStringFromClass(self.class);
        [self _init];
    }
    return self;
}

- (void)loadView
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    _containerView = [[UIView alloc] initWithFrame:bounds];
    [_containerView setBackgroundColor:[UIColor primaryBackgroundColor]];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _detailView = [[SFHearingDetailView alloc] initWithFrame:bounds];
    [_detailView setBackgroundColor:[UIColor primaryBackgroundColor]];
    [_detailView setAutoresizesSubviews:NO];
    
//    [_detailView.favoriteButton addTarget:self action:@selector(handleFavoriteButtonPress) forControlEvents:UIControlEventTouchUpInside];
//    [_detailView.callButton addTarget:self action:@selector(handleCallButtonPress) forControlEvents:UIControlEventTouchUpInside];
//    [_detailView.websiteButton addTarget:self action:@selector(handleWebsiteButtonPress) forControlEvents:UIControlEventTouchUpInside];
    
    _loadingView = [[SSLoadingView alloc] initWithFrame:bounds];
    [_loadingView setBackgroundColor:[UIColor primaryBackgroundColor]];
    [_detailView addSubview:_loadingView];
    
    [_scrollView addSubview:_detailView];
    [_containerView addSubview:_scrollView];
    
    self.view = _containerView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_scrollView, _detailView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scrollView]|" options:0 metrics: 0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scrollView]|" options:0 metrics: 0 views:views]];
//    [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_detailView]|" options:0 metrics: 0 views:views]];
//    [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_detailView]|" options:0 metrics: 0 views:views]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_hearing) {
        [_detailView.committeePrefixLabel setText:@"Hearing of the"];
        [_detailView.committeePrimaryLabel setText:[NSString stringWithFormat:@"%@ %@", _hearing.committee.prefixName, _hearing.committee.primaryName]];
        [_detailView.descriptionLabel setText:_hearing.description lineSpacing:[NSParagraphStyle lineSpacing]];
        
        [_loadingView removeFromSuperview];
//        [self.view setNeedsLayout];
    }
    
    [_scrollView setContentSize:CGSizeMake(320.0f, 900.0f)];
    
}

#pragma mark - private

- (void)_init
{

}

#pragma mark - public

- (void)updateWithHearing:(SFHearing *)hearing
{
    _hearing = hearing;
    self.title = @"Hearing";
}

@end
