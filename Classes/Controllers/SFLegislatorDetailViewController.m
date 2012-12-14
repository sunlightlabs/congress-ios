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
#import "SFLegislator.h"
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

-(void)setLegislator:(SFLegislator *)legislator
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
        self.legislatorDetailView.nameLabel.text =_legislator.name;

        LegislatorImageSize imgSize = [UIScreen mainScreen].scale > 1.0f ? LegislatorImageSizeLarge : LegislatorImageSizeMedium;

        NSURL *imageURL = [SFLegislatorService getLegislatorImageURLforId:_legislator.bioguide_id size:imgSize];
        [self.legislatorDetailView.photo setImageWithURL:imageURL];
    }
}

@end
