
//  NSView+AtoZ.m
//  AtoZ

//  Created by Alex Gray on 7/1/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
#import "NSView+AtoZ.h"
//#import "AGFoundation.h"
#import "AtoZGeometry.h"
#import "AtoZ.h"
#import <QuartzCore/QuartzCore.h>
//#import <DrawKit/DKShapeFactory.h>

//@interface NSView ()
//+ (void)runEndBlock:(void (^)(void))completionBlock;
//@end


NSTimeInterval AZDefaultAnimationDuration = -1; // -1 makes the system provide a default duration
NSAnimationBlockingMode AZDefaultAnimationBlockingMode = NSAnimationNonblocking;
NSAnimationCurve AZDefaultAnimationCurve = NSAnimationEaseInOut;

#import <objc/runtime.h>

//static char const * const ObjectTagKey = "ObjectTag";
static char const * const ObjectRepKey = "ObjectRep";

@implementation NSView (ObjectRep)
@dynamic objectRep;

- (id)objectRep {
	return objc_getAssociatedObject(self, ObjectRepKey);
}

- (void)setObjectRep:(id)newObjectRep {
	objc_setAssociatedObject(self, ObjectRepKey, newObjectRep, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSImage*) captureFrame
{
	
	NSRect originRect = [[self window] convertRectToScreen:[self bounds]]; // toView:[[self window] contentView]];
	
	NSRect rect = originRect;
	rect.origin.y = 0;
	rect.origin.x += [self window].frame.origin.x;
	rect.origin.y += [[self window] screen].frame.size.height - [self window].frame.origin.y - [self window].frame.size.height;
	rect.origin.y += [self window].frame.size.height - originRect.origin.y - originRect.size.height;
	
	CGImageRef cgimg = CGWindowListCreateImage(rect,
															 kCGWindowListOptionIncludingWindow,
															 (CGWindowID)[[self window] windowNumber],
															 kCGWindowImageDefault);
	NSIMG *img = [NSImage.alloc initWithCGImage:cgimg size:[self bounds].size];
	CFRelease(cgimg);
	return img;
}
- (NSView *)viewWithObjectRep:(id)object {
	// Raise an exception if object is nil
	if (object == nil) {
		[NSException raise:NSInternalInconsistencyException format:@"Argument to -viewWithObjectTag: must not be nil"];
	}
	
	// Recursively search the view hierarchy for the specified objectTag
	if ([self.objectRep isEqual:object]) {
		return self;
	}
	for (NSView *subview in self.subviews) {
		NSView *resultView = [subview viewWithObjectRep:object];
		if (resultView != nil) {
			return resultView;
		}
	}
	return nil;
}

@end

static NSString *ANIMATION_IDENTIFER = @"animation";
static char const * const ISANIMATED_KEY = "ObjectRep";

@implementation NSView (AtoZ)

-(CALayer *)layerFromContents		{

	CALayer *newLayer = CALayer.layer;
	newLayer.bounds = NSRectToCGRect(self.bounds);
	NSBitmapImageRep *bitmapRep = [self bitmapImageRepForCachingDisplayInRect:self.bounds];
	[self cacheDisplayInRect:self.bounds toBitmapImageRep:bitmapRep];
	newLayer.contents =  [NSIMG.alloc initWithData:bitmapRep.TIFFRepresentation];
	return newLayer;
}

- (NSBP*) path {  return [NSBP bezierPathWithRect:self.bounds]; }

- (CGF) maxDim { return AZMaxDim(self.size); }
- (CGF) minDim { return AZMinDim(self.size); }


- (NSV*) autosizeable { self.arMASK = NSSIZEABLE; return self; }


// setup 3d transform
- (void) setZDistance: (NSUInteger) zDistance
{
	CATransform3D aTransform = CATransform3DIdentity;
	aTransform.m34 = -1.0 / zDistance;
	if (!self.layer) [self setupHostView];
	self.layer.sublayerTransform = aTransform;
}

- (CGP)layerPoint:(NSEvent*)event;
{
	return [self convertPointToLayer:[self convertPoint:event.locationInWindow fromView:nil]];
}
- (CGP)layerPoint:(NSEvent*)event toLayer:(CAL*)layer;
{
	return [self.layer convertPoint:[self layerPoint:event] toLayer:layer];
}

- (void) observeFrameChangeUsingBlock:(void(^)(void))block
{
	self.postsFrameChangedNotifications  = YES;
	self.postsBoundsChangedNotifications = YES;
	[@[NSViewFrameDidChangeNotification, NSViewBoundsDidChangeNotification] each:^(NSS* name) {
		[self observeName:name usingBlock:^(NSNotification *n) {	block();	}];			}];
}
- (BOOL)isSubviewOfView:(NSView*) theView
{
	__block BOOL isSubView = NO;
	[[theView subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if ([self isEqualTo:(NSView*) obj]) {
			isSubView = YES;
			*stop = YES;
		}
	}];
	return isSubView;
}
- (BOOL)containsSubView:(NSView*) subview
{
	__block BOOL containsSubView = NO;
	[[self subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if ([subview isEqualTo:(NSView*) obj]) {
			containsSubView = YES;
			*stop = YES;
		}
	}];
	return containsSubView;
}


- (void)setCenter:(NSPoint)center
{
	[self setFrameOrigin:NSMakePoint(floorf(center.x - (NSWidth([self bounds])) / 2),
												floorf(center.y - (NSHeight([self bounds])) / 2))];
}
- (NSPoint)getCenter
{
	return NSMakePoint(floorf(self.bounds.origin.x + (self.bounds.size.width / 2)),
							 floorf(self.bounds.origin.y + (self.bounds.size.height / 2)));
}
- (NSPoint)getCenterOnFrame
{
	return NSMakePoint(floorf(self.frame.origin.x + (self.frame.size.width / 2)),
							 floorf(self.frame.origin.y + (self.frame.size.height / 2)));
}

- (void) maximize{
	NSRect r = [self.window.contentView bounds];
	self.autoresizesSubviews = YES;
	self.autoresizingMask = NSSIZEABLE;
	[self setFrame:r];
	[self setNeedsDisplay:YES];
	
}
//@dynamic center;
- (NSRect) centerRect:(NSRect) aRect onPoint:(NSPoint) aPoint
{
	float
	height = NSHeight(aRect),
	width = NSWidth(aRect);
	
	return NSMakeRect(aPoint.x-(width/2.0), aPoint.y - (height/2.0), width, height);
}

- (void) centerOriginInBounds { [self centerOriginInRect:[self bounds]];  }
- (void) centerOriginInFrame { [self centerOriginInRect:[self convertRect:[self frame] fromView:[self superview]]];  }
- (void) centerOriginInRect:(NSRect) aRect  { [self translateOriginToPoint:NSMakePoint(NSMidX(aRect), NSMidY(aRect))]; }
- (void) slideDown {
	
	NSRect newViewFrame;
	if ([self valueForKeyPath:@"dictionary.visibleRect"] ) {
		newViewFrame = 	[[self valueForKeyPath:@"dictionary.visibleRect"]rectValue];
	} else {
		/*		id aView = [ @[ self, [ self superview], [self window]] filterOne:^BOOL(id object) {
		 return  [object respondsToSelector:@selector(orientation)] ? YES : NO ;
		 }];
		 if  (aView) { 	AZOrient b = (AZOrient)[aView valueForKey:@"orientation"];
		 //		NSLog(@"computed orentation  %ld", b);
		 NSLog(@"computed orentation %@", AZOrientName[b]);
		 }
		 */		newViewFrame = AZMakeRectFromSize([[self superview]frame].size);
		//		AZRectVerticallyOffsetBy( [self frame], -[self frame].size.height);
	}
	
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"frame"];
	[animation setFromValue:AZVrect([self frame])];
	[animation setToValue:	AZVrect(newViewFrame)];
	
	//	CABasicAnimation *fader = [CABasicAnimation animationWithKeyPath:@"alphaValue"];
	//	[fader setFromValue:@0.f];
	//	[fader setToValue:@1.f];
	[self setAnimations:	@{ @"frame" : animation}];
	
	[[self animator] setFrame:newViewFrame];
}

