//
//  SFSegmentedViewController.h
//  Congress
//
//  Created by Daniel Cloud on 2/1/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFSegmentedViewController : UIViewController

@property (nonatomic, retain) NSArray *viewControllers;
@property (nonatomic, retain) NSArray *segmentTitles;
@property (nonatomic, readonly) id currentViewController;
@property (nonatomic, readonly) NSInteger currentSegmentIndex;

+ (instancetype)segmentedViewControllerWithChildViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles;
- (void)setViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles;
- (id)viewControllerForSegmentTitle:(NSString *)title;
- (void)displayViewForSegment:(NSInteger)index;

@end
