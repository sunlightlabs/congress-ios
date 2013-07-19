//
//  SFBillDetector.h
//  Congress
//
//  Created by Jeremy Carbaugh on 7/18/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFBillDetector : NSObject

+ (NSArray*)detectBills:(NSString*)text forSession:(NSString*)session;

@end