-(void) slideUp {
	
	if (! [self valueForKeyPath:@"dictionary.visibleRect"] ) {
		NSLog(@"avaing cvisirect: %@", NSStringFromRect([self frame]));
		[self setValue:AZVrect([self frame]) forKeyPath:@"dictionary.visibleRect"];
	}
	NSRect newViewFrame = [self frame];
	AZWindowPosition r = AZPositionOfQuadInRect([[self window]frame], AZScreenFrameUnderMenu());
	NSSize getOut = AZDirectionsOffScreenWithPosition(newViewFrame,r);
	newViewFrame.size.width  += getOut.width;
	newViewFrame.size.height += getOut.height;
	CABasicAnimation *framer = [CABasicAnimation animationWithKeyPath:@"frame"];
	[framer setFromValue:AZVrect([self frame])];
	[framer setToValue:	AZVrect(newViewFrame)];
	[self setAnimations:	@{ @"frame" : framer}];
	[[self animator] setFrame:newViewFrame];
}

- (NSA*)allSubviews {
	NSMutableArray *allSubviews = [NSMutableArray arrayWithObject:self];
	NSArray *subviews = [self subviews];
	for (NSView *view in subviews) {
		[allSubviews addObjectsFromArray:[view allSubviews]];
	}
	return [allSubviews copy];
}
-(void)setAnimationIdentifer:(NSS*)newAnimationIdentifer{
	objc_setAssociatedObject(self, &ANIMATION_IDENTIFER, newAnimationIdentifer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString*)animationIdentifer{
	return objc_getAssociatedObject(self, &ANIMATION_IDENTIFER);
}

-(void) replaceSubviewWithRandomTransition:(NSView *)oldView with:(NSView *)newView
{
	BOOL hasLayer = (self.layer == nil);
	if (!hasLayer) [self setWantsLayer:YES];
	[self setAnimations:@{@"subviews":[CATransition randomTransition]}];
	[self replaceSubview:oldView with:newView];
	if (!hasLayer) [self setWantsLayer:NO];
}

- (void) swapSubs:(NSView*)view;
{
	NSS* firstID = [[self firstSubview]identifier];
	[[self firstSubview]fadeOut];
	[self removeAllSubviews];
	
	[view setHidden:YES];
	[self addSubview:view];
	[view setFrame:self.bounds];
	[view fadeIn];
	NSLog(@"Swapped subview: %@ for %@", firstID, view);
}

-(NSPoint) center {
	return AZCenterOfRect ([self frame]);
}

//-(void)setCenter:(NSPoint)center {
//	objc_setAssociatedObject(self, &ISANIMATED_KEY, NSPoiu numberWithBool:animated], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

//-(NSPoint)center {
//   return [objc_getAssociatedObject(self, &ISANIMATED_KEY) boolValue];
//}

/*** A "layer backed NSView"
 1. can have subviews.  it is a normal view after all
 2. it uses a layer as "pixel backing storage", instead of the kind of storage views otherwise use.
 3. the backing layer of a NSView cannot have sublayers (there is no support for "layer hierarchies").
 
 NSView *layerBacked = [NSView new];
 [layerBacked setWantsLayer:YES];
 
 A "layer hosting" view
 1. cannot have subviews
 2. its sole purpose is to "host a layer"
 3. the layer it hosts can have sublayers and a very complex layer-tree-hierarchy.
 
 NSView *layerHosting = [NSView new];
 CALayer *layer = [CALayer new];
 [layerHosting setLayer:layer];
 [layerHosting setWantsLayer:YES];
 */

-(CALayer*) setupHostViewNamed:(NSS*)name {
	CAL *i = [self setupHostView];
	i.name = name;
	return i;
}
-(CALNH*) setupHostViewNoHit {
	CALNH *layer = [CALNH layerNamed:@"root"];
	[self setLayer:layer];
	[self setWantsLayer:YES];
	NSLog(@"setup NOHIT hosting layer:%@ in view: %@.  do not addsubviews to this view.  go crazy with layers.", layer.debugDescription, self);
	return layer;
}

-(CALayer*) setupHostView {
	CALayer *layer = [CALayer layerNamed:@"root"];
	layer.hostView = self;
	
	//	layer.frame = [self bounds];
	//	layer.position = [self center];
	//	layer.bounds = [self bounds];
	//	layer.needsDisplayOnBoundsChange = YES;
	//	layer.backgroundColor = cgRANDOMCOLOR;
	//	layer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
	[self setLayer:layer];
	[self setWantsLayer:YES];
	//	NSLog(@"setup hosting layer:%@ in view: %@.  do not addsubviews to this view.  go crazy with layers.", layer.debugDescription, self);
	return layer;
}
- (NSView *)firstSubview
{
	return [self.subviews count] == 0 ? nil: self.subviews[0];
}

- (NSView *)lastSubview {
	return self.subviews.count == 0 ? nil : [self.subviews lastObject];
}

- (void)setLastSubview:(NSView *)view {
	[self addSubview:view];
}

//Remove all the subviews from a view
- (void)removeAllSubviews;
{
	NSEnumerator* enumerator = [[self subviews] reverseObjectEnumerator];
	NSView* view;
	
	while (view = [enumerator nextObject])
		[view removeFromSuperviewWithoutNeedingDisplay];
}

//NSArray 	*subviews;  int		loop;
//subviews = [[self subviews] copy];
//for (loop = 0;loop < [subviews count]; loop++) {
//	[[subviews objectAtIndex:loop] removeFromSuperview];
//}
-(NSTrackingArea *)trackFullView {
	NSTrackingAreaOptions options =
	NSTrackingMouseEnteredAndExited
	| NSTrackingMouseMoved
	| NSTrackingActiveInKeyWindow
	| NSTrackingInVisibleRect ;
	NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:NSMakeRect(0, 0, 0, 0)
																		 options:options
																			owner:self
																		userInfo:nil];
	[self addTrackingArea:area];
	return area;
}

