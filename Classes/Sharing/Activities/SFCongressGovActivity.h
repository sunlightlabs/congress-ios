//
//  SFCongressGovActivity.h
//  Congress
//
//  Created by Jeremy Carbaugh on 8/27/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFActivity.h"
#import "SFBill.h"

@interface SFCongressGovActivity : SFActivity

@property (nonatomic, strong) NSURL *url;

+ (instancetype)activityForBill:(SFBill *)bill;
+ (instancetype)activityForBillText:(SFBill *)bill;

@end
