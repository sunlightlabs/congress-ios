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

//    CGFloat offset_y = _nameLabel.frame.origin.y + _nameLabel.frame.size.height;
}


@end
