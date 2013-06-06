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

@interface SFBillsSectionViewController : GAITrackedViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *introducedBills;
@property (strong, nonatomic) NSMutableArray *activeBills;
@property (strong, nonatomic) NSMutableArray *billsSearched;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UIViewController *currentVC;

@property (nonatomic) BOOL *restorationKeyboardVisible;
@property (nonatomic) NSInteger *restorationSelectedSegment;
@property (nonatomic, retain) NSString *restorationSearchQuery;

- (void)searchAfterDelay;
- (void)searchAndDisplayResults:(NSString *)searchText;
- (void)searchFor:(NSString *)query withKeyboard:(BOOL)showKeyboard;

@end
