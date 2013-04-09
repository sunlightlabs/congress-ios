//
//  SFCellData.h
//  Congress
//
//  Created by Daniel Cloud on 4/9/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFCellData : NSObject

@property (nonatomic) UITableViewCellStyle cellStyle;
@property (nonatomic) NSString *cellIdentifier;
@property (nonatomic) NSString *textLabelString;
@property (nonatomic) UIFont *textLabelFont;
@property (nonatomic) UIColor *textLabelColor;
@property (nonatomic) NSInteger textLabelNumberOfLines;
@property (nonatomic) NSString *detailTextLabelString;
@property (nonatomic) UIFont *detailTextLabelFont;
@property (nonatomic) UIColor *detailTextLabelColor;
@property (nonatomic) NSInteger detailTextLabelNumberOfLines;
@property (nonatomic) BOOL hasAccessoryView;
@property (nonatomic) BOOL persist;
@property (nonatomic) NSMutableDictionary *extraData;
@property (nonatomic) CGFloat extraHeight;

- (CGFloat)heightForWidth:(CGFloat)width;

@end
