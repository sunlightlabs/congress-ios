//
//  SFNavTableCell.m
//  Congress
//
//  Created by Daniel Cloud on 11/30/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFNavTableCell.h"

@implementation SFNavTableCell

#pragma mark - UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor = [UIColor menuTextColor];
        [self.textLabel setBackgroundColor:[UIColor menuBackgroundColor]];
        self.detailTextLabel.textColor = self.textLabel.textColor;

        SSBorderedView *background = [[SSBorderedView alloc] initWithFrame:CGRectZero];
        background.backgroundColor = [UIColor menuBackgroundColor];
        background.bottomBorderColor =  [UIColor menuDividerColor];
		background.contentMode = UIViewContentModeRedraw;
        self.backgroundView = background;
        self.contentView.clipsToBounds = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
