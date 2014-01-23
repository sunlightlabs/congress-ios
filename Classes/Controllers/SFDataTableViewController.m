//
//  SFDataTableViewController.m
//  Congress
//
//  Created by Daniel Cloud on 2/26/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFDataTableViewController.h"
#import "SFTableHeaderView.h"
#import "SFDataTableDataSource.h"
#import "SFTableCell.h"
#import "SFValue1TableCell.h"

static void *kSFDataTableContext = &kSFDataTableContext;

@implementation SFDataTableViewController
{
    NSString *_itemsSelector;
}

@synthesize dataProvider = _dataProvider;

#pragma mark - UITableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        self.dataProvider = [SFDataTableDataSource new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[SFTableCell class] forCellReuseIdentifier:[SFTableCell defaultCellIdentifer]];
    [self.tableView registerClass:[SFValue1TableCell class] forCellReuseIdentifier:[SFValue1TableCell defaultCellIdentifer]];
    _itemsSelector = NSStringFromSelector(@selector(items));
//    [self.dataProvider addObserver:self forKeyPath:_itemsSelector options:0 context:kSFDataTableContext];
}

//- (void)dealloc
//{
//    @try {
//        [self removeObserver:self forKeyPath:_itemsSelector];
//    }
//    @catch (NSException *exception) {
//        NSLog(@"Error removing observer for %@", _itemsSelector);
//    }
//
//}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.dataProvider && [self.dataProvider.items count] > 0) {
        [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - SFDataTableViewController

- (void)setDataProvider:(SFDataTableDataSource *)pDataProvider {
    _dataProvider = pDataProvider;
    self.tableView.dataSource = self.dataProvider;
}

#pragma mark - Key-Value Observation

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if (context == kSFDataTableContext) {
//        if ([keyPath isEqualToString:_itemsSelector]) {
//            NSLog(@"Saw that %@ changed", _itemsSelector);
//        }
//    }
//    else {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SFTableHeaderView *headerView = [[SFTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, SFTableHeaderViewHeight)];
    headerView.textLabel.text = [self.dataProvider.sectionTitles[section] uppercaseString];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.dataProvider.sectionTitles count]) {
        return SFTableHeaderViewHeight;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Remove";
}

#pragma mark - SFDataTableViewController

- (void)reloadTableView {
    [self.tableView reloadData];
}

- (void)sortItemsIntoSectionsAndReload {
    [self.dataProvider sortItemsIntoSections];
    [self reloadTableView];
}

#pragma mark - Application state

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.dataProvider.sections forKey:@"sections"];
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    NSArray *sSections = [coder decodeObjectForKey:@"sections"];
    self.dataProvider.sections = sSections;
}

@end
