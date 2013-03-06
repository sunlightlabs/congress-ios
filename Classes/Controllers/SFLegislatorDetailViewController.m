//
//  SFLegislatorDetailViewController.m
//  Congress
//
//  Created by Daniel Cloud on 12/13/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFDistrictMapViewController.h"
#import "SFLegislatorDetailViewController.h"
#import "SFLegislatorDetailView.h"
#import "SFLegislatorService.h"
#import "SFLegislator.h"
#import "UIImageView+AFNetworking.h"

@implementation SFLegislatorDetailViewController
{
    SSLoadingView *_loadingView;
    NSMutableDictionary *__socialButtons;
}

@synthesize legislator = _legislator;
@synthesize legislatorDetailView = _legislatorDetailView;
@synthesize favoriteButton = _favoriteButton;

#pragma mark - UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addFavoritingBarButtonItem];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadView {
    _legislatorDetailView.frame = [[UIScreen mainScreen] applicationFrame];
    _legislatorDetailView.autoresizesSubviews = YES;
    self.view = _legislatorDetailView;
}

#pragma mark - Accessors

-(void)setLegislator:(SFLegislator *)legislator
{
    // TODO: Determine if an additional request for more details will be made
    _legislator = legislator;
    _shareableObjects = [NSMutableArray array];
    [_shareableObjects addObject:_legislator];
    [_shareableObjects addObject:_legislator.shareURL];

    for (NSString *key in _legislator.socialURLs) {
        UIButton *socialButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [socialButton setTitle:[key capitalizedString] forState:UIControlStateNormal];
        [__socialButtons setObject:socialButton forKey:key];
        [socialButton setTarget:self action:@selector(handleSocialButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [_legislatorDetailView.socialButtonsView addSubview:socialButton];
    }

    [self setFavoriteButtonIsFavorited:self.legislator.persist];

    [self updateView];
}

#pragma mark - Private

-(void)_initialize {
    if (!_legislatorDetailView) {
        _legislatorDetailView = [[SFLegislatorDetailView alloc] initWithFrame:CGRectZero];
        _legislatorDetailView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    __socialButtons = [NSMutableDictionary dictionary];
    _favoriteButton = [UIBarButtonItem favoriteButtonWithTarget:self action:@selector(handleFavoriteButtonPress)];
    
    CGSize size = self.view.frame.size;
    _loadingView = [[SSLoadingView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    [self.view addSubview:_loadingView];
}

-(void)updateView
{
    if (self.legislatorDetailView) {
        self.legislatorDetailView.nameLabel.text = _legislator.titledName;

        NSMutableArray *infoStrings = [NSMutableArray arrayWithCapacity:4];
        infoStrings[0] = _legislator.partyName;
        infoStrings[1] = _legislator.stateName;
        infoStrings[2] = _legislator.district ? [NSString stringWithFormat:@"District %@", _legislator.district] : @"";
        infoStrings[3] = _legislator.congressOffice ? _legislator.congressOffice : @"";

        self.legislatorDetailView.infoText.text = [infoStrings componentsJoinedByString:@"\n"];
        LegislatorImageSize imgSize = [UIScreen mainScreen].scale > 1.0f ? LegislatorImageSizeLarge : LegislatorImageSizeMedium;
        NSURL *imageURL = [SFLegislatorService legislatorImageURLforId:_legislator.bioguideId size:imgSize];
        [self.legislatorDetailView.photo setImageWithURL:imageURL];

        NSString *genderedPronoun = [_legislator.gender isEqualToString:@"F"] ? @"her" : @"his";
        [self.legislatorDetailView.callButton setTitle:[NSString stringWithFormat:@"Call %@ office", genderedPronoun] forState:UIControlStateNormal];
        [self.legislatorDetailView.callButton addTarget:self action:@selector(handleCallButtonPress) forControlEvents:UIControlEventTouchUpInside];
        [self.legislatorDetailView.districtMapButton addTarget:self action:@selector(handleMapButtonPress:) forControlEvents:UIControlEventTouchUpInside];

        if (_legislator.websiteURL)
        {
            [self.legislatorDetailView.websiteButton addTarget:self action:@selector(handleWebsiteButtonPress) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            self.legislatorDetailView.websiteButton.enabled = NO;
        }
        [_loadingView removeFromSuperview];

        [_legislatorDetailView layoutSubviews];
    }
}

-(void)handleSocialButtonPress:(id)sender
{
    NSString *senderKey = [__socialButtons mtl_keyOfEntryPassingTest:^BOOL(id key, id obj, BOOL *stop) {
        return [obj isEqual:sender];
    }];
    NSURL *externalURL = [_legislator.socialURLs objectForKey:senderKey];
    BOOL urlOpened = [[UIApplication sharedApplication] openURL:externalURL];
    if (!urlOpened) {
        NSLog(@"Unable to open externalURL: %@", [externalURL absoluteString]);
    }
}

-(void)handleMapButtonPress:(id)sender
{
    SFDistrictMapViewController *mapViewController = [[SFDistrictMapViewController alloc] init];
    [self.navigationController pushViewController:mapViewController animated:YES];
}

-(void)handleCallButtonPress
{
    NSURL *phoneURL = [NSURL URLWithFormat:@"tel:%@", _legislator.phone];
    [TestFlight passCheckpoint:@"Pressed call legislator button"];
    BOOL urlOpened = [[UIApplication sharedApplication] openURL:phoneURL];
    if (!urlOpened) {
        NSLog(@"Unable to open phone url %@", [phoneURL absoluteString]);
    }
}

-(void)handleWebsiteButtonPress
{
    BOOL urlOpened = [[UIApplication sharedApplication] openURL:_legislator.websiteURL];
    [TestFlight passCheckpoint:@"Pressed legislator website button"];
    if (!urlOpened) {
        NSLog(@"Unable to open _legislator.website: %@", [_legislator.websiteURL absoluteString]);
    }
}

#pragma mark - SFFavoriting protocol

- (void)addFavoritingBarButtonItem
{
    NSMutableArray *rightBarButtonItems = [NSMutableArray arrayWithArray:self.navigationItem.rightBarButtonItems];
    if (![rightBarButtonItems containsObject:_favoriteButton]) {
        [rightBarButtonItems addObject:_favoriteButton];
        [self.navigationItem setRightBarButtonItems:rightBarButtonItems];
    }
}

- (void)handleFavoriteButtonPress
{
    self.legislator.persist = !self.legislator.persist;
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@avorited legislator", (self.legislator.persist ? @"F" : @"Unf")]];
    [self setFavoriteButtonIsFavorited:self.legislator.persist];
}

- (void)setFavoriteButtonIsFavorited:(BOOL)favorited
{
    UIColor *tintColor = favorited ? [UIColor redColor] : nil;
    [self.favoriteButton setTintColor:tintColor];
}

@end
