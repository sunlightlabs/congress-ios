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

@synthesize dataTableDataSource;

#pragma mark Backwards compatibility properties
@synthesize sortIntoSectionsBlock;
@synthesize sectionTitleGenerator;
@synthesize orderItemsInSectionsBlock;
@synthesize cellForIndexPathHandler;
@synthesize sectionIndexTitleGenerator;
@synthesize sectionIndexHandler;

#pragma mark Backwards compatibility methods
- (void)setSectionTitleGenerator:(SFDataTableSectionTitleGenerator)pSectionTitleGenerator
                sortIntoSections:(SFDataTableSortIntoSectionsBlock)pSectionSorter
            orderItemsInSections:(SFDataTableOrderItemsInSectionsBlock)pOrderItemsInSectionsBlock
         cellForIndexPathHandler:(SFDataTableCellForIndexPathHandler)pCellForIndexPathHandler
{
    self.dataTableDataSource.sectionTitleGenerator = pSectionTitleGenerator;
    self.dataTableDataSource.sortIntoSectionsBlock = pSectionSorter;
    if (pOrderItemsInSectionsBlock) {
        self.dataTableDataSource.orderItemsInSectionsBlock = pOrderItemsInSectionsBlock;
    }
    if (pCellForIndexPathHandler) {
        self.dataTableDataSource.cellForIndexPathHandler = pCellForIndexPathHandler;
    }
}

- (void)setSectionIndexTitleGenerator:(SFDataTableSectionIndexTitleGenerator)pSectionIndexTitleGenerator
                  sectionIndexHandler:(SFDataTableSectionForSectionIndexHandler)pSectionForSectionIndexHandler
{
    [self.dataTableDataSource setSectionIndexTitleGenerator:pSectionIndexTitleGenerator sectionIndexHandler:pSectionForSectionIndexHandler];
}

- (void)sortItemsIntoSections
{
    [self.dataTableDataSource sortItemsIntoSections];
}

- (id)itemForIndexPath:(NSIndexPath *)indexPath;
{
    return [self.dataTableDataSource itemForIndexPath:indexPath];
}


#pragma mark - UITableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        self.dataTableDataSource = [SFDataTableDataSource new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[SFTableCell class] forCellReuseIdentifier:[SFTableCell defaultCellIdentifer]];
    self.tableView.dataSource = self.dataTableDataSource;
    _itemsSelector = NSStringFromSelector(@selector(items));
    [self.dataTableDataSource addObserver:self forKeyPath:_itemsSelector options:0 context:kSFDataTableContext];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 16.0f, 0);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSArray *visPaths = [self.tableView indexPathsForVisibleRows];
    if (visPaths && [visPaths count] > 0) {
        [self.tableView reloadRowsAtIndexPaths:visPaths withRowAnimation:UITableViewRowAnimationNone];
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

#pragma mark - Backwards compatibility accessor methods

- (NSArray *)items
{
    return self.dataTableDataSource.items;
}

- (void)setItems:(NSArray *)pItems
{
    [self.dataTableDataSource setItems:pItems];
}

- (NSArray *)sections
{
    return self.dataTableDataSource.sections;
}

- (void)setSections:(NSArray *)pSections
{
    self.dataTableDataSource.sections = pSections;
}

- (void)setSortIntoSectionsBlock:(SFDataTableSortIntoSectionsBlock)pSortIntoSectionsBlock
{
    self.dataTableDataSource.sortIntoSectionsBlock = pSortIntoSectionsBlock;
}

- (SFDataTableSortIntoSectionsBlock)sortIntoSectionsBlock
{
    return self.dataTableDataSource.sortIntoSectionsBlock;
}

- (void)setSectionTitleGenerator:(SFDataTableSectionTitleGenerator)pSectionTitleGenerator
{
    self.dataTableDataSource.sectionTitleGenerator = pSectionTitleGenerator;
}

- (SFDataTableSectionTitleGenerator)sectionTitleGenerator
{
    return self.dataTableDataSource.sectionTitleGenerator;
}

- (void)setOrderItemsInSectionsBlock:(SFDataTableOrderItemsInSectionsBlock)pOrderItemsInSectionsBlock
{
    self.dataTableDataSource.orderItemsInSectionsBlock = pOrderItemsInSectionsBlock;
}

- (SFDataTableOrderItemsInSectionsBlock)orderItemsInSectionsBlock
{
    return self.dataTableDataSource.orderItemsInSectionsBlock;
}

- (void)setCellForIndexPathHandler:(SFDataTableCellForIndexPathHandler)pCellForIndexPathHandler
{
    self.dataTableDataSource.cellForIndexPathHandler = pCellForIndexPathHandler;
}

- (SFDataTableCellForIndexPathHandler)cellForIndexPathHandler
{
    return self.dataTableDataSource.cellForIndexPathHandler;
}

- (void)setSectionIndexTitleGenerator:(SFDataTableSectionIndexTitleGenerator)pSectionIndexTitleGenerator
{
    self.dataTableDataSource.sectionIndexTitleGenerator = pSectionIndexTitleGenerator;
}

- (SFDataTableSectionIndexTitleGenerator)sectionIndexTitleGenerator
{
    return self.dataTableDataSource.sectionIndexTitleGenerator;
}

- (void)setSectionIndexHandler:(SFDataTableSectionForSectionIndexHandler)pSectionIndexHandler
{
    self.dataTableDataSource.sectionIndexHandler = pSectionIndexHandler;
}

- (SFDataTableSectionForSectionIndexHandler)sectionIndexHandler
{
    return self.dataTableDataSource.sectionIndexHandler;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SFTableHeaderView *headerView = [[SFTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, SFTableHeaderViewHeight)];
    headerView.textLabel.text = [self.dataTableDataSource.sectionTitles[section] uppercaseString];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.dataTableDataSource.sectionTitles count]) {
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
    [self.dataTableDataSource sortItemsIntoSections];
    [self reloadTableView];
}

#pragma mark - Application state

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {

    [coder encodeObject:self.dataTableDataSource.sections forKey:@"sections"];
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    NSArray *sSections = [coder decodeObjectForKey:@"sections"];
    self.dataTableDataSource.sections = sSections;
}

@end
