//
//  SFBillsSectionViewController.h
//  Congress
//
//  Created by Daniel Cloud on 11/30/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "SFMainDeckTableViewController.h"
#import "SFBillsTableViewController.h"
#import "GAITrackedViewController.h"

@class SFBillsSectionView;

@interface SFBillsSectionViewController : GAITrackedViewController <UISearchBarDelegate>

@property (strong, nonatomic) NSMutableArray *introducedBills;
@property (strong, nonatomic) NSMutableArray *activeBills;
@property (strong, nonatomic) NSMutableArray *billsSearched;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIViewController *currentVC;

@property (nonatomic) BOOL *restorationKeyboardVisible;
@property (nonatomic) NSInteger *restorationSelectedSegment;
@property (nonatomic, strong) NSString *restorationSearchQuery;
@property (nonatomic) BOOL shouldRestoreSearch;

- (void)resetSearchResults;
- (void)searchAfterDelay;
- (void)searchAndDisplayResults:(NSString *)searchText forAutocomplete:(BOOL)autocomplete;
- (void)searchFor:(NSString *)query withKeyboard:(BOOL)showKeyboard;

- (void)dismissSearchKeyboard;
- (void)showSearchKeyboard;

@end
