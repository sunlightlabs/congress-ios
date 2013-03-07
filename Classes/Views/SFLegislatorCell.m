//
//  SFLegislatorCell.m
//  Congress
//
//  Created by Daniel Cloud on 2/20/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorCell.h"
#import "SFLegislator.h"

@implementation SFLegislatorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:19.0];
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self _reset];
}

-(void)setLegislator:(SFLegislator *)legislator
{
    if (_legislator != legislator) {
        _legislator = legislator;
        [self updateDisplay];
    }
}

- (void)updateDisplay
{
    self.textLabel.text = _legislator.titledByLastName;
    self.detailTextLabel.text = _legislator.fullDescription;
    if (_legislator.persist) {
        self.textLabel.textColor = [UIColor colorWithRed:0.337 green:0.627 blue:0.827 alpha:1.000];
        self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.950 alpha:1.000];
    }
    self.textLabel.backgroundColor = self.backgroundView.backgroundColor;
    self.detailTextLabel.backgroundColor = self.backgroundView.backgroundColor;
}

- (void)_reset
{
    self.textLabel.textColor = [UIColor primaryTextColor];
    self.backgroundView.backgroundColor = [UIColor primaryBackgroundColor];
    self.textLabel.backgroundColor = self.backgroundView.backgroundColor;
    self.detailTextLabel.backgroundColor = self.backgroundView.backgroundColor;
}

@end
