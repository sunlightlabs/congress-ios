//
//  SFAnalyticsSettingsDataSource.m
//  Congress
//
//  Created by Jeremy Carbaugh on 2/5/14.
//  Copyright (c) 2014 Sunlight Foundation. All rights reserved.
//

#import "SFInAppSettingsDataSource.h"
#import "SFSettingCell.h"
#import "SFAppSettings.h"

@implementation SFInAppSettingsDataSource

- (id)init {
    self = [super init];
    if (self) {
        
        [self setSettingsMap:[NSMutableDictionary dictionaryWithDictionary:@{@"SFNotificationSettings": @"Notifications",
                                                                             SFGoogleAnalyticsOptOut: @"Enable anonymous analytics",
                                                                             UIApplicationOpenSettingsURLString: @"Location & notifications settings"}]];

        #if CONFIGURATION_Debug
            [self.settingsMap setValue:@"Debug Flags" forKey:SFDebugSettings];
        #endif

        self.sections = @[[self.settingsMap allValues]];

        self.sectionTitles = @[@"Congress App Settings"];
    }
    return self;
}

- (SFCellData *)cellDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    SFCellData *data = [super cellDataForItemAtIndexPath:indexPath];;
    NSString *settingIdentifier = [self settingIdentifierItemAtIndexPath:indexPath];
    if ([settingIdentifier isEqualToString:SFGoogleAnalyticsOptOut]) {
        data.detailTextLabelString = @"We use Google Analytics to learn about aggregate usage of the app. Nothing personally identifiable is recorded.";
        data.detailTextLabelNumberOfLines = 3;
        data.detailTextLabelFont = [UIFont systemFontOfSize:12.0f];
    } else if ([settingIdentifier isEqualToString:@"SFNotificationSettings"]) {
        data.textLabelFont = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        if (![[SFAppSettings sharedInstance] remoteNotificationTypesEnabled]) {
            data.detailTextLabelString = @"Notifications are disabled for Congress App! Favorite something and we'll ask to enable notifications.";
            data.detailTextLabelNumberOfLines = 3;
            data.detailTextLabelFont = [UIFont systemFontOfSize:12.0f];
        }
    } else if ([settingIdentifier isEqualToString:UIApplicationOpenSettingsURLString]) {
        data.detailTextLabelString = @"Opens iOS Settings app";
        data.detailTextLabelFont = [UIFont systemFontOfSize:12.0f];
    } else if ([settingIdentifier isEqualToString:SFDebugSettings]) {
        data.textLabelFont = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    }
    return data;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *settingIdentifier = [self settingIdentifierItemAtIndexPath:indexPath];
    SFTableCell *cell = (SFTableCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if ([settingIdentifier isEqualToString:@"SFNotificationSettings"]) {
        if ([[SFAppSettings sharedInstance] remoteNotificationTypesEnabled]) {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
            cell.accessoryView = [[UITableViewCell alloc] init].accessoryView;
        } else {
            [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Warning"]];
            cell.selectedBackgroundView = nil;
        }
    } else if ([settingIdentifier isEqualToString:UIApplicationOpenSettingsURLString]
               || [settingIdentifier isEqualToString:SFDebugSettings]) {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        cell.accessoryView = [[UITableViewCell alloc] init].accessoryView;
    } else {
        cell.selectedBackgroundView = nil;
    }
    return cell;
}

- (BOOL)valueForSetting:(NSString *)settingIdentifier withSwitch:(UISwitch *)control
{
    BOOL value = NO;
    if ([settingIdentifier isEqualToString:SFGoogleAnalyticsOptOut]) {
        value = ![[SFAppSettings sharedInstance] googleAnalyticsOptOut];
    }
    return value;
}


@end
