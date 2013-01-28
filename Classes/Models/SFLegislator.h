//
//  SFLegislator.h
//  Congress
//
//  Created by Daniel Cloud on 1/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SFSynchronizedObject.h"


@interface SFLegislator : SFSynchronizedObject <SFSynchronizedObject>

@property (nonatomic, retain) NSString * bioguideId;
@property (nonatomic, retain) NSString * crpId;
@property (nonatomic, retain) NSString * chamber;
@property (nonatomic, retain) NSString * congressOffice;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * govtrackId;
@property (nonatomic, retain) NSNumber * district;
@property (nonatomic) BOOL inOffice;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * middleName;
@property (nonatomic, retain) NSString * nameSuffix;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * party;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * stateAbbreviation;
@property (nonatomic, retain) NSString * stateName;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * twitterId;
@property (nonatomic, retain) NSURL * websiteURL;
@property (nonatomic, retain) NSURL * youtubeURL;
@property (nonatomic, retain) NSURL * contactFormURL;


@property (readonly) NSString *fullName;
@property (readonly) NSString *titledName;
@property (readonly) NSString *titledByLastName;
@property (readonly) NSString *partyName;
@property (readonly) NSString *fullTitle;

@end
