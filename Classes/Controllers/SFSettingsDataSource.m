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
    NSDictionary *_notificationSettings;
}

@synthesize settingsMap = _settingsMap;
@synthesize switchMap = _switchMap;

- (id)init {
    self = [super init];
    if (self) {
        _switchMap = [NSMutableDictionary dictionary];
        self.sections = [NSMutableArray array];
        self.sectionTitles = [NSMutableArray array];
    }
    return self;
}

- (NSString *)settingIdentifierItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *item  = (NSString *)[self itemForIndexPath:indexPath];
    NSArray *matches = [_settingsMap allKeysForObject:item];
    if ([matches count] > 1) {
        return nil;
    }
    return (NSString *)[matches firstObject];
}

#pragma mark - SFCellDataSource

- (SFCellData *)cellDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    id item  = [self itemForIndexPath:indexPath];
    if (!item) return nil;

    SFCellData *data = [SFCellData new];
    data.textLabelString = (NSString *)item;
    data.textLabelFont = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    data.selectable = @NO;

    return data;
}

- (SFSettingCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SFSettingCell *cell = (SFSettingCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.settingIdentifier = [self settingIdentifierItemAtIndexPath:indexPath];
    
    [_switchMap setValue:cell forKey:cell.settingIdentifier];
    
    if ([cell.accessoryView isKindOfClass:[UISwitch class]]) {
        
        [_switchMap setObject:cell.accessoryView forKey:cell.settingIdentifier];
        
        UISwitch *cellSwitch = (UISwitch *)(cell.accessoryView);
        [cellSwitch setOn:[self valueForSetting:cell.settingIdentifier withSwitch:cellSwitch]];
        [cellSwitch removeTarget:self action:NULL forControlEvents:UIControlEventValueChanged];
        [cellSwitch addTarget:self action:@selector(handleCellSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }

    return cell;
}

- (BOOL)valueForSetting:(NSString *)settingIdentifier withSwitch:(UISwitch *)control
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override settingForSwitch: in a subclass"];
    return NO;
}

- (NSString *)cellIdentifier;
{
    return [SFSettingCell defaultCellIdentifer];
}

- (void)handleCellSwitchValueChanged:(id)target {
    UISwitch *cellSwitch = (UISwitch *)target;
    NSString *settingIdentifier = [[_switchMap allKeysForObject:cellSwitch] lastObject];
    NSDictionary *userInfo = @{ @"settingIdentifier": settingIdentifier, @"value": [NSNumber numberWithBool:[cellSwitch isOn]] };
    [[NSNotificationCenter defaultCenter] postNotificationName:SFSettingsValueChangeNotification object:self userInfo:userInfo];
}

@end
