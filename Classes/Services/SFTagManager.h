//
//  SFFollowedObjectsManager.h
//  Congress
//
//  Created by Daniel Cloud on 11/19/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFSharedInstance.h"

extern NSString * const SFQueuedTagsRegisteredNotification;

@interface SFTagManager : NSObject <SFSharedInstance>

@property (readonly, nonatomic, strong) NSString *timeZoneTag;

+(instancetype)sharedInstance;

- (void)updateAllTags;
- (void)queueTagForRegistration:(NSString *)tagName;
- (void)removeTagFromQueue:(NSString *)tagName;

@end
