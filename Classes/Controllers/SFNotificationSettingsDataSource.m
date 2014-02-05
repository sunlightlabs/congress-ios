//
//  SFNotificationSettingsDataSource.m
//  Congress
//
//  Created by Jeremy Carbaugh on 2/5/14.
//  Copyright (c) 2014 Sunlight Foundation. All rights reserved.
//

#import "SFNotificationSettingsDataSource.h"
#import "SFSettingCell.h"

@implementation SFNotificationSettingsDataSource

- (id)init {
    self = [super init];
    if (self) {
        
        NSMutableDictionary *settingsMap = [NSMutableDictionary dictionary];
        
        /* analytics */
        [settingsMap addEntriesFromDictionary:@{SFGoogleAnalyticsOptOut: @"Enable anonymous analytics reporting"}];
        
        /* notifications */
        
        [settingsMap addEntriesFromDictionary:@{
            SFBillActionSetting: @"Is vetoed or signed by the President",
            SFBillVoteSetting: @"Is voted on",
            SFBillUpcomingSetting: @"Is scheduled for a vote",
            SFCommitteeBillReferredSetting: @"Committee Bill Referred",
            SFLegislatorBillIntroSetting: @"Introduces a bill",
            SFLegislatorBillUpcomingSetting: @"Sponsors a bill that is schedule for a vote",
            SFLegislatorVoteSetting: @"Votes on a bill"
        }];
        
        [self setSettingsMap:settingsMap];
        
        self.sections = [self.sections arrayByAddingObjectsFromArray:@[
            [settingsMap objectsForKeys:@[SFLegislatorBillIntroSetting, SFLegislatorBillUpcomingSetting, SFLegislatorVoteSetting] notFoundMarker:[NSNull null]],
            [settingsMap objectsForKeys:@[SFBillVoteSetting, SFBillUpcomingSetting, SFBillActionSetting] notFoundMarker:[NSNull null]],
            [settingsMap objectsForKeys:@[SFCommitteeBillReferredSetting] notFoundMarker:[NSNull null]],
            [settingsMap objectsForKeys:@[SFGoogleAnalyticsOptOut] notFoundMarker:[NSNull null]],
        ]];

        self.sectionTitles = [self.sectionTitles arrayByAddingObjectsFromArray:@[
            @"When a legislator I follow",
            @"When a bill I follow",
            @"When a committee I follow",
            @"Analytics Reporting"
        ]];
    }
    return self;
}

- (SFCellData *)cellDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    SFCellData *data = [super cellDataForItemAtIndexPath:indexPath];
    if ([[self settingIdentifierItemAtIndexPath:indexPath] isEqualToString:SFGoogleAnalyticsOptOut]) {
        data.detailTextLabelString = @"Sunlight uses Google Analytics to learn about aggregate usage of the app. Nothing personally identifiable is recorded.";
        data.detailTextLabelNumberOfLines = 3;
        data.detailTextLabelFont = [UIFont cellSecondaryDetailFont];
    }
    return data;
}

- (BOOL)valueForSetting:(NSString *)settingIdentifier withSwitch:(UISwitch *)control
{
    BOOL value = NO;
    if ([settingIdentifier isEqualToString:SFGoogleAnalyticsOptOut]) {
        value = ![[SFAppSettings sharedInstance] googleAnalyticsOptOut];
    }
    else {
        value = [[SFAppSettings sharedInstance] boolForNotificationSetting:settingIdentifier];
        BOOL notificationsEnabled = [[SFAppSettings sharedInstance] remoteNotificationTypesEnabled];
        control.enabled = notificationsEnabled;
    }
    return value;
}

@end
