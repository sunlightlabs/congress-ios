//
//  SFLegislatorDetailViewController.m
//  Congress
//
//  Created by Daniel Cloud on 12/13/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorDetailViewController.h"
#import "SFLegislatorDetailView.h"
#import "SFLegislatorService.h"
#import "Legislator.h"
#import "UIImageView+AFNetworking.h"

@implementation SFLegislatorDetailViewController

@synthesize legislator = _legislator;
@synthesize legislatorDetailView = _legislatorDetailView;

#pragma mark - UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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

-(void)setLegislator:(Legislator *)legislator
{
    // TODO: Determine if an additional request for more details will be made
    _legislator = legislator;
    [self updateView];
    
}


#pragma mark - Private

-(void)_initialize {
    if (!_legislatorDetailView) {
        _legislatorDetailView = [[SFLegislatorDetailView alloc] initWithFrame:CGRectZero];
        _legislatorDetailView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
}

-(void)updateView
{
    if (self.legislatorDetailView) {
        self.legislatorDetailView.nameLabel.text = _legislator.titled_name;

        NSMutableArray *infoStrings = [NSMutableArray arrayWithCapacity:4];
        infoStrings[0] = _legislator.party_name;
        infoStrings[1] = _legislator.state_name;
        infoStrings[2] = _legislator.district ? [NSString stringWithFormat:@"District %@", _legislator.district] : @"";
        infoStrings[3] = _legislator.congress_office ? _legislator.congress_office : @"";

        self.legislatorDetailView.infoText.text = [infoStrings componentsJoinedByString:@"\n"];
        LegislatorImageSize imgSize = [UIScreen mainScreen].scale > 1.0f ? LegislatorImageSizeLarge : LegislatorImageSizeMedium;
        NSURL *imageURL = [[SFLegislatorService sharedInstance] getLegislatorImageURLforId:_legislator.bioguide_id size:imgSize];
        [self.legislatorDetailView.photo setImageWithURL:imageURL];

        NSString *genderedPronoun = [_legislator.gender isEqualToString:@"F"] ? @"her" : @"his";
        [self.legislatorDetailView.callButton setTitle:[NSString stringWithFormat:@"Call %@ office", genderedPronoun] forState:UIControlStateNormal];
        [self.legislatorDetailView.callButton addTarget:self action:@selector(handleCallButtonPress) forControlEvents:UIControlEventTouchUpInside];

        if (_legislator.website)
        {
            [self.legislatorDetailView.websiteButton addTarget:self action:@selector(handleWebsiteButtonPress) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            self.legislatorDetailView.websiteButton.enabled = NO;
        }

    }
}

-(void)handleCallButtonPress
{
    NSURL *phoneURL = [NSURL URLWithFormat:@"tel:%@", _legislator.phone];
    BOOL urlOpened = [[UIApplication sharedApplication] openURL:phoneURL];
    if (!urlOpened) {
        NSLog(@"Unable to open phone url %@", [phoneURL absoluteString]);
    }
}

-(void)handleWebsiteButtonPress
{
    NSURL *websiteURL = [NSURL URLWithString:_legislator.website];
    BOOL urlOpened = [[UIApplication sharedApplication] openURL:websiteURL];
    if (!urlOpened) {
        NSLog(@"Unable to open websiteURL: %@", [websiteURL absoluteString]);
    }
}

@end
