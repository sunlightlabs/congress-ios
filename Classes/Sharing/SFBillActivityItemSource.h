//
//  SFBillActivityItemSource.h
//  Congress
//
//  Created by Jeremy Carbaugh on 10/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFBill.h"
#import "SFTextActivityItemSource.h"

@interface SFBillTextActivityItemSource : SFTextActivityItemSource

- (id)initWithBill:(SFBill *)bill;

@end


@interface SFBillURLActivityItemSource : NSObject <UIActivityItemSource>

@property (nonatomic, strong) SFBill *bill;

- (id)initWithBill:(SFBill *)bill;

@end
