//
//  SFAnalyticsSettingsDataSource.m
//  Congress
//
//  Created by Jeremy Carbaugh on 2/5/14.
//  Copyright (c) 2014 Sunlight Foundation. All rights reserved.
//

#import "SFAnalyticsSettingsDataSource.h"

@implementation SFAnalyticsSettingsDataSource

- (id)init {
    self = [super init];
    if (self) {
        
        [self setSettingsMap:[NSMutableDictionary dictionaryWithDictionary:@{SFGoogleAnalyticsOptOut: @"Enable anonymous analytics reporting"}]];
        self.sections = [self.sections arrayByAddingObjectsFromArray:@[[self.settingsMap objectsForKeys:@[SFGoogleAnalyticsOptOut] notFoundMarker:[NSNull null]]]];
        self.sectionTitles = [self.sectionTitles arrayByAddingObject:@"Analytics Reporting"];
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
    return value;
}


@end
