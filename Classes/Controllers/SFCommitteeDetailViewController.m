//
//  SFCommitteeDetailViewController.m
//  Congress
//
//  Created by Jeremy Carbaugh on 7/22/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCommitteeDetailViewController.h"
#import "SFCalloutView.h"
#import <GAI.h>

@interface SFCommitteeDetailViewController ()

@end

@implementation SFCommitteeDetailViewController {
    SFCommittee *_committee;
    SFCalloutView *_calloutView;
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
        [self _init];
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] init];
    [view setFrame:[[UIScreen mainScreen] bounds]];
    [view setBackgroundColor:[UIColor primaryBackgroundColor]];
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_calloutView addSubview:_nameLabel];
    [_calloutView addSubview:_favoriteButton];
    
    [self.view addSubview:_calloutView];
    
    /* manual layout */

    [_calloutView setFrame:CGRectMake(4, 0, 312, 180)];
    [_nameLabel setFrame:CGRectMake(0, 0, 280, 100)];
    [_committeeTableController.view setFrame:CGRectMake(0, 200, 320, 280)];
    
    [_calloutView setNeedsLayout];

}

#pragma mark - private

- (void)_init
{
    _calloutView = [[SFCalloutView alloc] initWithFrame:CGRectZero];
    
    _nameLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _nameLabel.font = [UIFont legislatorTitleFont];
    _nameLabel.textColor = [UIColor primaryTextColor];
    _nameLabel.numberOfLines = 2;
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _nameLabel.verticalTextAlignment = SSLabelVerticalTextAlignmentTop;
    _nameLabel.backgroundColor = [UIColor clearColor];
    [_nameLabel setAccessibilityLabel:@"Legislator"];
    
    _favoriteButton = [[SFFavoriteButton alloc] init];
    [_favoriteButton addTarget:self action:@selector(handleFavoriteButtonPress) forControlEvents:UIControlEventTouchUpInside];
    
    _committeeTableController = [[SFCommitteesTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [_committeeTableController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
}

#pragma mark - public

- (void)updateWithCommittee:(SFCommittee *)committee
{
    _committee = committee;
    
    _nameLabel.text = _committee.name;
    [_nameLabel setAccessibilityLabel:@"Name of committee"];
    [_nameLabel setAccessibilityValue:_committee.name];
    [_nameLabel sizeToFit];
    
    _favoriteButton.selected = _committee.persist;
    [_favoriteButton setAccessibilityLabel:@"Follow commmittee"];
    [_favoriteButton setAccessibilityValue:_committee.persist ? @"Following" : @"Not Following"];
    [_favoriteButton setAccessibilityHint:@"Follow this committee to see the lastest updates in the Following section."];
    [_favoriteButton setFrame:CGRectMake(270, _nameLabel.height + 5, 20, 20)];
    
    if (![committee isSubcommittee]) {
        [self.view addSubview:_committeeTableController.view];
        [self addChildViewController:_committeeTableController];
    }
    
    [self.view setNeedsLayout];
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
