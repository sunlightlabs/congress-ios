//
//  SFEditFavoriteCell.h
//  Congress
//
//  Created by Daniel Cloud on 3/15/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFTableCell.h"

@class SFFavoriteButton;
@class  SFSynchronizedObject;

@interface SFEditFavoriteCell : SFTableCell

@property (nonatomic, retain) SFFavoriteButton *favoriteButton;
@property (nonatomic, weak) SFSynchronizedObject *syncObject;


@end
