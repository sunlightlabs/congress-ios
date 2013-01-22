//
//  SFBillDetailViewController.h
//  Congress
//
//  Created by Daniel Cloud on 12/4/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFShareableViewController.h"

@class Bill;
@class SFBillDetailView;

@interface SFBillDetailViewController : SFShareableViewController

@property (nonatomic, strong, setter=setBill:) Bill *bill;

@property (nonatomic, strong) SFBillDetailView *billDetailView;


@end
