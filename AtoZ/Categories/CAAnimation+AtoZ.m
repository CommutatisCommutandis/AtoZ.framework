	//
	//  CAAnimation+AtoZ.m
	//  AtoZ
	//
	//  Created by Alex Gray on 7/13/12.
	//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
	//

#import "CAAnimation+AtoZ.h"
#import "AtoZ.h"

	//CGFloat DegreesToRadians(CGFloat degrees)
	//{
	//    return degrees * M_PI / 180;
	//}

	//NSNumber* DegreesToNumber(CGFloat degrees)
	//{
	//    return [NSNumber numberWithFloat:
	//            DegreesToRadians(degrees)];
	//}



@implementation CAAnimation (AtoZ)

+ (CAAnimation*)shakeAnimation;

{
	CAKeyframeAnimation * animation;
	animation = [CAKeyframeAnimation
                 animationWithKeyPath:@"transform.rotation.z"];
    [animation setDuration:0.3];
    [animation setRepeatCount:10000];

		// Try to get the animation to begin to start with a small offset
		// that will make it shake out of sync with other layers.
    srand([[NSDate date] timeIntervalSince1970]);
    float rand = (float)random();
    [animation setBeginTime:
	 CACurrentMediaTime() + rand * .0000000001];

	NSMutableArray *values = [NSMutableArray array];
		// Turn right
    [values addObject:DegreesToNumber(-2)];
		// Turn left
    [values addObject:DegreesToNumber(2)];
		// Turn right
    [values addObject:DegreesToNumber(-2)];
		// Set the values for the animation
	[animation setValues:values];

	return animation;
}


+ (CAAnimation*)colorAnimationForLayer:(CALayer *)theLayer
					 withStartingColor:(NSColor*)color1 endColor:(NSColor*)color2{

	CAAnimation * animation = [[CAAnimation animation]
							   animationWithKeyPath:@"backgroundColor"];
	NSDictionary *dic = $map(	(id)[color1 CGColor], 	@"fromValue",
							 (id)[color2 CGColor], 	@"toValue",
							 $float(2.0), 			@"duration",
							 YES,						@"removedOnCompletion",
							 kCAFillModeForwards, 	@"fillMode");
	[animation setValuesForKeysWithDictionary:dic];
	[theLayer addAnimation:animation forKey:@"color"];
	return animation;
}

+ (CAAnimation*)rotateAnimationForLayer:(CALayer *)theLayer start:(CGFloat)starting end:(CGFloat)ending {
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	[animation setFromValue:DegreesToNumber(starting)];
	[animation setToValue:DegreesToNumber(ending)];

	[animation setRemovedOnCompletion:NO];
	[animation setFillMode:kCAFillModeForwards];

		//	previousValue = [slider floatValue];

	return animation;
}

	//- (CAAnimation *)rotateAnimationFrom:(NSNumber*)startDegree to:(NSNumber*)endDegrees
	//{
	//	CABasicAnimation * animation;
	//	animation = [CABasicAnimation
	//                 animationWithKeyPath:@"transform.rotation.z"];
	//
	//    [animation setFromValue:NSValue DegreesToNumber(startDegree.floatValue)];// previousValue)];
	//    [animation setToValue:DegreesToNumber(endDegrees.floatValue)];
	//
	//    [animation setRemovedOnCompletion:NO];
	//    [animation setFillMode:kCAFillModeForwards];
	//
	//    previousValue = [slider floatValue];
	//
	//	return animation;
	//}


+ (CAKeyframeAnimation*)popInAnimation {
	CAKeyframeAnimation* animation = [CAKeyframeAnimation animation];

	animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)],
	[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)],
	[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];

	animation.duration = 0.3f;
	return animation;
}

@end

@implementation NSView (CAAnimationEGOHelper)

- (void)popInAnimated {
	if ([self wantsLayer])
		[[self layer] popInAnimated];
}

@end

@implementation CALayer (CAAnimationEGOHelper)

- (void)popInAnimated {
	[self addAnimation:[CAAnimation popInAnimation] forKey:@"transform"];
}

