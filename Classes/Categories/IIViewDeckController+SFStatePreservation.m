//
//  IIViewDeckController+SFStatePreservation.m
//  Congress
//
//  Created by Daniel Cloud on 3/27/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "IIViewDeckController+SFStatePreservation.h"

@implementation IIViewDeckController (SFStatePreservation)

/*
   For iOS 6 state preservation to work, we must encode references to the controllers
 */
- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    for (UIViewController *controller in self.controllers) {
        NSString *keyName = controller.restorationIdentifier ? controller.restorationIdentifier : NSStringFromClass(controller.class);
        [coder encodeObject:controller forKey:keyName];
    }
    [coder encodeBool:[self isSideOpen:IIViewDeckLeftSide] forKey:@"isOpen"];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    if ([coder decodeBoolForKey:@"isOpen"]) {
        [self openLeftViewAnimated:NO];
    }
}

@end
