//
//  NSTextView+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 9/16/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//
#import "NSTextView+AtoZ.h"

@implementation AZTextViewResponder
- (void) mouseDown:(NSEvent *)theEvent {
	[[self nextResponder] mouseDown:theEvent];
}
@end
@implementation NSTextView (AtoZ)


//+ (void) load {
//
//	[$ swizzleMethod:@selector(insertText:) with:@selector(swizzledInsert:) in:self.class];
//}


- (void) swizzledInsert:(id) text; {	[self autoScrollText:text];	}

-	(void) autoScrollText:(id) text	{

	NSRange theEnd				= NSMakeRange([self.string length], 0);
	theEnd.location	   	+= [text length];
	// Smart Scrolling
	if (NSMaxY(self.visibleRect) == NSMaxY(self.bounds)) {
		// Append string to textview and scroll to bottom
		[text isKindOfClass:NSAS.class]
			?	[self.textStorage appendAttributedString:text]
			:	[self.textStorage appendString:text];
			[self scrollRangeToVisible:theEnd];
	} else	// Append string to textview
		[text isKindOfClass:NSAS.class]
			?	[self.textStorage appendAttributedString:text]
			:  [self.textStorage appendString:text];
}

-	(void) autoScrollAndStyleText:(NSString*) text;{

	static	NSColor *c = nil;  c = c ?: RANDOMCOLOR;
	static	NSDictionary *dict = nil;

	dict = dict ?: @{ @"NSFontAttributeName" : AtoZ.controlFont,
				   @"NSForegroundColorAttributeName" : c };
	[self autoScrollText:[NSAttributedString stringWithString:text attributes: dict]];
	// Get the length of the textview contents
}

+ (AZTextViewResponder*)  textViewForFrame:(NSRect)frame withString:(NSAttributedString*)s {

	NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle]mutableCopy];//
	// alloc] init];
	//	[theStyle setLineSpacing:[s enumerateAttributesInRange:[s length] options:nil usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
	//	}]  floor((int)(.8 * s.font.pointSize)];
	AZTextViewResponder *anAtv = [[AZTextViewResponder alloc]initWithFrame:frame];
	anAtv.selectable					= NO;
	anAtv.defaultParagraphStyle	   		= style;
	anAtv.backgroundColor			 	= CLEAR;
	anAtv.textStorage.attributedString 	= s;
	style.lineSpacing = (anAtv.textStorage.font.pointSize * .8);
	anAtv.defaultParagraphStyle	   		= style;
	//	[anAtv textStorage].foregroundColor = [NSColor blackColor]];
	return  anAtv;
}

- (IBAction)increaseFontSize:(id)sender
{
	NSTextStorage *textStorage = [self textStorage];
	[textStorage beginEditing];
	[textStorage enumerateAttributesInRange: NSMakeRange(0, [textStorage length])
									options: 0
								 usingBlock: ^(NSDictionary *attributesDictionary,
											   NSRange range,
											   BOOL *stop)
	 {
#pragma unused(stop)
		 NSFont *font = attributesDictionary[NSFontAttributeName];
		 if (font) {
			 [textStorage removeAttribute:NSFontAttributeName range:range];
			 font = [[NSFontManager sharedFontManager] convertFont:font toSize:[font pointSize] + 1];
			 [textStorage addAttribute:NSFontAttributeName value:font range:range];
		 }
	 }];
	[textStorage endEditing];
	[self didChangeText];

}

- (void)changeFontSize:(CGFloat)delta;
{
	NSFontManager * fontManager = [NSFontManager sharedFontManager];
	NSTextStorage * textStorage = [self textStorage];
	[textStorage beginEditing];
	[textStorage enumerateAttribute:NSFontAttributeName
							inRange:NSMakeRange(0, [textStorage length])
							options:0
						 usingBlock:^(id value,
									  NSRange range,
									  BOOL * stop)
	 {
		 NSFont * font = value;
		 font = [fontManager convertFont:font
								  toSize:[font pointSize] + delta];
		 if (font != nil) {
			 [textStorage removeAttribute:NSFontAttributeName
									range:range];
			 [textStorage addAttribute:NSFontAttributeName
								 value:font
								 range:range];
		 }
	 }];
	[textStorage endEditing];
	[self didChangeText];
}

-  (IBAction)decrementFontSize:(id)sender;
{
	[self changeFontSize:-1.0];
}

-  (IBAction)incrementFontSize:(id)sender;
{
	[self changeFontSize:1.0];
}

@end



@implementation NSSegmentedControl (FitTextNice)

- (void)fitTextNice {
	NSInteger N = [self segmentCount] ;
	NSInteger i ;

	CGFloat totalWidthAvailable = 0.0 ;
	for (i=0; i<N; i++) {
		totalWidthAvailable += [self widthForSegment:i] ;
	}

	CGFloat totalTextWidth = 0.0 ;
	NSMutableArray* textWidths = NSMA.new ;
	for (i=0; i<N; i++) {
		CGFloat textWidth = [[self labelForSegment:i] widthForHeight:CGFLOAT_MAX
																font:[self font]] ;
		[textWidths addObject:[NSNumber numberWithDouble:textWidth]] ;
		totalTextWidth += textWidth ;
	}

	CGFloat factor = totalWidthAvailable/totalTextWidth ;

	for (i=0; i<N; i++) {
		CGFloat textWidth = [[textWidths objectAtIndex:i] doubleValue] * factor ;
		[self setWidth:textWidth
			forSegment:i] ;
	}

	[textWidths release] ;
}

@end
