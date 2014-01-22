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
                SFGoogleAnalyticsOptOut: @"Enable anonymous analytics reporting",
        };

        NSDictionary *notificationSettings = @{
           SFBillActionSetting: @"Is vetoed or signed by the President",
           SFBillVoteSetting: @"Is voted on",
           SFBillUpcomingSetting: @"Is scheduled for a vote",
           SFCommitteeBillReferredSetting: @"Committee Bill Referred",
           SFLegislatorBillIntroSetting: @"Introduces a bill",
           SFLegislatorBillUpcomingSetting: @"Sponsors a bill that is schedule for a vote",
           SFLegislatorVoteSetting: @"Votes on a bill"
       };

        BOOL isTestingNotifications = [[SFAppSettings sharedInstance] boolForTestingSetting:SFTestingNotificationsSetting];
        if (isTestingNotifications) {
            NSMutableDictionary *testSettings = [NSMutableDictionary dictionaryWithDictionary:_settingsMap];
            [testSettings addEntriesFromDictionary:notificationSettings];
            _settingsMap = [testSettings copy];
        }
        
        self.sections = @[
            [_settingsMap objectsForKeys:@[SFGoogleAnalyticsOptOut] notFoundMarker:[NSNull null]],
        ];

        NSArray *notificationSections = @[
            [_settingsMap objectsForKeys:@[SFLegislatorBillIntroSetting, SFLegislatorBillUpcomingSetting, SFLegislatorVoteSetting] notFoundMarker:[NSNull null]],
            [_settingsMap objectsForKeys:@[SFBillVoteSetting, SFBillUpcomingSetting, SFBillActionSetting] notFoundMarker:[NSNull null]],
            [_settingsMap objectsForKeys:@[SFCommitteeBillReferredSetting] notFoundMarker:[NSNull null]],
        ];

        self.sectionTitles = @[
           @"Analytics Reporting",
        ];

        NSArray *notificationSectionTitles = @[
            @"When a legislator I follow",
            @"When a bill I follow",
            @"When a committee I follow"
        ];

        if (isTestingNotifications) {
            self.sections = [self.sections arrayByAddingObjectsFromArray:notificationSections];
            self.sectionTitles = [self.sectionTitles arrayByAddingObjectsFromArray:notificationSectionTitles];
        }

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
    if ([[self _settingIdentifierItemAtIndexPath:indexPath] isEqualToString:SFGoogleAnalyticsOptOut]) {
        data.detailTextLabelString = @"Sunlight uses Google Analytics to learn about aggregate usage of the app. Nothing personally identifiable is recorded.";
        data.detailTextLabelNumberOfLines = 3;
        data.detailTextLabelFont = [UIFont cellSecondaryDetailFont];
    }

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
