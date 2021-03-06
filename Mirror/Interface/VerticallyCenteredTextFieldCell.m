//
//  VerticallyCenteredTextFieldCell.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 14/07/15.
//  Copyright (c) 2015 Bruno. All rights reserved.
//

#import "VerticallyCenteredTextFieldCell.h"

@implementation VerticallyCenteredTextFieldCell

- (NSRect)titleRectForBounds:(NSRect)theRect {
    
    NSRect titleFrame = [super titleRectForBounds:theRect];
    NSSize titleSize = [[self attributedStringValue] size];
    titleFrame.origin.y = theRect.origin.y - .5 + (theRect.size.height - titleSize.height) / 2.0;
    
    return titleFrame;
    
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    
    NSRect titleRect = [self titleRectForBounds:cellFrame];
    [[self attributedStringValue] drawInRect:titleRect];
    
}

@end
