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
    for (UIViewController *controller in self.controllers) {
        NSString *keyName = controller.restorationIdentifier ? controller.restorationIdentifier : NSStringFromClass(controller.class);
        [coder encodeObject:controller forKey:keyName];
    }
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
}

@end