-(NSTrackingArea *)trackAreaWithRect:(NSRect)rect {
	return [self trackAreaWithRect:rect userInfo:nil];
}

-(NSTrackingArea *)trackAreaWithRect:(NSRect)rect
									 userInfo:(NSD*)context
{
	NSTrackingAreaOptions options = NSTrackingMouseEnteredAndExited
	| NSTrackingMouseMoved
	| NSTrackingActiveInKeyWindow;
	NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:rect
																		 options:options
																			owner:self
																		userInfo:context];
	[self addTrackingArea:area];
	return area;
}

-(BOOL)requestFocus {
	return [[self window] makeFirstResponder:self];
}

-(void)animate:(AZViewAnimationType)type {
	
	CALayer *touchedLayer;
	if  (self.layer) touchedLayer = self.layer;
	else { touchedLayer = [CALayer layer]; [self setLayer: touchedLayer]; [self setWantsLayer:YES];}
	touchedLayer.masksToBounds = NO;
	//	touchedLayer.anchorPoint = CGPointMake(.5,.5);
	// here is an example wiggle
	CABasicAnimation *wiggle = [CABasicAnimation animationWithKeyPath:@"transform"];
	wiggle.duration = 3;
	wiggle.timeOffset = RAND_FLOAT_VAL(0, 1);
	wiggle.repeatCount = HUGE_VALF;
	wiggle.autoreverses = YES;
	//	Rotate 't' by 'angle' radians about the vector '(x, y, z)' and return the result. If the vector has zero length the behavior is undefined: t' = rotation(angle, x, y, z) * t.
	//  Original signature is 'CATransform3D CATransform3DRotate (CATransform3D t, CGFloat angle, CGFloat x, CGFloat y, CGFloat z)'
	switch (type) {
		case AZViewAnimationTypeJiggle:
			wiggle.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(touchedLayer.transform,0.1, 0.0 ,1.0 ,2.0)];
			break;
		case AZViewAnimationTypeFlipHorizontally:
			wiggle.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(touchedLayer.transform,DEG2RAD(180), 1,0,0)];
		default:
			break;
	}
	// doing the wiggle
	[touchedLayer addAnimation:wiggle forKey:@"jiggle"];
	
	// setting a timer to remove the layer
	//	NSTimer *wiggleTimer = [NSTimer scheduledTimerWithTimeInterval:(2) target:self selector:@selector(endWiggle:) userInfo:touchedLayer repeats:NO];
	
}

