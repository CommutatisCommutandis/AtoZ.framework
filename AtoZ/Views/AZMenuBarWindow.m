#import "AZMenuBarWindow.h"

@implementation AZMenuBarWindow
@synthesize perfectRect, unit, dragStart, dragDiff;


- (BOOL) acceptsMouseMovedEvents { return YES; };
- (BOOL) acceptsFirstResponder { return YES;   };

- (id) init
{

	if (!(self = [self initWithContentRect:AZScreenFrameUnderMenu() styleMask:NSBorderlessWindowMask
								   backing:NSBackingStoreBuffered	defer:NO] )) return nil;

	self.backgroundColor		 	= CLEAR;
	self.opaque					 	= NO;
	self.hidesOnDeactivate			= YES;
	self.acceptsMouseMovedEvents 	= YES;
	//	self.movableByWindowBackground  = YES;
	self.level 					 	= NSScreenSaverWindowLevel;//CGWindowLevelForKey(kCGCursorWindowLevelKey)];
	self.collectionBehavior	     	= NSWindowCollectionBehaviorCanJoinAllSpaces |
	NSWindowCollectionBehaviorStationary;
	self.scrollPoint = NSZeroPoint;
	self.unitOffset  = 1;
	CALayer *layer 	 = [CAL  layerNamed:@"root"];
	self.scrollLayer = [CAL layerNamed:@"scroll"];
	_scrollLayer.backgroundColor = [[GREEN alpha:.2]CGColor];
	[((NSV*)self.contentView) setLayer:layer];
	[((NSV*)self.contentView) setWantsLayer:YES];
	layer.layoutManager 	= AZLAYOUTMGR;
	_scrollLayer.layoutManager = self;
	[_scrollLayer addConstraintsSuperSize];

	[layer addSublayer:_scrollLayer];
	//	[_scrollLayer addConstraint:AZConstRelSuperScaleOff(kCAConstraintWidth, 2, 0)];

	NSArray *r 			= [[NSColor randomPalette]withMaxItems:30];
	self.unit			= ScreenWidess() / r.count;
	self.perfectRect 	= AZRectBy(unit, AZScreenFrameUnderMenu().size.height);

	_scrollLayer.sublayers 	= [[NSArray from:-1 to:r.count] nmap:^id(id obj, NSUInteger index) {
		CAL *root  		 	= [CAL layerNamed:$(@"%@",obj)];
		root[@"hovered"] 	= @(NO);
		CAL *tab 		 	= [CAL layerNamed:@"tab"];
		CALNH *ribbon  		= [CALNH layerNamed:@"ribbon"];
		root.anchorPoint 	= AZAnchorTop;
		root.delegate 		= self;
		[@[tab, ribbon]each:^(CAL* obj) {
			[obj addConstraintsSuperSize];
			AddShadow(obj);
			obj.mTB 		= NO;
			obj.cRadius 	= .1 * perfectRect.size.width;
			obj.aPoint 		= AZAnchorBottom;

		}];
		//		tab.position	 	= NSMakePoint(NSWidth(vRect)/2, root.boundsHeight -100);
		tab.bgC	 			= cgWHITE;
		ribbon.bgC	 		= [[NSColor leatherTintedWithColor:[r normal:[obj integerValue]]] CGColor];
		ribbon.shadowOffset 	= AZMultiplySize(ribbon.shadowOffset, .1);

		//			[@[root, tab]each:^(CAL* obj) {
		//				obj.layoutManager = AZLAYOUTMGR;
		//				[obj addConstraintsSuperSize];
		//			}];
		tab.sublayers   = @[ribbon];
		root.sublayers 	= @[tab];

		[self addTabConstraintsToTab:tab];
		//									 AZConstRelSuperScaleOff(kCAConstraintMinY,1,( AZHeightUnderMenu()-tab.boundsWidth))]];
		//									 AZConstAttrRelNameAttrScaleOff(kCAConstraintMinY, @"superlayer",kCAConstraintMaxY, 1, -tab.boundsWidth)]];
		//AZConstAttrRelNameAttrScaleOff(kCAConstraintMinY, @"superlayer", kCAConstraintMaxY, -1, vRect.size.width)]];
		[ribbon addConstraints:@[AZConstRelSuperScaleOff(kCAConstraintWidth, .9, 0), AZConstRelSuperScaleOff(kCAConstraintMinY, 1, 7)]];
		ribbon.delegate	 	= self;
		[ribbon setNeedsDisplay];
		perfectRect.origin.x += unit;
		return root;
	}];
	//	[root addSublayer:drawer];
	//	[_winRoot enableDebugBordersRecursively:YES];
	[self makeKeyAndOrderFront:nil];
	return self;
}

