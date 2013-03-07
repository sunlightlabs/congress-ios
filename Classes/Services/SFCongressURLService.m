//
//  SFCongressURLService.m
//  Congress
//
//  Created by Daniel Cloud on 2/22/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCongressURLService.h"

@implementation SFCongressURLService

static NSString * const SFCongressURLServiceBase = @"http://cngr.es/";

+ (NSURL *)urlForBillId:(NSString *)billId
{
    return [NSURL URLWithFormat:@"%@b/%@", SFCongressURLServiceBase, billId];
}

+ (NSURL *)urlForLegislatorId:(NSString *)bioguideId
{
    return [NSURL URLWithFormat:@"%@l/%@", SFCongressURLServiceBase, bioguideId];
}

@end
