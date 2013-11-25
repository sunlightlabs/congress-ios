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

static void * kSFDataTableContext = &kSFDataTableContext;

@implementation SFDataTableViewController
{
    NSString *_itemsSelector;
}

@synthesize dataProvider = _dataProvider;

#pragma mark - UITableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        self.dataProvider = [SFDataTableDataSource new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[SFTableCell class] forCellReuseIdentifier:[SFTableCell defaultCellIdentifer]];
    _itemsSelector = NSStringFromSelector(@selector(items));
    [self.dataProvider addObserver:self forKeyPath:_itemsSelector options:0 context:kSFDataTableContext];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSArray *visPaths = [self.tableView indexPathsForVisibleRows];
    if (visPaths && [visPaths count] > 0) {
        [self.tableView reloadRowsAtIndexPaths:visPaths withRowAnimation:UITableViewRowAnimationNone];
    }
    else {
        [self.tableView reloadData];
    }
}

- (void)dealloc
{
    @try {
        [self removeObserver:self forKeyPath:_itemsSelector];
    }
    @catch (NSException *exception) {
        NSLog(@"Error removing observer for %@", _itemsSelector);
    }

}

#pragma mark - SFDataTableViewController

- (void)setDataProvider:(SFDataTableDataSource *)pDataProvider
{
    _dataProvider = pDataProvider;
    self.tableView.dataSource = self.dataProvider;
}

#pragma mark - Key-Value Observation

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kSFDataTableContext) {
        if ([keyPath isEqualToString:_itemsSelector]) {
            NSLog(@"Saw that %@ changed", _itemsSelector);
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SFTableHeaderView *headerView = [[SFTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, SFTableHeaderViewHeight)];
    headerView.textLabel.text = [self.dataProvider.sectionTitles[section] uppercaseString];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.dataProvider.sectionTitles count]) {
        return SFTableHeaderViewHeight;
    }
    return 0;
}

#pragma mark - SFDataTableViewController

- (void)reloadTableView
{
    [self.tableView reloadData];
}

- (void)sortItemsIntoSectionsAndReload
{
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
