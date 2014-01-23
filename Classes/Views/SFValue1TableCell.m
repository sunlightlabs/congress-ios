//
//  SFValue1TableCell.m
//  Congress
//
//  Created by Daniel Cloud on 11/26/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFValue1TableCell.h"

@implementation SFValue1TableCell

static NSString *__defaultCellIdentifer;

+ (void)load {
    __defaultCellIdentifer = NSStringFromClass([self class]);
}

+ (NSString *)defaultCellIdentifer {
    return __defaultCellIdentifer;
}

+ (NSInteger)defaultCellStyle {
    return UITableViewCellStyleValue1;
}

@end
