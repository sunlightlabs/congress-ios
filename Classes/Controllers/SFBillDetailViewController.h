//
//  SFBillDetailViewController.h
//  Congress
//
//  Created by Daniel Cloud on 12/4/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFShareableViewController.h"
#import "SFFollowing.h"

@class SFBill;

@interface SFBillDetailViewController : SFShareableViewController <SFFollowing>

@property (nonatomic, strong) SFBill *bill;

@end
