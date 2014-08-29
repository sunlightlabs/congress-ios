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

@property (nonatomic, copy) NSString *bioguideId;
@property (nonatomic, copy) NSString *crpId;
@property (nonatomic, strong) NSString *chamber;
@property (nonatomic, strong) NSString *congressOffice;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *govtrackId;
@property (nonatomic, strong) NSNumber *district;
@property (nonatomic) BOOL inOffice;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *middleName;
@property (nonatomic, strong) NSString *nameSuffix;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *party;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *stateAbbreviation;
@property (nonatomic, strong) NSString *stateName;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *facebookId;
@property (nonatomic, strong) NSString *twitterId;
@property (nonatomic, strong) NSString *youtubeId;
@property (nonatomic, strong) NSURL *websiteURL;
@property (nonatomic, strong) NSURL *contactFormURL;


@property (nonatomic, readonly) NSString *fullName;
@property (nonatomic, readonly) NSString *titledName;
@property (nonatomic, readonly) NSString *titledByLastName;
@property (nonatomic, readonly) NSString *partyName;
@property (nonatomic, readonly) NSString *fullTitle;
@property (nonatomic, readonly) NSString *fullDescription;
@property (nonatomic, readonly) NSURL *facebookURL;
@property (nonatomic, readonly) NSURL *twitterURL;
@property (nonatomic, readonly) NSURL *youtubeURL;
@property (nonatomic, readonly) NSDictionary *socialURLs;
@property (nonatomic, readonly) NSURL *shareURL;

- (NSString *)openCongressEmail;

@end
