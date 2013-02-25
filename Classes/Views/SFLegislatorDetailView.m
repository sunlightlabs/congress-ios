//
//  SFLegislatorDetailView.m
//  Congress
//
//  Created by Daniel Cloud on 12/13/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorDetailView.h"

@implementation SFLegislatorDetailView

@synthesize nameLabel = _nameLabel;
@synthesize infoText = _infoText;
@synthesize photo = _photo;
@synthesize socialButtonsView = _socialButtonsView;
@synthesize callButton = _callButton;
@synthesize districtMapButton = _districtMapButton;
@synthesize websiteButton = _websiteButton;

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

    _socialButtonsView = [[UIView alloc] initWithFrame:CGRectZero];
//    _socialButtonsView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_socialButtonsView];
    
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
    [super layoutSubviews];
    CGSize size = self.bounds.size;

    _photo.frame = CGRectMake(0.0f, 0.0f, 100.0f, 125.0f);

    _nameLabel.frame = CGRectMake(_photo.right + 4.0f, 0.0f, size.width, 0.0f);
    [_nameLabel sizeToFit];

    [_infoText sizeToFit];
    _infoText.frame = CGRectMake(0.0f, _photo.bottom, size.width, _infoText.height);
    
    [_callButton sizeToFit];
    _callButton.frame = CGRectMake(0.0f, _infoText.bottom, size.width/2, _callButton.height);
    
    [_websiteButton sizeToFit];
    _websiteButton.frame = CGRectMake(_callButton.right, _callButton.top, size.width/2, _callButton.height);

    NSArray *subviews = [_socialButtonsView subviews];
    UIView *previousSubView = nil;
    CGFloat svMaxHeight = 0.0f;
    for (UIView *sv in subviews) {
        [sv sizeToFit];
        CGFloat xPos = 0.0f;
        if (previousSubView) {
            xPos = previousSubView.right + 1.0f;
        }
        sv.frame = CGRectMake(xPos, 0.0f, sv.width, sv.height);
        previousSubView = sv;
        svMaxHeight = MAX(svMaxHeight, sv.height);
    }
    [_socialButtonsView sizeToFit];
    _socialButtonsView.frame = CGRectMake(0.0f, _websiteButton.bottom, size.width, svMaxHeight);

    [_districtMapButton sizeToFit];
    _districtMapButton.frame = CGRectMake(0.0f, _socialButtonsView.bottom, size.width, _callButton.height);

}


@end
