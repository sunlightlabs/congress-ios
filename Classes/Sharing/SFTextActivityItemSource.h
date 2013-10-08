//
//  SFTextActivityItemSource.h
//  Congress
//
//  Created by Jeremy Carbaugh on 10/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFTextActivityItemSource : NSObject <UIActivityItemSource>

@property NSString *defaultText;

- (id)initWithText:(NSString *)text;

- (NSString *)facebookText:(NSString *)text;
- (NSString *)twitterText:(NSString *)text;

@end
