//
//  SFCommitteeDetailViewController.m
//  Congress
//
//  Created by Jeremy Carbaugh on 7/22/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCommitteeDetailViewController.h"
#import "SFCommitteeDetailView.h"
#import "SFCommitteeService.h"
#import "SFCalloutView.h"
#import <GAI.h>

@interface SFCommitteeDetailViewController ()

@end

@implementation SFCommitteeDetailViewController {
    SFCommitteeDetailView *_detailView;
    SFCommittee *_committee;
}

@synthesize nameLabel = _nameLabel;
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
    _detailView = [[SFCommitteeDetailView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_detailView setBackgroundColor:[UIColor primaryBackgroundColor]];
    [_detailView.favoriteButton addTarget:self action:@selector(handleFavoriteButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [_detailView.callButton addTarget:self action:@selector(handleCallButtonPress) forControlEvents:UIControlEventTouchUpInside];
    self.view = _detailView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [_calloutView addSubview:_nameLabel];
//    [_calloutView addSubview:_favoriteButton];
//    
//    [self.view addSubview:_calloutView];
    
    /* manual layout */

//    [_calloutView setFrame:CGRectMake(4, 0, 312, 180)];
//    [_nameLabel setFrame:CGRectMake(0, 0, 280, 100)];
//    
//    [_calloutView setNeedsLayout];

}

#pragma mark - private

- (void)_init
{
    _committeeTableController = [[SFCommitteesTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [_committeeTableController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
}

#pragma mark - public

- (void)updateWithCommittee:(SFCommittee *)committee
{
    _committee = committee;
    
    [_detailView.prefixNameLabel setText:[committee prefixName]];
    [_detailView.primaryNameLabel setText:[committee primaryName]];
    [_detailView.primaryNameLabel setAccessibilityLabel:@"Name"];
    [_detailView.primaryNameLabel setAccessibilityValue:[NSString stringWithFormat:@"%@ %@", committee.prefixName, committee.primaryName]];
    
    _detailView.favoriteButton.selected = committee.persist;
    [_detailView.favoriteButton setAccessibilityLabel:@"Follow committee"];
    [_detailView.favoriteButton setAccessibilityValue:committee.persist ? @"Following" : @"Not Following"];
    [_detailView.favoriteButton setAccessibilityHint:@"Follow this committee to see the lastest updates in the Following section."];
    
    if (!_committee.phone) {
        [_detailView.callButton setHidden:YES];
    }
    
    if ([committee isSubcommittee]) {
        [_detailView.noSubcommitteesLabel setText:[NSString stringWithFormat:@"Under the %@.", _committee.parentCommittee.name]];
    }
    else {
        [SFCommitteeService subcommitteesForCommittee:_committee.committeeId completionBlock:^(NSArray *subcommittees) {
            if ([subcommittees count] > 0) {
                [_committeeTableController setItems:subcommittees];
                [_committeeTableController setSectionTitleGenerator:subcommitteeSectionGenerator];
                [_committeeTableController setSortIntoSectionsBlock:subcommitteeSectionSorter];
                [_committeeTableController sortItemsIntoSectionsAndReload];
                _detailView.subcommitteeListView = _committeeTableController.view;
                [self addChildViewController:_committeeTableController];
            }
            else {
                [_detailView.noSubcommitteesLabel setText:@"There are no subcommittees for this committee."];
            }
            [_detailView setNeedsLayout];
        }];
    }
    
    [self.view setNeedsLayout];
}

- (void)handleFavoriteButtonPress
{
    _committee.persist = !_committee.persist;
    [_detailView.favoriteButton setSelected:_committee.persist];
    [_detailView.favoriteButton setAccessibilityValue:_committee.persist ? @"Following" : @"Not Following"];
    
    if (_committee.persist) {
        [[[GAI sharedInstance] defaultTracker] sendEventWithCategory:@"Committee"
                                                          withAction:@"Favorite"
                                                           withLabel:[NSString stringWithFormat:@"%@ %@", _committee.prefixName, _committee.primaryName]
                                                           withValue:nil];
    }
#if CONFIGURATION_Beta
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@avorited committee", (_committee.persist ? @"F" : @"Unf")]];
#endif
}

-(void)handleCallButtonPress
{
    NSString *callButtonTitle = [NSString stringWithFormat:@"Call %@", _committee.phone];
    UIActionSheet *callActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:callButtonTitle, nil];
    callActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [callActionSheet showInView:self.view];
#if CONFIGURATION_Beta
    [TestFlight passCheckpoint:@"Pressed call committee button"];
#endif
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSURL *phoneURL = [NSURL URLWithFormat:@"tel:%@", _committee.phone];
    if (buttonIndex == 0) {
        BOOL urlOpened = [[UIApplication sharedApplication] openURL:phoneURL];
        if (urlOpened) {
            [[[GAI sharedInstance] defaultTracker] sendEventWithCategory:@"Committee"
                                                              withAction:@"Call"
                                                               withLabel:[NSString stringWithFormat:@"%@ %@", _committee.prefixName, _committee.primaryName]
                                                               withValue:nil];
        } else {
            NSLog(@"Unable to open phone url %@", [phoneURL absoluteString]);
        }
    }
}

@end