-(void)stopAnimating{
	//:(NSTimer*)timer {
	// stopping the wiggle now
	[self.layer removeAllAnimations];
}
- (void)resizeFrameBy:(int)value {
	NSRect frame = [self frame];
	[[self animator]setFrame:CGRectMake(frame.origin.x,
													frame.origin.x,
													frame.size.width + value,
													frame.size.height + value
													)];
}


- (NSA*)animationArrayForParameters:(NSD*)params
{
	NSMutableDictionary *animationDetails = [NSMutableDictionary
														  dictionaryWithDictionary:params];
	animationDetails[NSViewAnimationTargetKey] = self;
	return @[animationDetails];
}

- (void)playAnimationWithParameters:(NSD*)params
{
	NSViewAnimation *animation = [[NSViewAnimation alloc]
											initWithViewAnimations:[self animationArrayForParameters:params]];
	[animation setAnimationBlockingMode:AZDefaultAnimationBlockingMode];
	[animation setDuration:AZDefaultAnimationDuration];
	[animation setAnimationCurve:AZDefaultAnimationCurve];
	[animation setDelegate:(id)self];
	[animation startAnimation];
}
- (void)fadeWithEffect:effect
{
	[self playAnimationWithParameters:@{NSViewAnimationEffectKey: effect}];
}

- (void)fadeOut 
{
	[self fadeWithEffect:NSViewAnimationFadeOutEffect];
}

- (void)fadeIn
{
	[self fadeWithEffect:NSViewAnimationFadeInEffect];
}

- (void)animateToFrame:(NSRect)newFrame
{
	[self playAnimationWithParameters:@{NSViewAnimationEndFrameKey: AZVrect(newFrame)}];
}

- (void)fadeToFrame:(NSRect)newFrame
{
	[self playAnimationWithParameters:@{NSViewAnimationEndFrameKey: AZVrect(newFrame), NSViewAnimationEffectKey: [self isHidden] ?
		  NSViewAnimationFadeInEffect : NSViewAnimationFadeOutEffect}];
}

+ (void)setDefaultDuration:(NSTimeInterval)duration
{
	AZDefaultAnimationDuration = duration;
}

+ (void)setDefaultBlockingMode:(NSAnimationBlockingMode)mode
{
	AZDefaultAnimationBlockingMode = mode;
}

+ (void)setDefaultAnimationCurve:(NSAnimationCurve)curve
{
	AZDefaultAnimationCurve = curve;
}

- (NSImage *) snapshot { return [self snapshotFromRect:[self frame]]; }

//  This method creates a new image from a portion of the receiveing view.
- (NSImage *) snapshotFromRect:(NSRect) sourceRect; {
	NSImage *snapshot = [[NSImage alloc] initWithSize:sourceRect.size];
	[self lockFocus];
	NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:sourceRect];
	[self unlockFocus];
	[snapshot addRepresentation:rep];
	return snapshot;
}

+ (void)animateWithDuration:(NSTimeInterval)duration 
						animation:(void (^)(void))animationBlock
{
	[self animateWithDuration:duration animation:animationBlock completion:nil];
}
+ (void)animateWithDuration:(NSTimeInterval)duration 
						animation:(void (^)(void))animationBlock
					  completion:(void (^)(void))completionBlock
{
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:duration];
	animationBlock();
	[NSAnimationContext endGrouping];
	
	if(completionBlock)
	{
		id completionBlockCopy = [completionBlock copy];
		[self performSelector:@selector(runEndBlock:) withObject:completionBlockCopy afterDelay:duration];
	}
}
+ (void)runEndBlock:(void (^)(void))completionBlock
{
	completionBlock();
}

/////[i convertPoint: [[i window] convertScreenToBase:[NSEvent mouseLocation]] fromView: nil ]
- (NSP)windowPoint 
{
	NSPoint globalLocation 	= NSE.mouseLocation;
	NSPoint windowLocation 	= [self.window convertScreenToBase:globalLocation];
	NSPoint viewLocation 		= [self convertPoint: windowLocation fromView: nil];
	return viewLocation;
}

- (NSPoint) localPoint;
{
	return [self convertPoint: [[self window] convertScreenToBase:NSPointFromCGPoint( mouseLoc())] fromView:nil];
	//								[NSEvent mouseLocation]] fromView: nil ]
}

- (void) handleMouseEvent:(NSEventMask)mask withBlock:(void (^)())block  {
	[NSEvent addLocalMonitorForEventsMatchingMask:mask handler:^NSEvent *(NSEvent *event) {
		NSPoint localP = self.localPoint;
		[self setNeedsDisplay:YES];
		NSLog(@"oh my god.. point %@", NSStringFromPoint(localP));
		if ([event type] == mask ) {
			
			//			if ( NSPointInRect(localP, view.frame) ){
			NSLog(@"oh my god.. point is local to view: %@! Localpoint: %@...  about to run block !!". self.description, [self localPoint]);
			[[NSThread mainThread] performBlock:block waitUntilDone:YES];
			//			[NSThread performBlockInBackground:block];
		}
		return event;
	}];
	return;
}

@end

void AZMoveView(NSView* view, CGF dX, CGF dY) {
	NSRect frame = [view frame] ;
	frame.origin.x += dX ;
	frame.origin.y += dY ;
	[view setFrame:frame] ;
}

