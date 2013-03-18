//
//  SFLabel.h
//  Congress
//
//  Created by Daniel Cloud on 3/13/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <SSToolkit/SSLabel.h>

@interface SFLabel : SSLabel <UIGestureRecognizerDelegate>

- (void)handleLongPress:(UIGestureRecognizer*)recognizer;

@end
