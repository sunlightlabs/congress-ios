//
//  SFCommitteeSegmentedViewController.m
//  Congress
//
//  Created by Jeremy Carbaugh on 7/20/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCommitteeSegmentedViewController.h"
#import "SFCommitteeService.h"

@interface SFCommitteeSegmentedViewController ()

@end

@implementation SFCommitteeSegmentedViewController {
    NSString *_committeeId;
    SFCommittee *_committee;
    NSInteger *_currentSegmentIndex;
}

@synthesize segmentedController = _segmentedController;
@synthesize membersController = _membersController;
@synthesize subcommitteesController = _subcommitteesController;

- (id)initWithCommittee:(SFCommittee *)committee
{
    self = [self initWithNibName:nil bundle:nil];
    [self updateWithCommittee:committee];
    return self;
}

- (id)initWithCommitteeId:(NSString *)committeeId
{
    self = [self initWithNibName:nil bundle:nil];
    _committeeId = committeeId;
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.restorationIdentifier = NSStringFromClass(self.class);
        self.restorationClass = [self class];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    if (_committeeId && _committee == nil) {
        [SFCommitteeService committeeWithId:_committeeId completionBlock:^(SFCommittee *committee) {
            [self updateWithCommittee:committee];
        }];
    }
}

#pragma mark - public
         
- (void)updateWithCommittee:(SFCommittee *)committee
{
    _committee = committee;
    _committeeId = committee.committeeId;
    
    
    
    if (_currentSegmentIndex) {
        [_segmentedController displayViewForSegment:_currentSegmentIndex];
        _currentSegmentIndex = nil;
    }
}
         
#pragma mark - UIViewControllerRestoration

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    return [[SFCommitteeSegmentedViewController alloc] initWithNibName:nil bundle:nil];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    NSString *committeeId = _committee ? _committee.committeeId : _committeeId;
    [coder encodeObject:committeeId forKey:@"committeeId"];
    [coder encodeInteger:[_segmentedController currentSegmentIndex] forKey:@"segmentIndex"];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    _committeeId = [coder decodeObjectForKey:@"committeeId"];
    _currentSegmentIndex = [coder decodeIntegerForKey:@"segmentIndex"];
}

@end