void AZResizeView(NSView* view, CGF dX, CGF dY) {
	NSRect frame = [view frame] ;
	frame.size.width += dX ;
	frame.size.height += dY ;
	[view setFrame:frame] ;
}

void AZResizeViewMovingSubviews(NSView* view, CGF dXLeft, CGF dXRight, CGF dYTop, CGF dYBottom) {
	AZResizeView(view, dXLeft + dXRight, dYTop + dYBottom) ;
	
	NSArray* subviews = [view subviews] ;
	NSEnumerator* e ;
	NSView* subview ;
	
	// If we wanted to change the "left", move all existing subviews to the right
	if (dXLeft != 0.0) {
		e = [subviews objectEnumerator] ;
		while ((subview = [e nextObject])) {
			AZMoveView(subview, dXLeft, 0.0) ;
		}
	}
	
	// If we wanted to change the "bottom", move all existing subviews up
	if (dYBottom != 0.0) {
		e = [subviews objectEnumerator] ;
		while ((subview = [e nextObject])) {
			AZMoveView(subview, 0.0, dYBottom) ;
		}
	}
	[view display] ;
}

NSView* AZResizeWindowAndContent(NSWindow* window, CGF dXLeft, CGF dXRight, CGF dYTop, CGF dYBottom, BOOL moveSubviews) {
	NSView* view = [window contentView] ;
	if (moveSubviews)
		AZResizeViewMovingSubviews(view, dXLeft, dXRight, dYTop, dYBottom) ;
	else
		AZResizeView(view, dXLeft + dXRight, dYTop + dYBottom) ;
	NSRect frame = [window frame] ;
	frame.size.width += (dXLeft + dXRight) ;
	frame.size.height += (dYTop + dYBottom) ;
	// Since window origin is at the bottom, and we want  the bottom to move instead of the top, we also adjust the origin.y
	frame.origin.y -= (dYTop + dYBottom) ;
	// since screen y is measured from the top, we have to	subtract instead of add
	[window setFrame:frame display:YES] ;
	return view ;  // because often this is handy
}

@implementation NSView (Layout)

- (CGF)leftEdge {	return [self frame].origin.x ;	}

- (CGF)rightEdge {	return [self frame].origin.x + [self width] ;	}

- (CGF)centerX {	return ([self frame].origin.x + [self width]/2) ;	}

- (void)setLeftEdge:(CGF)t {	NSRect frame = [self frame] ;	frame.origin.x = t ;	[self setFrame:frame] ;	}

- (void)setRightEdge:(CGF)t {	NSRect frame = [self frame] ;	frame.origin.x = t - [self width] ;	[self setFrame:frame];	}

- (void)setCenterX:(CGF)t {	float center = [self centerX] ;	float adjustment = t - center ;
	NSRect frame = [self frame] ;	frame.origin.x += adjustment ;	[self setFrame:frame];
}



- (CGF)bottom {	return [self frame].origin.y ;	}

- (CGF)top {		return [self frame].origin.y + [self height] ;	}

- (CGF)centerY {	return ([self frame].origin.y + [self height]/2) ;}

- (void)setBottom:(CGF)t {	NSRect frame = [self frame] ;	frame.origin.y = t ;	[self setFrame:frame] ;	}

- (void) setBottom:(CGF)t duration:(NSTI)time
{
	[NSAnimationContext runAnimationBlock:^{	NSRect frame = self.frame;	frame.origin.y = t;
		[[self animator] setFrame:frame]; }
							  completionHandler:nil	duration: time];
}

- (void) setTop:(CGF)t duration:(NSTI)time; {
	
}
- (void) setCenterY:(CGF)t duration:(NSTI)time {}

- (void)setTop:(CGF)t {	NSRect frame = [self frame] ;	frame.origin.y = t - [self height] ;	[self setFrame:frame] ;	}

- (void)setCenterY:(CGF)t {		float center = [self centerY] ;		float adjustment = t - center ;
	NSRect frame = [self frame] ;	frame.origin.y += adjustment ;		[self setFrame:frame] ;
}

- (CGF)width {	return [self frame].size.width ;		}

- (CGF)height {	return [self frame].size.height ;	}

- (void)setWidth:(CGF)t {
	NSRect frame = [self frame] ;
	frame.size.width = t ;
	[self setFrame:frame] ;
}

- (void)setHeight:(CGF)t 	{ 	self.frame = AZRectExceptHigh(self.frame, t); }

- (NSSize)size 				{	return  self.bounds.size; }

- (void)setSize:(NSSize)size
{
	NSR frame = self.frame ;
	frame.size.width  = size.width ;
	frame.size.height = size.height ;
	self.frame = frame;
}

- (void)deltaX:(CGF)dX
		  deltaW:(CGF)dW {
	NSRect frame = [self frame] ;
	frame.origin.x += dX ;
	frame.size.width += dW ;
	[self setFrame:frame] ;
}

- (void)deltaY:(CGF)dY
		  deltaH:(CGF)dH {
	NSRect frame = [self frame] ;
	frame.origin.y += dY ;
	frame.size.height += dH ;
	[self setFrame:frame] ;
}

- (void)deltaX:(CGF)dX {
	[self deltaX:dX
			deltaW:0.0] ;
}

- (void)deltaY:(CGF)dY {
	[self deltaY:dY
			deltaH:0.0] ;
}

- (void)deltaW:(CGF)dW {
	[self deltaX:0.0
			deltaW:dW] ;
}

