//
//  SFLegislatorsSectionViewController.h
//  Congress
//
//  Created by Daniel Cloud on 12/5/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"
#import "GAITrackedViewController.h"

@interface SFLegislatorsSectionViewController : GAITrackedViewController

@property (strong, nonatomic) NSArray *legislatorList;
@property BOOL legislatorsLoaded;

@end
