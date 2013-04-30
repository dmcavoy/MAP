//
//  CMSelfAdjustingTextView.m
//  Campus Mate
//
//  Created by Rob Visentin on 7/16/12.
//  Copyright (c) 2012 Bowdoin College. All rights reserved.
//

#import "CMSelfAdjustingTextView.h"
#import "UILabelCategories.h"

@interface CMSelfAdjustingTextView()
- (void)updateHeaderView;
- (void)updateTextView;
@end

@implementation CMSelfAdjustingTextView

@synthesize title = _title;
@synthesize text = _text;
@synthesize headerFont = _headerFont;
@synthesize textFont = _textFont;
@synthesize headerHeight = _headerHeight;
@synthesize headerColor = _headerColor;
@synthesize headerTextColor = _headerTextColor;
@synthesize textColor = _textColor;

- (id)init
{
    self = [super init];
    
    if (self)
    {
        /* set up the header view */
        _headerView = [[UILabel alloc] init];
        _headerView.autoresizingMask = self.autoresizingMask;
        _headerView.adjustsFontSizeToFitWidth = YES;
        _headerView.textAlignment = UITextAlignmentLeft;
        
        /* set up the text body view */
        _textView = [[UILabel alloc] init];
        _textView.autoresizingMask = self.autoresizingMask;
        _textView.adjustsFontSizeToFitWidth = YES;
        _textView.textAlignment = UITextAlignmentLeft;
        
        [self addSubview:_headerView];
        [self addSubview:_textView];
        
        /* default color set. These values have a "Bowdoin-esque" feel */
        self.backgroundColor = [UIColor whiteColor];
        self.headerColor = [UIColor blackColor];
        self.headerTextColor = [UIColor whiteColor];
        self.textColor = [UIColor blackColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        /* set up the header view */
        _headerView = [[UILabel alloc] init];
        _headerView.autoresizingMask = self.autoresizingMask;
        _headerView.adjustsFontSizeToFitWidth = YES;
        _headerView.textAlignment = UITextAlignmentLeft;
        
        /* set up the text body view */
        _textView = [[UILabel alloc] init];
        _textView.autoresizingMask = self.autoresizingMask;
        _textView.adjustsFontSizeToFitWidth = YES;
        _textView.textAlignment = UITextAlignmentLeft;
        
        [self addSubview:_headerView];
        [self addSubview:_textView];
        
        /* default color set. These values have a "Bowdoin-esque" feel */
        self.backgroundColor = [UIColor whiteColor];
        self.headerColor = [UIColor blackColor];
        self.headerTextColor = [UIColor whiteColor];
        self.textColor = [UIColor blackColor];
    }
    return self;
}

/* called when initializing from  storyboard. currently duplicates init */
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        /* set up the header view */
        _headerView = [[UILabel alloc] init];
        _headerView.autoresizingMask = self.autoresizingMask;
        _headerView.adjustsFontSizeToFitWidth = YES;
        _headerView.textAlignment = UITextAlignmentLeft;
        
        /* set up the text body view */
        _textView = [[UILabel alloc] init];
        _textView.autoresizingMask = self.autoresizingMask;
        _textView.adjustsFontSizeToFitWidth = YES;
        _textView.textAlignment = UITextAlignmentLeft;
        _textView.numberOfLines = 0;
        _textView.lineBreakMode = UILineBreakModeWordWrap;
        
        [self addSubview:_headerView];
        [self addSubview:_textView];
        
        /* default color set. These values have a "Bowdoin-esque" feel */
        self.backgroundColor = [UIColor whiteColor];
        self.headerColor = [UIColor blackColor];
        self.headerTextColor = [UIColor whiteColor];
        self.textColor = [UIColor blackColor];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    
    [self updateHeaderView];
}

- (void)setText:(NSString *)text
{
    _text = [text copy];
    
    /* reload the body view because it needs to adjust to the new text */
    [self updateTextView];
}

- (void)setHeaderFont:(UIFont *)headerFont
{
    _headerView.font = headerFont;
    
    /* changing the header font also changes the text body font */
    [self updateHeaderView];
    [self updateTextView];
}

- (UIFont *)headerFont
{
    /* create default header font if not already set */
    if (!_headerFont) 
    {
        _headerFont = [UIFont fontWithName:FONT_NAME_BOLD size:16.0];
        _headerView.font = _headerFont;
    }
    return _headerView.font;
}

- (void)setTextFont:(UIFont *)textFont
{
    /* note that while the text font can change, the text font size will always equal the header font size */
    _textView.font = [UIFont fontWithName:textFont.fontName size:self.headerFont.pointSize];
        
    [self updateTextView];
}

- (UIFont *)textFont
{
    /* create default text font if not already set */
    if (!_textFont) 
    {
        _textFont = [UIFont fontWithName:FONT_NAME_STANDARD size:self.headerFont.pointSize];
        _textView.font = _textFont;
    }
    
    return _textView.font;
}

- (void)setHeaderHeight:(float)headerHeight
{
    _headerHeight = headerHeight;
    
    [self updateHeaderView];
    [self updateTextView];
}

- (void)setHeaderColor:(UIColor *)headerColor
{
    _headerColor = headerColor;
    
    _headerView.backgroundColor = _headerColor;
}

- (void)setHeaderTextColor:(UIColor *)headerTextColor
{
    _headerTextColor = headerTextColor;
    
    _headerView.textColor = _headerTextColor;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    
    _textView.textColor = _textColor;
}

- (void)updateHeaderView
{
    _headerView.frame = CGRectMake(0.0f, 0.0f, self.bounds.size.width, _headerHeight);
    _headerView.font = self.headerFont;
    _headerView.text = self.title;
    [_headerView adjustFontSizeToFitHeight];
}

- (void)updateTextView
{
    /* calculate new view frame */
    CGRect textFrame = UIEdgeInsetsInsetRect(CGRectMake(0.0f, self.headerHeight, self.frame.size.width, 0.0f), UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 5.0f));
    
    _textView.frame = textFrame;
    _textView.font = self.textFont;
    _textView.text = self.text;
    [_textView sizeToFit];
    
    CGFloat newHeight = _textView.bounds.size.height > 0 ? self.headerHeight + _textView.bounds.size.height + 6.0f : self.headerHeight;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, newHeight);
    
    [self setNeedsDisplay];    
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    /* only apply mask if the text body view is visible */
    if (self.text.length)
    {
        /* this path will round off the bottom two corners of the view */
        UIBezierPath *roundedPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10.0f, 10.0f)];    
        
        /* mask the view according to the above path. This rounds the bottom corners of the view */
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = self.bounds;
        maskLayer.fillColor = self.backgroundColor.CGColor;
        maskLayer.backgroundColor = [UIColor clearColor].CGColor;
        maskLayer.path = roundedPath.CGPath;
        
        self.layer.mask = maskLayer;
    }
    else
    {
        self.layer.mask = nil;
    }
}

@end
