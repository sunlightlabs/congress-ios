//
//  SFBillSegmentedViewController.m
//  Congress
//
//  Created by Daniel Cloud on 12/4/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFBillSegmentedViewController.h"
#import "SFBillDetailView.h"
#import "SFBillService.h"
#import "SFSegmentedViewController.h"
#import "SFBillDetailViewController.h"
#import "SFActionTableViewController.h"
#import "SFBill.h"
#import "SFLegislatorService.h"
#import "SFLegislator.h"
#import "SFRollCallVoteService.h"
#import "SFCongressGovActivity.h"
#import "SFBillActivityItemSource.h"
#import <SAMLoadingView/SAMLoadingView.h>

@interface SFBillSegmentedViewController () <UIViewControllerRestoration>

@end

@implementation SFBillSegmentedViewController
{
    NSArray *_sectionTitles;
    NSInteger *_currentSegmentIndex;
    NSString *_restorationBillId;
    SFActionTableViewController *_actionListVC;
    SFBillDetailViewController *_billDetailVC;
    SFSegmentedViewController *_segmentedVC;
    SAMLoadingView *_loadingView;
}

static NSString *const CongressActionTableVC = @"CongressActionTableVC";
static NSString *const CongressBillDetailVC = @"CongressBillDetailVC";
static NSString *const CongressSegmentedBillVC = @"CongressSegmentedBillVC";

static NSString *const BillFetchErrorMessage = @"Unable to fetch bill";

@synthesize bill = _bill;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self _initialize];
        self.restorationIdentifier = NSStringFromClass(self.class);
        self.restorationClass = [self class];
        _restorationBillId = nil;
    }
    return self;
}

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_restorationBillId) {
        __weak SFBillSegmentedViewController *weakSelf = self;
        [SFBillService billWithId:_restorationBillId completionBlock: ^(SFBill *bill) {
            __strong SFBillSegmentedViewController *strongSelf = weakSelf;
            if (bill) {
                [strongSelf setBill:bill];
            }
            else {
                [_loadingView.activityIndicatorView stopAnimating];
                [SFMessage showErrorMessageInViewController:strongSelf withMessage:BillFetchErrorMessage];
                CLS_LOG(@"%@", BillFetchErrorMessage);
            }
        }];
        _restorationBillId = nil;
    }
    if (_bill) {
        [[[GAI sharedInstance] defaultTracker] send:
         [[GAIDictionaryBuilder createEventWithCategory:@"Bill"
                                                 action:@"View"
                                                  label:_bill.displayName
                                                  value:nil] build]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Accessors

- (void)setBill:(SFBill *)bill {
    _bill = bill;

    [self.view addSubview:_loadingView];
    [self.view bringSubviewToFront:_loadingView];

    __weak SFBillSegmentedViewController *weakSelf = self;
    [SFBillService billWithId:self.bill.billId completionBlock: ^(SFBill *pBill) {
        __strong SFBillSegmentedViewController *strongSelf = weakSelf;
        if (pBill) {
            strongSelf->_bill = pBill;
            strongSelf->_billDetailVC.bill = pBill;
            _actionListVC.dataProvider.items = [pBill.actions sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"actedAt" ascending:NO]]];

            [SFRollCallVoteService votesForBill:pBill.billId count:[NSNumber numberWithInt:50] completionBlock: ^(NSArray *resultsArray) {
                    if (!resultsArray) {
                        // Network or other error returns nil
//                    [SFMessage showErrorMessageInViewController:strongSelf withMessage:BillsFetchErrorMessage];
                        CLS_LOG(@"Unable to load votesForBill: %@", pBill.billId);
                    }
                    else if ([resultsArray count] > 0) {
                        strongSelf->_bill.rollCallVotes = resultsArray;
                        strongSelf->_actionListVC.dataProvider.items = strongSelf->_bill.actionsAndVotes;
                        [strongSelf->_actionListVC sortItemsIntoSectionsAndReload];
                    }
                }];
            [_loadingView sam_fadeOutAndRemoveFromSuperview];
        }
        else {
            [_loadingView.activityIndicatorView stopAnimating];
            [SFMessage showErrorMessageInViewController:weakSelf withMessage:BillFetchErrorMessage];
        }

        [strongSelf.view layoutSubviews];

        if (_currentSegmentIndex != nil) {
            [_segmentedVC displayViewForSegment:_currentSegmentIndex];
            _currentSegmentIndex = nil;
        }
    }];

    self.title = self.bill.displayName;
    [self.view layoutSubviews];
}

