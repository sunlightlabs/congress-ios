//
//  SFActivityItemProvider.h
//  Congress
//
//  Created by Jeremy Carbaugh on 8/28/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFActivityItemProvider : UIActivityItemProvider

- (NSString *)facebookStringWithText:(NSString *)text;
- (NSString *)twitterStringWithText:(NSString *)text;

@end
