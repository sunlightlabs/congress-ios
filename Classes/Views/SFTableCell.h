//
//  SFTableCell.h
//  Congress
//
//  Created by Daniel Cloud on 3/7/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFTableCell : UITableViewCell

+ (CGFloat)contentInsetHorizontal;
+ (CGFloat)contentInsetVertical;
+ (CGFloat)detailTextLabelOffset;

@property (readonly) CGFloat cellHeight;
@property (readonly) UITableViewCellStyle cellStyle;
@property (nonatomic) BOOL selectable;
@property (nonatomic, retain) UIImageView *preTextImageView;

- (CGSize)labelSize:(UILabel *)label;

@end
