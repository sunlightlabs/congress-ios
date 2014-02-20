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
        
        /* notifications */
        
        [settingsMap addEntriesFromDictionary:@{
            SFBillActionSetting: @"Is vetoed or signed into law by the President",
            SFBillSignedSetting: @"Is signed into law by the President",
            SFBillVoteSetting: @"Is voted on",
            SFBillUpcomingSetting: @"Is scheduled for a vote",
            SFLegislatorBillIntroSetting: @"Introduces a bill",
            SFLegislatorBillUpcomingSetting: @"Sponsors a bill that is scheduled for a vote",
            SFOtherAppSetting: @"Congress App status and other updates",
            SFOtherImportantSetting: @"Other important congressional information",
//            SFLegislatorVoteSetting: @"Votes on a bill"
//            SFCommitteeBillReferredSetting: @"Committee Bill Referred",
        }];
        
        [self setSettingsMap:settingsMap];
        
        self.sections = [self.sections arrayByAddingObjectsFromArray:@[
            [settingsMap objectsForKeys:@[SFLegislatorBillIntroSetting, SFLegislatorBillUpcomingSetting] notFoundMarker:[NSNull null]],
            [settingsMap objectsForKeys:@[SFBillUpcomingSetting, SFBillVoteSetting, SFBillActionSetting] notFoundMarker:[NSNull null]],
            [settingsMap objectsForKeys:@[SFBillSignedSetting] notFoundMarker:[NSNull null]],
            [settingsMap objectsForKeys:@[SFOtherImportantSetting, SFOtherAppSetting] notFoundMarker:[NSNull null]],
//            [settingsMap objectsForKeys:@[SFCommitteeBillReferredSetting] notFoundMarker:[NSNull null]],
        ]];

        self.sectionTitles = [self.sectionTitles arrayByAddingObjectsFromArray:@[
            @"When a legislator I follow",
            @"When a bill I follow",
            @"When any bill",
            @"Other",
//            @"When a committee I follow",
        ]];
    }
    return self;
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

- (SFCellData *)cellDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    SFCellData *data = [super cellDataForItemAtIndexPath:indexPath];
    return data;
}

@end