#pragma mark - SFActivity

- (NSArray *)activityItems {
    if (_bill) {
        return @[[[SFBillTextActivityItemSource alloc] initWithBill:_bill],
                 [[SFBillURLActivityItemSource alloc] initWithBill:_bill]];
    }
    return nil;
}

- (NSArray *)applicationActivities {
    if (_bill) {
        return @[[SFCongressGovActivity activityForBill:_bill]];
    }
    return nil;
}

#pragma mark - Public

- (void)setVisibleSegment:(NSString *)segmentName;
{
    NSUInteger segmentIndex = [_segmentedVC.segmentTitles indexOfObjectPassingTest: ^BOOL (id obj, NSUInteger idx, BOOL *stop) {
        if ([segmentName caseInsensitiveCompare:(NSString *)obj] == NSOrderedSame) {
            stop = YES;
            return YES;
        }
        return NO;
    }];
    _currentSegmentIndex = segmentIndex != NSNotFound ? segmentIndex : 0;
}

#pragma mark - Private

- (void)_initialize {
    _sectionTitles = @[@"Summary", @"Activity"];

    _segmentedVC = [[self class] newSegmentedViewController];
    [self addChildViewController:_segmentedVC];
    _segmentedVC.view.frame = self.view.frame;
    [self.view addSubview:_segmentedVC.view];
    [_segmentedVC didMoveToParentViewController:self];


    _actionListVC = [[self class] newActionTableController];
    _billDetailVC = [[self class] newBillDetailViewController];
    [_segmentedVC setViewControllers:@[_billDetailVC, _actionListVC] titles:_sectionTitles];
    [_segmentedVC displayViewForSegment:0];

    CGSize size = self.view.frame.size;
    _loadingView = [[SAMLoadingView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    _loadingView.backgroundColor = [UIColor primaryBackgroundColor];
    _loadingView.textLabel.text = @"Loading bill info.";
    [self.view addSubview:_loadingView];
}

+ (SFSegmentedViewController *)newSegmentedViewController {
    SFSegmentedViewController *vc = [SFSegmentedViewController new];
    vc.restorationIdentifier = CongressSegmentedBillVC;
    vc.restorationClass = [self class];
    return vc;
}

+ (SFActionTableViewController *)newActionTableController {
    SFActionTableViewController *vc = [[SFActionTableViewController alloc] initWithStyle:UITableViewStylePlain];
    vc.restorationIdentifier = CongressActionTableVC;
    vc.restorationClass = [self class];
    return vc;
}

+ (SFBillDetailViewController *)newBillDetailViewController {
    SFBillDetailViewController *vc = [SFBillDetailViewController new];
    vc.restorationIdentifier = CongressBillDetailVC;
    vc.restorationClass = [self class];
    return vc;
}

#pragma mark - UIViewControllerRestoration

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder {
    return [[SFBillSegmentedViewController alloc] initWithNibName:nil bundle:nil];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    NSString *billId = _bill ? _bill.billId : _restorationBillId;
    [coder encodeObject:billId forKey:@"billId"];
    [coder encodeInteger:[_segmentedVC currentSegmentIndex] forKey:@"segmentIndex"];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    _restorationBillId = [coder decodeObjectForKey:@"billId"];
    _currentSegmentIndex = [coder decodeIntegerForKey:@"segmentIndex"];
}

@end
