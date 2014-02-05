//
//  SFSettingsDataSource.h
//  Congress
//
//  Created by Daniel Cloud on 12/9/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFDataTableDataSource.h"

FOUNDATION_EXPORT NSString *const SFSettingsValueChangeNotification;

@interface SFSettingsDataSource : SFDataTableDataSource

@property (nonatomic, retain) NSMutableDictionary *settingsMap;
@property (nonatomic, retain) NSMutableDictionary *switchMap;

- (NSString *)settingIdentifierItemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)valueForSetting:(NSString *)settingIdentifier withSwitch:(UISwitch *)control;

@end
