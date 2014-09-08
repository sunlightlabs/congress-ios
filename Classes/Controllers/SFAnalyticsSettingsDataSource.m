//
//  SFAnalyticsSettingsDataSource.m
//  Congress
//
//  Created by Jeremy Carbaugh on 2/5/14.
//  Copyright (c) 2014 Sunlight Foundation. All rights reserved.
//

#import "SFAnalyticsSettingsDataSource.h"
#import "SFSettingCell.h"
#import "SFAppSettings.h"

@implementation SFAnalyticsSettingsDataSource

- (id)init {
    self = [super init];
    if (self) {
        
        [self setSettingsMap:[NSMutableDictionary dictionaryWithDictionary:@{@"SFNotificationSettings": @"Notifications",
                                                                             SFGoogleAnalyticsOptOut: @"Enable anonymous analytics"}]];
        
        #if CONFIGURATION_Debug
            [self.settingsMap setValue:@"Debug Flags" forKey:SFDebugSettings];
            self.sections = @[@[@"Notifications", @"Enable anonymous analytics", @"Debug Flags"]];
        #else
            self.sections = @[@[@"Notifications", @"Enable anonymous analytics"]];
        #endif
        
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
            data.detailTextLabelString = @"Notifications are disabled for Congress App! Enable them by opening your iPhone's Settings app, tapping on Notification Center and turning on banners or alerts for Congress.";
            data.detailTextLabelNumberOfLines = 4;
            data.detailTextLabelFont = [UIFont systemFontOfSize:12.0f];
        }
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
    } else if ([settingIdentifier isEqualToString:SFDebugSettings]) {
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
