//
//  SFSettingCell.m
//  Congress
//
//  Created by Daniel Cloud on 12/9/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFSettingCell.h"

@implementation SFSettingCell

@synthesize settingIdentifier;

+ (NSString *)defaultCellIdentifer {
    return NSStringFromClass([self class]);
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryView = [[UISwitch alloc] initWithFrame:CGRectZero];
        [self.accessoryView setHidden:NO];
        [self setSelectable:NO];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

@end
