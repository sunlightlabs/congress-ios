//
//  SFInformationSectionViewController.m
//  Congress
//
//  Created by Daniel Cloud on 12/2/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFInformationSectionViewController.h"
#import "SFInformationView.h"
#import "SFLabel.h"
#import "TTTAttributedLabel.h"
#import "SFCongressButton.h"
#import "SFCongressURLService.h"

@interface SFInformationSectionViewController () <UIGestureRecognizerDelegate, TTTAttributedLabelDelegate>

@end

@implementation SFInformationSectionViewController

@synthesize informationView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.screenName = @"Information Screen";
        self.restorationIdentifier = NSStringFromClass(self.class);
        self.title = @"Information";
    }
    return self;
}

- (void)loadView {
    self.informationView = [[SFInformationView alloc] initWithFrame:CGRectZero];
    self.informationView.frame = [[UIScreen mainScreen] applicationFrame];
    self.view = self.informationView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor primaryBackgroundColor];

    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

    NSMutableAttributedString *headerText = [[NSMutableAttributedString alloc] initWithString:@"ABOUT " attributes:@{ NSFontAttributeName: [UIFont subitleStrongFont] }];
    [headerText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Congress  v%@", version] attributes:@{ NSFontAttributeName: [UIFont subitleEmFont] }]];
    self.informationView.headerLabel.attributedText = headerText;
    
    // configure description
    
    NSDictionary *links = @{ @"Sunlight Foundation": @"http://sunlightfoundation.com/",
                             @"Sunlight Congress API": @"http://sunlightlabs.github.io/congress/",
                             @"U.S. Census Bureau": @"http://www.census.gov/geo/maps-data/data/tiger-line.html",
                             @"Mapbox": @"http://www.mapbox.com/",
                             @"terms, conditions and attribution": @"http://www.mapbox.com/about/maps/" };

    NSDictionary *textAttributes = @{ NSParagraphStyleAttributeName: [NSParagraphStyle congressParagraphStyle],
                                             NSForegroundColorAttributeName: [UIColor primaryTextColor],
                                             NSFontAttributeName: [UIFont bodyTextFont] };

    NSDictionary *linkAttributes = @{ NSForegroundColorAttributeName: [UIColor linkTextColor],
                                      NSFontAttributeName: [UIFont linkFont],
                                      NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone) };
    
    NSDictionary *activeLinkAttributes = @{ NSForegroundColorAttributeName: [UIColor linkHighlightedTextColor],
                                            NSFontAttributeName: [UIFont linkFont],
                                            NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone) };
    
    TTTAttributedLabel *descriptionLabel = self.informationView.descriptionLabel;
    
    descriptionLabel.delegate = self;
    descriptionLabel.enabledTextCheckingTypes = NSTextCheckingAllTypes;
    descriptionLabel.linkAttributes = linkAttributes;
    descriptionLabel.activeLinkAttributes = activeLinkAttributes;
    descriptionLabel.inactiveLinkAttributes = linkAttributes;
    
    NSString *descriptionText = @"This app is made by the Sunlight Foundation, a nonpartisan nonprofit dedicated to increasing government transparency through the power of technology.\nThe data for Sunlight Congress comes directly from official congressional sources via the Sunlight Congress API and district boundaries come from the U.S. Census Bureau.\nMaps powered by Mapbox. View terms, conditions and attribution for map data.";

    NSMutableAttributedString *descriptionAttributedText = [[NSMutableAttributedString alloc] initWithString:descriptionText attributes:textAttributes];
    
    [self.informationView.descriptionLabel setText:descriptionAttributedText afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        [mutableAttributedString setAttributes:textAttributes range:NSMakeRange(0, mutableAttributedString.length)];
        return mutableAttributedString;
    }];
    
    [links enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
        NSRange range = [self.informationView.descriptionLabel.text rangeOfString:key];
        [self.informationView.descriptionLabel addLinkToURL:[NSURL URLWithString:obj] withRange:range];
    }];
    
    // other stuff
    
    [self.informationView.feedbackButton addTarget:self action:@selector(handleFeedbackButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [self.informationView.joinButton addTarget:self action:@selector(handleJoinButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [self.informationView.donateButton addTarget:self action:@selector(handleDonateButtonPress) forControlEvents:UIControlEventTouchUpInside];

    self.informationView.logoView.userInteractionEnabled = YES;
    UITapGestureRecognizer *logoTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleLogoTouch:)];
    logoTapRecognizer.numberOfTapsRequired = 1;
    logoTapRecognizer.numberOfTouchesRequired = 1;
    logoTapRecognizer.delegate = self;
    [self.informationView.logoView addGestureRecognizer:logoTapRecognizer];

    // This needs the same buttons as SFMainDeckTableViewController
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem menuButtonWithTarget:self.viewDeckController action:@selector(toggleLeftView)];
    
    
    [self.informationView setNeedsUpdateConstraints];
    [self.informationView.scrollView layoutIfNeeded];
    [self resizeScrollView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.informationView.scrollView flashScrollIndicators];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self resizeScrollView];
}

- (void)resizeScrollView {
    UILabel *bottomView = self.informationView.descriptionLabel;
    [self.informationView.scrollView layoutIfNeeded];
    [self.informationView.scrollView setContentSize:CGSizeMake(self.informationView.width, bottomView.bottom + self.informationView.contentInset.bottom)];
}

#pragma mark - UIGestureRecognizerDelegate

- (void)handleLogoTouch:(UIPanGestureRecognizer *)recognizer {
    NSURL *theURL = [NSURL URLWithString:@"http://sunlightfoundation.com/"];
    [[UIApplication sharedApplication] openURL:theURL];
}

#pragma mark - SFSettingsSectionViewController button actions

- (void)handleFeedbackButtonPress {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *subject = [NSString stringWithFormat:@"%@ - v%@", kSFContactEmailSubject, version];
    NSString *mailToURIString = [NSString stringWithFormat:@"mailto:%@?subject=%@", kSFContactEmailAddress, subject];
    NSURL *theURL = [NSURL URLWithString:[mailToURIString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    [[UIApplication sharedApplication] openURL:theURL];
}

- (void)handleJoinButtonPress {
    NSURL *theURL = [NSURL URLWithString:@"http://sunlightfoundation.com/join"];
    [[UIApplication sharedApplication] openURL:theURL];
}

- (void)handleDonateButtonPress {
    NSURL *theURL = [NSURL URLWithString:@"http://sunlightfoundation.com/donate"];
    [[UIApplication sharedApplication] openURL:theURL];
}

#pragma mark - SFActivity

- (NSArray *)activityItems {
    return @[@"Keep tabs on Capitol Hill: Use @congress_app to follow bills, contact legislators and more.",
             [SFCongressURLService globalLandingPage]];
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)theURL {
    [[UIApplication sharedApplication] openURL:theURL];
}

#pragma mark - Application state

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
}

@end
