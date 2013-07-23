//
//  SFCommitteeDetailViewController.m
//  Congress
//
//  Created by Jeremy Carbaugh on 7/22/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCommitteeDetailViewController.h"
#import <GAI.h>

@interface SFCommitteeDetailViewController ()

@end

@implementation SFCommitteeDetailViewController {
    SFCommittee *_committee;
}

@synthesize nameLabel = _nameLabel;
@synthesize favoriteButton = _favoriteButton;
@synthesize committeeTableController = _committeeTableController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.trackedViewName = @"Committee Detail Screen";
        self.restorationIdentifier = NSStringFromClass(self.class);
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor greenColor]];
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
//    _nameLabel = [[SFLabel alloc] init];
//    [_nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [self.view addSubview:_nameLabel];
//    
//    _favoriteButton = [[SFFavoriteButton alloc] init];
//    [_nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [self.view addSubview:_nameLabel];
//    
//    _committeeTableController = [[SFCommitteesTableViewController alloc] init];
//    [_committeeTableController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [self.view addSubview:_committeeTableController.view];
//    
//    /* auto layout */
//    
//    NSDictionary *viewDict = @{ @"name": _nameLabel,
//                                @"star": _favoriteButton,
//                                @"subcommittees": _committeeTableController.view };
//    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[name(>=180)]-[subcommittees]|" options:0 metrics:nil views:viewDict]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subcommittees]|" options:0 metrics:nil views:viewDict]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[name]-[star(60)]-|" options:0 metrics:nil views:viewDict]];
}

#pragma mark - public

- (void)updateWithCommittee:(SFCommittee *)committee
{
    _favoriteButton.selected = _committee.persist;
    [_favoriteButton setAccessibilityLabel:@"Follow commmittee"];
    [_favoriteButton setAccessibilityValue:_committee.persist ? @"Following" : @"Not Following"];
    [_favoriteButton setAccessibilityHint:@"Follow this committee to see the lastest updates in the Following section."];
    
    _nameLabel.text = _committee.name;
    [_nameLabel setAccessibilityLabel:@"Name of committee"];
    [_nameLabel setAccessibilityValue:_committee.name];
}

- (void)handleFavoriteButtonPress
{
    _committee.persist = !_committee.persist;
    _favoriteButton.selected = _committee.persist;
    [_favoriteButton setAccessibilityValue:_committee.persist ? @"Following" : @"Not Following"];
    
    if (_committee.persist) {
        [[[GAI sharedInstance] defaultTracker] sendEventWithCategory:@"Committee"
                                                          withAction:@"Favorite"
                                                           withLabel:_committee.name
                                                           withValue:nil];
    }
    
#if CONFIGURATION_Beta
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@avorited bill", (self.bill.persist ? @"F" : @"Unf")]];
#endif
}

@end
