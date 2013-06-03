//
//  SFLegislatorSegmentedViewController.m
//  Congress
//
//  Created by Daniel Cloud on 6/3/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorSegmentedViewController.h"
#import "SFLegislator.h"
#import "SFLegislatorService.h"
#import "SFLegislatorDetailViewController.h"
#import "SFBillService.h"
#import "SFSegmentedViewController.h"
#import "SFBillsTableViewController.h"

@interface SFLegislatorSegmentedViewController ()

@end

@implementation SFLegislatorSegmentedViewController
{
    NSArray *_sectionTitles;
    NSInteger *_currentSegmentIndex;
    NSString *_restorationBioguideId;
    SFBillsTableViewController *_sponsoredBillsVC;
    SFLegislatorDetailViewController *_legislatorDetailVC;
    SFSegmentedViewController *_segmentedVC;
//    SSLoadingView *_loadingView;
}

static NSString * const CongressLegislatorBillsTableVC = @"CongressLegislatorBillsTableVC";
static NSString * const CongressLegislatorDetailVC = @"CongressLegislatorDetailVC";
static NSString * const CongressSegmentedLegislatorVC = @"CongressSegmentedLegislatorVC";

@synthesize legislator = _legislator;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _initialize];
        self.restorationIdentifier = NSStringFromClass(self.class);
        self.restorationClass = [self class];
        _restorationBioguideId = nil;
    }
    return self;
}

-(void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    if (_restorationBioguideId) {
        [SFLegislatorService legislatorWithId:_restorationBioguideId completionBlock:^(SFLegislator *legislator) {
            if (legislator) {
                [self setLegislator:legislator];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
         }];
        _restorationBioguideId = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Accessors

- (void)setLegislator:(SFLegislator *)legislator
{
    _legislator = legislator;
    
    _shareableObjects = [NSMutableArray array];
    [_shareableObjects addObject:[NSString stringWithFormat:@"%@ via @SunFoundation", _legislator.titledName]];
    [_shareableObjects addObject:_legislator.shareURL];

    if (_currentSegmentIndex != nil) {
        [_segmentedVC displayViewForSegment:_currentSegmentIndex];
        _currentSegmentIndex = nil;
    }

    _legislatorDetailVC.legislator = _legislator;

//    Fetch sponsored bills
    __weak SFBillsTableViewController *weakSponsoredBillsVC = _sponsoredBillsVC;
    [SFBillService billsWithSponsorId:_legislator.bioguideId page:0 completionBlock:^(NSArray *resultsArray) {
        weakSponsoredBillsVC.items = resultsArray;
        [weakSponsoredBillsVC sortItemsIntoSectionsAndReload];
    }];

//    Fetch legislator votes

    self.title = _legislator.titledName;
    [self.view layoutSubviews];
}

#pragma mark - Private

-(void)_initialize{
    _sectionTitles = @[@"About", @"Bills"];

    _segmentedVC = [[self class] newSegmentedViewController];
    [self addChildViewController:_segmentedVC];
    _segmentedVC.view.frame = self.view.frame;
    [self.view addSubview:_segmentedVC.view];
    [_segmentedVC didMoveToParentViewController:self];

    _legislatorDetailVC = [[self class] newLegislatorDetailViewController];
    _sponsoredBillsVC = [[self class] newSponsoredBillsViewController];
    [_segmentedVC setViewControllers:@[_legislatorDetailVC, _sponsoredBillsVC] titles:_sectionTitles];
    [_segmentedVC displayViewForSegment:0];

//    CGSize size = self.view.frame.size;
//    _loadingView = [[SSLoadingView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
//    _loadingView.backgroundColor = [UIColor primaryBackgroundColor];
//    _loadingView.textLabel.text = @"Loading legislator info.";
//    [self.view addSubview:_loadingView];
}

+ (SFSegmentedViewController *)newSegmentedViewController
{
    SFSegmentedViewController *vc = [SFSegmentedViewController new];
    vc.restorationIdentifier = CongressSegmentedLegislatorVC;
    vc.restorationClass = [self class];
    return vc;
}

+ (SFBillsTableViewController *)newSponsoredBillsViewController
{
    SFBillsTableViewController *vc = [[SFBillsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [vc setSectionTitleGenerator:lastActionAtTitleBlock sortIntoSections:lastActionAtSorterBlock
                           orderItemsInSections:nil cellForIndexPathHandler:nil];
    vc.restorationIdentifier = CongressLegislatorBillsTableVC;
    vc.restorationClass = [self class];
    return vc;
}

+ (SFLegislatorDetailViewController *)newLegislatorDetailViewController
{
    SFLegislatorDetailViewController *vc = [SFLegislatorDetailViewController new];
    vc.restorationIdentifier = CongressLegislatorDetailVC;
    vc.restorationClass = [self class];
    return vc;
}

#pragma mark - UIViewControllerRestoration

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    return [[SFLegislatorSegmentedViewController alloc] initWithNibName:nil bundle:nil];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    NSString *legislatorId = _legislator ? _legislator.bioguideId : _restorationBioguideId;
    [coder encodeObject:legislatorId forKey:@"bioguideId"];
    [coder encodeInteger:[_segmentedVC currentSegmentIndex] forKey:@"segmentIndex"];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    _restorationBioguideId = [coder decodeObjectForKey:@"bioguideId"];
    _currentSegmentIndex = [coder decodeIntegerForKey:@"segmentIndex"];
}

@end
