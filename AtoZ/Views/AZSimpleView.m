//
//  AZSimpleView.m
//  AtoZ
//
//  Created by Alex Gray on 7/29/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AZSimpleView.h"
#import "AtoZ.h"

@implementation AZSimpleView
@synthesize glossy, backgroundColor, checkerboard, gradient;

- (id)initWithFrame:(NSRect)frame
{
 	if (self = [super initWithFrame:frame]) {
		[self setBackgroundColor:[NSColor blueColor]];
		glossy = NO;
	}
	return self;
}

-(void)	setFrameSizePinnedToTopLeft: (NSSize)siz
{
	NSRect		theBox = [self frame];
	NSPoint		topLeft = theBox.origin;
	topLeft.y += theBox.size.height;

	[[self superview] setNeedsDisplayInRect: theBox];	// Inval old box.

	theBox.size = siz;
	topLeft.y -= siz.height;
	theBox.origin = topLeft;
	[self setFrame: theBox];
	[self setNeedsDisplay: YES];
}


- (void)drawRect:(NSRect)rect {

	if (glossy)
		DrawGlossGradient([[NSGraphicsContext currentContext]graphicsPort],self.backgroundColor, [self bounds]);
	else if (gradient) {
		NSBezierPath *p =[NSBezierPath bezierPathWithRect: [self bounds]];// cornerRadius:0];
		[p fillGradientFrom:backgroundColor.darker.darker.darker to:backgroundColor.brighter.brighter angle:270];
	}
	else {
 	    [(checkerboard ? [NSColor checkerboardWithFirstColor:backgroundColor secondColor:backgroundColor.contrastingForegroundColor squareWidth:10] : [self backgroundColor]) set];
    	NSRectFill(rect);
	}
}


@end