- (void) layoutSublayersOfLayer:(CALayer *)layer {


	//	layer.frame = (NSR){ 0, AZHeightUnderMenu() - unit, unit, unit};
	[layer.sublayers eachWithIndex:^(CAL* obj, NSInteger idx) {

		NSR r =  (NSR){  (idx-1) * unit + _scrollPoint.x, AZHeightUnderMenu() - unit, unit, unit};
		//	 AZHeightUnderMenu() - unit, unit, unit};

		//	= AZRectExceptOriginY(AZRectExceptOriginX(AZRectFromSize(perfectRect.size), (idx-1) * unit + _scrollPoint.x),AZHeightUnderMenu() - obj.boundsWidth);
		//	r.size = AZSizeFromDimension(unit);
		obj.frame = r;
	}];

}


- (void) addTabConstraintsToTab:(CAL*)l {
	//	[l addConstraintsSuperSize];
	[l addConstraints:@[		 AZConstRelSuperScaleOff(kCAConstraintWidth, .9, 1), AZConstRelSuperScaleOff(kCAConstraintMaxY, 1.2, 0)]];
	//	 AZConstRelSuperScaleOff(kCAConstraintMinY,1, AZHeightUnderMenu()-l.boundsWidth)]];
}
/*
 //	self.bar = [[NSView alloc]initWithFrame:[self.contentView frame]];
 //	_bar.wantsLayer = YES;   //AZUpperEdge([[self contentView]frame], 400)];
 //	self.drawerView = [[NSView alloc]initWithFrame:AZUpperEdge([[self contentView]frame], 22)];
 //	_drawerView.arMASK = NSSIZEABLE;
 CAShapeLayer *drawer 	= [CAShapeLayer layerNamed:@"drawer"]; [_drawerView setupHostView];
 CALayer *liner  		= [CALayer layerNamed:@"liner"];
 drawer.layoutManager 	= AZLAYOUTMGR;
 drawer.strokeColor 		= cgBLACK;
 //	NSBezierPath *outer = [NSBezierPath bezierPathWithStandardChainLink
 //	[liner addConstraintsSuperSize];

 [liner addConstraints:@[AZConstRelSuperScaleOff(kCAConstraintMinY, 1, 15), AZConstRelSuperScaleOff(kCAConstraintWidth, .9, 0)]];
 liner.contents = [NSImage imageNamed:@"black.minimal.jpg"];
 liner.contentsGravity = kCAGravityResize;
 liner.cornerRadius = 20;
 liner.opaque = YES;
 AddShadow(drawer);
 AddShadow(liner);
 [drawer addSublayer:liner];
 //	[self.contentView setSubvie/ws :@[_bar]];
 [self.contentView setAutoresizesSubviews:YES];
 //	[((NSV*)self.contentView).layer addSublayer:drawer];
 //	CALayer *i = [ setupHostView];
 //	self.scrollLayer = [CAScrollLayer layerNamed:@"winRoot"];
 //	[i addSublayer:_winRoot];
 //		NSRect vRect = (NSR) { unit * [obj integerValue],	0, 					unit, _bar.height};
 //		[_spots setValue:AZVrect(vRect) forKey:obj];
 //		CGF initInset = unit/1.3;
 //		NSRect tRect 	 = AZInsetRect(vRect, initInset);
 //			   h = AZRectExceptOriginY(h, _bar.height - 100);
 //		NSRect rRect = AZInsetRect(tRect, 6);
 //			   rRect.origin.y += 40;//(g, 35);

 //			AZSimpleView *s = [[AZSimpleView alloc]initWithFrame:vRect];
 &*/
- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event;
{
	NSLog(@"? actionforlayer:%@  event:%@", layer, event );
	__block id theA 		 	= [CABA animationWithKeyPath:@"transform"];
	((CABA*)theA).fillMode 				= kCAFillModeForwards;
	((CABA*)theA).removedOnCompletion 	= NO;
	((CABA*)theA).duration 				= 1;
	__block CATransform3D transform	 	= [layer presentationLayer]
	? [[layer presentationLayer][@"transform"]CATransform3DValue]
	: CATransform3DIdentity;
	areSame(event,@"clicked") ? ^{
		((CABA*)theA).fromValue 				= AZV3d([(CAL*)(layer.presentationLayer) transform]);
		transform.m34 = 1.0/700.0;
		((CABA*)theA).toValue = AZV3d(CATransform3DConcat(transform, CATransform3DMakeRotation(DEG2RAD(180), 0, 1, 0)));
	}() : [@[@"hovered", kCAOnOrderIn] containsObject:event] ? ^{
//		((CABA*)theA).keyPath = @"position.y";
//		CGF p = [(CAL*)[layer modelLayer]position].y;
//		((CABA*)theA).removedOnCompletion = YES;
//		((CABA*)theA).toValue = [layer[@"hovered"]boolValue] ? @(p) : @( p - 200);
//	}() :
//	areSame(kCAOnOrderIn, event) ? ^ {
//		CABasicAnimation * fold = [CABA animationWithKeyPath:@"transform"];
//		CATransform3D up = CATransform3DMakePerspective(0, -.003);
//		theA.toValue = AZV3d(up);
//		theA.fromValue =AZV3d(CATransform3DIdentity);
//		fold.duration = 3;
//		return fol
		AZLOG(@"pooping!");
		theA = [CAAnimation popInAnimation];// [CAAnimation flipDown:2 scaleFactor:.5];

	}(): nil;

	//		AZV3d(CATransform3DConcat(transform, CATransform3DMakeTranslation(0, [layer[@"hovered"]boolValue] ? 200 : -200, 0)))
	//CATransform3DRotate(transform, DEG2RAD(2*M_PI), 0, 1, 0); //180 * M_PI/180
	return theA ?: nil;
}

//
//	NSLog(@"asking for event : %@",event);
//    if ([key isEqualToString:@"clicked"]) {
//		CATransform3D transform = CATransform3DMakeRotation(M_PI, 0.0f,
//															1.0f, 0.0f);

//		CABA *flip  = [CABA animationWithKeyPath:@"poop"];
//		CATransform3D transform = CATransform3DIdentity;
//		transform.m34 = 1.0/700.0;
//		transform = CATransform3DRotate(transform, 180 * M_PI/180, 1, 0, 0);
//		flip.fromValue = AZV3d(CATransform3DIdentity);
//		flip.toValue = AZV3d(transform);
//		[anObject addAnimation:rotateAnimation];

-(void) drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
	AZLOG($(@"d in c for %@", layer.debugDescription));
	[NSGraphicsContext drawInContext:ctx flipped:NO actions:^{
		NSR bottomSquare = AZLowerEdge(layer.bounds, layer.boundsWidth);
		[[[[NSIMG randomIcon]scaledToMax:layer.boundsWidth]etched] drawInRect:AZInsetRect(bottomSquare, layer.boundsWidth*.2) operation:NSCompositeSourceOver fraction:1 method:AGImageResizeScale];

		[$(@"%f",[layer.superlayers[(layer.superlayers.count -3)]frame].origin.x) drawInRect:AZUpperEdge(layer.bounds,100) withFont:[AtoZ font:@"Ubuntu" size:24] andColor:WHITE];
		//AZCenterRectOnPoint(AZRectFromDim(.7*layer.boundsWidth), (NSPoint) {NSMidX(layer.bounds), layer.boundsWidth})];//// fraction:1];// operation:NSCompositeSourceOver fraction:1];
	}];
}
+ (id<CAAction>)defaultActionForKey:(NSString *)event;
{
	NSLog(@"asking for event default: %@", event);
	

}