- (void)deltaH:(CGF)dH {
	[self deltaY:0.0
			deltaH:dH] ;
}
- (void)sizeHeightToFitAllowShrinking:(BOOL)allowShrinking {
	float oldHeight = [self height] ;
	float width = [self width] ;
	float height ;
	if ([self isKindOfClass:[NSTextView class]]) {
		NSAttributedString* attributedString = [(NSTextView*)self textStorage] ;
		if (attributedString != nil) {
			height = [attributedString heightForWidth:width] ;
		}
		else {
			NSFont* font = [(NSTextView*)self font] ;
			/* According to Douglas Davidson, http://www.cocoabuilder.com/archive/message/cocoa/2002/2/13/66379,
			 "The default font for text that has no font attribute set is 12-pt Helvetica."
			 So, we make that interpretation... */
			if (font == nil)				font = [NSFont fontWithName:@"Helvetica" size:12] ;
			height = [[(NSTextView*)self string] heightForWidth:width	font:font] ;
		}
		NSRect frame = [self frame] ;
		frame.size.height = allowShrinking ? height : MAX(height, oldHeight) ;
		[self setFrame:frame] ;
	}
	else if ([self isKindOfClass:[NSTextField class]]) {
		gNSStringGeometricsTypesetterBehavior = NSTypesetterBehavior_10_2_WithCompatibility ;
		height = [[(NSTextField*)self stringValue] heightForWidth:width	font:[(NSTextView*)self font]] ;
		NSRect frame = [self frame] ;
		frame.size.height = allowShrinking ? height : MAX(height, oldHeight) ;
		[self setFrame:frame] ;
	}
	else {
		// Subclass should have set height to fit
	}
	// Clip if taller than screen
	float screenHeight = [[NSScreen mainScreen] frame].size.height ;
	if ([self height] > screenHeight) {	NSRect frame = [self frame] ;	frame.size.height = screenHeight ;	[self setFrame:frame] ;	}
}

- (NSComparisonResult)compareLeftEdges:(NSView*)otherView {
	float myLeftEdge = [self leftEdge] ;
	float otherLeftEdge = [otherView leftEdge] ;
	if (myLeftEdge < otherLeftEdge) {
		return NSOrderedAscending ;
	}
	else if (myLeftEdge > otherLeftEdge) {
		return NSOrderedDescending ;
	}
	
	return NSOrderedSame ;
}

// The normal margin of "whitespace" that one leaves at the bottom of a window

#define BOTTOM_MARGIN 20.0

- (void)sizeHeightToFit {
	CGFloat minY = 0.0 ;
	for (NSView* subview in [self subviews]) {
		minY = MIN([subview frame].origin.y - BOTTOM_MARGIN, minY) ;
	}
	
	// Set height so that minHeight is the normal window edge margin of 20
	CGFloat deltaH = -minY ;
	NSRect frame = [self frame] ;
	frame.size.height += deltaH ;
	[self setFrame:frame] ;
	
	// Todo: Set width similarly
}

@end

@implementation  NSScrollView (Notifications)

- (void) performBlockOnScroll:(void (^)(void))block
{
	[self setPostsBoundsChangedNotifications:YES];
	
	[AZNOTCENTER addObserver:self keyPath:NSViewBoundsDidChangeNotification options:0 block:^(MAKVONotification *notification) {
		block();
	}];
	//	addObserver:self selector:@selector(boundsDidChange:) name:NSViewBoundsDidChangeNotification object:contentView];
}



