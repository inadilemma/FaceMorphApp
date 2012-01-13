//
//  Dragger.m
//  MyAgingBooth
//
//  Created by Mahmud on 3/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//this class defines the draggable markers

#import "Draggable.h"


@implementation Draggable

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    // Retrieve the touch point
    CGPoint pt = [[touches anyObject] locationInView:self];
    startLocation = pt;
    [[self superview] bringSubviewToFront:self];
    [[self superview] touchesBegan:touches withEvent:event];
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    // Move relative to the original touch point
    CGPoint pt = [[touches anyObject] locationInView:self];
    CGRect frame = [self frame];
    frame.origin.x += pt.x - startLocation.x;
    frame.origin.y += pt.y - startLocation.y;
    [self setFrame:frame];
    [[self superview] touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self superview] touchesEnded:touches withEvent:event];
}

@end