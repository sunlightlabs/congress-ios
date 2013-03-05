//
//  SFFavoriting.h
//  Congress
//
//  Created by Daniel Cloud on 3/5/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SFFavoriting <NSObject>

@required

@property (nonatomic, strong) UIBarButtonItem *favoriteButton;

- (void)handleFavoriteButtonPress;
- (void)addFavoritingBarButtonItem;

@end
