//
//  SFSettingsDataSource.m
//  Congress
//
//  Created by Daniel Cloud on 12/9/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFSettingsDataSource.h"
#import "SFAppSettings.h"
#import "SFSettingCell.h"

@implementation SFSettingsDataSource
{
    NSDictionary *_settingsMap;
    NSMutableDictionary *_switchMap;
}

- (id)init
{
    self = [super init];
    if (self) {
        _switchMap = [NSMutableDictionary dictionary];
        _settingsMap = @{
                    kSFBillActionSetting: @"Bill Action",
                      kSFBillVoteSetting: @"Bill Vote",
                  kSFBillUpcomingSetting: @"Bill Upcoming",
         kSFCommitteeBillReferredSetting: @"Committee Bill Referred",
           kSFLegislatorBillIntroSetting: @"Legislator Bill Intro",
        kSFLegislatorBillUpcomingSetting: @"Legislator Bill Upcoming",
                kSFLegislatorVoteSetting: @"Legislator Vote"
        };

        self.sections = @[
            [_settingsMap objectsForKeys:@[kSFBillActionSetting, kSFBillVoteSetting, kSFBillUpcomingSetting] notFoundMarker:[NSNull null]],
            [_settingsMap objectsForKeys:@[kSFCommitteeBillReferredSetting] notFoundMarker:[NSNull null]],
            [_settingsMap objectsForKeys:@[kSFLegislatorBillIntroSetting, kSFLegislatorBillUpcomingSetting, kSFLegislatorVoteSetting] notFoundMarker:[NSNull null]],
        ];
        
        self.sectionTitles = @[@"Notifications on Bills",
                               @"Notifications on Committees",
                               @"Notifications on Legislators"];
    }
    return self;
}

- (NSString *)_settingIdentifierItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *item  = (NSString *)[self itemForIndexPath:indexPath];
    NSArray *matches = [_settingsMap allKeysForObject:item];
    if ([matches count] > 1) {
        return nil;
    }
    return (NSString *)[matches firstObject];
}

#pragma mark - SFCellDataSource

- (SFCellData *)cellDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id item  = [self itemForIndexPath:indexPath];
    if (!item) return nil;

    SFCellData *data = [SFCellData new];
    data.textLabelString = (NSString *)item;
    data.selectable = @NO;

    return data;
}

- (SFSettingCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFSettingCell *cell = (SFSettingCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.settingIdentifier = [self _settingIdentifierItemAtIndexPath:indexPath];
    [_switchMap setValue:cell forKey:cell.settingIdentifier];
    if ([cell.accessoryView isKindOfClass:[UISwitch class]]) {
        [_switchMap setObject:cell.accessoryView forKey:cell.settingIdentifier];
        UISwitch *cellSwitch = (UISwitch *)(cell.accessoryView);
        BOOL settingOn = [[SFAppSettings sharedInstance] boolForNotificationSetting:cell.settingIdentifier];
        [cellSwitch setOn:settingOn];
        [cellSwitch removeTarget:self action:NULL forControlEvents:UIControlEventValueChanged];
        [cellSwitch addTarget:self action:@selector(handleCellSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }

    return cell;
}

- (NSString *)cellIdentifier;
{
    return [SFSettingCell defaultCellIdentifer];
}

- (void)handleCellSwitchValueChanged:(id)target
{
    UISwitch *cellSwitch = (UISwitch *)target;
    NSString *settingIdentifier = [[_switchMap allKeysForObject:cellSwitch] lastObject];
    [[SFAppSettings sharedInstance] setBool:[cellSwitch isOn] forNotificationSetting:settingIdentifier];
}


@end
