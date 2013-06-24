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
@property (weak, nonatomic) NSString *cellIdentifier;
@property (weak, nonatomic) NSString *textLabelString;
@property (weak, nonatomic) UIFont *textLabelFont;
@property (weak, nonatomic) UIColor *textLabelColor;
@property (nonatomic) NSInteger textLabelNumberOfLines;
@property (weak, nonatomic) NSString *detailTextLabelString;
@property (weak, nonatomic) UIFont *detailTextLabelFont;
@property (weak, nonatomic) UIColor *detailTextLabelColor;
@property (nonatomic) NSInteger detailTextLabelNumberOfLines;
@property (weak, nonatomic) NSString *tertiaryTextLabelString;
@property (weak, nonatomic) UIFont *tertiaryTextLabelFont;
@property (weak, nonatomic) UIColor *tertiaryTextLabelColor;
@property (nonatomic) NSInteger tertiaryTextLabelNumberOfLines;
@property (nonatomic) BOOL selectable;
@property (nonatomic) BOOL persist;
@property (nonatomic) NSMutableDictionary *extraData;
@property (nonatomic) CGFloat extraHeight;

- (CGFloat)heightForWidth:(CGFloat)width;

@end
