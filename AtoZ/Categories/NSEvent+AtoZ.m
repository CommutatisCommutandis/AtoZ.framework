//
//  NSEvent+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 9/23/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "NSEvent+AtoZ.h"

static NSString *NSTVDOUBLEACTIONBLOCKKEY = @"com.mrgray.NSTV.double.action.block";


@implementation NSTableView (TargetAction)

- (void) setDoubleAction:(SEL)method withTarget:(id)object;
{
	self.doubleAction = method;	self.target = object;
}
- (void) setDoubleActionString:(NSS*)methodAsString withTarget:(id)object;
{
	self.doubleAction = NSSelectorFromString(methodAsString);	self.target		= object;
}

@dynamic doubleActionBlock;


- (NSControlVoidActionBlock) doubleActionBlock {	return (NSControlVoidActionBlock)[self associatedValueForKey:NSTVDOUBLEACTIONBLOCKKEY];}

- (void)setDoubleActionBlock:(NSControlVoidActionBlock)block
{
	[self setDoubleActionString:@"callDoubleActionBlock" withTarget:self];
	[self setAssociatedValue:block forKey: NSTVDOUBLEACTIONBLOCKKEY policy:OBJC_ASSOCIATION_COPY];
}
- (void) callDoubleActionBlock { self.doubleActionBlock(); }

@end

#include <objc/runtime.h>

static NSString *NSCONTROLBLOCKACTIONKEY = @"com.mrgray.NSControl.block";
static NSString *NSCONTROLVOIDBLOCKACTIONKEY = @"com.mrgray.NSControl.voidBlock";

@implementation NSControl (AtoZ)
@dynamic actionBlock, voidActionBlock;

- (NSControlActionBlock)actionBlock
{//	NSControlActionBlock theBlock =
	return (NSControlActionBlock)[self associatedValueForKey:NSCONTROLBLOCKACTIONKEY];
//	return(theBlock);
}
- (void)setActionBlock:(NSControlActionBlock)inBlock
{
	self.target = self;
	self.action = @selector(callAssociatedBlock:);
	[self setAssociatedValue:inBlock forKey: NSCONTROLBLOCKACTIONKEY policy:OBJC_ASSOCIATION_COPY];
}

- (void)callAssociatedBlock:(id)inSender { self.actionBlock(inSender); }


- (NSControlVoidActionBlock) voidActionBlock {	return (NSControlVoidActionBlock)[self associatedValueForKey:NSCONTROLVOIDBLOCKACTIONKEY];}

- (void)setVoidActionBlock:(NSControlVoidActionBlock)inBlock
{
	[self setActionString:@"callAssociatedVoidBlock" withTarget:self];
	[self setAssociatedValue:inBlock forKey: NSCONTROLVOIDBLOCKACTIONKEY policy:OBJC_ASSOCIATION_COPY];
}
- (void)callAssociatedVoidBlock { self.voidActionBlock(); }

- (void) setAction:(SEL)method withTarget:(id)object;
{
	self.action = method; 	self.target = object;
}
- (void) setActionString:(NSS*)methodAsString withTarget:(id)object
{
	self.action = NSSelectorFromString(methodAsString);	self.target = object;
}

@end

//insideDrag dragBlock = ^void(NSE *e, NSP start, whileDragging dragaction) {
//
//	NSLog(@"Inside dragblock!  Yay!");
//	while ( ( e = [NSApp nextEventMatchingMask: MOUSEDRAGGING untilDate:FUTURE inMode:NSEventTrackingRunLoopMode dequeue:YES] ) && ( e.type != MOUSEUP) ) {
//		@autoreleasepool {
//			dragaction();
//		}
//	}
//};

@implementation NSEvent (AtoZ)

//+ (whileDragging)dragBlock:(NSE*)e;
//{
//	NSPoint start = e.locationInWindow;
//	return  whileDragging:(e, start);
//}
static NSEvent *theDrag;

+ (void)whileDragging:(void(^)(NSE*click, NSE*drag)) block
{
	[self addLocalMonitorForEventsMatchingMask:NSLeftMouseDownMask handler:^NSE*(NSE *click){
		NSLog(@"click caller at %@", AZString(click.locationInWindow));
		theDrag = [click dragHandlerForClickWithBlock:block];
		return click;
	}];
	[self addLocalMonitorForEventsMatchingMask:NSLeftMouseUpMask handler:^NSEvent *(NSEvent *e) {
		theDrag = nil;
		return e;
	}];
}

- (id) dragHandlerForClickWithBlock:(void(^)(NSE*click, NSE*drag)) block
{
	return [self.class addLocalMonitorForEventsMatchingMask:NSLeftMouseDraggedMask handler:^NSEvent *(NSEvent *drag) {
//		drag = [NSApp nextEventMatchingMask:NSLeftMouseDraggedMask untilDate:FUTURE inMode:NSEventTrackingRunLoopMode dequeue:YES];
//			[NSApp discardEventsMatchingMask:NSAnyEventMask beforeEvent:drag];
//			if ( drag.type == NSLeftMouseDragged )
		block(self, drag);
//			else if ( click.type == NSLeftMouseUp )
			return drag;
	}];
}

//	__block NSP down;
//		down = d.locationInWindow;
//		[self addLocalMonitorForEventsMatchingMask:NSLeftMouseDraggedMask handler:^(NSE *drag) {
//		NSE *drag;
//		while ( ( drag = [NSApp nextEventMatchingMask: NSLeftMouseDraggedMask untilDate:FUTURE inMode:NSEventTrackingRunLoopMode dequeue:YES] )
//		&&
//		 ( drag.type != MOUSEUP ))  {
//			@autoreleasepool {
//				block(click, drag);
//			}
//			return drag;
//			}];
//		}
//		return click;
//
//	}];


+ (void) shiftClick:(void(^)(void))block {

	[NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler: ^(NSEvent *event){
		NSUInteger flags = [event modifierFlags] & NSDeviceIndependentModifierFlagsMask;
		if (flags ==  NSShiftKeyMask)   block(); ////NSControlKeyMask +
		return event;
	}];
}

@end
