//
//  CMSelfAdjustingTextView.h
//  Campus Mate
//
//  Created by Rob Visentin on 7/16/12.
//  Copyright (c) 2012 Bowdoin College. All rights reserved.
//
//  A view that displays text. A title is displayed in a header view that is of settable size.
//  The body of the text is displayed in a view that adjusts its size automatically to fit the size of the text.

#import <UIKit/UIKit.h>

@interface CMSelfAdjustingTextView : UIView
{
    UILabel *_headerView;   // label used for the "title" of the text view
    UILabel *_textView;     // label used for the body of the text view
}

@property (copy, nonatomic) NSString *title;            // title to be displayed in the header
@property (copy, nonatomic) NSString *text;             // body of the text to be displayed in the automatically adjusting view below the header
@property (strong, nonatomic) UIFont *headerFont;       // font to use in the header view
@property (strong, nonatomic) UIFont *textFont;         // font to use in the text body view
@property (nonatomic) float headerHeight;               // height of the header view. Header view's width is the full width of the view
@property (strong, nonatomic) UIColor *headerColor;     // background color of the header view
@property (strong, nonatomic) UIColor *headerTextColor; // color of the title in the header view
@property (strong, nonatomic) UIColor *textColor;       // color of the body text

@end