@end

@implementation CAAnimation (MCAdditions)

+(CAAnimation *)flipAnimationWithDuration:(NSTimeInterval)aDuration forLayerBeginningOnTop:(BOOL)beginsOnTop scaleFactor:(CGFloat)scaleFactor {
		// Rotating halfway (pi radians) around the Y axis gives the appearance of flipping
    CABasicAnimation *flipAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    CGFloat startValue = beginsOnTop ? 0.0f : M_PI;
    CGFloat endValue = beginsOnTop ? -M_PI : 0.0f;
    flipAnimation.fromValue = [NSNumber numberWithDouble:startValue];
    flipAnimation.toValue = [NSNumber numberWithDouble:endValue];

		// Shrinking the view makes it seem to move away from us, for a more natural effect
		// Can also grow the view to make it move out of the screen
    CABasicAnimation *shrinkAnimation = nil;
    if ( scaleFactor != 1.0f ) {
        shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        shrinkAnimation.toValue = [NSNumber numberWithFloat:scaleFactor];

			// We only have to animate the shrink in one direction, then use autoreverse to "grow"
        shrinkAnimation.duration = aDuration * 0.5;
        shrinkAnimation.autoreverses = YES;
    }

		// Combine the flipping and shrinking into one smooth animation
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:flipAnimation, shrinkAnimation, nil];

		// As the edge gets closer to us, it appears to move faster. Simulate this in 2D with an easing function
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationGroup.duration = aDuration;

		// Hold the view in the state reached by the animation until we can fix it, or else we get an annoying flicker
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;

    return animationGroup;
}


+(CAAnimation *)flipDown:(NSTimeInterval)aDuration scaleFactor:(CGFloat)scaleFactor {

		// Rotating halfway (pi radians) around the Y axis gives the appearance of flipping
    CABasicAnimation *flipAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    CGFloat startValue =  /*beginsOnTop ? 0.0f :*/ M_PI;
    CGFloat endValue =  /*beginsOnTop-M_PI :*/ 0.0f;
    flipAnimation.fromValue = [NSNumber numberWithDouble:startValue];
    flipAnimation.toValue = [NSNumber numberWithDouble:endValue];

		// Shrinking the view makes it seem to move away from us, for a more natural effect
		// Can also grow the view to make it move out of the screen
    CABasicAnimation *shrinkAnimation = nil;
    if ( scaleFactor != 1.0f ) {
        shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        shrinkAnimation.toValue = [NSNumber numberWithFloat:scaleFactor];

			// We only have to animate the shrink in one direction, then use autoreverse to "grow"
        shrinkAnimation.duration = aDuration * 0.5;
        shrinkAnimation.autoreverses = YES;
    }

		// Combine the flipping and shrinking into one smooth animation
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:flipAnimation, shrinkAnimation, nil];

		// As the edge gets closer to us, it appears to move faster. Simulate this in 2D with an easing function
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationGroup.duration = aDuration;

		// Hold the view in the state reached by the animation until we can fix it, or else we get an annoying flicker
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;

    return animationGroup;

}


	//	//assuming view is your NSView
	//CGPoint newCenter = CGPointMake(view.center.x - 300, view.center.y);
	//CABasicAnimation *animation = [CABasicAnimation animation];
	//	//setup your animation eg. duration/other options
	//animation.fromValue = [NSValue valueWithCGPoint:v.center];
	//animation.toValue = [NSValue valueWithCGPoint:newCenter];
	//[view.layer addAnimation:animation forKey:@"key"];
	//
	//- (CAKeyframeAnimation *)slideOut:(NSRect)frame oriented: (AZOrient)orientation{
	//
	//    CAKeyframeAnimation *slideout = [CAKeyframeAnimation animation];
	//
	//    CGMutablePathRef slidePath = CGPathCreateMutable();
	//	CGFloat xFin, yFin;  CGPoint go;
	//
	//	switch (orientation) {
	//		case AZOrientLeft:
	//		case AZOrientRight:
	//			xFin = 	orientation == AZOrientLeft ?  - NSMaxX(frame)	:   NSMaxX(frame) ;
	//			yFin =  0;
	//			go   =  orientation == AZOrientLeft ? (CGPoint){ NSMidY(frame), -
	//				break;
	//
	//			default:
	//				break;
	//			}
	//			xFin =  orientation == AZOrientBottom  	?  0
	//			:	orientation == AZOrientTop 		?  0
	//			yFin = 	orientation == AZOrientLeft || orientation == AZOrientRight ?  0
	//			:	orientation == AZOrientTop 		?   NSMaxY(frame) : -NSMaxY(frame);
	//			go 	 =  orientation == AZOrientBottom 	:
	//
	//
	//			CGPathMoveToPoint(shakePath, NULL, NSMinX(frame), NSMinY(frame));
	//			int index;
	//			for (index = 0; index < numberOfShakes; ++index)
	//			{
	//				CGPathAddLineToPoint(shakePath, NULL, NSMinX(frame) - frame.size.width * vigourOfShake, NSMinY(frame));
	//				CGPathAddLineToPoint(shakePath, NULL, NSMinX(frame) + frame.size.width * vigourOfShake, NSMinY(frame));
	//			}
	//			CGPathCloseSubpath(shakePath);
	//			shakeAnim.path = shakePath;
	//			shakeAnim.duration = durationOfShake;
	//			return shakeAnim;
	//	}
	//
