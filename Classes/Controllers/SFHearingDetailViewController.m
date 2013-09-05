//
//  SFHearingDetailViewController.m
//  Congress
//
//  Created by Jeremy Carbaugh on 8/23/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFHearingDetailViewController.h"
#import "SFCalloutView.h"
#import "SFCalendarActivity.h"
#import "SFHearingActivityItemProvider.h"
#import <EventKit/EventKit.h>

@implementation SFHearingDetailViewController {
    SSLoadingView *_loadingView;
    SFHearing *_hearing;
    UIView *_containerView;
    UIScrollView *_scrollView;
    UIBarButtonItem *_calendarButton;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.screenName = @"Hearing Detail Screen";
        self.restorationIdentifier = NSStringFromClass(self.class);
        self.title = @"Committee Hearing";
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
    
    _calendarButton = [UIBarButtonItem locationButtonWithTarget:self action:@selector(addToCalendar)];
    [_calendarButton setAccessibilityLabel:@"Add Hearing to Calendar"];
    self.navigationItem.rightBarButtonItem = _calendarButton;
    
    self.view = _containerView;
}

- (void)viewDidLoad
{
    NSLog(@"----> [SFHearingDetailViewController] viewDidLoad:");
    [super viewDidLoad];
    
    NSDictionary *views = @{@"scroll": _scrollView};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scroll]|" options:0 metrics: 0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scroll]|" options:0 metrics: 0 views:views]];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"----> [SFHearingDetailViewController] viewWillAppear:");
    [super viewWillAppear:animated];
    
    if (_hearing) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterFullStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        
        [_detailView.committeePrefixLabel setText:@"Hearing of the"];
        [_detailView.committeePrefixLabel sizeToFit];
        
        [_detailView.committeePrimaryLabel setText:[NSString stringWithFormat:@"%@ %@", _hearing.committee.prefixName, _hearing.committee.primaryName]];
        [_detailView.committeePrimaryLabel sizeToFit];
        
        [_detailView.occursAtLabel setText:[dateFormatter stringFromDate:_hearing.occursAt]];
        [_detailView.occursAtLabel sizeToFit];
        
        [_detailView.locationLabel setText:_hearing.room];
        [_detailView.locationLabel sizeToFit];
        
        [_detailView.descriptionLabel setText:_hearing.description lineSpacing:[NSParagraphStyle lineSpacing]];
        [_detailView.descriptionLabel sizeToFit];
        
        [_detailView.relatedBillsButton sizeToFit];
        
        [_loadingView removeFromSuperview];
    }
}

- (void)viewDidLayoutSubviews
{
    NSLog(@"----> [SFHearingDetailViewController] viewDidLayoutSubviews:");
//    _detailView.descriptionLabel.top = _detailView.calloutView.bottom + 10.0f;
//    _detailView.relatedBillsButton.top = _detailView.descriptionLabel.bottom + 10.0f;
    [_scrollView setContentSize:CGSizeMake(self.view.width, _detailView.descriptionLabel.bottom + 30.0f)];
    [self.view layoutSubviews];
//    _detailView.descriptionLabel.hidden = NO;
    [super viewDidLayoutSubviews];
}

#pragma mark - private

- (void)_init
{

}

- (void)addToCalendar
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (granted) {
            [self performSelectorOnMainThread:@selector(presentEventEditViewControllerWithStore:) withObject:eventStore waitUntilDone:NO];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to add to calendar"
                                                            message:@"Sorry, we can't add events unless you've given us access to your calendar."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (void)presentEventEditViewControllerWithStore:(EKEventStore *)eventStore
{
    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
    [event setTitle:[NSString stringWithFormat:@"%@ Hearing", _hearing.committee.name]];
    [event setStartDate:_hearing.occursAt];
    [event setEndDate:[_hearing.occursAt dateByAddingTimeInterval:60 * 60]];
    [event setLocation:_hearing.room];
    [event setNotes:_hearing.description];
    [event setURL:_hearing.url];
    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
    
    EKEventEditViewController *vc = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
    [vc setEvent:event];
    [vc setEventStore:eventStore];
    [vc setDelegate:(id)self];
    
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - public

- (void)updateWithHearing:(SFHearing *)hearing
{
    _hearing = hearing;
}

#pragma mark - SFActivity

- (NSArray *)activityItems
{
    if (_hearing) {
        NSMutableArray *items = [[NSMutableArray alloc] init];
        [items addObject:[[SFHearingActivityItemProvider alloc] initWithPlaceholderItem:_hearing]];
        if (_hearing.url) {
            [items addObject:_hearing.url];
        }
        return items;
    }
    return nil;
}

- (NSArray *)applicationActivities
{
    if (_hearing) {
        return @[[SFCalendarActivity activityForHearing:_hearing]];
    }
    return nil;
}

#pragma mark - EKEventEditViewDelegate

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    if (action == EKEventEditViewActionCanceled) {
        
    } else if (action == EKEventEditViewActionSaved) {
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
