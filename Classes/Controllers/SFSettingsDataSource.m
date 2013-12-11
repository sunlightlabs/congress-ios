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

NSString *const SFSettingsValueChangeNotification = @"SFSettingsValueChangeNotification";

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
                    SFBillActionSetting: @"Bill Action",
                      SFBillVoteSetting: @"Bill Vote",
                  SFBillUpcomingSetting: @"Bill Upcoming",
         SFCommitteeBillReferredSetting: @"Committee Bill Referred",
           SFLegislatorBillIntroSetting: @"Legislator Bill Intro",
        SFLegislatorBillUpcomingSetting: @"Legislator Bill Upcoming",
                SFLegislatorVoteSetting: @"Legislator Vote"
        };

        self.sections = @[
            [_settingsMap objectsForKeys:@[SFBillActionSetting, SFBillVoteSetting, SFBillUpcomingSetting] notFoundMarker:[NSNull null]],
            [_settingsMap objectsForKeys:@[SFCommitteeBillReferredSetting] notFoundMarker:[NSNull null]],
            [_settingsMap objectsForKeys:@[SFLegislatorBillIntroSetting, SFLegislatorBillUpcomingSetting, SFLegislatorVoteSetting] notFoundMarker:[NSNull null]],
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
    NSDictionary *userInfo = @{@"settingIdentifier": settingIdentifier, @"value": [NSNumber numberWithBool:[cellSwitch isOn]]};
    [[NSNotificationCenter defaultCenter] postNotificationName:SFSettingsValueChangeNotification object:self userInfo:userInfo];
}


@end