#define AUTOSCROLL_CATCH_SIZE 	20	//The distance (in pixels) that the scrollview must be within (from the bottom) for auto-scroll to kick in.
- (void)setAutoScrollToBottom:(BOOL)inValue
{
	[self setAssociatedValue:@(inValue) forKey:@"autoScroll" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
	//Observe the document view's frame changes
   if (inValue) [AZNOTCENTER removeObserver:self name:NSViewFrameDidChangeNotification object:nil];
	else  [AZNOTCENTER addObserver:self object:self.documentView keyPath:NSViewFrameDidChangeNotification options:nil block:^(MAKVONotification *notification) {
					 [self scrollToBottom];
	}];
}

//When our document resizes
//- (void)documentFrameDidChange:(NSNotification *)notification
//{
//	//We guard against a recursive call to this method, which may occur if the user is resizing the view at the same time
//	//content is being modified
//    if (autoScrollToBottom && !inAutoScrollToBottom) {
//        NSRect	documentVisibleRect =  [self documentVisibleRect];
//        NSRect	   newDocumentFrame = [[self documentView] frame];
//        
//        //We autoscroll if the height of the document frame changed AND (Using the old frame to calculate) we're scrolled close to the bottom.
//        if ((newDocumentFrame.size.height != oldDocumentFrame.size.height) && 
//		   ((documentVisibleRect.origin.y + documentVisibleRect.size.height) > (oldDocumentFrame.size.height - AUTOSCROLL_CATCH_SIZE))) {
//			inAutoScrollToBottom = YES;
//            [self scrollToBottom];
//			inAutoScrollToBottom = NO;
//        }
//    
//        //Remember the new frame
//        oldDocumentFrame = newDocumentFrame;
//    }
//}

//Scroll to the top of our view
- (void)scrollToTop
{    
    [[self documentView] scrollPoint:NSZeroPoint];
}

//Scroll to the bottom of our view
- (void)scrollToBottom
{
    [[self documentView] scrollPoint:NSMakePoint(0, 1000000)];
}

@end

@implementation NSTableView (Scrolling)

- (void)scrollRowToTop:(NSInteger)row {
	if ((row != NSNotFound) && (row >=0)) {
		CGFloat rowPitch = [self rowHeight] + [self intercellSpacing].height ;
		CGFloat y = row * rowPitch ;
		[self scrollPoint:NSMakePoint(0, y)] ;
	}
}

@end


@implementation NSView (findSubview)

- (NSA*)findSubviewsOfKind:(Class)kind withTag:(NSInteger)tag inView:(NSView*)v {
	NSMutableArray *array = [NSMutableArray array];
	
	if(kind==nil || [v isKindOfClass:kind]) {
		if(tag==NSNotFound || v.tag==tag) {
			[array addObject:v];
		}
	}
	
	for (id subview in v.subviews) {
		NSArray *vChild = [self findSubviewsOfKind:kind withTag:tag inView:subview];
		[array addObjectsFromArray:vChild];
	}
	
	return array;
}

#pragma mark -

- (NSA*)subviewsOfKind:(Class)kind withTag:(NSInteger)tag {
	return [self findSubviewsOfKind:kind withTag:tag inView:self];
}

- (NSA*)subviewsOfKind:(Class)kind {
	return [self findSubviewsOfKind:kind withTag:NSNotFound inView:self];
}

- (NSView *)firstSubviewOfKind:(Class)kind withTag:(NSInteger)tag {
	return [self findSubviewsOfKind:kind withTag:tag inView:self][0];
}

- (NSView *)firstSubviewOfKind:(Class)kind {
	return [self firstSubviewOfKind:kind withTag:NSNotFound];
}
@end


//void NSAnimationContextRunAnimationBlock( dispatch_block_t group, dispatch_block_t completionHandler, NSTimeInterval time )
//{
//	[NSAnimationContext runAnimationBlock:group
//						completionHandler:completionHandler
//								 duration:time];
//}
@implementation NSAnimationContext (AtoZ)

+ (void)runAnimationBlock:(dispatch_block_t)group	completionHandler:(dispatch_block_t)completionHandler
					  duration:(NSTimeInterval)time		eased:(CAMediaTimingFunction*)timing;
{
	// run animation
	[NSAnimationContext beginGrouping];
	NSAnimationContext.currentContext.duration = time;
	NSAnimationContext.currentContext.timingFunction = timing;
	group();
	[NSAnimationContext endGrouping];
	
	if (completionHandler)
	{// block delay
		dispatch_time_t popTime = dispatch_time( DISPATCH_TIME_NOW, (double)time * NSEC_PER_SEC);
		dispatch_after( popTime, dispatch_get_main_queue(), completionHandler );
	}
}

+ (void)runAnimationBlock:(dispatch_block_t)group
		  completionHandler:(dispatch_block_t)completionHandler
					  duration:(NSTimeInterval)time
{
	// run animation
	
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:time];
	group();
	[NSAnimationContext endGrouping];
	
	if (completionHandler) {
		// block delay
		dispatch_time_t popTime = dispatch_time( DISPATCH_TIME_NOW, (double)time * NSEC_PER_SEC);
		dispatch_after( popTime, dispatch_get_main_queue(), completionHandler );
	}
}
@end

@interface COICOPopoverView : AZSimpleView
@end
@implementation COICOPopoverView
- (void)drawRect:(NSRect)aRect 
{
	self.backgroundColor = self.backgroundColor ?: [NSColor controlBackgroundColor];
	NSG *gradient = [NSG.alloc initWithStartingColor:self.backgroundColor  endingColor:NSC.controlBackgroundColor];
	[gradient drawInBezierPath:[NSBP bezierPathWithRoundedRect:self.bounds xRadius:5 yRadius:6] angle:270.0];
	[super drawRect:aRect];
}
@end

@implementation NSPopover (Message)

+ (void) showRelativeToRect:(NSR)rect ofView:(NSV*)view preferredEdge:(NSRectEdge)edge string:(NSS*)string maxWidth:(float)width {
	
	[NSPopover showRelativeToRect:rect ofView:view preferredEdge:edge string:string backgroundColor:NSC.controlBackgroundColor maxWidth:width];
}

+ (void) showRelativeToRect:(NSR)rect ofView:(NSV*)view preferredEdge:(NSRectEdge)edge	string:(NSS*)string backgroundColor:(NSC*)bg maxWidth:(float)width {
	
	[NSPopover showRelativeToRect:rect ofView:view  preferredEdge:edge string:string backgroundColor:bg
					  foregroundColor:NSColor.controlTextColor	font:[NSFont systemFontOfSize:NSFont.systemFontSize] maxWidth:width];
}

+ (void) showRelativeToRect:(NSR)rect ofView:(NSV*)view preferredEdge:(NSRectEdge)edge string:(NSS*)string backgroundColor:(NSC*)bg
				foregroundColor:(NSColor *)foregroundColor			  font:(NSFont *)font maxWidth:(float)width {
	
	[NSPopover showRelativeToRect:rect ofView:view preferredEdge:edge attributedString:	[NSMAS.alloc initWithString:string 
			attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: foregroundColor }] backgroundColor:bg maxWidth:width];
}

