//
//  SVPullToRefreshView+Congress.h
//  Congress
//
//  Created by Daniel Cloud on 3/22/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "UIScrollView+SVPullToRefresh.h"

@interface SVPullToRefreshView (Congress)

- (void)setLastUpdatedNow;
- (void)stopAnimatingAndSetLastUpdatedNow;

@end
