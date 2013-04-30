//
//  CMMapView.m
//  Bowdoin Map
//
//  Created by John Visentin on 1/12/13.
//  Copyright (c) 2012 Bowdoin College. All rights reserved.
//

#import "CMMapView.h"

@interface UnfadingTiledLayer : CATiledLayer
@end

@implementation UnfadingTiledLayer

+ (CFTimeInterval)fadeDuration
{
    return 0;
}

@end

@implementation CMMapView

/* from Apple PhotoScroller demo project: "to handle the interaction between CATiledLayer and high resolution screens, we need to always keep the tiling view's contentScaleFactor at 1.0. UIKit will try to set it back to 2.0 on retina displays, which is the right call in most cases, but since we're backed by a CATiledLayer it will actually cause us to load the wrong sized tiles." 
*/
- (void)setContentScaleFactor:(CGFloat)contentScaleFactor
{
    [super setContentScaleFactor:1.0f];
}

/* returns the image to draw in tile at given row, column */
- (UIImage *)tileForRow:(int)row col:(int)col
{
    NSString *tileName = [NSString stringWithFormat:@"%@-%d-%d", self.tileNameBase, col, row];
        
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:tileName ofType:@"jpg"]];    
}

- (void)drawRect:(CGRect)rect
{
     CGSize tileSize = ((CATiledLayer *)[self layer]).tileSize;    

    /* bounding row/col calculations from Apple's PhotoScroller demo */
    int firstCol = floorf(CGRectGetMinX(rect) / tileSize.width);
    int lastCol = floorf((CGRectGetMaxX(rect)-1) / tileSize.width);
    int firstRow = floorf(CGRectGetMinY(rect) / tileSize.height);
    int lastRow = floorf((CGRectGetMaxY(rect)-1) / tileSize.height);

    /* for each tile in the rect we're drawing, draw the appropriate image */
    for (int r = firstRow; r <= lastRow; r++)
    {
        for (int c = firstCol; c <= lastCol; c++)
        {
            UIImage *tile = [self tileForRow:r col:c];
            
            CGRect tileRect = CGRectMake(tileSize.width * c, tileSize.height * r, tileSize.width, tileSize.height);
            
            /* clip drawing rect if it exceeds the bounds of the whole rectangle */
            tileRect = CGRectIntersection(self.bounds, tileRect);
            
            [tile drawInRect:tileRect];
        }
    }
}

+ (Class)layerClass
{
    return [UnfadingTiledLayer class];
}

@end
