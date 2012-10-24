	//
	//  CALayer+AtoZ.h
	//  AtoZ
	//
	//  Created by Alex Gray on 7/13/12.
	//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
	//

#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
#import "AtoZ.h"

	void prepareContext(CGContextRef ctx);

	extern void applyPerspective (CALayer* layer);
//	extern CATransform3D perspective();

/** Moves a layer from one superlayer to another, without changing its position onscreen. */
	extern void ChangeSuperlayer( CALayer *layer, CALayer *newSuperlayer, int index );
/** Removes a layer from its superlayer without any fade-out animation. */
	extern void RemoveImmediately( CALayer *layer );

	extern CALayer* AddPulsatingBloom( CALayer *layer);
	extern CALayer* AddShadow ( CALayer *layer);
	extern CALayer* AddBloom  ( CALayer *layer);

/** Convenience for creating, adding,a nd returning a relatively nice CALayer. */
	extern CALayer* NewLayerInLayer( CALayer *superlayer );
	extern CALayer* NewLayerWithFrame( NSRect rect );

/** Convenience for creating a CATextLayer. */
	extern CATextLayer* AddTextLayer  ( CALayer *superlayer, NSString *text, NSFont* font, enum CAAutoresizingMask align );
	extern CATextLayer* AddLabelLayer ( CALayer *superlayer, NSString *text, NSFont* font );
	extern CATextLayer* AddLabel ( 	    CALayer *superlayer, NSString *text );

	extern CALayer* ReturnImageLayer( CALayer *superlayer, NSImage *image, CGFloat scale);
	extern CATextLayer* AddLabelLayer( CALayer *superlayer, NSString *text, NSFont* font );

/** Loads an image or pattern file into a CGImage or CGPattern. If the name begins with "/", it's interpreted as an absolute filesystem path. Otherwise, it's the name of a resource that's looked up in the app bundle. The image must exist, or an assertion-failure exception will be raised! Loaded images/patterns are cached in memory, so subsequent calls with the same name are very fast. */
	extern CGImageRef GetCGImageNamed ( NSString *name );
	extern CGColorRef GetCGPatternNamed (      NSString *name );
/** Loads image data from the pasteboard into a CGImage. */
	extern CGImageRef GetCGImageFromPasteboard ( NSPasteboard *pb );
/** Creates a CGPattern from a CGImage. */
	extern CGPatternRef CreateImagePattern ( CGImageRef image );
/** Creates a CGColor that draws the given CGImage as a pattern. */
	extern CGColorRef CreatePatternColor ( CGImageRef image );
/** Returns the alpha value of a single pixel in a CGImage, scaled to a particular size. */
	float GetPixelAlpha ( CGImageRef image, CGSize imageSize, CGPoint pt );

/**
As with the distort transform, the x and y values adjust intensity. I have included a CATransform3DMake method as there are no built in CATransform3D methods to create a transform by passing in 16 values (mimicking the CGAffineTransformMake method).

For those that have never seen the CATransform3D struct before, you must apply the transform to a CALayer‘s transform, as opposed to a CGAffineTransform which is applied to the UIView‘s transform. If you want to apply it to a UIView, obtain it’s layer then set the transform (myView.layer = CATransform3DMakePerspective(0.002, 0)).

	What do represent the two parameters in CATransform3DMakePerspective(0.002, 0) ?
 	The first is how much you want it to skew on the X axis (horizontally), and the second for the Y axis (vertically)

	Yes, but what are the units ? (radians … ?)
	The value goes directly into the transform, if you want to make it radians, or any other type of unit you will need to put some math in there
 */
extern CATransform3D CATransform3DMake(CGFloat m11, CGFloat m12, CGFloat m13, CGFloat m14,
				  CGFloat m21, CGFloat m22, CGFloat m23, CGFloat m24,
				  CGFloat m31, CGFloat m32, CGFloat m33, CGFloat m34,
				  CGFloat m41, CGFloat m42, CGFloat m43, CGFloat m44);
//
//
//	CG_INLINE CATransform3D CATransform3DMake( CGFloat m11, CGFloat m12, CGFloat m13, CGFloat m14,
//					  						   CGFloat m21, CGFloat m22, CGFloat m23, CGFloat m24,
//											   CGFloat m31, CGFloat m32, CGFloat m33, CGFloat m34,
//											   CGFloat m41, CGFloat m42, CGFloat m43, CGFloat m44);

