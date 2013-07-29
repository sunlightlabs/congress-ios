//
//  SFBillCodeInputAccessoryView.m
//  Congress
//
//  Created by Jeremy Carbaugh on 7/29/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFBillCodeInputAccessoryView.h"
#import "SFInputAccessoryButton.h"

@implementation SFBillCodeInputAccessoryView {
    UIScrollView *_scrollView;
    SFInputAccessoryButton *_hrButton;
    SFInputAccessoryButton *_hresButton;
    SFInputAccessoryButton *_hjresButton;
    SFInputAccessoryButton *_hconresButton;
    SFInputAccessoryButton *_sButton;
    SFInputAccessoryButton *_sresButton;
    SFInputAccessoryButton *_sjresButton;
    SFInputAccessoryButton *_sconresButton;
}

@synthesize searchBar = _searchBar;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)_init
{
    float buttonHeight = 40.0f;
    float buttonWidth = 70.0f;
 
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, buttonHeight)];
    [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [_scrollView setBackgroundColor:[UIColor secondaryBackgroundColor]];
    [_scrollView setCanCancelContentTouches:NO];
    [_scrollView setClipsToBounds:NO];
    [_scrollView setIndicatorStyle:UIScrollViewIndicatorStyleDefault];
    [_scrollView setPagingEnabled:YES];
    [_scrollView setScrollEnabled:YES];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    
    _hrButton = [[SFInputAccessoryButton alloc] init];
    [_hrButton setTitle:@"H.R." forState:UIControlStateNormal];
    [_hrButton addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_hrButton];
    
    _hresButton = [[SFInputAccessoryButton alloc] init];
    [_hresButton setTitle:@"H. Res." forState:UIControlStateNormal];
    [_hresButton addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_hresButton];
    
    _hjresButton = [[SFInputAccessoryButton alloc] init];
    [_hjresButton setTitle:@"H.J. Res." forState:UIControlStateNormal];
    [_hjresButton addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_hjresButton];
    
    _hconresButton = [[SFInputAccessoryButton alloc] init];
    [_hconresButton setTitle:@"H.Con. Res." forState:UIControlStateNormal];
    [_hconresButton addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_hconresButton];
    
    _sButton = [[SFInputAccessoryButton alloc] init];
    [_sButton setTitle:@"S." forState:UIControlStateNormal];
    [_sButton addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_sButton];
    
    _sresButton = [[SFInputAccessoryButton alloc] init];
    [_sresButton setTitle:@"S. Res." forState:UIControlStateNormal];
    [_sresButton addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_sresButton];
    
    _sjresButton = [[SFInputAccessoryButton alloc] init];
    [_sjresButton setTitle:@"S.J. Res." forState:UIControlStateNormal];
    [_sjresButton addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_sjresButton];
    
    _sconresButton = [[SFInputAccessoryButton alloc] init];
    [_sconresButton setTitle:@"S.Con. Res." forState:UIControlStateNormal];
    [_sconresButton addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_sconresButton];
    
    [_hrButton setFrame:CGRectMake(0, 0, buttonWidth, buttonHeight)];
    [_hresButton setFrame:CGRectMake(buttonWidth, 0, buttonWidth, buttonHeight)];
    [_hjresButton setFrame:CGRectMake(buttonWidth * 2, 0, buttonWidth, buttonHeight)];
    [_hconresButton setFrame:CGRectMake(buttonWidth * 3, 0, buttonWidth, buttonHeight)];
    [_sButton setFrame:CGRectMake(buttonWidth * 4, 0, buttonWidth, buttonHeight)];
    [_sresButton setFrame:CGRectMake(buttonWidth * 5, 0, buttonWidth, buttonHeight)];
    [_sjresButton setFrame:CGRectMake(buttonWidth * 6, 0, buttonWidth, buttonHeight)];
    [_sconresButton setFrame:CGRectMake(buttonWidth * 7, 0, buttonWidth, buttonHeight)];
    
    [_scrollView setContentSize:CGSizeMake(buttonWidth * 8, buttonHeight)];
    
    [self addSubview:_scrollView];
}

- (void)handleButton:(SFInputAccessoryButton *)btn
{
    NSString *currentText = [_searchBar text];
    if ([currentText length] > 0) {
        [_searchBar setText:[NSString stringWithFormat:@"%@ %@ ", currentText, btn.titleLabel.text]];
    } else {
        [_searchBar setText:[NSString stringWithFormat:@"%@ ", btn.titleLabel.text]];
    }
    [_searchBar setKeyboardType:UIKeyboardTypeNumberPad];
    [_searchBar resignFirstResponder];
    [_searchBar becomeFirstResponder];
}

@end
