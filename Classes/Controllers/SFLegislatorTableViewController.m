//
//  SFLegislatorTableViewController.m
//  Congress
//
//  Created by Daniel Cloud on 1/29/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorTableViewController.h"
#import "SFLegislator.h"
#import "SFLegislatorSegmentedViewController.h"
#import "SFTableCell.h"
#import "SFCellData.h"
#import "SFLegislatorTableDataSource.h"

SFDataTableSectionTitleGenerator const chamberTitlesGenerator = ^NSArray *(NSArray *items) {
    NSSet *sectionTitlesSet = [NSSet setWithArray:[items valueForKeyPath:@"chamber"]];
    return [[sectionTitlesSet allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
};
SFDataTableSortIntoSectionsBlock const byChamberSorterBlock = ^NSUInteger (id item, NSArray *sectionTitles) {
    SFLegislator *legislator = (SFLegislator *)item;
    NSUInteger index = [sectionTitles indexOfObject:legislator.chamber];
    if (index != NSNotFound) {
        return index;
    }
    return 0;
};

SFDataTableSectionTitleGenerator const stateTitlesGenerator = ^NSArray *(NSArray *items) {
    NSSet *sectionTitlesSet = [NSSet setWithArray:[items valueForKeyPath:@"stateName"]];
    return [[sectionTitlesSet allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
};
SFDataTableSectionIndexTitleGenerator const stateSectionIndexTitleGenerator = ^NSArray *(NSArray *sectionTitles)
{
    NSMutableSet *sectionIndexTitlesSet = [NSMutableSet set];
    [sectionTitles enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        if (obj) {
            obj = [(NSString *)obj substringToIndex : 1];
            [sectionIndexTitlesSet addObject:obj];
        }
    }];
    return [[sectionIndexTitlesSet allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
};
SFDataTableSectionForSectionIndexHandler const legSectionIndexHandler = ^NSInteger (NSString *title, NSInteger index, NSArray *sectionTitles)
{
    NSPredicate *alphaPredicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[c] %@", [title substringToIndex:1]];
    NSArray *filteredTitles = [sectionTitles filteredArrayUsingPredicate:alphaPredicate];
    NSInteger position = (NSInteger)[sectionTitles indexOfObject :[filteredTitles firstObject]];
    return position;
};
SFDataTableSortIntoSectionsBlock const byStateSorterBlock = ^NSUInteger (id item, NSArray *sectionTitles) {
    SFLegislator *legislator = (SFLegislator *)item;
    NSUInteger index = [sectionTitles indexOfObject:legislator.stateName];
    if (index != NSNotFound) {
        return index;
    }
    return 0;
};
SFDataTableSectionTitleGenerator const lastNameTitlesGenerator = ^NSArray *(NSArray *items) {
    NSMutableSet *sectionTitlesSet = [NSMutableSet set];
    [[items valueForKeyPath:@"lastName"] enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        if (obj) {
            obj = [(NSString *)obj substringToIndex : 1];
            [sectionTitlesSet addObject:obj];
        }
    }];
    return [[sectionTitlesSet allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
};
SFDataTableSortIntoSectionsBlock const byLastNameSorterBlock = ^NSUInteger (id item, NSArray *sectionTitles) {
    SFLegislator *legislator = (SFLegislator *)item;
    id (^singleLetter)(id obj) = ^id (id obj) {
        if (obj) {
            obj = [(NSString *)obj substringToIndex : 1];
        }
        return obj;
    };
    NSUInteger index = [sectionTitles indexOfObject:singleLetter(legislator.lastName)];
    if (index != NSNotFound) {
        return index;
    }
    return 0;
};
SFDataTableOrderItemsInSectionsBlock const lastNameFirstOrderBlock = ^NSArray *(NSArray *sectionItems) {
    return [sectionItems sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"stateName" ascending:YES]]];
};

@implementation SFLegislatorTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
    }
    return self;
}

- (void)viewDidLoad {
    self.tableView.delegate = self;
    self.dataProvider = [SFLegislatorTableDataSource new];
    [super viewDidLoad];

    id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Legislator List Screen"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![tableView isEditing]) {
        SFLegislator *legislator = (SFLegislator *)[[self.dataProvider.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        SFLegislatorSegmentedViewController *detailViewController = [[SFLegislatorSegmentedViewController alloc] initWithNibName:nil bundle:nil
                                                                                                                      bioguideId:legislator.bioguideId];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFLegislator *legislator = (SFLegislator *)[self.dataProvider itemForIndexPath:indexPath];
    NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:SFDefaultLegislatorCellTransformerName];
    SFCellData *cellData = [transformer transformedValue:legislator];
    CGFloat cellHeight = [cellData heightForWidth:self.tableView.width];
    return cellHeight;
}

#pragma mark - UIViewControllerRestoration

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder {
    return [[SFLegislatorTableViewController alloc] initWithNibName:nil bundle:nil];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    [coder encodeObject:self.dataProvider.items forKey:@"tableItems"];
    [coder encodeObject:self.title forKey:@"tableTitle"];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    self.dataProvider.items = [coder decodeObjectForKey:@"tableItems"];
    self.title = [coder decodeObjectForKey:@"tableTitle"];
    [self reloadTableView];
}

@end