- (void)sendEvent:(NSEvent *)theEvent
{
	static CAL *tab = nil;

	//	[theEvent type] == NSLeftMouseDown || [NSEvent modifierFlags] != NSCommandKeyMask ? ^{
	//
	//
	//}():nil;
	[theEvent type] == NSMouseMoved || [theEvent type] == NSLeftMouseDown  || [theEvent type] != NSLeftMouseDragged ? ^{

		tab = [[(NSV*)self.contentView layer] hitTest:theEvent.locationInWindow];
		tab = areSame(tab.name, @"tab") ? tab.superlayer : [[tab sublayerWithName:@"tab"] superlayer];

	}():nil;
	[theEvent type] == NSLeftMouseDown ? ^{
		tab ? ^{
			dragDiff = AZSubtractPoints(theEvent.locationInWindow, tab.position);
			dragStart = theEvent.locationInWindow;

//			AZLOG($(@"winner: %@", tab.debugDescription));
		}():nil;
	}():nil;
	[theEvent type] == NSLeftMouseDragged  ? ^{
//				[CATransaction setDisableActions:YES];
				NSP newp = (NSP) {theEvent.locationInWindow.x, dragStart.y};
//				newp = AZSubtractPoints(newp, dragStart);
//				newp.y = dragStart.y;
				newp = AZSubtractPoints(newp,dragDiff);
				
				NSLog(@"dragstart: %@   setting newp: %@ on %@", AZString(dragStart), AZString(newp), tab.debugDescription);
				[CATransaction immediately:^{ [tab setPosition:newp]; }];

//			[tab setValue:[NSString randomWords:1] forKey:@"clicked"];
//				[CATransaction commit];

	}():nil;

	[theEvent type] == NSMouseMoved ? ^{
		if (tab) [tab boolForKey:@"hovered"] ?: [_scrollLayer.sublayers do:^(CAL*l){ [l setBool:areSame(l, tab) forKey:@"hovered"]; }];
	}() : nil;


	// ^{
	//			[self setIgnoresMouseEvents:YES];
	//			AZLeftClick(mouseLoc());
	//			[self setIgnoresMouseEvents:NO];
	//		}();
	//	}

	//	if ([theEvent type] == NSLeftMouseUp ) {
	//		[self setIgnoresMouseEvents:NO];
	//		[self setMovableByWindowBackground:NO];
	//
	//	}

	if (([theEvent type] == NSScrollWheel) && theEvent.deltaX ) {

		self.scrollPoint = AZPointOffsetX(_scrollPoint, theEvent.deltaX);
		if (ABS(_scrollPoint.x) >= unit) {
			[CATransaction immediately:^{

				BOOL neg = _scrollPoint.x < 0;
				CALayer *mover =  neg ?  [_scrollLayer.sublayers firstObject] : [_scrollLayer.sublayers lastObject];
				neg ? [_scrollLayer addSublayer:mover] : [_scrollLayer insertSublayer:mover	atIndex:0];
				self.scrollPoint = NSZeroPoint;
			}];
		}
		[_scrollLayer setNeedsLayout];
		//			[[_scrollLayer sublayers] eachWithIndex:^(CAL* obj, NSInteger idx) {
		//				NSR nw = AZRectExceptOriginX(obj.frame, obj.frame.origin.x + theEvent.deltaX);
		//				if (nw.origin.x < -unit) nw.origin.x =  ScreenWidess() + unit;
		//				else if (nw.origin.x > ScreenWidess() ) nw.origin.x = -unit;

		//				obj.frame = nw;
		//				[obj.sublayers  each:^(CAL *l) { [l setNeedsDisplay]; }];
		//			}];

	}
	[super sendEvent:theEvent];
}

//		[self.scrollLayer scrollBy:(NSP){theEvent.deltaX , 0 }];//
//		[self.scrollLayer scrollToPoint:_scrollPoint];
//		CGF regulator 	= ABS(_scrollPoint.x) - (ABS(_unitOffset) * unit);
//		CGF off 		=  regulator / unit; //-1  scrolling left,  1 scrolling right
//		NSLog(@"scrollX:%f unit:%f normalOff:%f multi:%ld  floater:%f ", _scrollPoint.x, unit, regulator, _unitOffset, off)
//		if ( ABS(off) >= 1 ) {
//			BOOL neg = (off*_unitOffset) < 0;  int now = _unitOffset += neg ? -1 : 1;
//												if ( now == 0 )  now = neg ? -1 : 1;
//												self.unitOffset = now;

//			CAL *v = neg ? [_scrollLayer sublayers][0] : [[_scrollLayer sublayers] lastObject];
//			[v blinkLayerWithColor:RANDOMCOLOR];
//			[CATransaction immediately:^{
//				NSLog(@"_scroll: %@", [_scrollLayer debugLayerTree]);
//				[v removeFromSuperlayer];
//				v.hidden = YES;
//				NSR newF = AZRectFromSize(perfectRect.size);
//				newF.origin.x = neg ? ScreenWidess() + unit : -unit;
//				v.position = AZCenterOfRect(newF);
//				neg ? [self.scrollLayer addSublayer:v] : [self.scrollLayer insertSublayer:v atIndex:0];
//				[self addTabConstraintsToTab:v];

//				[v setNeedsDisplay];
//				v.hidden = NO;

//			}];
//			[_scrollLayer setNeedsDisplay];
//			[_scrollLayer setNeedsLayout];
//		}

