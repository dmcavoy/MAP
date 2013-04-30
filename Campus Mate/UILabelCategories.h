//
//  UILabelCategories.h
//  Campus Mate
//
//  Created by Rob Visentin on 7/16/12.
//  Copyright (c) 2012 Bowdoin College. All rights reserved.
//

#ifndef Campus_Mate_UILabelCategories_h
#define Campus_Mate_UILabelCategories_h

@implementation UILabel (adjustFontSize)

// adjusts the size of the font, constrained by height, so it fits in the label
- (void)adjustFontSizeToFitHeight
{
    NSString *fontName = self.font.fontName;
    
    for (int i = 300; i >= self.minimumFontSize; i--) 
    {
        CGSize textSize = [self.text sizeWithFont:[UIFont fontWithName:fontName size:i]];
        
        if (textSize.height <= self.frame.size.height) 
        {
            self.font = [UIFont fontWithName:fontName size:i];
            break;
        }
    }
}

@end

#endif
