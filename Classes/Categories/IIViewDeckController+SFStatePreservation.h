//
//  IIViewDeckController+SFStatePreservation.h
//  Congress
//
//  Created by Daniel Cloud on 3/27/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "IIViewDeckController.h"

@interface IIViewDeckController (SFStatePreservation)

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder;
- (void)decodeRestorableStateWithCoder:(NSCoder *)coder;

@end
