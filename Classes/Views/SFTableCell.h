//
//  SFTableCell.h
//  Congress
//
//  Created by Daniel Cloud on 3/7/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const SFTableCellContentInsetHorizontal;
extern CGFloat const SFTableCellContentInsetVertical;
extern CGFloat const SFTableCellDetailTextLabelOffset;
extern CGFloat const SFTableCellPreTextImageOffset;
extern CGFloat const SFTableCellAccessoryOffset;

@class SFCellData;

@interface SFTableCell : UITableViewCell

+ (instancetype)cellWithData:(SFCellData *)data;
+ (NSString *)defaultCellIdentifer;
+ (NSInteger)defaultCellStyle;

@property (nonatomic) NSString *cellIdentifier;
@property (readonly) CGFloat cellHeight;
@property (readonly) UITableViewCellStyle cellStyle;
@property (nonatomic, readonly) SFCellData *cellData;
@property (nonatomic) BOOL selectable;

@property (nonatomic, strong) UILabel *decorativeHeaderLabel;
@property (nonatomic, strong) UIImageView *preTextImageView;
@property (nonatomic, strong) UILabel *tertiaryTextLabel;

- (void)setCellData:(SFCellData *)data;
- (void)setPersistStyle:(BOOL)persist;

@end