//		[_scrollLayer.sublayers each:^(CAL * obj) {
//			NSR f = AZRectHorizontallyOffsetBy(obj.frame, theEvent.deltaX);
//			if ( obj.frame.origin.x > ScreenWidess()) {
//				NSRect pminus = AZRectHorizontallyOffsetBy(perfectRect, -unit);
//				[CATransaction immediately:^{
//					obj.frame = pminus;
//////					[obj.layer setHidden:YES];
//				//					[obj addConstraint:AZConstScaleOff(kCAConstraintMinX,supersuper.name, 1, -obj.boundsWidth)];
//////					[obj.layer setHidden:NO];
//				}];
//////			[self enableFlushWindow];
//			}
//
//			else [obj setFrame:f];
//		}];
//	}
//	if (([theEvent type] == NSScrollWheel) && ([NSEvent modifierFlags] == NSCommandKeyMask)) {
//
//		[self setFrameTopLeftPoint:AZPointOffsetY(AZTopLeft(self.frame), theEvent.deltaY)];
//	}
//	if (([theEvent type] == NSScrollWheel) && ([NSEvent modifierFlags] == (NSCommandKeyMask |  NSAlternateKeyMask))) {
//		[self extendVerticallyBy:(int)theEvent.deltaY];
//	}
//	if (([theEvent type] == NSLeftMouseDragged) && ([NSEvent modifierFlags] == NSCommandKeyMask) && self.isMovableByWindowBackground == NO) {
//		NSLog(@"Setting to be moveable");
//		[self setMovableByWindowBackground:YES];
//		[self sendEvent:theEvent];
//		return;
//	}




//		NSPoint aPoint = [_bar convertPoint:[theEvent locationInWindow] toView:nil];
//		id viewHit = [_bar hitTest:aPoint];
//		AZSimpleView *winner = [viewHit isKindOfClass:[AZSimpleView class]] ? viewHit :
//							   [viewHit subviewsOfKind:[AZSimpleView class]][0] ?: nil;
//			The initializeClickThrough method does basically the following:
//
//			// Don't let our events block local hardware events
//			CGSetLocalEventsFilterDuringSupressionState(kCGEventFilterMaskPermitAllEvents,kCGEventSupressionStateSupressionInterval);
//			CGSetLocalEventsFilterDuringSupressionState(kCGEventFilterMaskPermitAllEvents,kCGEventSupressionStateRemoteMouseDrag);




//			winner.backgroundColor = [[winner.backgroundColor brighter]brighter];
//			NSRect saved = [[winner associatedValueForKey:@"oldFrame"]rectValue];
//			NSRect 	newF = AZRectVerticallyOffsetBy(saved, -300);
//					newF = AZRectExceptHigh(newF, NSHeight(newF)+300);
//			[[winner animator]setFrame:saved];
//			NSRect d = _drawerView.frame;
//			d.origin.y = newF.origin.y + 40;
//			[[_drawerView animator]setFrame: d];
////					[winner.layer animate:@"bounds" toCGRect:newF time:2];
////					[winner.layer animate:@"frame" toCGRect:newF time:2];;
////					[winner.layer flipDown];
//			[[[_bar subviews]arrayWithoutObject:winner]each:^(AZSimpleView *obj) {
////				NSRect savedOther = [[obj associatedValueForKey:@"oldFrame"]rectValue];
////				[[obj animator] setFrame:savedOther];
//			}];

@end

@implementation NSWindow (BorderlessInit)

-(void) bordlerlessInit{
	//	((NSV*)self.contentView).wantsLayer = YES;
#ifdef AZMOVABLE
	//									= YES;
#else
	//									= NO;
#endif
	self.backgroundColor		 	= [RED alpha:.2];//CLEAR;
	self.opaque					 	= NO;
	self.canHide				 	= NO;
	self.hidesOnDeactivate		 	= YES;
	self.ignoresMouseEvents		 	= NO;
	self.acceptsMouseMovedEvents 	= YES;
	self.movableByWindowBackground  = YES;
	self.level 					 	= NSScreenSaverWindowLevel;//CGWindowLevelForKey(kCGCursorWindowLevelKey)];
	self.collectionBehavior	     	= NSWindowCollectionBehaviorCanJoinAllSpaces |
	NSWindowCollectionBehaviorStationary;
}
@end

//	NSLog(@"event: %@", 	event);
//	// look for mouse down
//	if ([event type] == NSLeftMouseDown) {
//		// look for deepest subview
//		AZSimpleView *deepView = (AZSimpleView*)[_bar hitTest:[event locationInWindow]];
////		if (deepView) {
//			for (AZSimpleView *aClickView in _clickViews) {
//				if ([deepView isSubviewOfView:aClickView]) {
//					[(id)aClickView setBackgroundColor:RANDOMCOLOR];//subviewClicked:deepView];
//					break;
//				}
//			}
////		}
//	}




