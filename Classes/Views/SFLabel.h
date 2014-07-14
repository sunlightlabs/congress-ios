//
//  SFLabel.h
//  Congress
//
//  Created by Daniel Cloud on 3/13/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <SAMLabel/SAMLabel.h>

@interface SFLabel : SAMLabel <UIGestureRecognizerDelegate>

- (void)handleLongPress:(UIGestureRecognizer *)recognizer;
- (void)setText:(NSString *)pText lineSpacing:(CGFloat)lineSpacing;

@end
