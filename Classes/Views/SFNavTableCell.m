//
//  SFNavTableCell.m
//  Congress
//
//  Created by Daniel Cloud on 11/30/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFNavTableCell.h"
#import <SAMGradientView/SAMGradientView.h>

@implementation SFNavTableCell

#pragma mark - UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont menuFont];
        self.textLabel.textColor = [UIColor menuTextColor];
        [self.textLabel setBackgroundColor:[UIColor menuBackgroundColor]];
        self.detailTextLabel.textColor = self.textLabel.textColor;

        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
        SAMGradientView *selBackground = [[SAMGradientView alloc] initWithFrame:CGRectZero];
        selBackground.backgroundColor = [UIColor menuSelectionBackgroundColor];
        selBackground.bottomBorderColor =  [UIColor menuDividerBottomColor];
        selBackground.bottomInsetColor =  [UIColor menuDividerBottomInsetColor];
        selBackground.contentMode = UIViewContentModeRedraw;
        self.selectedBackgroundView = selBackground;

        SAMGradientView *background = [[SAMGradientView alloc] initWithFrame:CGRectZero];
        background.backgroundColor = [UIColor menuBackgroundColor];
        background.bottomBorderColor =  [UIColor menuDividerBottomColor];
        background.bottomInsetColor =  [UIColor menuDividerBottomInsetColor];
        background.contentMode = UIViewContentModeRedraw;
        self.backgroundView = background;
        
        self.contentView.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.width = self.contentView.width;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self toggleFontFaceForSelected:selected];
}

- (void)toggleFontFaceForSelected:(BOOL)selected {
    if (selected) {
        self.textLabel.font = [UIFont menuSelectedFont];
    }
    else {
        self.textLabel.font = [UIFont menuFont];
    }
    [self.textLabel layoutSubviews];
}

@end