//		[_bar trackFullView];
//		[NSEvent addLocalMonitorForEventsMatchingMask:NSMouseMovedMask handler:^NSEvent *(NSEvent *e) {
//
//			NSP p = [_bar convertPoint:e. fromView:nil];
//			AZSimpleView *v = [_bar hitTest:p forClass:[AZSimpleView class]];
//			AZLOG(AZString(p));AZLOG(v);
//			if (_hoveredView != v) {
//				v.backgroundColor = RANDOMCOLOR;
//				self.hoveredView = v;
//			}
////			NSLog(@"Went:%@ of Color: %@", e.type == NSMouseEntered ?@"Into":@"Out of", [obj nameOfColor]);
//			return e;
//		}];
//		[_bar setCheckerboard:YES];
//		[_bar setNeedsDisplay:YES];
//		[_bar trackFullView];
//		[NSEVENTLOCALMASK:(NSMouseEnteredMask | NSMouseExitedMask) handler:^NSEvent *(NSEvent *d) {
//			AZLOG(d);
//			if (NSPointInRect(mouseLoc(), _bar.frame))
//				_bar.isHidden ? [_bar fadeIn] : nil;
//			else  !_bar.isHidden ? [_bar fadeOut] : nil;
//				//			d.type == NSMouseExitedMask ? [_bar fadeOut] : [_bar fadeIn];
//			AZLOG(@"entered or ewxit");
//			return d;
//		}];

//        [self setLevel:kCGStatusWindowLevel + 1];
//      if ( [self respondsToSelector:@selector(toggleFullScreen:)] ) {
//            [self setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces |
//             NSWindowCollectionBehaviorTransient];
//   	} else {

//- (void)setFilter:(NSString *)filterName{
//    if ( fid ){	CGSRemoveWindowFilter( cid, wid, fid );	CGSReleaseCIFilter( cid, fid );	}
//    if ( filterName ) {	CGError error = CGSNewCIFilterByName( cid, (CFStringRef)filterName, &fid );
//        if ( error == noErr ) 		{	CGSAddWindowFilter( cid, wid, fid, 0x00003001 );
//}	}	}
//
//-(void)setFilterValues:(NSDictionary *)filterValues{
//    if ( !fid ) {	return;		}
//    CGSSetCIFilterValuesFromDictionary( cid, fid, (CFDictionaryRef)filterValues );
//}



/*

 add a click view

 click view must be a sub view of the NSWindow contentView

 */

//- (void)addClickView:(AZSimpleView *)aView
//{
//	if ([aView isDescendantOf:[self contentView]] && [aView respondsToSelector:@selector(subviewClicked:)])
// _clickViews will maintain a weak ref to aView so we don't need to remove it
//}


//@implementation Drawer
//
//-(void) registerLevers:(NSView*)leverView
//{
//	static NSArray *baseline = nil;
//	baseline = [leverView.subviews map:^id(AZSimpleView *obj) {
//		return [NSValue valueWithPoint:[obj frame].origin];
//	}];
//
//	_leverView = leverView;
//	NSTimer *timer = [NSTimer timerWithTimeInterval:1 block:^(NSTimeInterval time) {
//		[_leverView.subviews eachWithIndex:^(AZSimpleView *obj, NSInteger idx) {
//			CGF diff = [baseline[idx]pointValue].y - [obj frame].origin.y;
//			if (diff != 0) { NSLog(@"diff with Lever # %ld", idx);
//				NSRect selfframe = self.frame;
//				selfframe.origin.y += diff;
//				[self setFrame:selfframe display:YES animate:YES];
//			}
//		}];
//	} repeats:YES];
//}
//- (id) init
//{
//	NSRect 	f = AZRectExceptHigh(AZMenuBarFrame(), ScreenHighness());
////			f = AZRectVerticallyOffsetBy(f, -100);
//
//	if (!(self = [self initWithContentRect:f styleMask:NSBorderlessWindowMask
//								   backing:NSBackingStoreBuffered	defer:NO] )) return nil;
//
//	[self bordlerlessInit];
//	self.backgroundColor		 = [RED alpha:.4];
//
//	_root  	= [[self contentView] setupHostView];
//	CALayer *drawer = [CALayer layer];
//	CALayer *liner  = [CALayer layer];
//	_root.layoutManager = AZLAYOUTMGR;
//	[drawer addConstraintsSuperSize];
//	[liner addConstraintsSuperSize];
//	[liner addConstraints:@[AZConstRelSuperScaleOff(kCAConstraintMinY, 1, 15), AZConstRelSuperScaleOff(kCAConstraintWidth, .9, 0)]];
//	liner.contents = [NSImage imageNamed:@"black.minimal.jpg"];
//	AddShadow(drawer);
//	drawer.borderWidth 	= 20;
//	drawer.borderColor 	= cgBLACK;
//
//	liner.cornerRadius = 10;
//	AddShadow(liner);
////	w.delegate	 	= self;
////	[w setNeedsDisplay];
////	w.shadowOffset 	= AZMultiplySize(w.shadowOffset, .5);
////	w.cornerRadius 	= 7;
////	w.bgC	 		= [[NSColor leatherTintedWithColor:obj] CGColor];
//	_root.sublayers 	= @[drawer, liner];
//
//
//	return self;
//}
//
//@end
// This action method dispatches mouse and keyboard events sent to the window by the NSApplication object.
// We intercept the sendEvent: method at the NSWindow level to inspect it.
// If the event type is a click ("NSLeftMouseDown") and the element that the mouse
// is hovering over is an input, then we do something


