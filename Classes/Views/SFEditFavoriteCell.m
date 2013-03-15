//
//  SFEditFavoriteCell.m
//  Congress
//
//  Created by Daniel Cloud on 3/15/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFEditFavoriteCell.h"
#import "SFFavoriteButton.h"
#import "SFSynchronizedObject.h"

@implementation SFEditFavoriteCell

@synthesize favoriteButton = _favoriteButton;
@synthesize syncObject = _syncObject;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _favoriteButton = [[SFFavoriteButton alloc] init];
        self.accessoryView = _favoriteButton;
        [_favoriteButton addTarget:self action:@selector(handleFavoriteButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        _syncObject = nil;
    }
    return self;
}

- (void)layoutSubviews
{
    [_favoriteButton sizeToFit];
    [super layoutSubviews];
    self.accessoryView.right = self.width - [self.class contentInsetHorizontal];
}

- (void)setSyncObject:(SFSynchronizedObject *)pSyncObject
{
    _syncObject = pSyncObject;
    _favoriteButton.selected = _syncObject.persist;
}

- (void)handleFavoriteButtonPress:(id)sender
{
    _syncObject.persist = !_syncObject.persist;
    _favoriteButton.selected = _syncObject.persist;
}


@end
