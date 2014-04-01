//
//  SFLabel.m
//  Congress
//
//  Created by Daniel Cloud on 3/13/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFLabel.h"

@implementation SFLabel {
    CGFloat _lineSpacing;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _lineSpacing = 1.0f;
        self.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *pressGestureRec = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        pressGestureRec.delegate = self;
        [self addGestureRecognizer:pressGestureRec];
    }
    return self;
}

- (void)setText:(NSString *)pText lineSpacing:(CGFloat)lineSpacing {
    _lineSpacing = lineSpacing;
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
    pStyle.lineSpacing = lineSpacing;
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:pText attributes:@{ NSParagraphStyleAttributeName:pStyle }];
    self.attributedText = attString;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)copy:(id)sender {
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:self.text];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(copy:));
}

- (void)handleLongPress:(UIGestureRecognizer *)recognizer {
    [self becomeFirstResponder];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        UIMenuController *copyMenu = [UIMenuController sharedMenuController];
        CGRect halfLabel = CGRectInset(self.frame, self.frame.size.width / 2, self.frame.size.height / 2);
        [copyMenu setTargetRect:halfLabel inView:self.superview];
        [copyMenu setMenuVisible:YES animated:YES];
    }
}

@end