+ (void) showRelativeToRect:(NSR)rect ofView:(NSV*)view preferredEdge:(NSRectEdge)edge attributedString:(NSAS*)attributedString
				backgroundColor:(NSC*)backgroundColor  			 maxWidth:(float)width {
	
	float padding = 15;
	
	NSRect containerRect = [attributedString boundingRectWithSize:NSMakeSize(width, 0) options:NSStringDrawingUsesLineFragmentOrigin];
	containerRect.size.width = containerRect.size.width *= (25/(containerRect.size.width+2)+1);
	NSSize size = containerRect.size;
	NSSize popoverSize = NSMakeSize(containerRect.size.width + (padding * 2), containerRect.size.height + (padding * 2));
	
	containerRect = NSMakeRect(0, 0, popoverSize.width, popoverSize.height);
	
	NSTXTF *label = [NSTXTF.alloc initWithFrame:(NSR){padding, padding, size.width, size.height}];
	label.bezeled 					 = NO;
	label.drawsBackground  		 = NO;
	label.editable					 = NO;
	label.selectable				 = NO;
	label.attributedStringValue = attributedString;
	[label.cell setLineBreakMode: NSLineBreakByWordWrapping];
	
	COICOPopoverView *container = [COICOPopoverView.alloc initWithFrame:containerRect];
	
	container.bgC					 = backgroundColor;
	container.subviews 			 = @[label];
	label.bounds					 = NSMakeRect(padding, padding, size.width, size.height);
	[container awakeFromNib];
	NSVC *controller 				 = NSViewController.new;
	controller.view 				 = container;
	NSPopover *popover 			 	= NSPopover.new;
	popover.contentSize				= popoverSize;
	popover.contentViewController = controller;
	popover.animates					= YES;
	popover.behavior					= NSPopoverBehaviorTransient;
	[popover showRelativeToRect:rect ofView:view preferredEdge:edge];
}


@end


@interface AZRBLPopBack :RBLPopoverBackgroundView
@end

@implementation AZRBLPopBack

- (CGPathRef)newPopoverPathForEdge:(CGRectEdge)popoverEdge inFrame:(CGRect)frame;

{
	CGF tailArea = .4 * AZMaxDim( frame.size );
	CGR box 	= popoverEdge == CGRectMaxXEdge ? AZRectTrimmedOnLeft  (	frame, tailArea) 
				: popoverEdge == CGRectMaxYEdge ? AZRectTrimmedOnTop   (	frame, tailArea)
				: popoverEdge == CGRectMinYEdge ? AZRectTrimmedOnBottom( frame, tailArea)
				: 											 AZRectTrimmedOnRight  (	frame, tailArea);
	NSR edgeRect = AZRectInsideRectOnEdge(AZRectFromDim(tailArea), frame, AZPosAtCGRectEdge(popoverEdge));
	NSBP * tail = [NSBezierPath bezierPathWithTriangleInRect:edgeRect orientation:popoverEdge];
	NSBP * Boxpath = [NSBezierPath bezierPathWithRect:box];
	NSBP * unionp = [Boxpath az_intersect:tail];
	NSBP *pp = [DKShapeFactory arrowTailFeatherWithRake:.4];
	pp = [pp scaledToFrame:box];
	return  pp.quartzPath;

}

@end

@implementation RBLPopover (AtoZ)

+ (void) showRelativeTo:(NSR)r ofView:(NSV*)v edge:(NSRectEdge)edge string:(NSS*)s bg:(NSC*)bg size:(NSSZ)sz {

	
	float padding = 15;
	
	NSAS *as = 	[NSAS.alloc initWithString:s attributes:@{NSFontAttributeName: AtoZ.controlFont, NSForegroundColorAttributeName: bg.contrastingForegroundColor }];

	NSRect containerRect = [as boundingRectWithSize:NSMakeSize(sz.width, 0) options:NSStringDrawingUsesLineFragmentOrigin];
	containerRect.size.width = containerRect.size.width *= (25/(containerRect.size.width+2)+1);
	NSSize size = containerRect.size;
	NSSize popoverSize = NSMakeSize(containerRect.size.width + (padding * 2), containerRect.size.height + (padding * 2));
	
	containerRect = NSMakeRect(0, 0, popoverSize.width, popoverSize.height);
	
	NSTXTF *label = [NSTXTF.alloc initWithFrame:(NSR){padding, padding, size.width, size.height}];
	label.bezeled 					 = NO;
	label.drawsBackground  		 = NO;
	label.editable					 = NO;
	label.selectable				 = NO;
	label.attributedStringValue = as;
	[label.cell setLineBreakMode: NSLineBreakByWordWrapping];
	
	COICOPopoverView *container = [COICOPopoverView.alloc initWithFrame:containerRect];
	
	container.bgC					 = bg;
	container.subviews 			 = @[label];
	label.bounds					 = NSMakeRect(padding, padding, size.width, size.height);
	[container awakeFromNib];
	NSVC *controller 				 = NSViewController.new;
	controller.view 				 = container;
	
	RBLPopover *popover = [RBLPopover.alloc initWithContentViewController:controller];
	popover.backgroundViewClass   = AZRBLPopBack.class;
//	popover.backgroundView			= [AZRBLPopBack.alloc initWithFrame:AZRectFromSize(popoverSize) popoverEdge:edge originScreenRect:AZScreenFrame()];
	popover.contentSize				= popoverSize;
	popover.contentViewController = controller;
	popover.animates					= YES;
	popover.behavior					= RBLPopoverViewControllerBehaviorTransient;
	[popover showRelativeToRect:r ofView:v preferredEdge:edge];

//	[popover showRelativeToRect:rect ofView:view preferredEdge:edge];
}

@end