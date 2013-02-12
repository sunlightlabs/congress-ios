//
//  SFSegmentedViewController.m
//  Congress
//
//  Created by Daniel Cloud on 2/1/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFSegmentedViewController.h"
#import "SFSegmentedView.h"

@implementation SFSegmentedViewController
{
    SFSegmentedView *__segmentedView;
    UIViewController *__selectedViewController;
}

@synthesize viewControllers = _viewControllers;
@synthesize segmentTitles = _segmentTitles;

+ (instancetype)segmentedViewControllerWithChildViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles
{
    id instance = [[self alloc] init];
    [instance setViewControllers:viewControllers titles:titles];
    return instance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _initialize];
    }
    return self;
}
- (void)loadView
{
	__segmentedView.frame = [[UIScreen mainScreen] bounds];
    __segmentedView.backgroundColor = [UIColor whiteColor];
	self.view = __segmentedView;
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

#pragma mark - SFSegmentedViewController

- (void)setViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles
{
    [self setViewControllers:viewControllers];
    [self setSegmentTitles:titles];
}

- (void)setSegmentTitles:(NSArray *)segmentTitles
{
    _segmentTitles = segmentTitles;
    [__segmentedView.segmentedControl removeAllSegments];
    NSInteger index = 0;
    for (NSString *title in _segmentTitles) {
        [__segmentedView.segmentedControl insertSegmentWithTitle:title atIndex:index animated:NO];
        index++;
    }
    __segmentedView.segmentedControl.selectedSegmentIndex = 0;
}

- (id)viewControllerForSegmentTitle:(NSString *)title
{
    NSInteger index = [_segmentTitles indexOfObjectIdenticalTo:title];
    if (index == NSNotFound) {
        return nil;
    }
    return _viewControllers[index];
}


- (void)displayViewForSegment:(NSInteger)index
{
    if (__selectedViewController) {
        [__selectedViewController willMoveToParentViewController:nil];
        [__selectedViewController removeFromParentViewController];
    }
    __selectedViewController = _viewControllers[index];
    [self addChildViewController:__selectedViewController];
    __segmentedView.contentView = __selectedViewController.view;
    [__selectedViewController didMoveToParentViewController:self];
}

- (id)currentViewController
{
    return __selectedViewController;
}


#pragma mark - Private

-(void)handleSegmentedControllerChangeEvent:(UISegmentedControl *)segmentedControl
{
    if ([segmentedControl isEqual:__segmentedView.segmentedControl]) {
        NSInteger index = [segmentedControl selectedSegmentIndex];
        [self displayViewForSegment:index];
    }
}

- (void)_initialize
{
    if (!__segmentedView) {
        __segmentedView = [[SFSegmentedView alloc] initWithFrame:CGRectZero];
        __segmentedView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [__segmentedView.segmentedControl addTarget:self action:@selector(handleSegmentedControllerChangeEvent:) forControlEvents:UIControlEventValueChanged];
        __segmentedView.segmentedControl.selectedSegmentIndex = 0;
    }
}

@end