@interface AZLayerTabWindow :NSWindow
@end
@implementation AZLayerTabWindow

-(id) initPositioned:(AZPOS)pos againstRect:(NSRect)parent withFrame:(NSR)frame
{
	//	self addChildWindow:(NSWindow *)win ordered:<#(NSWindowOrderingMode)#>
	if (!(self = [self initWithContentRect:frame styleMask:NSBorderlessWindowMask
								   backing:NSBackingStoreBuffered	defer:NO] )) return nil;

	[self bordlerlessInit];

	CALayer *root  = [self.contentView setupHostView];
	root.layoutManager = AZLAYOUTMGR;
	CALayer *edge  = [CALayer layer];
	CALayer *tab   = [CALayer layer];
	root.sublayers = @[edge, tab];
	[root.sublayers eachWithIndex:^(CAL *obj, NSInteger idx) {

		[obj addConstraintsSuperSize];
		obj.orient = pos;
		AddShadow(obj);
		obj.cornerRadius = idx == 0 ? AZMaxDim(obj.boundsSize) *.2 : AZMaxDim(obj.boundsSize) *.1;
		obj.anchorPoint = AZAnchorPointForPosition(pos);
		obj.bgC = idx == 0 ? cgWHITE : [[NSColor leatherTintedWithColor:RANDOMCOLOR]CGColor];
		//		[obj addConstraints:@[AZConstRelSuperScaleOff(kCAConstraintHeight, .9, 0), AZConstRelSuperScaleOff(kCAConstraintWidth, .9, 0)]];
		obj.delegate = self;
		[obj setNeedsDisplay];
	}];
	//	w.anchorPoint 	= AZAnchorBottom;
	//	w.position	 	= NSMakePoint(NSWidth(vRect)/2, 30);

	//	w.shadowOffset 	= AZMultiplySize(w.shadowOffset, .5);
	//	w.cornerRadius 	= 7;
	//	w.bgC	 		= [[NSColor leatherTintedWithColor:obj] CGColor];
	//	u.sublayers 	= @[uu, w];
	//	u.name = [NSS randomWords:1];

}

@end

@interface MenuBarWindowFrame : NSView
@property (assign, nonatomic) NSR resizeRect;
@end

@implementation MenuBarWindowFrame

//
// resizeRect
//
// Returns the bounds of the resize box.
//
- (NSRect)resizeRect
{

	return AZRectFromDim(100);
	//	const CGFloat resizeBoxSize = 16.0;
	//	const CGFloat contentViewPadding = 5.5;
	//
	//	NSRect contentViewRect = [[self window] contentRectForFrameRect:[[self window] frame]];
	//	NSRect resizeRect = NSMakeRect(
	//								   NSMaxX(contentViewRect) + contentViewPadding,
	//								   NSMinY(contentViewRect) - resizeBoxSize - contentViewPadding,
	//								   resizeBoxSize,
	//								   resizeBoxSize);
	//
	//	return resizeRect;
}

