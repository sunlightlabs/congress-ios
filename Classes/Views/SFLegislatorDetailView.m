//
//  SFLegislatorDetailView.m
//  Congress
//
//  Created by Daniel Cloud on 12/13/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorDetailView.h"

@implementation SFLegislatorDetailView

#pragma mark - UIView

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		[self _initialize];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)_initialize
{
    self.backgroundColor = [UIColor whiteColor];
	self.opaque = YES;

    _photo = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 125.f)];
    [self addSubview:_photo];

    _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _nameLabel.font = [UIFont systemFontOfSize:16.0f];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_nameLabel];

    _infoText = [[UILabel alloc] initWithFrame:CGRectZero];
    _infoText.font = [UIFont systemFontOfSize:16.0f];
    _infoText.numberOfLines = 0;
    _infoText.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:_infoText];

    _callButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_callButton setTitle:@"Call" forState:UIControlStateNormal];
    [self addSubview:_callButton];

    _websiteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_websiteButton setTitle:@"Website" forState:UIControlStateNormal];
    [self addSubview:_websiteButton];
    
    _districtMapButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_districtMapButton setTitle:@"View Map" forState:UIControlStateNormal];
    [self addSubview:_districtMapButton];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)layoutSubviews
{
    CGSize size = self.bounds.size;

    _photo.frame = CGRectMake(0.0f, 0.0f, 100.0f, 125.0f);

    _nameLabel.frame = CGRectMake(_photo.frame.size.width + 4.0f, 0.0f, size.width, 0.0f);
    [_nameLabel sizeToFit];

    CGFloat offset_y = _photo.frame.origin.y + _photo.frame.size.height;
    [_infoText sizeToFit];
    _infoText.frame = CGRectMake(0.0f, offset_y, size.width, _infoText.frame.size.height);

    offset_y = _infoText.frame.origin.y + _infoText.frame.size.height;
    
    [_callButton sizeToFit];
    _callButton.frame = CGRectMake(0.0f, offset_y, size.width/2, _callButton.frame.size.height);
    
    CGFloat offset_button_x = _callButton.frame.size.width + _callButton.frame.origin.x;
    
    [_websiteButton sizeToFit];
    _websiteButton.frame = CGRectMake(offset_button_x, offset_y, size.width/2, _callButton.frame.size.height);
    
    
    [_districtMapButton sizeToFit];
    _districtMapButton.frame = CGRectMake(0.0f, offset_y + _callButton.frame.size.height, size.width, _callButton.frame.size.height);
    
}


@end
