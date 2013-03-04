//
//  SFBillCell.h
//  Congress
//
//  Created by Daniel Cloud on 2/20/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFPanopticCell.h"
@class SFBill;

@interface SFBillCell : SFPanopticCell

@property (strong, nonatomic) SFBill *bill;

- (void)updateDisplay;

@end
