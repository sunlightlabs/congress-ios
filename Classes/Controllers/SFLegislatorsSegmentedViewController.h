//
//  SFLegislatorsSectionViewController.h
//  Congress
//
//  Created by Daniel Cloud on 12/5/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"

@interface SFLegislatorsSegmentedViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *legislatorList;

-(BOOL)isUpdating;

@end
