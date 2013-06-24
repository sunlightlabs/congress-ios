//
//  SFSegmentedViewController.h
//  Congress
//
//  Created by Daniel Cloud on 2/1/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFSegmentedView.h"

@interface SFSegmentedViewController : UIViewController

@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) NSArray *segmentTitles;
@property (weak, nonatomic, readonly) id currentViewController;
@property (nonatomic, readonly) NSInteger currentSegmentIndex;
@property (weak, nonatomic, readonly) SFSegmentedView *segmentedView;

+ (instancetype)segmentedViewControllerWithChildViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles;
- (void)setViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles;
- (id)viewControllerForSegmentTitle:(NSString *)title;
- (void)displayViewForSegment:(NSInteger)index;

@end
