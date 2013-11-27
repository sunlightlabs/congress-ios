//
//  SFDataTableDataSource.m
//  Congress
//
//  Created by Daniel Cloud on 11/25/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFDataTableDataSource.h"

@implementation SFDataTableDataSource

@synthesize items = _items;
@synthesize sections = _sections;
@synthesize sectionTitles = _sectionTitles;
@synthesize sectionIndexTitles = _sectionIndexTitles;
@synthesize sortIntoSectionsBlock;
@synthesize sectionTitleGenerator;
@synthesize orderItemsInSectionsBlock;
@synthesize sectionIndexTitleGenerator;
@synthesize sectionIndexHandler;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _items = @[];
    }
    return self;
}

#pragma mark - SFDataTableDataSource

- (void)setItems:(NSArray *)pItems
{
    _items = pItems ?: @[];
    if (!self.sortIntoSectionsBlock) {
        self.sections = @[_items];
    }
}

- (void)setSectionTitleGenerator:(SFDataTableSectionTitleGenerator)pSectionTitleGenerator
                sortIntoSections:(SFDataTableSortIntoSectionsBlock)pSectionSorter
            orderItemsInSections:(SFDataTableOrderItemsInSectionsBlock)pOrderItemsInSectionsBlock
{
    self.sectionTitleGenerator = pSectionTitleGenerator;
    self.sortIntoSectionsBlock = pSectionSorter;
    if (pOrderItemsInSectionsBlock) {
        self.orderItemsInSectionsBlock = pOrderItemsInSectionsBlock;
    }
}

- (void)setSectionIndexTitleGenerator:(SFDataTableSectionIndexTitleGenerator)pSectionIndexTitleGenerator
                  sectionIndexHandler:(SFDataTableSectionForSectionIndexHandler)pSectionForSectionIndexHandler
{
    self.sectionIndexTitleGenerator = pSectionIndexTitleGenerator;
    self.sectionIndexHandler = pSectionForSectionIndexHandler;
}


- (void)sortItemsIntoSections
{
    if (self.sectionTitleGenerator && self.sortIntoSectionsBlock) {
        self.sectionTitles = sectionTitleGenerator(self.items);

        NSMutableArray *mutableSections = [NSMutableArray arrayWithCapacity:[self.sectionTitles count]];
        [mutableSections addObject:[NSMutableArray array]];
        for (NSUInteger i = 1; i < [self.sectionTitles count]; i++) {
            [mutableSections addObject:[NSMutableArray array]];
        }

        for (id item in self.items) {
            NSUInteger sectionNum = self.sortIntoSectionsBlock(item, self.sectionTitles);
            NSMutableArray *section = [mutableSections objectAtIndex:sectionNum];
            [section addObject:item];
        }
        if (self.orderItemsInSectionsBlock) {
            for (NSUInteger i=0; i < [mutableSections count]; i++) {
                NSArray *sortedSection = self.orderItemsInSectionsBlock([NSArray arrayWithArray:[mutableSections objectAtIndex:i]]);
                [mutableSections replaceObjectAtIndex:i withObject:sortedSection];
            }
        }
        self.sections = [NSArray arrayWithArray:mutableSections];
        if (self.sectionIndexTitleGenerator) {
            self.sectionIndexTitles = self.sectionIndexTitleGenerator(self.sectionTitles);
        }
    }
    else if (self.orderItemsInSectionsBlock) {
        self.items = self.orderItemsInSectionsBlock([NSArray arrayWithArray:self.items]);
    }
}

- (id)itemForIndexPath:(NSIndexPath *)indexPath
{
    if ([self.items count] == 0) return nil;
    id item;
    if ([self.sections count] == 0) {
        item = [self.items objectAtIndex:indexPath.row];
    }
    else
    {
        item = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    return item;
}

// !!!: Adopt SFCellDataSource, override cellDataForItemAtIndexPath
- (SFCellData *)cellDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UITableViewDataSource

- (SFTableCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil) return nil;

    SFTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[SFTableCell defaultCellIdentifer] forIndexPath:indexPath];
    SFCellData *cellData = [self cellDataForItemAtIndexPath:indexPath];

    if (cellData) {
        [cell setCellData:cellData];
        if ([cellData persist] && [cell respondsToSelector:@selector(setPersistStyle)]) {
            [cell performSelector:@selector(setPersistStyle)];
        }
        CGFloat cellHeight = [cellData heightForWidth:tableView.width];
        [cell setFrame:CGRectMake(0, 0, cell.width, cellHeight)];
    }

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (!_sections || [_sections count] == 0) {
        return 1;
    }
    return [_sections count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([_sectionTitles count]) {
        return [_sectionTitles objectAtIndex:section];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.sections && self.sections[section]) {
        return [self.sections[section] count];
    }
    return [self.items count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (self.sectionIndexTitles && self.sectionIndexHandler) {
        return self.sectionIndexHandler(title, index, _sectionTitles);
    }
    return 0;
}

@end
