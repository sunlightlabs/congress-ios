//
//  SFEditFollowedViewController.m
//  Congress
//
//  Created by Daniel Cloud on 3/12/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFEditFollowedViewController.h"
#import "SFSegmentedViewController.h"
#import "SFLegislatorTableViewController.h"
#import "SFEditBillsTableViewController.h"
#import "SFBill.h"
#import "SFLegislator.h"
#import "SFCongressButton.h"
#import "SFFollowButton.h"
#import "SFDataArchiver.h"

@interface SFEditFollowedViewController ()  <UIGestureRecognizerDelegate>

@end

@implementation SFEditFollowedViewController
{
    NSArray *_followedBills;
    NSArray *_followedLegislators;
    SFSegmentedViewController *_segmentedVC;
    SFEditBillsTableViewController *_followedBillsVC;
    SFLegislatorTableViewController *_followedLegislatorsVC;
}

@synthesize saveButton = _saveButton;

- (id)init
{
    self = [super init];
    
    if (self) {
    
        self.screenName = @"Favorites Edit Screen";
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
    
        self.title = @"Settings";
        
        _segmentedVC = [[SFSegmentedViewController alloc] initWithNibName:nil bundle:nil];
        _segmentedVC.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addChildViewController:_segmentedVC];

        _saveButton = [[SFCongressButton alloc] init];
        [_saveButton setTitle:@"Save" forState:UIControlStateNormal];
        _saveButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_saveButton addTarget:self action:@selector(saveButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [_saveButton sizeToFit];

        _followedBillsVC = [[SFEditBillsTableViewController alloc] initWithStyle:UITableViewStylePlain];
        _followedLegislatorsVC = [[SFLegislatorTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [_segmentedVC setViewControllers:@[_followedBillsVC, _followedLegislatorsVC] titles:@[@"Bills", @"Legislators"]];


        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDidSave:) name:SFDataArchiveSaveCompletedNotification object:nil];
    }
    return self;
}


-(void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor primaryBackgroundColor];
	self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _segmentedVC.view.frame = self.view.frame;
    [self.view addSubview:_segmentedVC.view];
    [_segmentedVC didMoveToParentViewController:self];
    
    [_segmentedVC displayViewForSegment:0];
    
    [self.view addSubview:_saveButton];
    CGSize saveButtonSize = [_saveButton size];

    NSDictionary *viewsDictionary = @{@"segmentedView": _segmentedVC.view, @"saveButton":_saveButton};
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|[segmentedView]|"
                               options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-[saveButton(buttonWidth)]-|"
                               options:0 metrics:@{@"buttonWidth":@(saveButtonSize.width)} views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|[segmentedView]-[saveButton(buttonHeight)]-5-|"
                               options:0 metrics:@{@"buttonHeight":@(saveButtonSize.height)} views:viewsDictionary]];
}

- (void)viewWillAppear:(BOOL)animated
{
    _followedBillsVC.dataProvider.items = _followedBills ?: [SFBill allObjectsToPersist];
    [_followedBillsVC reloadTableView];

    _followedLegislatorsVC.dataProvider.items = _followedLegislators ?: [SFLegislator allObjectsToPersist];
    [_followedLegislatorsVC reloadTableView];
    
    _followedBills = nil;
    _followedLegislators = nil;

    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveButtonPress:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:SFDataArchiveSaveRequestNotification object:nil]];
}

- (void)handleDidSave:(id)sender
{
    _followedBillsVC.dataProvider.items = [SFBill allObjectsToPersist];
    [_followedBillsVC reloadTableView];

    _followedLegislatorsVC.dataProvider.items = [SFLegislator allObjectsToPersist];
    [_followedLegislatorsVC reloadTableView];
}

#pragma mark - UIViewControllerRestoration

+ (UIViewController*)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    return [[SFEditFollowedViewController alloc] init];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];
    [coder encodeInteger:[_segmentedVC currentSegmentIndex] forKey:@"selectedSegment"];
    [coder encodeObject:[_followedBillsVC.dataProvider items] forKey:@"followedBills"];
    [coder encodeObject:[_followedLegislatorsVC.dataProvider items] forKey:@"followedLegislators"];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];
    [_segmentedVC displayViewForSegment:[coder decodeIntegerForKey:@"selectedSegment"]];
    _followedBills = [coder decodeObjectForKey:@"followedBills"];
    _followedLegislators = [coder decodeObjectForKey:@"followedLegislators"];
}

@end
