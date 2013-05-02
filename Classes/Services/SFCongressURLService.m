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

+ (NSURL *)landingPageforBillWithId:(NSString *)billId
{
    return [NSURL URLWithFormat:@"%@b/%@", SFCongressURLServiceBase, billId];
}

+ (NSURL *)fullTextPageforBillWithId:(NSString *)billId;
{
    return [NSURL URLWithFormat:@"%@b/%@/text", SFCongressURLServiceBase, billId];
}

+ (NSURL *)landingPageForLegislatorWithId:(NSString *)bioguideId
{
    return [NSURL URLWithFormat:@"%@l/%@", SFCongressURLServiceBase, bioguideId];
}

@end
