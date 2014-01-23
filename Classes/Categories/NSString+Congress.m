//
//  NSString+Congress.m
//  Congress
//
//  Created by Daniel Cloud on 3/19/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "NSString+Congress.h"

@implementation NSString (Congress)

#pragma mark - iOS 7 bifurcation method
- (CGSize)sf_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    CGSize labelSize;
    NSInteger options = (NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine);
    if ([[UIDevice currentDevice] systemMajorVersion] < 7) {
        NSRange stringRange = NSMakeRange(0, self.length);
        NSMutableAttributedString *textString = [[NSMutableAttributedString alloc] initWithString:self];
        [textString addAttribute:NSFontAttributeName value:font range:stringRange];
        CGRect boundingRect = [textString boundingRectWithSize:size options:options context:nil];
        labelSize = boundingRect.size;
    }
    else {
        CGRect bRect = [self boundingRectWithSize:size options:options attributes:@{ NSFontAttributeName: font } context:nil];
        labelSize = bRect.size;
    }
    return labelSize;
}

@end
