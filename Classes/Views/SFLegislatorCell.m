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

    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    if (!selected && _legislator.persist) {
        [self setPersistStyle];
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
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
        [self setPersistStyle];
    }
}

@end