#import "AtoZUmbrella.h"
@interface CALayer (VariadicConstraints)
- (void)addConstraintsRelSuper:(CAConstraintAttribute)first,...; /* REQUIRES NSNotFound termination */
//- (void) addConstraintsRelSuper:(CAConstraintAttribute) nilAttributeList, ...;  // This method takes a nil-terminated list of objects.
@end

@interface CALayer (AtoZ)
-(void) animateXThenYToFrame:(NSR)toRect duration:(NSUI)time;


- (void)blinkLayerWithColor:(NSColor *)color;

- (void) addPerspectiveForVerticalOffset:(CGFloat)pixels;
- (CAL*)hitTestEvent:(NSEvent*)e inView:(NSView*)v;

- (void) toggleLasso:(BOOL)state;

- (id) lassoLayerForLayer:(CALayer*)layer;
- (void) redrawPath;

- (CALayer*) selectionLayerForLayer:(CALayer*)layer;
- (CATransform3D)makeTransformForAngle:(CGFloat)angle;
- (id)objectForKeyedSubscript:(NSString *)key;
- (void)setObject:(id)object forKeyedSubscript:(NSString *)key;

- (void)addConstraints:(NSArray*)constraints;
- (void)orientWithPoint:(CGPoint) point;
- (void)orientWithX: (CGFloat)x andY: (CGFloat)y;
- (void)orientOnEvent: (NSEvent*)event;

- (void) setAnchorPointRelative: (CGPoint) anchorPoint;
- (void) setAnchorPoint: (CGPoint) anchorPoint inRect:(NSRect)rect;
- (void) setAnchorPoint: (CGPoint) anchorPoint inView: (NSView *) view;
- (void) flipHorizontally;
- (void) flipVertically;
- (void) flipBackAtEdge:	(AZWindowPosition)position;
- (void) flipForwardAtEdge: (AZWindowPosition)position;

- (CATransform3D) flipAnimationPositioned:(AZWindowPosition)pos;

- (void) flipOver;
- (void) flipBack;
- (void) flipDown;

- (void) setScale: (CGFloat) scale;

- (void)pulse;
- (void)fadeOut;
- (void)fadeIn;
- (void)animateToColor:(NSColor*)color;

- (void)addAnimations:(NSArray*)anims forKeys:(NSArray *)keys;

+ (CALayer *) withName:(NSString*)name   inFrame:(NSRect)rect
			   colored:(NSColor*)color withBorder:(CGFloat)width colored:(NSColor*) borderColor;

- (CATransform3D)makeTransformForAngle:(CGFloat)angle from:(CATransform3D)start;
- (BOOL)containsOpaquePoint:(CGPoint)p;
- (CALayer *) labelLayer;
- (CALayer *) setLabelString:(NSString *)label;
- (id) sublayerWithName:(NSString *)name;
+ (CALayer*)veilForView:(CALayer*)view;

- (CATransform3D)rectToQuad:(NSRect)rect quadTLX:(double)x1a quadTLY:(double)y1a quadTRX:(double)x2a quadTRY:(double)y2a quadBLX:(double)x3a quadBLY:(double)y3a quadBRX:(double)x4a quadBRY:(double)y4a;

- (void) addConstraintsSuperSizeScaled:(CGFloat)scale;
- (void) addConstraintsSuperSize;
+ (CALayer*)closeBoxLayer;
+ (CALayer*)closeBoxLayerForLayer:(CALayer*)parentLayer;

	//Metallic grey gradient background
+ (CAGradientLayer*) greyGradient;
-(NSString*)debugDescription;

-(void)debugAppendToLayerTree:(NSMutableString*)treeStr indention:(NSString*)indentStr;
- (NSString*)debugLayerTree;
- (void) addSublayers:(NSArray*)subLayers;

@end
@interface  CATextLayer (AtoZ)
- (CTFontRef)newFontWithAttributes:(NSDictionary *)attributes;
- (CTFontRef)newCustomFontWithName:(NSString *)fontName ofType:(NSString *)type attributes:(NSDictionary *)attributes;
- (CGSize)suggestSizeAndFitRange:(CFRange *)range	forAttributedString:(NSMutableAttributedString *)attrString
															  usingSize:(CGSize)referenceSize;
- (void)setupAttributedTextLayerWithFont:(CTFontRef)font;

@end
