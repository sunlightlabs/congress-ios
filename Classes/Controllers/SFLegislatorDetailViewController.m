//
//  SFLegislatorDetailViewController.m
//  Congress
//
//  Created by Daniel Cloud on 12/13/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFBoundaryService.h"
#import "SFDistrictMapViewController.h"
#import "SFLegislatorDetailViewController.h"
#import "SFLegislatorDetailView.h"
#import "SFLegislatorService.h"
#import "SFLegislator.h"
#import "UIImageView+AFNetworking.h"
#import "SFImageButton.h"
#import "SFLegislatorActivityItemProvider.h"

@interface SFLegislatorDetailViewController () <UIActionSheetDelegate>
{
    SSLoadingView *_loadingView;
    NSMutableDictionary *_socialButtons;
    NSString *_restorationBioguideId;
}

@end

@implementation SFLegislatorDetailViewController

@synthesize mapViewController = _mapViewController;
@synthesize legislator = _legislator;
@synthesize legislatorDetailView = _legislatorDetailView;

NSDictionary *_socialImages;

+ (NSDictionary *)socialButtonImages
{
    if (!_socialImages) {
        NSMutableDictionary *imgs = [NSMutableDictionary dictionary];
        [imgs setObject:[UIImage facebookImage] forKey:@"facebook"];
        [imgs setObject:[UIImage twitterImage] forKey:@"twitter"];
        [imgs setObject:[UIImage youtubeImage] forKey:@"youtube"];
        _socialImages = [NSDictionary dictionaryWithDictionary:imgs];
    }
    return _socialImages;
}

