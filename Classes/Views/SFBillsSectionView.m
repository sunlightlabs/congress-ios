//
//  SFBillListView.m
//  Congress
//
//  Created by Daniel Cloud on 2/5/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFBillsSectionView.h"

@implementation SFBillsSectionView

@synthesize tableView = _tableView;
@synthesize searchBar = _searchBar;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
        _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _searchBar.showsCancelButton = YES;
        [self addSubview:_searchBar];

        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.autoresizingMask  = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_tableView];
    }
    return self;
}

- (void)layoutSubviews
{
    CGSize size = self.bounds.size;

    [_searchBar sizeToFit];
    _searchBar.center = CGPointMake(size.width/2, _searchBar.frame.size.height/2);

    CGFloat offset_y = _searchBar.frame.size.height + _searchBar.frame.origin.y;
    _tableView.frame = CGRectMake(0.0f, offset_y, size.width, (size.height-offset_y));
}

-(void)setTableView:(UITableView *)tableView
{
    [_tableView removeFromSuperview];
    _tableView = tableView;
    [self addSubview:_tableView];
}

@end
