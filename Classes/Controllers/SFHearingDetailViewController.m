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
    
    _detailView = [[SFHearingDetailView alloc] initWithFrame:bounds];
    [_detailView setBackgroundColor:[UIColor primaryBackgroundColor]];
//    [_detailView.favoriteButton addTarget:self action:@selector(handleFavoriteButtonPress) forControlEvents:UIControlEventTouchUpInside];
//    [_detailView.callButton addTarget:self action:@selector(handleCallButtonPress) forControlEvents:UIControlEventTouchUpInside];
//    [_detailView.websiteButton addTarget:self action:@selector(handleWebsiteButtonPress) forControlEvents:UIControlEventTouchUpInside];
    
    _loadingView = [[SSLoadingView alloc] initWithFrame:bounds];
    [_loadingView setBackgroundColor:[UIColor primaryBackgroundColor]];
    [_detailView addSubview:_loadingView];
    
    self.view = _detailView;
    
    if (_hearing) {
        [self updateWithHearing:_hearing];
    }
}

#pragma mark - private

- (void)_init
{

}

#pragma mark - public

- (void)updateWithHearing:(SFHearing *)hearing
{
    _hearing = hearing;
    
    if (self.view) {
    
        [_detailView.committeePrefixLabel setText:hearing.committee.prefixName];
        [_detailView.committeePrimaryLabel setText:hearing.committee.primaryName];
        
        [_loadingView removeFromSuperview];
        [self.view setNeedsLayout];
        
    }
}

@end
