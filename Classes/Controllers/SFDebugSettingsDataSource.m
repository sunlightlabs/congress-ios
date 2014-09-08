//
//  SFDebugSettingsDataSource.m
//  Congress
//
//  Created by Jeremy Carbaugh on 9/5/14.
//  Copyright (c) 2014 Sunlight Foundation. All rights reserved.
//

#import "SFDebugSettingsDataSource.h"
#import "SFSettingCell.h"
#import "SFAppSettings.h"

@implementation SFDebugSettingsDataSource

- (id)init {
    
    self = [super init];
    if (self) {
        
        NSMutableDictionary *settingsMap = [NSMutableDictionary dictionary];
        
        /* notifications */
        
        [settingsMap addEntriesFromDictionary:@{
                                                SFOCEmailConfirmation: @"Confirmed OC email",
                                                }];
        
        [self setSettingsMap:settingsMap];
        
        self.sections = [self.sections arrayByAddingObjectsFromArray:@[
                                                                       [settingsMap objectsForKeys:@[SFOCEmailConfirmation] notFoundMarker:[NSNull null]],
                                                                       ]];
        
        self.sectionTitles = [self.sectionTitles arrayByAddingObjectsFromArray:@[@"Debug Flags"]];
    }
    return self;
}

- (BOOL)valueForSetting:(NSString *)settingIdentifier withSwitch:(UISwitch *)control
{
    BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:settingIdentifier] || NO;
    return value;
}

- (SFCellData *)cellDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    SFCellData *data = [super cellDataForItemAtIndexPath:indexPath];
    return data;
}

- (void)handleCellSwitchValueChanged:(id)target {
    UISwitch *cellSwitch = (UISwitch *)target;
    NSString *settingIdentifier = [[self.switchMap allKeysForObject:cellSwitch] lastObject];
    BOOL value = [cellSwitch isOn];
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:settingIdentifier];
}


@end