//
// mouseDown:
//
// Handles mouse clicks in our frame. Two actions:
//	- click in the resize box should resize the window
//	- click anywhere else will drag the window.
//
- (void)mouseDown:(NSEvent *)event
{
	NSPoint pointInView = [self convertPoint:[event locationInWindow] fromView:nil];

	BOOL resize = NO;
	if (NSPointInRect(pointInView, [self resizeRect]))
	{
		NSBeep();

		resize = YES;
	}

	NSWindow *window = [self window];
	NSPoint originalMouseLocation = [window convertBaseToScreen:[event locationInWindow]];
	NSRect originalFrame = [window frame];

	while (YES)
	{
		[AZTalker say:@"dragging"];
		//
		// Lock focus and take all the dragged and mouse up events until we
		// receive a mouse up.
		//
		NSEvent *newEvent = [window
							 nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];

		if ([newEvent type] == NSLeftMouseUp)
		{
			break;
		}

		//
		// Work out how much the mouse has moved
		//
		NSPoint newMouseLocation = [window convertBaseToScreen:[newEvent locationInWindow]];
		NSPoint delta = NSMakePoint(
									newMouseLocation.x - originalMouseLocation.x,
									newMouseLocation.y - originalMouseLocation.y);

		NSRect newFrame = originalFrame;

		if (!resize)
		{
			//
			// Alter the frame for a drag
			//
			newFrame.origin.x += delta.x;
			newFrame.origin.y += delta.y;
		}
		else
		{
			//
			// Alter the frame for a resize
			//
			newFrame.size.width += delta.x;
			newFrame.size.height -= delta.y;
			newFrame.origin.y += delta.y;

			//
			// Constrain to the window's min and max size
			//
			NSRect newContentRect = [window contentRectForFrameRect:newFrame];
			NSSize maxSize = [window maxSize];
			NSSize minSize = [window minSize];
			if (newContentRect.size.width > maxSize.width)
			{
				newFrame.size.width -= newContentRect.size.width - maxSize.width;
			}
			else if (newContentRect.size.width < minSize.width)
			{
				newFrame.size.width += minSize.width - newContentRect.size.width;
			}
			if (newContentRect.size.height > maxSize.height)
			{
				newFrame.size.height -= newContentRect.size.height - maxSize.height;
				newFrame.origin.y += newContentRect.size.height - maxSize.height;
			}
			else if (newContentRect.size.height < minSize.height)
			{
				newFrame.size.height += minSize.height - newContentRect.size.height;
				newFrame.origin.y -= minSize.height - newContentRect.size.height;
			}
		}

		[window setFrame:newFrame display:YES animate:NO];
	}
}

//
// drawRect:
//
// Draws the frame of the window.
//
- (void)drawRect:(NSRect)rect
{
	[RED set];
	NSRectFill(self.resizeRect);

	//	NSBezierPath *circlePath = [NSBezierPath bezierPathWithOvalInRect:[self bounds]];
	//
	//	NSGradient* aGradient =
	//	[[[NSGradient alloc]
	//	  initWithColorsAndLocations:
	//	  [NSColor whiteColor], (CGFloat)0.0,
	//	  [NSColor lightGrayColor], (CGFloat)1.0,
	//	  nil]
	//	 autorelease];
	//	[aGradient drawInBezierPath:circlePath angle:90];
	//
	//	[[NSColor whiteColor] set];
	//	[circlePath stroke];
	//
	//	NSRect resizeRect = [self resizeRect];
	//	NSBezierPath *resizePath = [NSBezierPath bezierPathWithRect:resizeRect];
	//
	//	[[NSColor lightGrayColor] set];
	//	[resizePath fill];
	//
	//	[[NSColor darkGrayColor] set];
	//	[resizePath stroke];
	//
	//	[[NSColor blackColor] set];
	//	NSString *windowTitle = [[self window] title];
	//	NSRect titleRect = [self bounds];
	////	titleRect.origin.y = titleRect.size.height - (WINDOW_FRAME_PADDING - 7);
	////	titleRect.size.height = (WINDOW_FRAME_PADDING - 7);
	//	NSMutableParagraphStyle *paragraphStyle =
	//	[[[NSMutableParagraphStyle alloc] init] autorelease];
	//	[paragraphStyle setAlignment:NSCenterTextAlignment];
	//	[windowTitle
	//	 drawWithRect:titleRect
	//	 options:0
	//	 attributes:[NSDictionary
	//				 dictionaryWithObjectsAndKeys:
	//				 paragraphStyle, NSParagraphStyleAttributeName,
	//				 [NSFont systemFontOfSize:14], NSFontAttributeName,
	//				 nil]];
}

@end