- (CAKeyframeAnimation *)negativeShake:(NSRect)frame{
	int numberOfShakes = 4;
	float durationOfShake = 0.5f;
	float vigourOfShake = 0.05f;

	CAKeyframeAnimation *shakeAnim = [CAKeyframeAnimation animation];

	CGMutablePathRef shakePath = CGPathCreateMutable();
	CGPathMoveToPoint(shakePath, NULL, NSMinX(frame), NSMinY(frame));
	int index;
	for (index = 0; index < numberOfShakes; ++index)
	{
		CGPathAddLineToPoint(shakePath, NULL, NSMinX(frame) - frame.size.width * vigourOfShake, NSMinY(frame));
		CGPathAddLineToPoint(shakePath, NULL, NSMinX(frame) + frame.size.width * vigourOfShake, NSMinY(frame));
	}
	CGPathCloseSubpath(shakePath);
	shakeAnim.path = shakePath;
	shakeAnim.duration = durationOfShake;
	return shakeAnim;
}

- (IBAction)shakeBabyShake:(id)sender;
{
	NSString *key = @"frameOrigin";
#if __i386__
	if ([NSView defaultAnimationForKey:key] == nil){
#elif __x86_64__
		if ([NSWindow defaultAnimationForKey:key] == nil){
#endif
			NSLog(@"NSVindow not animatable for key '%@'",key);
		}else {
			[[NSApp keyWindow] setAnimations:[NSDictionary dictionaryWithObject:[self negativeShake:[[NSApp keyWindow] frame]] forKey:key]];
			[[[NSApp keyWindow] animator] setFrameOrigin:[[NSApp keyWindow] frame].origin];
		}
	}


	//- (void)animateView:(NSView*)sender {
	//		// Get the relevant frames.
	//	NSView *enclosingView = [[[NSApplication sharedApplication] mainWindow] contentView];
	////	int rowIndex = [sender selectedRow];
	//	NSRect cellFrame = [sender frame];//OfCellAtColumn:0 row:rowIndex];
	////	NSRect buttonFrame = [button frame];
	////	NSRect mainViewFrame = [enclosingView frame];
	//
	//	/*	      * Yellow fade animation/9**/
	//
	//		// Create the yellow fade layer.
	//	CALayer *layer = [CALayer layer];
	//	[layer setDelegate:self];
	//	yellowFadeView = [[NSView alloc] init];
	//	[yellowFadeView setWantsLayer:YES];
	//	[yellowFadeView setFrame:cellFrame];
	//	[yellowFadeView setLayer:layer];
	//	[[yellowFadeView layer] setNeedsDisplay];
	//	[yellowFadeView setAlphaValue:0.0];
	//	[sourceList addSubview:yellowFadeView];
	//
	//		// Create the animation pieces.
	//	CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath: @"alphaValue"];
	//	alphaAnimation.beginTime = 1.0;
	//	alphaAnimation.fromValue = [NSNumber numberWithFloat: 0.0];
	//	alphaAnimation.toValue = [NSNumber numberWithFloat: 1.0];
	//	alphaAnimation.duration = 0.25;
	//	CABasicAnimation *alphaAnimation2 = [CABasicAnimation animationWithKeyPath: @"alphaValue"];
	//	alphaAnimation2.beginTime = 1.25;
	//	alphaAnimation2.duration = 0.25;
	//	alphaAnimation2.fromValue = [NSNumber numberWithFloat: 1.0];
	//	alphaAnimation2.toValue = [NSNumber numberWithFloat: 0.0];
	//	CABasicAnimation *alphaAnimation3 = [CABasicAnimation animationWithKeyPath: @"alphaValue"];
	//	alphaAnimation3.beginTime = 1.5;
	//	alphaAnimation3.duration = 0.25;
	//	alphaAnimation3.fromValue = [NSNumber numberWithFloat: 0.0];
	//	alphaAnimation3.toValue = [NSNumber numberWithFloat: 1.0];
	//	CABasicAnimation *alphaAnimation4 = [CABasicAnimation animationWithKeyPath: @"alphaValue"];
	//	alphaAnimation4.beginTime = 1.75;
	//	alphaAnimation4.duration = 0.25;
	//	alphaAnimation4.fromValue = [NSNumber numberWithFloat: 1.0];
	//	alphaAnimation4.toValue = [NSNumber numberWithFloat: 0.0];
	//
	//		// Create the animation group.
	//	CAAnimationGroup *yellowFadeAnimation = [CAAnimationGroup animation];
	//	yellowFadeAnimation.delegate = self;
	//	yellowFadeAnimation.animations =@[ alphaAnimation, alphaAnimation2, alphaAnimation3, alphaAnimation4 ];
	//	yellowFadeAnimation.duration = 2.0;
	//	[yellowFadeView setAnimations:@{ @"frameOrigin":yellowFadeAnimation} ];
	//
	//		// Start the yellow fade animation.
	//	[[yellowFadeView animator] setFrame:[yellowFadeView frame]];
	//}
	//
	//- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
	//		// Bezier path radius
	//	int radius = 4;
	//
	//		// Setup graphics context.
	//	NSGraphicsContext *nsGraphicsContext = [NSGraphicsContext graphicsContextWithGraphicsPort:ctx flipped:NO];
	//	[NSGraphicsContext saveGraphicsState];
	//	[NSGraphicsContext setCurrentContext:nsGraphicsContext];
	//
	//		// Convert to NSRect.
	//	CGRect aRect = [layer frame];
	//	NSRect rect = NSMakeRect(aRect.origin.x, aRect.origin.y, aRect.size.width, aRect.size.height);
	//
	//		// Draw dark outside line.
	//	[NSBezierPath setDefaultLineWidth:2];
	//	NSBezierPath *highlightPath = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:radius yRadius:radius];
	//	[[NSColor yellowColor] set];
	//	[highlightPath stroke];
	//
	//		// Draw transparent inside fill.
	//	CGFloat r, g, b, a;
	//	[[NSColor yellowColor] getRed:&amp;r green:&amp;g blue:&amp;b alpha:&amp;a];
	//	NSColor *transparentYellow = [NSColor colorWithCalibratedRed:r green:g blue:b alpha:0.5];
	//	NSBezierPath *fillPath = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:radius yRadius:radius];
	//	[transparentYellow set];
	//	[fillPath fill];
	//
	//		// Finish with graphics context.
	//	[NSGraphicsContext restoreGraphicsState];
	//}
	//

	//	@end





/*   example of blocks category below

 - (void)runAnimation:(id)unused
 {
 // Create a shaking animation that rotates a bit counter clockwisely and then rotates another
 // bit clockwisely and repeats. Basically, add a new rotation animation in the opposite
 // direction at the completion of each rotation animation.
 const CGFloat duration = 0.1f;
 const CGFloat angle = 0.03f;
 NSNumber *angleR = [NSNumber numberWithFloat:angle];
 NSNumber *angleL = [NSNumber numberWithFloat:-angle];

 CABasicAnimation *animationL = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
 CABasicAnimation *animationR = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];

 void (^completionR)(BOOL) = ^(BOOL finished) {
 [self.imageView.layer setValue:angleL forKey:@"transform.rotation.z"];
 [self.imageView.layer addAnimation:animationL forKey:@"L"]; // Add rotation animation in the opposite direction.
 };

 void (^completionL)(BOOL) = ^(BOOL finished) {
 [self.imageView.layer setValue:angleR forKey:@"transform.rotation.z"];
 [self.imageView.layer addAnimation:animationR forKey:@"R"];
 };

 animationL.fromValue = angleR;
 animationL.toValue = angleL;
 animationL.duration = duration;
 animationL.completion = completionL; // Set completion to perform rotation in opposite direction upon completion.

 animationR.fromValue = angleL;
 animationR.toValue = angleR;
 animationR.duration = duration;
 animationR.completion = completionR;

 // First animation performs half rotation and then proceeds to enter the loop by playing animationL in its completion block
 CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
 animation.fromValue = [NSNumber numberWithFloat:0.f];
 animation.toValue = angleR;
 animation.duration = duration/2;
 animation.completion = completionR;

 [self.imageView.layer setValue:angleR forKey:@"transform.rotation.z"];
 [self.imageView.layer addAnimation:animation forKey:@"0"];
 }

 */

@end
@interface CAAnimationDelegate : NSObject {
    void (^_completion)(BOOL);
    void (^_start)();
}

@property (nonatomic, copy) void (^completion)(BOOL);
@property (nonatomic, copy) void (^start)();

- (void)animationDidStart:(CAAnimation *)anim;
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;

@end


@implementation CAAnimationDelegate

@synthesize completion=_completion;
@synthesize start=_start;

- (id)init
{
    self = [super init];
    if (self) {
        self.completion = nil;
        self.start = nil;
    }
    return self;
}

- (void)dealloc
{
    self.completion = nil;
    self.start = nil;
//    [super dealloc];
}

- (void)animationDidStart:(CAAnimation *)anim
{
    if (self.start != nil) {
        self.start();
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (self.completion != nil) {
        self.completion(flag);
    }
}

@end



@implementation CAAnimation (BlocksAddition)

-  (BOOL)delegateCheck
{
    if (self.delegate != nil && ![self.delegate isKindOfClass:[CAAnimationDelegate class]]) {
        NSLog(@"CAAnimation(BlocksAddition) Warning: CAAnimation instance's delegate was modified externally");
        return NO;
    }
    return YES;
}

- (void)setCompletion:(void (^)(BOOL))completion
{
    CAAnimationDelegate *newDelegate = [[CAAnimationDelegate alloc] init];
    newDelegate.completion = completion;
    newDelegate.start = ((CAAnimationDelegate *)self.delegate).start;
    self.delegate = newDelegate;
    [newDelegate release];
}

- (void (^)(BOOL))completion
{
    if (![self delegateCheck]) {
        return nil;
    }
    return ((CAAnimationDelegate *)self.delegate).completion;
}

- (void)setStart:(void (^)())start
{
    CAAnimationDelegate *newDelegate = [[CAAnimationDelegate alloc] init];
    newDelegate.start = start;
    newDelegate.completion = ((CAAnimationDelegate *)self.delegate).completion;
    self.delegate = newDelegate;
    [newDelegate release];
}

- (void (^)())start
{
    if (![self delegateCheck]) {
        return nil;
    }
    return ((CAAnimationDelegate *)self.delegate).start;
}

@end