#pragma mark - UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _initialize];
        self.screenName = @"Legislator Detail Screen";
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        _restorationBioguideId = nil;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_restorationBioguideId) {
        [SFLegislatorService legislatorWithId:_restorationBioguideId completionBlock:^(SFLegislator *legislator) {
            if (legislator) {
                [self setLegislator:legislator];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        _restorationBioguideId = nil;
        if (_legislator) {
            [[[GAI sharedInstance] defaultTracker] send:
             [[GAIDictionaryBuilder createEventWithCategory:@"Legislator"
                                                     action:@"View"
                                                      label:[NSString stringWithFormat:@"%@. %@ (%@-%@)", _legislator.title, _legislator.fullName, _legislator.party, _legislator.stateAbbreviation]
                                                      value:nil] build]];
        }
    }
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

- (void)viewDidLoad
{
    [_legislatorDetailView.websiteButton setAccessibilityLabel:@"Official web site"];
    [_legislatorDetailView.websiteButton setAccessibilityHint:@"Tap to view official web site in Safari"];
    [_legislatorDetailView.websiteButton setTarget:self action:@selector(handleWebsiteButtonPress) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Accessors

-(void)setLegislator:(SFLegislator *)legislator
{
    if (legislator == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    _legislator = legislator;
    
    if (legislator.inOffice) {
        NSDictionary *socialImages = [[self class] socialButtonImages];
        for (NSString *key in _legislator.socialURLs) {
            UIButton *socialButton = [SFImageButton button];
            UIImage *socialImage = [socialImages valueForKey:key];
            [socialButton setImage:socialImage forState:UIControlStateNormal];
            [_socialButtons setObject:socialButton forKey:key];
            [socialButton setTarget:self action:@selector(handleSocialButtonPress:) forControlEvents:UIControlEventTouchUpInside];
            [socialButton setAccessibilityLabel:[NSString stringWithFormat:@"%@ profile", key]];
            [socialButton setAccessibilityHint:[NSString stringWithFormat:@"Tap to leave Congress app to view the %@ profile of %@ %@", key, legislator.fullTitle, legislator.fullName]];
            [_legislatorDetailView.socialButtonsView addSubview:socialButton];
        }
        [_legislatorDetailView.socialButtonsView addSubview:_legislatorDetailView.websiteButton];
    }

    [self updateView];
}

#pragma mark - Private

-(void)_initialize {

    if (!_legislatorDetailView) {
        _legislatorDetailView = [[SFLegislatorDetailView alloc] initWithFrame:CGRectZero];
        _legislatorDetailView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    _socialButtons = [NSMutableDictionary dictionary];

    [_legislatorDetailView.favoriteButton addTarget:self action:@selector(handleFavoriteButtonPress) forControlEvents:UIControlEventTouchUpInside];
    _legislatorDetailView.favoriteButton.selected = NO;

    CGSize size = self.view.frame.size;
    _loadingView = [[SSLoadingView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    _loadingView.backgroundColor = [UIColor primaryBackgroundColor];
    [self.view addSubview:_loadingView];

}

- (void)updateInOffice
{
    NSMutableAttributedString *contactText = [[NSMutableAttributedString alloc] initWithString:@"CONTACT "];
    [contactText addAttribute:NSFontAttributeName value:[UIFont subitleStrongFont] range:NSMakeRange(0, contactText.length)];
    NSMutableAttributedString *legNameString =  [[NSMutableAttributedString alloc] initWithString:_legislator.fullName];
    [legNameString addAttribute:NSFontAttributeName value:[UIFont subitleEmFont] range:NSMakeRange(0, legNameString.length)];
    [contactText appendAttributedString:legNameString];
    // Gotta set paragraph style or string won't draw correctly.
    [contactText addAttribute:NSParagraphStyleAttributeName value:[NSParagraphStyle defaultParagraphStyle] range:NSMakeRange(0, contactText.length)];
    _legislatorDetailView.contactLabel.attributedText = contactText;
    _legislatorDetailView.contactLabel.contentScaleFactor = 2.0;

    NSRange secondaryAddressRange = [_legislator.congressOffice rangeOfString:@"office building" options:NSCaseInsensitiveSearch];
    NSString *secondaryAddress = @" ";
    NSString *primaryAddress = @" ";
    if (!(secondaryAddressRange.location == NSNotFound)) {
        secondaryAddress = [_legislator.congressOffice substringWithRange:secondaryAddressRange];
        primaryAddress =  [_legislator.congressOffice substringToIndex:secondaryAddressRange.location];
    } else {
        primaryAddress = _legislator.congressOffice;
    }
    _legislatorDetailView.addressLabel.text = [NSString stringWithFormat:@"%@\n%@", primaryAddress, secondaryAddress];
    [_legislatorDetailView.addressLabel setAccessibilityValue:[NSString stringWithFormat:@"%@\n%@", primaryAddress, secondaryAddress]];

    [_legislatorDetailView.officeMapButton addTarget:self action:@selector(handleOfficeMapButtonPress) forControlEvents:UIControlEventTouchUpInside];

    [_legislatorDetailView.callButton addTarget:self action:@selector(handleCallButtonPress) forControlEvents:UIControlEventTouchUpInside];
    //        [self.legislatorDetailView.map.expandoButton addTarget:self action:@selector(handleMapResizeButtonPress) forControlEvents:UIControlEventTouchUpInside];
    
    if (_mapViewController == nil) {
        _mapViewController = [[SFDistrictMapViewController alloc] init];
        [self addChildViewController:_mapViewController];
        [self.view addSubview:_mapViewController.view];
        [_mapViewController didMoveToParentViewController:self];
        [_mapViewController.view sizeToFit];
        [_mapViewController.view setFrame:CGRectMake(0.0f, 240.0f, self.view.frame.size.width, self.view.frame.size.height - 240.0f)];
    }
    [_mapViewController loadBoundaryForLegislator:_legislator];
    [_mapViewController zoomToPointsAnimated:NO];
}

- (void)updateOutOfOffice
{
    NSMutableAttributedString *outOfOfficeText = [[NSMutableAttributedString alloc] initWithString:@" is no longer in office"];
    [outOfOfficeText addAttribute:NSFontAttributeName value:[UIFont subitleStrongFont] range:NSMakeRange(0, outOfOfficeText.length)];
    [outOfOfficeText addAttribute:NSForegroundColorAttributeName value:[UIColor linkHighlightedTextColor] range:NSMakeRange(0, outOfOfficeText.length)];
    
    NSMutableAttributedString *legNameString =  [[NSMutableAttributedString alloc] initWithString:_legislator.fullName];
    [legNameString addAttribute:NSFontAttributeName value:[UIFont subitleEmFont] range:NSMakeRange(0, legNameString.length)];
    [legNameString addAttribute:NSForegroundColorAttributeName value:[UIColor linkHighlightedTextColor] range:NSMakeRange(0, legNameString.length)];
    
    [legNameString appendAttributedString:outOfOfficeText];
    [legNameString addAttribute:NSParagraphStyleAttributeName value:[NSParagraphStyle defaultParagraphStyle] range:NSMakeRange(0, legNameString.length)];
    _legislatorDetailView.contactLabel.attributedText = legNameString;
    _legislatorDetailView.contactLabel.contentScaleFactor = 2.0;

    _legislatorDetailView.callButton.hidden = YES;
    _legislatorDetailView.officeMapButton.hidden = YES;
    _legislatorDetailView.websiteButton.hidden = YES;
}

-(void)updateView
{
    self.title = _legislator.titledName;
    
    if (self.legislatorDetailView) {
    
        _legislatorDetailView.nameLabel.text = _legislator.fullName;
        _legislatorDetailView.favoriteButton.selected = _legislator.persist;
        [_legislatorDetailView.favoriteButton setAccessibilityValue:self.legislator.persist ? @"Enabled" : @"Disabled"];
        _legislatorDetailView.contactLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:@""];
        [_legislatorDetailView.nameLabel setAccessibilityValue:_legislator.fullName];

        NSMutableAttributedString *infoText = [NSMutableAttributedString new];

        NSMutableAttributedString *stateStr = [NSMutableAttributedString stringWithFormat:@"%@ ", _legislator.stateName];
        [stateStr addAttribute:NSFontAttributeName value:[UIFont subitleEmFont] range:NSMakeRange(0, stateStr.length)];
        [infoText appendAttributedString:stateStr];

        NSMutableAttributedString *partyStr = [[NSMutableAttributedString alloc] initWithString:_legislator.partyName];
        [partyStr addAttribute:NSFontAttributeName value:[UIFont subitleStrongFont] range:NSMakeRange(0, partyStr.length)];
        [infoText appendAttributedString:partyStr];

        [infoText appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        
        NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:_legislator.fullTitle];
        [titleStr addAttribute:NSFontAttributeName value:[UIFont subitleStrongFont] range:NSMakeRange(0, titleStr.length)];
        [infoText appendAttributedString:titleStr];

        NSMutableAttributedString *districtStr = [NSMutableAttributedString new];
        if (_legislator.district) {
            if ([_legislator.district isEqualToNumber:[NSNumber numberWithInt:0]]) {
                [districtStr appendAttributedString:[NSMutableAttributedString stringWithFormat:@" At-large\n"]];
            } else {
                [districtStr appendAttributedString:[NSMutableAttributedString stringWithFormat:@" District %@\n", _legislator.district]];
            }
            [districtStr addAttribute:NSFontAttributeName value:[UIFont subitleFont] range:NSMakeRange(0, districtStr.length)];
        }
        [infoText appendAttributedString:districtStr];

        [infoText addAttribute:NSForegroundColorAttributeName value:[UIColor subtitleColor] range:NSMakeRange(0, infoText.length)];
        NSMutableParagraphStyle *pStyle = [NSMutableParagraphStyle new];
        pStyle.alignment = NSTextAlignmentLeft;
        [infoText addAttribute:NSParagraphStyleAttributeName value:pStyle range:NSMakeRange(0, infoText.length)];
        self.legislatorDetailView.infoText.attributedText = infoText;

        LegislatorImageSize imgSize = [UIScreen mainScreen].scale > 1.0f ? LegislatorImageSizeLarge : LegislatorImageSizeMedium;
        NSURL *imageURL = [SFLegislatorService legislatorImageURLforId:_legislator.bioguideId size:imgSize];
        [self.legislatorDetailView.photo setImageWithURL:imageURL placeholderImage:[UIImage photoPlaceholderImage]];

        if (_legislator.inOffice) {
            [self updateInOffice];
        } else {
            [self updateOutOfOffice];
        }

        [_loadingView removeFromSuperview];
        [_legislatorDetailView layoutSubviews];
    }
}

-(void)handleSocialButtonPress:(id)sender
{
    NSString *senderKey = [[_socialButtons keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
        if ([obj isEqual:sender]) {
            stop = YES;
            return YES;
        }
        return NO;
    }] anyObject];
    NSURL *externalURL = [_legislator.socialURLs objectForKey:senderKey];
    NSString *scheme = [NSURL schemeForAppName:senderKey];
    NSURL *appURL;
    if ([senderKey isEqualToString:@"twitter"]) {
        appURL = [NSURL twitterURLForUser:_legislator.twitterId];
    }
    else if ([senderKey isEqualToString:@"facebook"])
    {
        if (([_legislator.facebookId integerValue] != 0)) {
            appURL = [NSURL facebookURLForUser:_legislator.facebookId];
        }
    }
    else
    {
        appURL = [externalURL URLByReplacingScheme:scheme];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:appURL]) {
        externalURL = appURL;
    }
    BOOL urlOpened = [[UIApplication sharedApplication] openURL:externalURL];
    if (!urlOpened) {
        NSLog(@"Unable to open externalURL: %@", [externalURL absoluteString]);
    }
    
    NSString *service = nil;
    
    if ([senderKey isEqualToString:@"facebook"]) {
        service = @"Facebook";
    } else if ([senderKey isEqualToString:@"twitter"]) {
        service = @"Twitter";
    } else if ([senderKey isEqualToString:@"youtube"]) {
        service = @"YouTube";
    }

    if (service) {
        [[[GAI sharedInstance] defaultTracker] send:
         [[GAIDictionaryBuilder createEventWithCategory:@"Social Media"
                                                 action:service
                                                  label:[NSString stringWithFormat:@"%@. %@ (%@-%@)", _legislator.title, _legislator.fullName, _legislator.party, _legislator.stateAbbreviation]
                                                  value:nil] build]];
    }
}

-(void)handleCallButtonPress
{
#if CONFIGURATION_Beta
    [TestFlight passCheckpoint:@"Pressed call legislator button"];
#endif
    NSString *callButtonTitle = [NSString stringWithFormat:@"Call %@", _legislator.phone];
    UIActionSheet *callActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:callButtonTitle, nil];
    callActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [callActionSheet showInView:self.view];
}

-(void)handleWebsiteButtonPress
{
    BOOL urlOpened = [[UIApplication sharedApplication] openURL:_legislator.websiteURL];
#if CONFIGURATION_Beta
    [TestFlight passCheckpoint:@"Pressed legislator website button"];
#endif
    if (urlOpened) {
        [[[GAI sharedInstance] defaultTracker] send:
         [[GAIDictionaryBuilder createEventWithCategory:@"Social Media"
                                                 action:@"Web Site"
                                                  label:[NSString stringWithFormat:@"%@. %@ (%@-%@)", _legislator.title, _legislator.fullName, _legislator.party, _legislator.stateAbbreviation]
                                                  value:nil] build]];
    } else {
        NSLog(@"Unable to open _legislator.website: %@", [_legislator.websiteURL absoluteString]);
    }
}

- (void)handleOfficeMapButtonPress
{
    NSString *addressNoOfficeNum = [[_legislator.congressOffice stringByTrimmingLeadingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]]
                                    stringByTrimmingLeadingAndTrailingWhitespaceAndNewlineCharacters];
    NSString *escapedAddress = [[addressNoOfficeNum stringByAppendingString:@", Washington, DC"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *mapSearchURL = [NSURL URLWithFormat:@"http://maps.apple.com/?q=%@", escapedAddress];
    BOOL urlOpened = [[UIApplication sharedApplication] openURL:mapSearchURL];
#if CONFIGURATION_Beta
    [TestFlight passCheckpoint:@"Pressed legislator website button"];
#endif
    if (urlOpened) {
        [[[GAI sharedInstance] defaultTracker] send:
         [[GAIDictionaryBuilder createEventWithCategory:@"Legislator"
                                                 action:@"Office Map"
                                                  label:[NSString stringWithFormat:@"%@. %@ (%@-%@)", _legislator.title, _legislator.fullName, _legislator.party, _legislator.stateAbbreviation]
                                                  value:nil] build]];
    } else {
        NSLog(@"Unable to open _legislator.officeMap: %@", [_legislator.websiteURL absoluteString]);
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSURL *phoneURL = [NSURL URLWithFormat:@"tel:%@", _legislator.phone];
    if (buttonIndex == 0) {
        BOOL urlOpened = [[UIApplication sharedApplication] openURL:phoneURL];
        if (urlOpened) {
            [[[GAI sharedInstance] defaultTracker] send:
             [[GAIDictionaryBuilder createEventWithCategory:@"Legislator"
                                                     action:@"Call"
                                                      label:[NSString stringWithFormat:@"%@. %@ (%@-%@)", _legislator.title, _legislator.fullName, _legislator.party, _legislator.stateAbbreviation]
                                                      value:nil] build]];
        } else {
            NSLog(@"Unable to open phone url %@", [phoneURL absoluteString]);
        }
    }
}

#pragma mark - SFActivity

- (NSArray *)activityItems
{
    if (_legislator) {
        return @[[[SFLegislatorActivityItemProvider alloc] initWithPlaceholderItem:_legislator],
                 _legislator.shareURL];
    }
    return nil;
}

#pragma mark - SFFavoriting protocol

- (void)handleFavoriteButtonPress
{
    self.legislator.persist = !self.legislator.persist;
    _legislatorDetailView.favoriteButton.selected = self.legislator.persist;
    [_legislatorDetailView.favoriteButton setAccessibilityValue:self.legislator.persist ? @"Enabled" : @"Disabled"];
    [[[GAI sharedInstance] defaultTracker] send:
     [[GAIDictionaryBuilder createEventWithCategory:@"Legislator"
                                             action:@"Favorite"
                                              label:[NSString stringWithFormat:@"%@. %@ (%@-%@)", _legislator.title, _legislator.fullName, _legislator.party, _legislator.stateAbbreviation]
                                              value:nil] build]];
#if CONFIGURATION_Beta
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@avorited legislator", (self.legislator.persist ? @"F" : @"Unf")]];
#endif
}

#pragma mark - UIViewControllerRestoration

+ (UIViewController*)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    NSLog(@"--- restoring SFLegislatorDetailViewController");
    UIViewController *viewController = [[SFLegislatorDetailViewController alloc] initWithNibName:nil bundle:nil];
    return viewController;
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];
    NSString *bioguideId = _legislator ? _legislator.bioguideId : _restorationBioguideId;
    [coder encodeObject:bioguideId forKey:@"bioguideId"];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];
    _restorationBioguideId = [coder decodeObjectForKey:@"bioguideId"];
}

@end
