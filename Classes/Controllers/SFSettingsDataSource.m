//
//  SFSettingsDataSource.m
//  Congress
//
//  Created by Daniel Cloud on 12/9/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFSettingsDataSource.h"
#import "SFSettingCell.h"

@implementation SFSettingsDataSource

#pragma mark - SFCellDataSource

- (SFCellData *)cellDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id item  = [self itemForIndexPath:indexPath];
    if (!item) return nil;

    SFCellData *data = [SFCellData new];
    data.textLabelString = item;
    data.selectable = @NO;

    return data;
}

- (NSString *)cellIdentifier;
{
    return [SFSettingCell defaultCellIdentifer];
}


@end
