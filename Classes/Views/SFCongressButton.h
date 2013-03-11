//
//  SFCongressButton.h
//  Congress
//
//  Created by Daniel Cloud on 3/11/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFCongressButton : UIButton

+ (instancetype)button;
+ (instancetype)buttonWithTitle:(NSString *)title;

@property UILabel *detailLabel;

@end
