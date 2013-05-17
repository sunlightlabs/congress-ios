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

@property (nonatomic, retain) NSArray *viewControllers;
@property (nonatomic, retain) NSArray *segmentTitles;
@property (nonatomic, readonly) id currentViewController;
@property (nonatomic, readonly) NSInteger currentSegmentIndex;
@property (nonatomic, readonly) SFSegmentedView *segmentedView;

+ (instancetype)segmentedViewControllerWithChildViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles;
- (void)setViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles;
- (id)viewControllerForSegmentTitle:(NSString *)title;
- (void)displayViewForSegment:(NSInteger)index;

@end
