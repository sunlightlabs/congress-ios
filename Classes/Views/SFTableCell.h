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

+ (NSString *)defaultCellIdentifer;
+ (NSInteger)defaultCellStyle;
+ (instancetype)cellWithReuseIdentifier:(NSString *)reuseIdentifier;
+ (instancetype)cellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
+ (instancetype)cellWithData:(SFCellData *)data;

@property (nonatomic) NSString *cellIdentifier;
@property (readonly) CGFloat cellHeight;
@property (readonly) UITableViewCellStyle cellStyle;
@property (nonatomic, readonly) SFCellData *cellData;
@property (nonatomic, getter = isSelectable) BOOL selectable;
@property (nonatomic, getter = isProminent) BOOL prominent;

@property (nonatomic, strong) UILabel *decorativeHeaderLabel;
@property (nonatomic, strong) UIImageView *preTextImageView;
@property (nonatomic, strong) UILabel *tertiaryTextLabel;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)setCellData:(SFCellData *)data;

@end
