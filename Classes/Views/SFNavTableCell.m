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
        self.textLabel.textColor = [UIColor colorWithWhite:0.973 alpha:1.000];
        [self.textLabel setBackgroundColor:[UIColor clearColor]];
        self.detailTextLabel.textColor = self.textLabel.textColor;

        SSBorderedView *background = [[SSBorderedView alloc] initWithFrame:CGRectZero];
        background.backgroundColor = [UIColor colorWithRed:0.156 green:0.202 blue:0.270 alpha:1.000];
        background.bottomBorderColor =  [UIColor colorWithRed:0.857 green:0.879 blue:0.925 alpha:1.000];
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
