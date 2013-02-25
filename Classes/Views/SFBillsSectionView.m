//
//  SFBillListView.m
//  Congress
//
//  Created by Daniel Cloud on 2/5/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFBillsSectionView.h"

@implementation SFBillsSectionView

@synthesize contentView = _contentView;
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

        _contentView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _contentView.autoresizingMask  = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_contentView];
    }
    return self;
}

- (void)layoutSubviews
{
    CGSize size = self.bounds.size;

    [_searchBar sizeToFit];
    _searchBar.center = CGPointMake(size.width/2, _searchBar.height/2);

    _contentView.frame = CGRectMake(0.0f, _searchBar.bottom, size.width, (size.height-_searchBar.bottom));
}

-(void)setContentView:(UITableView *)contentView
{
    if (_contentView) {
        [_contentView removeFromSuperview];
    }
    _contentView = contentView;
    [self addSubview:_contentView];
    [self layoutSubviews];
}

@end
