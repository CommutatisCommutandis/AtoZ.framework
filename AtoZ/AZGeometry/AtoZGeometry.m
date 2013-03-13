//
//  THGeometricFunctions.m
//  Lumumba
//
//  Created by Benjamin Schüttler on 19.11.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "AtoZGeometry.h"
#import "AtoZ.h"
#import <Quartz/Quartz.h>
//#import <DrawKit/DKDrawKit.h>

@implementation AtoZGeometry
@end


BOOL AZEqualRects(NSR r1, NSR r2){ return NSEqualRects(r1,r2); }

const CGP AZAnchorTop		  = (CGP) { .5, 1 };
const CGP AZAnchorBottom	  = (CGP) { .5, 0 };
const CGP AZAnchorRight		  = (CGP) {  1,.5 };
const CGP AZAnchorLeft 		  = (CGP) {  0,.5 };
const CGP AZAnchorTopLeft	  = (CGP) { .5,.5 };  //  0, 1 };
const CGP AZAnchorBottomLeft  = (CGP) { .5,.5 };  // 0, 0 };
const CGP AZAnchorTopRight	= (CGP) { .5,.5 };  // 1, 1 };
const CGP AZAnchorBottomRight = (CGP) { .5,.5 };  //1, 0 };


AZPOS AZPositionAtPerimeterInRect(NSR edgeBox, NSR outer)
{
//	CGF max, left, right, top, bttom

	AZOrient vORh = (edgeBox.origin.x == outer.origin.x || (edgeBox.origin.x + edgeBox.size.width) == outer.size.width)
				  ? AZOrientVertical : AZOrientHorizontal;
	AZPOS p;
	if ( vORh == AZOrientHorizontal ) p = edgeBox.origin.y == 0 ? AZPositionBottom : AZPositionTop;
	else 							  p = edgeBox.origin.x == 0 ? AZPositionLeft : AZPositionRight;
	return p;
}

CGP AZAnchorPointForPosition( AZPOS pos){

	return pos == AZPositionLeft  		? AZAnchorLeft
		 : pos == AZPositionTop			? AZAnchorTop
		 : pos == AZPositionBottom 		? AZAnchorBottom
		 : pos == AZPositionRight  		? AZAnchorRight
		 : pos == AZPositionTopLeft		? AZAnchorTopLeft
		 : pos == AZPositionBottomLeft 	? AZAnchorBottomLeft
	 	 : pos == AZPositionTopRight	? AZAnchorTopRight
		 : 								  AZAnchorBottomRight;  //pos == AZPositionRight


}

NSR	AZRandomRectinRect(CGRect rect){

	NSR r = AZRectFromDim(RAND_FLOAT_VAL(0, AZMinDim(rect.size)));
	r.origin = AZRandomPointInRect(AZRectBy(rect.size.width-r.size.width,rect.size.height-r.size.height));
	return r;
}


CGP AZRandomPointInRect(CGRect rect)
{
	CGP point = CGPointZero;
	NSInteger max = rect.size.width;
	NSInteger min = 0;
	point.x = (random() % (max-min+1)) + min;

	max = rect.size.height;
	point.y = (random() % (max-min+1)) + min;

	return point;
}

NSNumber *iNum(NSInteger i) {
  return [NSNumber numberWithInt:i];
}

NSNumber *uNum(NSUInteger ui) {
  return [NSNumber numberWithUnsignedInt:ui];
}

NSNumber *fNum(CGFloat f) {
  return [NSNumber numberWithFloat:f];
}

NSNumber *dNum(double d) {
  return @(d);
}

//NSRange AZMakeRange(NSUInteger min, NSUInteger max) {
//  NSUInteger loc = MIN(min, max);
//  NSUInteger len = MAX(min, max) - loc;
//  return NSMakeRange(loc, len);
//}

NSR nanRectCheck(NSR rect) {
		rect.origin = nanPointCheck(rect.origin);
		rect.size 	= nanSizeCheck(rect.size);
		return rect;
}
NSSize nanSizeCheck(NSSize size) {
	size.width  = isinf(size.width)  ? 0 : size.width;
	size.height = isinf(size.height) ? 0 : size.height;
	return  size;
}
NSPoint nanPointCheck(NSPoint origin) {
	origin.x = isinf(origin.x) ? 0 : origin.x;
	origin.y = isinf(origin.y) ? 0 : origin.y;
	return origin;
}

//id nanCheck(NSValue* point) {
//	id behind;
//	if ( [point respondsToSelector:@selector(recttValue)] ) behind = (__bridge_transfer NSR)nanRectCheck( [point rectValue]);
//		:   [point respondsToSelector:@selector(sizeValue)]  ? nanSizeCheck(  [point pointValue])
//		:   					 							   nanPointCheck( [point pointValue]);
//}
NSPoint AZPointOffset (NSPoint p, NSPoint size) {
	p.x += size.x;
	p.y += size.y;
	return p;
}
NSPoint AZPointOffsetY (NSPoint p, CGFloat distance) {
	p.y += distance;
	return p;
}
NSPoint AZPointOffsetX (NSPoint p, CGFloat distance) {
	p.x += distance;
	return p;
}

CGFloat AZAspectRatioForSize(NSSize size){
	return	size.height == size.width	? 1.0 :
	size.width / size.height;
}
CGFloat AZAspectRatioOf(CGFloat width, CGFloat height){
	return AZAspectRatioForSize(NSMakeSize(width, height));
}

NSI AZLowestCommonDenominator(int a, int b){
	int i;
	for(i = 2; (a % i != 0) || (b%i != 0); ++i)
		{
		if( i > a || i > b)//a and b are prime
			return 1;
		}
	return i;
}

BOOL isWhole(CGFloat fl) {
	return fmod(fl, 1.0) == 0.0 ? YES : NO;
}

int GCD(int a, int b) {
	while (a != 0 && b != 0)	 if (a > b) a %= b; else  b %= a;
	return a == 0 ? b : a;
}

// Using Konrad's code:

//var gcd = GCD(A, B);
//return string.Format("{0}:{1}", A / gcd, B / gcd)

NSString* AZAspectRatioString(CGFloat ratio)
{
	CGFloat a, b; int newRatio, m; m =10;
	if (ratio != 1.0) {
		while (	isWhole(m * ratio) == NO) m = m *10;

		newRatio = GCD(m, (int)m*ratio );
	}

	return	ratio == 1.0 ?	@"** 1 : 1 **" : $(@"%i : %i", (int)(m*ratio/newRatio),(int)(m/newRatio));
//	size.height > _size.width  ?	$(@"1 : %0.1f", (float)(_size.height/_size.width))
//	//	: 	$(@"%0.1f : 1", (float)(_size.width/_size.height));
//	return
// @"poop";
}

//CGSize AZAspectRatio(NSR rect ){

// CGFloat aspectRatio = ( rect.width / rect.height );
//}

AZPOS AZPositionOpposite(AZPOS position){

	switch (position) {
		case AZPositionBottom:		return AZPositionTop;			break;
		case AZPositionTop:			return AZPositionBottom;		break;
		case AZPositionLeft:			return AZPositionRight;			break;
		case AZPositionRight:		return AZPositionLeft;			break;
		case AZPositionBottomLeft:	return AZPositionTopRight;		break;
		case AZPositionTopLeft:		return AZPositionBottomRight;	break;
		case AZPositionBottomRight:	return AZPositionTopLeft;		break;
		case AZPositionTopRight:	return AZPositionBottomLeft;	break;
		default:					return 99;						break;
	}
}

AZPOS AZPositionOfEdgeAtOffsetAlongPerimeterOfRect(CGF offset, NSR r) {

	NSSZ sz = r.size; AZPOS anchor;
	if 		( sz.width > offset ) 					anchor = AZPositionBottom;
	else if ( sz.width + sz.height > offset ) 		anchor = AZPositionRight;
	else if ( AZPerimeter(r) - sz.height > offset ) anchor = AZPositionTop;
	else 											anchor = AZPositionLeft;
	return anchor;
}
CGP AZPointAtOffsetAlongPerimeterOfRect(CGF offset, NSR r)
{
	NSSZ sz = r.size; NSP anchor; CGF offsetOnSide;
	if 		( sz.width > offset ) 					anchor = (NSP) { offset, 				   				 0};
	else if ( sz.width + sz.height > offset ) 		anchor = (NSP) { sz.width, 				 offset - sz.width};
	else if ( AZPerimeter(r) - sz.height > offset ) anchor = (NSP) { ABS( sz.width - (offset - sz.width - sz.height)),  sz.height};
	else 											anchor = (NSP) { 0,				   AZPerimeter(r) - offset};
	return anchor;
//	CG totes = AZPerimeter (r);  //  for example 60 ... 10 x 20 box
//	CGF cross = offset / totes;  //  offset of 10.   .16;
//	CGF xRat  = r.size.width / (totes/2);
//	CGF yRat  = ( 1 - (2*xRat)) / 2;;
//	CGF bott  = cross < ;
//	CGF right = cross < r.size.width + r.size.height / totes;
//	CGF top   = intersect < totes - r.size.height;
}


CGFloat AZPerimeter (NSR rect) {
	return ( (2* rect.size.width) + (2 * rect.size.height) );
}

CGFloat AZPermineterWithRoundRadius (NSR rect, CGFloat radius) {
	return  ( AZPerimeter(rect) - ( ( 8 - (   (2 * pi) * radius)   )));
}
NSR AZScreenFrameUnderMenu(void) { return AZRectTrimmedOnTop( [[NSScreen mainScreen]frame], AZMenuBarThickness()); }
NSR AZScreenFrame (void) {		  return [[NSScreen mainScreen]frame];	}
NSSize AZScreenSize  (void) {		  return AZScreenFrame().size; }

// 2D Functions

CGFloat AZMinDim(NSSize sz) {	return MIN(sz.width, sz.height); }
CGFloat AZMaxDim(NSSize sz) {	return MAX(sz.width, sz.height); }
CGFloat AZMaxEdge(NSR r) { 	return AZMaxDim(r.size); }
CGFloat AZMinEdge(NSR r) {	return AZMinDim(r.size); }

CGFloat AZLengthOfPoint(NSPoint pt) {
  return sqrt(pt.x * pt.x + pt.y * pt.y);
  //return ABS(pt.x) + ABS(pt.y);
}

CGFloat AZAreaOfSize(NSSize size) {
  return size.width * size.height;
}

CGFloat AZAreaOfRect(NSR rect) {
  return AZAreaOfSize(rect.size);
}
CGFloat AZPointDistance(CGP p1, CGP p2) {
	return sqrtf(powf(p1.x - p2.x, 2.) + powf(p1.y - p2.y, 2.));
}

CGFloat AZPointAngle(CGP p1, CGP p2) {
	return atan2f(p1.x - p2.x, p1.y - p2.y);
}

CGFloat AZDistanceFromPoint (NSPoint p1,NSPoint p2) {
	return distanceFromPoint(p1, p2);
}
CGFloat distanceFromPoint (NSPoint p1, NSPoint p2) {
	CGFloat temp;
	temp = pow(p1.x - p2.x, 2);
	temp += pow(p1.y - p2.y, 2);
	return (CGFloat)sqrt(temp);
}
//
// NSPoint result functions
//
NSPoint AZOriginFromMenubarWithX(CGFloat yOffset, CGFloat xOffset) {

	NSPoint topLeft = NSMakePoint(0,[[NSScreen mainScreen]frame].size.height);
	topLeft.x += xOffset;
	topLeft.y -= yOffset;
	topLeft.y -= 22;
	return topLeft;
}

NSPoint AZPointFromSize(NSSize size) {
  return NSMakePoint(size.width, size.height);
}

NSPoint AZAbsPoint(NSPoint point) {
  return NSMakePoint(ABS(point.x), ABS(point.y));
}

NSPoint AZFloorPoint(NSPoint point) {
  return NSMakePoint(floor(point.x), floor(point.y));
}

NSPoint AZCeilPoint(NSPoint point) {
  return NSMakePoint(ceil(point.x), ceil(point.y));
}

NSPoint AZRoundPoint(NSPoint point) {
  return NSMakePoint(round(point.x), round(point.y));
}

NSPoint AZNegatePoint(NSPoint point) {
  return NSMakePoint(-point.x, -point.y);
}

NSPoint AZInvertPoint(NSPoint point) {
  return NSMakePoint(1 / point.x, 1 / point.y);
}

NSPoint AZSwapPoint(NSPoint point) {
  return NSMakePoint(point.y, point.x);
}

NSPoint AZAddPoints(NSPoint one, NSPoint another) {
  return NSMakePoint(one.x + another.x, one.y + another.y);
}

NSPoint AZSubtractPoints(NSPoint origin, NSPoint subtrahend) {
  return NSMakePoint(origin.x - subtrahend.x, origin.y - subtrahend.y);
}

NSPoint AZSumPoints(NSUInteger count, NSPoint point, ...) {
  NSPoint re = point;
  
  va_list pts;
  va_start(pts, point);
  
  for (int i = 0; i < count; i++) {
	NSPoint pt = va_arg(pts, NSPoint);
	re.x += pt.x;
	re.y += pt.y;
  }
  
  va_end(pts);
  
  return re;
}

NSPoint AZMultiplyPoint(NSPoint point, CGFloat multiplier) {
  return NSMakePoint(point.x * multiplier, point.y * multiplier);
}

NSPoint AZMultiplyPointByPoint(NSPoint one, NSPoint another) {
  return NSMakePoint(one.x * another.x, one.y * another.y);
}

NSPoint AZMultiplyPointBySize(NSPoint one, NSSize size) {
  return NSMakePoint(one.x * size.width, one.y * size.height);
}

NSPoint AZRelativeToAbsolutePoint(NSPoint relative, NSR bounds) {
  return NSMakePoint(relative.x * bounds.size.width  + bounds.origin.x,
					 relative.y * bounds.size.height + bounds.origin.y
					 );
}

NSPoint AZAbsoluteToRelativePoint(NSPoint absolute, NSR bounds) {
  return NSMakePoint((absolute.x - bounds.origin.x) / bounds.size.width, 
					 (absolute.y - bounds.origin.y) / bounds.size.height
					 );
}

NSPoint AZDividePoint(NSPoint point, CGFloat divisor) {
  return NSMakePoint(point.x / divisor, point.y / divisor);
}

NSPoint AZDividePointByPoint(NSPoint point, NSPoint divisor) {
  return NSMakePoint(point.x / divisor.x, point.y / divisor.y);
}

NSPoint AZDividePointBySize(NSPoint point, NSSize divisor) {
  return NSMakePoint(point.x / divisor.width, point.y / divisor.height);
}
NSPoint AZMovePoint(NSPoint origin, NSPoint target, CGFloat p) {
  // delta = distance fom target to origin
  NSPoint delta = AZSubtractPoints(target, origin);
  // multiply that with the relative distance
  NSPoint way   = AZMultiplyPoint(delta, p);
  // add it to the origin to move along the way
  return AZAddPoints(origin, way);
}

NSPoint AZMovePointAbs(NSPoint origin, NSPoint target, CGFloat pixels) {
  // Distance from target to origin
  NSPoint delta = AZSubtractPoints(target, origin);
  // normalize that by x to recieve the x2y-ratio
  // but wait, if x is 0 already it can not be normalized
  if (delta.x == 0) {
	// in this case check whether y is empty too
	if (delta.y == 0) {
	  // cannot move anywhere
	  return origin;
	}
	return NSMakePoint(origin.x, 
					   origin.y + pixels * (delta.y > 0 ? 1.0 : -1.0));
  }
  // now, grab the normalized way
  CGFloat ratio = delta.y / delta.x;
  CGFloat x = pixels / sqrt(1.0 + ratio * ratio);
  if (delta.x < 0) x *= -1;
  NSPoint move = NSMakePoint(x, x * ratio);
  return AZAddPoints(origin, move);
}

NSPoint AZCenterOfRect(NSR rect) {
  // simple math, just the center of the rect
  return NSMakePoint(rect.origin.x + rect.size.width  * 0.5, 
					 rect.origin.y + rect.size.height * 0.5);
}

NSPoint AZCenterOfSize(NSSize size) {
  return NSMakePoint(size.width  * 0.5, 
					 size.height * 0.5);
}

NSPoint AZEndOfRect(NSR rect) {
  return NSMakePoint(rect.origin.x + rect.size.width,
					 rect.origin.y + rect.size.height);
}
/*
 *   +-------+
 *   |	   |   
 *   |   a   |   +-------+
 *   |	   |   |	   |
 *   +-------+   |   b   |
 *			   |	   |
 *			   +-------+	*/
NSPoint AZCenterDistanceOfRects(NSR a, NSR b) {
  return AZSubtractPoints(AZCenterOfRect(a),
						  AZCenterOfRect(b));
}

NSPoint AZBorderDistanceOfRects(NSR a, NSR b) {
  // 
  // +------------ left
  // |
  // |	 +------ right  
  // v	 v
  // +-----+ <---- top
  // |	 |
  // +-----+ <---- bottom
  //
  
  // distances, always from ones part to anothers counterpart
  // a zero x or y indicated that the rects overlap in that dimension
  NSPoint re = NSZeroPoint;
  
  NSPoint oa = a.origin;
  NSPoint ea = AZEndOfRect(a);
  
  NSPoint ob = b.origin;
  NSPoint eb = AZEndOfRect(b);
  
  // calculate the x and y separately

  // left / right check
  if (ea.x < ob.x) {
	// [a] [b] --- a left of b
	// positive re.x
	re.x = ob.x - ea.x;
  } else if (oa.x > eb.x) {
	// [b] [a] --- a right of b
	// negative re.x
	re.x = eb.x - oa.x;
  }
  
  // top / bottom check
  if (ea.y < ob.y) {
	// [a] --- a above b
	// [b]
	// positive re.y
	re.y = ob.y - ea.y;
  } else if (oa.y > eb.y) {
	// [b] --- a below b
	// [a]
	// negative re.y
	re.y = eb.y - oa.y;
  }
  
  return re;
}

NSPoint AZNormalizedDistanceOfRects(NSR from, NSR to) {
  NSSize mul = AZInvertSize(AZBlendSizes(from.size, to.size, 0.5));
  NSPoint re = AZCenterDistanceOfRects(to, from);
		  re = AZMultiplyPointBySize(re, mul);

  return re;
}

NSPoint AZNormalizedDistanceToCenterOfRect(NSPoint point, NSR rect) {
  NSPoint center = AZCenterOfRect(rect);
  NSPoint half   = AZMultiplyPoint(AZPointFromSize(rect.size), 0.5);
  NSPoint re	 = AZSubtractPoints(point, center);
		  re	 = AZMultiplyPointByPoint(re, half);
  
  return re;
}

NSPoint AZPointDistanceToBorderOfRect(NSPoint point, NSR rect) {
  NSPoint re = NSZeroPoint;
  
  NSPoint o = rect.origin;
  NSPoint e = AZEndOfRect(rect);
  
  if (point.x < o.x) {
	re.x = point.x - re.x;
  } else if (point.x > e.x) {
	re.x = e.x - point.x;
  }
  
  if (point.y < o.y) {
	re.y = point.y - re.y;
  } else if (point.y > e.y) {
	re.y = e.y - point.y;
  }

  return re;
}
NSPoint AZPointFromDim(CGFloat val){
	return (NSPoint){val,val};
}
//
// NSSize functions
//


NSR AZRectBy(CGFloat boundX, CGFloat boundY)
{
	return NSMakeRect(0,0,boundX, boundY);
}

NSR AZRectFromDim(CGFloat dim) {
	return (NSR){0,0,dim,dim};
}
NSSize AZSizeFromDimension(CGFloat dim) {
	return NSMakeSize(dim, dim);
}

NSSize AZSizeFromPoint(NSPoint point) {
  return NSMakeSize(point.x, point.y);
}

NSSize AZAbsSize(NSSize size) {
  return NSMakeSize(ABS(size.width), ABS(size.height));
}

NSSize AZAddSizes(NSSize one, NSSize another) {
  return NSMakeSize(one.width + another.width, 
					one.height + another.height);
}

NSSZ AZSubtractSizes ( NSSZ size, NSSZ subtrahend ){
	return NSMakeSize( size.width - subtrahend.width,
					   size.height - subtrahend.height);

}


NSSize AZInvertSize(NSSize size) {
  return NSMakeSize(1 / size.width, 1 / size.height);
}

NSSize AZRatioOfSizes(NSSize inner, NSSize outer) {
  return NSMakeSize (inner.width / outer.width,
					inner.height / outer.height);
}

NSSize AZMultiplySize( NSSize size, CGFloat multiplier) {
  return (NSSize) { size.width * multiplier, size.height * multiplier };
}

NSSize AZMultiplySizeBySize(NSSize size, NSSize another) {
  return NSMakeSize(size.width * another.width, 
					size.height * another.height);
}

NSSize AZMultiplySizeByPoint(NSSize size, NSPoint point) {
  return NSMakeSize(size.width * point.x, 
					size.height * point.y);
}

NSSize AZBlendSizes(NSSize one, NSSize another, CGFloat p) {
  NSSize way;
  way.width  = another.width - one.width;
  way.height = another.height - one.height;
  
  return NSMakeSize(one.width + p * way.width, 
					one.height + p * way.height);
}

NSSize AZSizeMax(NSSize one, NSSize another) {
  return NSMakeSize(MAX(one.width, another.width),
					MAX(one.height, another.height));
}

NSSize AZSizeMin(NSSize one, NSSize another) {
  return NSMakeSize(MIN(one.width, another.width),
					MIN(one.height, another.height));
  
}

NSSize AZSizeBound(NSSize preferred, NSSize minSize, NSSize maxSize) {
  NSSize re = preferred;
  
  re.width  = MIN(MAX(re.width,  minSize.width),  maxSize.width);
  re.height = MIN(MAX(re.height, minSize.height), maxSize.height);
  
  return re;
}
//
// NSR result functions
//
NSR AZRectVerticallyOffsetBy(CGRect rect, CGFloat offset) {
	rect.origin.y += offset;
	return  rect;
}

NSR AZRectHorizontallyOffsetBy(CGRect rect, CGFloat offset) {
	rect.origin.x += offset;
	return  rect;
}

NSR AZFlipRectinRect(CGRect local, CGRect dest)
{
	NSPoint a = NSZeroPoint;
	a.x = dest.size.width - local.size.width;
	a.y = dest.size.height - local.size.height;
	return AZMakeRect(a,local.size);
}

NSR AZSquareFromLength(CGFloat length) {
	return  AZMakeRectFromSize(NSMakeSize(length,length));
}

NSR AZZeroHeightBelowMenu(void) {
	NSR e = AZScreenFrame();
	e.origin.y += (e.size.height - 22);
	e.size.height = 0;
	return e;
}
NSR AZMenuBarFrame(void) {
	return AZUpperEdge( AZScreenFrame(), AZMenuBarThickness());
}

CGFloat AZMenuBarThickness (void) { return [[NSStatusBar systemStatusBar] thickness]; }

NSR AZMenulessScreenRect(void) {
	NSR e = AZScreenFrame();
	e.size.height -= 22;
	return e;
}
CGFloat AZHeightUnderMenu (void) {
	return ( [[NSScreen mainScreen]frame].size.height - [[NSStatusBar systemStatusBar] thickness] );
}
NSR AZMakeRectMaxXUnderMenuBarY(CGFloat distance) {
	NSR rect = [[NSScreen mainScreen]frame];
	rect.origin = NSMakePoint(0,rect.size.height - 22 - distance);
	rect.size.height = distance;
	return rect;
}

NSR AZMakeRectFromPoint(NSPoint point) {
  return NSMakeRect(point.x, point.y, 0, 0);
}

NSR AZMakeRectFromSize(NSSize size) {
  return NSMakeRect(0, 0, size.width, size.height);
}

NSR AZMakeRect(NSPoint point, NSSize size) {
  return  nanRectCheck( NSMakeRect(point.x,	point.y, size.width, size.height));
}

NSR AZMakeSquare(NSPoint center, CGFloat radius) {
  return NSMakeRect(center.x - radius, 
					center.y - radius, 
					2 * radius, 
					2 * radius);
}
NSR AZMultiplyRectBySize(NSR rect, NSSize size) {
  return NSMakeRect(rect.origin.x	* size.width,
					rect.origin.y	* size.height,
					rect.size.width  * size.width,
					rect.size.height * size.height
					);
}

NSR AZRelativeToAbsoluteRect(NSR relative, NSR bounds) {
  return NSMakeRect(relative.origin.x	* bounds.size.width  + bounds.origin.x,
					relative.origin.y	* bounds.size.height + bounds.origin.y,
					relative.size.width  * bounds.size.width,
					relative.size.height * bounds.size.height
					);
}

NSR AZAbsoluteToRelativeRect(NSR a, NSR b) {
  return NSMakeRect((a.origin.x - b.origin.x) / b.size.width,
					(a.origin.y - b.origin.y) / b.size.height,
					a.size.width  / b.size.width,
					a.size.height / b.size.height
					);
}
NSR AZPositionRectOnRect(NSR inner, NSR outer, NSPoint position) {
  return NSMakeRect(outer.origin.x 
					+ (outer.size.width - inner.size.width) * position.x, 
					outer.origin.y 
					+ (outer.size.height - inner.size.height) * position.y, 
					inner.size.width, 
					inner.size.height
					);
}

NSR AZCenterRectOnPoint(NSR rect, NSPoint center) {
  return NSMakeRect(center.x - rect.size.width  / 2, 
					center.y - rect.size.height / 2, 
					rect.size.width, 
					rect.size.height);
}

NSR AZCenterRectOnRect(NSR inner, NSR outer) {
  return AZPositionRectOnRect(inner, outer, AZHalfPoint);
}

NSR AZSquareAround(NSPoint center, CGFloat distance) {
  return NSMakeRect(center.x - distance, 
					center.y - distance, 
					2 * distance, 
					2 * distance
					);
}

NSR AZBlendRects(NSR from, NSR to, CGFloat p) {
  NSR re;

  CGFloat q = 1 - p;
  re.origin.x	= from.origin.x	* q + to.origin.x	* p;
  re.origin.y	= from.origin.y	* q + to.origin.y	* p;
  re.size.width  = from.size.width  * q + to.size.width  * p;
  re.size.height = from.size.height * q + to.size.height * p;

  return re;
}

NSR AZRectTrimmedOnRight(NSR rect, CGFloat width) {
	return NSMakeRect(	rect.origin.x, 					rect.origin.y,
					  	rect.size.width - width,  		rect.size.height	);
}

NSR AZRectTrimmedOnBottom(NSR rect, CGFloat height) {
	return NSMakeRect(	rect.origin.x, 					(rect.origin.y + height),
						rect.size.width,  				(rect.size.height - height)	);
}
NSR AZRectTrimmedOnLeft(NSR rect, CGFloat width) {
	return NSMakeRect( 	rect.origin.x + width, 					rect.origin.y,
						rect.size.width - width,  		rect.size.height	);
}
NSR AZRectTrimmedOnTop(NSR rect, CGFloat height) {
	return NSMakeRect(	rect.origin.x, 					rect.origin.y,
						rect.size.width,  				(rect.size.height - height)	);
}

NSSZ AZSizeExceptWide  ( NSSZ sz, CGF wide ) {	return NSMakeSize(wide, sz.height); }
NSSZ AZSizeExceptHigh  ( NSSZ sz, CGF high ) {  return NSMakeSize(sz.width, high);  }


NSR AZRectExtendedOnLeft(NSR rect, CGFloat amount) {
	NSR newRect = rect;
	rect.origin.x -= amount;
	rect.size.width += amount;
	return newRect;
}
NSR AZRectExtendedOnBottom(NSR rect, CGFloat amount) {
	NSR newRect = rect;
	rect.origin.x -= amount;
	rect.size.height += amount;
	return newRect;
}
NSR AZRectExtendedOnTop(NSR rect, CGFloat amount) {
	NSR newRect = rect;
	rect.size.height += amount;
	return newRect;
}
NSR AZRectExtendedOnRight(NSR rect, CGFloat amount) {
	NSR newRect = rect;
	rect.size.width += amount;
	return newRect;
}

NSR AZRectExceptWide(NSR rect, CGFloat wide) {
	return NSMakeRect(	rect.origin.x, 	rect.origin.y, wide, rect.size.height);
}

NSR AZRectExceptHigh(NSR rect, CGFloat high){
	return NSMakeRect(rect.origin.x, 	rect.origin.y, rect.size.width, high);
}

NSR AZRectExceptOriginX(NSR rect, CGFloat x)
{
	return NSMakeRect ( x, rect.origin.y, rect.size.width, rect.size.height);
}
NSR AZRectExceptOriginY(NSR rect, CGFloat y)
{
	return NSMakeRect(rect.origin.x, y, rect.size.width, rect.size.height);
}

NSR AZInsetRect(NSR rect, CGFloat inset){
	return NSInsetRect(rect, inset,inset);
}

NSR AZLeftEdge(NSR rect, CGFloat width) {
  return NSMakeRect(rect.origin.x, 
					rect.origin.y, 
					width, 
					rect.size.height);
}

NSR AZRightEdge(NSR rect, CGFloat width) {
  return NSMakeRect(rect.origin.x + rect.size.width - width, 
					rect.origin.y, 
					width, 
					rect.size.height);
}

NSR AZLowerEdge(NSR rect, CGFloat height) {
  return NSMakeRect(rect.origin.x, 
					rect.origin.y, 
					rect.size.width, 
					height);
}

NSR AZUpperEdge(NSR rect, CGFloat height) {
  return NSMakeRect(rect.origin.x, 
					rect.origin.y + rect.size.height - height, 
					rect.size.width, 
					height);
}


NSR AZRectFlippedOnEdge(NSRect r, AZPOS position) {
	return  position == AZPositionTop 		? 	AZRectExceptOriginY(r, r.size.height)
	:		position == AZPositionRight		?	AZRectExceptOriginX(r, r.size.width )
	:		position == AZPositionBottom	?	AZRectExceptOriginY(r, -r.size.height)
	:											AZRectExceptOriginX(r, -r.size.width );
}


NSR AZRectOutsideRectOnEdge(NSRect center, NSRect outer, AZPOS position) {
	return  position == AZPositionTop 		? 	AZRectExceptOriginY(outer, center.size.height)
	:		position == AZPositionRight		?	AZRectExceptOriginX(outer, center.size.width )
	:		position == AZPositionBottom	?	AZRectExceptOriginY(outer, -outer.size.height)
	:											AZRectExceptOriginX(outer, -outer.size.width );
}


FOUNDATION_EXPORT BOOL  AZPointIsInInsetRects    ( NSP point, NSRect outside, NSSZ inset ) {
	AZInsetRects e =  AZMakeInsideRects(outside, inset);
	return  NSPointInRect(point, e.top) 	?:
			NSPointInRect(point, e.right) 	?:
			NSPointInRect(point, e.bottom) 	?:
			NSPointInRect(point, e.left) 	?:	NO;
}

//AZPOS AZPositionOnOutsideEdgeOfRect(NSP point, NSRect rect, NSSZ size) {
AZPOS AZPosOfPointInInsetRects ( NSP point, NSRect outside, NSSZ inset ) {
	AZInsetRects e =  AZMakeInsideRects(outside, inset);
	return  NSPointInRect(point, e.top) 	? AZPositionTop	 	:
			NSPointInRect(point, e.right) 	? AZPositionRight  	:
			NSPointInRect(point, e.bottom) 	? AZPositionBottom 	:
			NSPointInRect(point, e.left) 	? AZPositionLeft 	:	AZPositionAutomatic;
}

NSR AZInsetRectInPosition ( NSRect outside, NSSZ inset, AZPOS pos ) {
	BOOL scaleX = pos ==  AZPositionBottom || pos == AZPositionTop ? NO: YES;
	CGR  scaled = scaleX ? AZRectExceptWide(outside, inset.width)
						 : AZRectExceptHigh(outside, inset.height);
	scaled.origin.y += pos == AZPositionTop   ? outside.size.height - inset.height : 0;
	scaled.origin.x += pos == AZPositionRight ? outside.size.width  - inset.width : 0;
	return scaled;
}

//AZOutsideEdges AZOutsideEdgesSized(NSRect rect, NSSZ size) {
//
//		return (AZOutsideEdges) { AZUpperEdge(rect, size.height),
//								  AZRightEdge(rect, size.width ),
//								  AZLowerEdge(rect, size.height),
//								  AZLeftEdge (rect, size.width ) 	};
//}

//
// Comparison Methods
//

BOOL AZIsPointLeftOfRect(NSPoint point, NSR rect) {
  return AZPointDistanceToBorderOfRect(point, rect).x < 0;
}

BOOL AZIsPointRightOfRect(NSPoint point, NSR rect) {
  return AZPointDistanceToBorderOfRect(point, rect).x > 0;
}

BOOL AZIsPointAboveRect(NSPoint point, NSR rect) {
  return AZPointDistanceToBorderOfRect(point, rect).y < 0;
}

BOOL AZIsPointBelowRect(NSPoint point, NSR rect) {
  return AZPointDistanceToBorderOfRect(point, rect).y > 0;
}

BOOL AZIsRectLeftOfRect(NSR rect, NSR compare) {
  return AZNormalizedDistanceOfRects(rect, compare).x <= -1;
}

BOOL AZIsRectRightOfRect(NSR rect, NSR compare) {
  return AZNormalizedDistanceOfRects(rect, compare).x >= 1;
}

BOOL AZIsRectAboveRect(NSR rect, NSR compare) {
  return AZNormalizedDistanceOfRects(rect, compare).y <= -1;
}

BOOL AZIsRectBelowRect(NSR rect, NSR compare) {
  return AZNormalizedDistanceOfRects(rect, compare).y >= 1;
}

//
// EOF
//

#import "math.h"

//BTFloatRange BTMakeFloatRange(float value,float location,float length){
//	BTFloatRange fRange;
//	fRange.value=value;
//	fRange.location=location;
//	fRange.length=length;
//	return fRange;
//}
//float BTFloatRangeMod(BTFloatRange range){
//	return fmod(range.value-range.location,range.length)+range.location;
//}
//
//float BTFloatRangeUnit(BTFloatRange range){
//	return (range.value-range.location)/range.length;
//}

NSPoint AZOffsetPoint(NSPoint fromPoint, NSPoint toPoint){
	return NSMakePoint(toPoint.x-fromPoint.x,toPoint.y-fromPoint.y);
}
/*
int oppositeQuadrant(int quadrant){
	quadrant=quadrant+2;
	quadrant%=4;
	if (!quadrant)quadrant=4;
	return quadrant;
}
*/

NSRect AZOffsetRect(NSR rect, NSP offset)
{
	rect.origin.x += offset.x;
	rect.origin.y += offset.y;
	return rect;
}

NSPoint AZOffsetOfRects(NSR innerRect,NSR outerRect){ //, QUAD quadrant){
//	if (quadrant )
//		return NSMakePoint((quadrant == 2 || quadrant == 1) ? NSMaxX(outerRect)-NSMaxX(innerRect) : NSMinX(outerRect)-NSMinX(innerRect),
//						   (quadrant == 3 || quadrant == 2) ? NSMaxY(outerRect)-NSMaxY(innerRect) : NSMinY(outerRect)-NSMinY(innerRect));
	return NSMakePoint( NSMidX(outerRect)-NSMidX(innerRect), NSMidY(outerRect)-NSMidY(innerRect) ); //Center Rects
}

int oppositeQuadrant(int quadrant){
	quadrant = quadrant + 2;
	quadrant%=3;
	return !quadrant ? 3 : quadrant;
}

//NSR sectionPositioned(NSR r, AZPOS p){
//
//	NSUInteger quad 	= 	p == AZPositionBottomLeft 	? 0
//						:	p == AZPositionLeft 		? 1
//						:	p == AZPositionTopRight 		? 2
//						:	p == AZPositionBottomRight 	? 3 : 3;
//
//	return quadrant(r, (NSUInteger)quadrant);
//}

NSR AZRectOfQuadInRect(NSR originalRect, AZQuadrant quad) { return quadrant(originalRect, quad); }

NSR quadrant(NSR r, AZQuadrant quad)
{
	NSSZ half = AZMultiplySize(r.size, .5);
	NSR newR  = AZRectBy(half.width, half.height);
	NSP p 	  = quad == AZTopLeftQuad  ? (NSP) { 0, 			 half.height }
			  : quad == AZTopRightQuad ? (NSP) { half.width, half.height }
			  : quad == AZBotRightQuad ? (NSP) { half.width,           0 }
			  :	NSZeroPoint;
			 
	return AZOffsetRect(newR, p);
}

CGFloat quadrantsVerticalGutter(NSR r)
{
	NSR aQ = quadrant(r, 1);
	return NSWidth(r) - (NSWidth(aQ) *2);
}

CGFloat quadrantsHorizontalGutter(NSR r)
{
	NSR aQ = quadrant(r, 1);
	return NSHeight(r) - (NSHeight(aQ) *2);
}


//NSR alignRectInRect(NSR innerRect, NSR outerRect, int quadrant)
//{
////	NSPoint offset= AZRectOffset(innerRect,outerRect,quadrant);
//	return NSOffsetRect(innerRect,offset.x,offset.y);
//}


NSR rectZoom(NSR rect,float zoom,int quadrant){
	NSSize newSize=NSMakeSize(NSWidth(rect)*zoom,NSHeight(rect)*zoom);
	NSR newRect=rect;
	newRect.size=newSize;
	return newRect;
}
NSR AZSizeRectInRect(NSR innerRect,NSR outerRect,bool expand){
	float proportion=NSWidth(innerRect)/NSHeight(innerRect);
	NSR xRect=NSMakeRect(0,0,outerRect.size.width,outerRect.size.width/proportion);
	NSR yRect=NSMakeRect(0,0,outerRect.size.height*proportion,outerRect.size.height);
	NSR newRect;
	if (expand) newRect = NSUnionRect(xRect,yRect);
	else newRect = NSIntersectionRect(xRect,yRect);
	return newRect;
}

NSR AZFitRectInRect(NSR innerRect,NSR outerRect,bool expand){
	return AZCenterRectInRect(AZSizeRectInRect(innerRect,outerRect,expand),outerRect);
}
/*
NSR rectWithProportion(NSR innerRect,float proportion,bool expand){
	NSR xRect=NSMakeRect(0,0,innerRect.size.width,innerRect.size.width/proportion);
	NSR yRect=NSMakeRect(0,0,innerRect.size.height*proportion,innerRect.size.height);
	NSR newRect;
	if (expand) newRect = NSUnionRect(xRect,yRect);
	else newRect = NSIntersectionRect(xRect,yRect);
	return newRect;
}
*/

NSR AZSquareInRect(NSR rect) {
	return AZCenterRectInRect(AZSquareFromLength(AZMinDim(rect.size)), rect);
}

NSR AZCenterRectInRect(NSR rect, NSR mainRect){
	return NSOffsetRect(rect,NSMidX(mainRect)-NSMidX(rect),NSMidY(mainRect)-NSMidY(rect));
}

NSR AZConstrainRectToRect(NSR innerRect, NSR outerRect){
	NSPoint offset=NSZeroPoint;
	if (NSMaxX(innerRect) > NSMaxX(outerRect))
		offset.x+= NSMaxX(outerRect) - NSMaxX(innerRect);
	if (NSMaxY(innerRect) > NSMaxY(outerRect))
		offset.y+= NSMaxY(outerRect) - NSMaxY(innerRect);
	if (NSMinX(innerRect) < NSMinX(outerRect))
		offset.x+= NSMinX(outerRect) - NSMinX(innerRect);
	if (NSMinY(innerRect) < NSMinY(outerRect))
		offset.y+= NSMinY(outerRect) - NSMinY(innerRect);
	return NSOffsetRect(innerRect,offset.x,offset.y);
}
/*
NSR expelRectFromRect(NSR innerRect, NSR outerRect,float peek){
	NSPoint offset=NSZeroPoint;
	
	float leftDistance=NSMaxX(innerRect) - NSMinX(outerRect);
	float rightDistance=NSMaxX(outerRect)-NSMinX(innerRect);
	float topDistance=NSMaxY(outerRect)-NSMinY(innerRect);
	float bottomDistance=NSMaxY(innerRect) - NSMinY(outerRect);
	float minDistance=MIN(MIN(MIN(leftDistance,rightDistance),topDistance),bottomDistance);
	
	if (minDistance==leftDistance)
		offset.x-=leftDistance-peek;
	else if (minDistance==rightDistance)
		offset.x+=rightDistance-peek;
	else if (minDistance==topDistance)
		offset.y+=topDistance-peek;
	else if (minDistance==bottomDistance)
		offset.y-=bottomDistance-peek;
	
	return NSOffsetRect(innerRect,offset.x,offset.y);
}

NSR expelRectFromRectOnEdge(NSR innerRect, NSR outerRect,NSREdge edge,float peek){
	NSPoint offset=NSZeroPoint;
	
	switch(edge){
		case NSMaxXEdge:
			
			offset.x+=NSMaxX(outerRect)-NSMinX(innerRect)-peek;
			break;
		case NSMinXEdge:
			offset.x-=NSMaxX(innerRect) - NSMinX(outerRect) - peek;
			break;
		case NSMaxYEdge:
			offset.y+=NSMaxY(outerRect)-NSMinY(innerRect)-peek;
			break;
		case NSMinYEdge:
			offset.y-=NSMaxY(innerRect) - NSMinY(outerRect)-peek;
			break;
	}

	return NSOffsetRect(innerRect,offset.x,offset.y);
}
*/
CGRectEdge AZEdgeTouchingEdgeForRectInRect( NSR innerRect, NSR outerRect ){
	
	return 	NSMaxX(innerRect)  >= NSMaxX(outerRect) ? NSMaxXEdge :
			NSMinX(innerRect)  <= NSMinX(outerRect) ? NSMinXEdge :
			NSMaxY(innerRect)  >= NSMaxY(outerRect) ? NSMaxYEdge :
			NSMinY(innerRect)  <= NSMinY(outerRect) ? NSMinYEdge : -1;
}

NSR AZRectFromSize(NSSize size){
	return NSMakeRect(0,0,size.width,size.height);
}

static float AZDistanceFromOrigin(NSPoint point){
	return hypot(point.x, point.y);
}

NSP AZTopLeftPoint  ( NSR rect ){	 return (NSP){rect.origin.x,rect.origin.y+NSHeight(rect)}; }
NSP AZTopRightPoint( NSR rect ){ return (NSP){NSWidth(rect)  + rect.origin.x, NSHeight(rect) + rect.origin.y}; }
NSP AZBotLeftPoint  ( NSR rect ){ return rect.origin; }
NSP AZBotRightPoint ( NSR rect ){ return (NSP){rect.origin.x + NSWidth(rect), rect.origin.y}; }

//AZPOS AZClosestCorner(NSR innerRect,NSR outerRect){
//	CGF bl, br, tl, tr;
//	NSP blP, brP, tlP, trP;		float distance = AZDistanceFromOrigin(rectOffset(innerRect,outerRect,i));
//		if (distance < bestDistance || bestDistance<0){
//			bestDistance=distance;
//			closestCorner=i;
//		}
//	}
//	return closestCorner;
//}

 
void logRect(NSR rect){
	LOG_EXPR(rect);
//QSLog(@"(%f,%f) (%fx%f)",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
}


AZOrient deltaDirectionOfPoints(NSPoint a, NSPoint b){

	return a.x != b.x ? AZOrientHorizontal : AZOrientVertical;
}

AZPOS AZPositionOfRectInRect(NSR rect, NSR outer ) {

	return NSEqualPoints( rect.origin, outer.origin) 			? AZPositionBottomLeft 	:
		   NSEqualPoints( AZTopLeftPoint(rect), AZTopLeftPoint(outer)) ||
		   (rect.origin.x == outer.origin.x && (rect.origin.y +NSHeight(rect) ) == NSHeight(outer))
		   	? AZPositionTopLeft		:
		   NSEqualPoints( AZTopRightPoint(rect), AZTopRightPoint(outer))	? AZPositionTopRight	:
		   NSEqualPoints( AZBotRightPoint(rect), AZBotRightPoint(outer))	? AZPositionBottomRight :
		  ^{ return AZOutsideEdgeOfRectInRect(rect, outer); }();
}

AZPOS AZPositionOfRectPinnedToOutisdeOfRect(NSR box, NSR innerBox  )
{
	NSR tIn  = AZRectFromSize(innerBox.size);
	box.origin.y -= innerBox.origin.y;
	box.origin.x -= innerBox.origin.x;
	NSLog(@"Testing attached: %@.. inner: %@", AZStringFromRect(box), AZStringFromRect(tIn));
	AZPOS winner; NSSZ bS, iS; bS = box.size; iS = tIn.size;
	winner = box.origin.x == -bS.width		? AZPositionRight
		   : box.origin.y == iS.height	  	? AZPositionBottom
		   : box.origin.x == iS.width		? AZPositionLeft
		   : box.origin.y == 0	  		? AZPositionTop : 97;
	// + bS.width == innerBox.origin.x	 	? AZPositionLeft
//		   : box.origin.y  == innerBox.origin.y + iS.height	  	? AZPositionBottom
//		   : box.origin.x  == innerBox.origin.y + iS.width		? AZPositionRight
//		   : box.origin.y + bS.height == innerBox.origin.y		? AZPositionTop : 97;
	return winner;// AZPositionTop : winner;
}


//	  , outer.origin) 			? AZPositionBottomLeft 	:
//	NSEqualPoints( AZTopLeft(rect), AZTopLeft(outer)) ||
//	(rect.origin.x == outer.origin.x && (rect.origin.y +NSHeight(rect) ) == NSHeight(outer))
//	? AZPositionTopLeft		:
//	NSEqualPoints( AZTopRightPoint(rect), AZTopRightPoint(outer))	? AZPositionTopRight	:
//	NSEqualPoints( AZBotRightPoint(rect), AZBotRightPoint(outer))	? AZPositionBottomRight :
//	^{ return AZOutsideEdgeOfRectInRect(rect, outer); }();



AZPOS AZOutsideEdgeOfRectInRect (NSR rect, NSR outer ) {
	NSPoint myCenter = AZCenterOfRect(rect);
	CGF test;
	AZPOS winner;
	CGF minDist = AZMaxDim(outer.size);

	test = AZDistanceFromPoint( myCenter, (NSPoint) { outer.origin.x, myCenter.y }); //testleft
	if  ( test < minDist) { 	minDist = test; winner = AZPositionLeft;}

	test = AZDistanceFromPoint( myCenter, (NSPoint) { myCenter.x,  0 }); //testbottom  OK
	if  ( test < minDist) { 	minDist = test; winner = AZPositionBottom; }

	test = AZDistanceFromPoint( myCenter, (NSPoint) {NSWidth(outer), myCenter.y }); //testright
	if  ( test < minDist) { 	minDist = test; winner = AZPositionRight; }

	test = AZDistanceFromPoint( myCenter, (NSPoint) { myCenter.x, NSHeight(outer) }); //testright
	if  ( test < minDist) { 	minDist = test; winner = AZPositionTop; }

	return  winner;
}

NSSize AZDirectionsOffScreenWithPosition(NSR rect, AZPOS position )
{
	CGFloat deltaX = position == AZPositionLeft 	?  -NSMaxX(rect)
	: position == AZPositionRight 	? 	NSMaxX(rect)	: 0;
	CGFloat deltaY = position == AZPositionTop 		?  NSMaxY(rect)
	: position == AZPositionBottom 	? -NSMaxY(rect)		: 0;

	return (NSSize){deltaX,deltaY};
}





// this point constant is arbitrary but it is intended to be very unlikely to arise by chance. It can be used to signal "not found" when
// returning a point value from a function.

const NSPoint		NSNotFoundPoint = {-10000000.2,-999999.6};


///*********************************************************************************************************************
///
/// function:		NSRectFromTwoPoints( a, b )
/// scope:			global
/// description:	forms a rectangle from any two corner points
/// 
/// parameters:		<a, b> a pair of points
/// result:			the rectangle formed by a and b at the opposite corners
///
/// notes:			the rect is normalised, in that the relative positions of a and b do not affect the result - the
///					rect always extends in the positive x and y directions.
///
///********************************************************************************************************************

NSRect NSRectFromTwoPoints( const NSPoint a, const NSPoint b)
{
	NSRect  r;
	
	r.size.width = ABS( b.x - a.x );
	r.size.height = ABS( b.y - a.y );
	
	r.origin.x = MIN( a.x, b.x );
	r.origin.y = MIN( a.y, b.y );

	return r;
}


///*********************************************************************************************************************
///
/// function:		NSRectCentredOnPoint( p, size )
/// scope:			global
/// description:	forms a rectangle of the given size centred on p
/// 
/// parameters:		<p> a point
///					<size> the rect size
/// result:			the rectangle
///
/// notes:			
///
///********************************************************************************************************************

NSRect				NSRectCentredOnPoint( const NSPoint p, const NSSize size )
{
	NSRect r;
	
	r.size = size;
	r.origin.x = p.x - (size.width * 0.5f);
	r.origin.y = p.y - (size.height * 0.5f);

	return r;
}


///*********************************************************************************************************************
///
/// function:		UnionOfTwoRects( a, b )
/// scope:			global
/// description:	returns the smallest rect that encloses both a and b
/// 
/// parameters:		<a, b> a pair of rects
/// result:			the rectangle that encloses a and b
///
/// notes:			unlike NSUnionRect, this is practical when either or both of the input rects have a zero
///					width or height. For convenience, if either a or b is EXACTLY NSZeroRect, the other rect is
///					returned, but in all other cases it correctly forms the union. While NSUnionRect might be
///					considered mathematically correct, since a rect of zero width or height cannot "contain" anything
///					in the set sense, what's more practically required for real geometry is to allow infinitely thin
///					lines and points to push out the "envelope" of the rectangular space they define. That's what this does.
///
///********************************************************************************************************************

NSRect				UnionOfTwoRects( const NSRect a, const NSRect b )
{
	if ( NSEqualRects( a, NSZeroRect ))
		return b;
	else if ( NSEqualRects( b, NSZeroRect ))
		return a;
	else
	{
		NSPoint tl, br;
		
		tl.x = MIN( NSMinX( a ), NSMinX( b ));
		tl.y = MIN( NSMinY( a ), NSMinY( b ));
		br.x = MAX( NSMaxX( a ), NSMaxX( b ));
		br.y = MAX( NSMaxY( a ), NSMaxY( b ));
		
		return NSRectFromTwoPoints( tl, br );
	}
}



///*********************************************************************************************************************
///
/// function:		UnionOfRectsInSet( aSet )
/// scope:			global
/// description:	returns the smallest rect that encloses all rects in the set
/// 
/// parameters:		<aSet> a set of NSValues containing rect values
/// result:			the rectangle that encloses all rects
///
/// notes:			
///
///********************************************************************************************************************

NSRect				UnionOfRectsInSet( const NSSet* aSet )
{
	NSEnumerator*	iter = [aSet objectEnumerator];
	NSValue*		val;
	NSRect			ur = NSZeroRect;
	
	while(( val = [iter nextObject]))
		ur = UnionOfTwoRects( ur, [val rectValue]);
	
	return ur;
}



///*********************************************************************************************************************
///
/// function:		DifferenceOfTwoRects( a, b )
/// scope:			global
/// description:	returns the area that is different between two input rects, as a list of rects
/// 
/// parameters:		<a, b> a pair of rects
/// result:			an array of rect NSValues
///
/// notes:			this can be used to optimize upates. If a and b are "before and after" rects of a visual change,
///					the resulting list is the area to update assuming that nothing changed in the common area,
///					which is frequently so. If a and b are equal, the result is empty. If a and b do not intersect,
///					the result contains a and b.
///
///********************************************************************************************************************

NSSet*			DifferenceOfTwoRects( const NSRect a, const NSRect b )
{
	NSMutableSet* result = [NSMutableSet set];
	
	// if a == b, there is no difference, so return the empty set
	
	if( ! NSEqualRects( a, b ))
	{
		NSRect ir = NSIntersectionRect( a, b );
		
		if( NSEqualRects( ir, NSZeroRect ))
		{
			// no intersection, so result is the two input rects
			
			[result addObject:[NSValue valueWithRect:a]];
			[result addObject:[NSValue valueWithRect:b]];
		}
		else
		{
			// a and b do intersect, so collect all the pieces by subtracting <ir> from each
			
			[result unionSet:SubtractTwoRects( a, ir )];
			[result unionSet:SubtractTwoRects( b, ir )];
		}
	}

	return result;
}


NSSet*				SubtractTwoRects( const NSRect a, const NSRect b )
{
	// subtracts <b> from <a>, returning the pieces left over. If a and b don't intersect the result is correct
	// but unnecessary, so the caller should test for intersection first.

	NSMutableSet* result = [NSMutableSet set];
	
	CGFloat rml, lmr, upb, lwt, mny, mxy;
	
	rml = MAX( NSMaxX( b ), NSMinX( a ));
	lmr = MIN( NSMinX( b ), NSMaxX( a ));
	upb = MAX( NSMaxY( b ), NSMinY( a ));
	lwt = MIN( NSMinY( b ), NSMaxY( a ));
	mny = MIN( NSMaxY( a ), NSMaxY( b ));
	mxy = MAX( NSMinY( a ), NSMinY( b ));
	
	NSRect		rr, rl, rt, rb;
	
	rr = NSMakeRect( rml, mxy, NSMaxX( a ) - rml, mny - mxy );
	rl = NSMakeRect( NSMinX( a ), mxy, lmr - NSMinX( a ), mny - mxy );
	rt = NSMakeRect( NSMinX( a ), upb, NSWidth( a ), NSMaxY( a ) - upb );
	rb = NSMakeRect( NSMinX( a ), NSMinY( a ), NSWidth( a ), lwt - NSMinY( a ));
	
	// add any non empty rects to the result
	
	if ( rr.size.width > 0 && rr.size.height > 0 )
		[result addObject:[NSValue valueWithRect:rr]];
		
	if ( rl.size.width > 0 && rl.size.height > 0 )
		[result addObject:[NSValue valueWithRect:rl]];
		
	if ( rt.size.width > 0 && rt.size.height > 0 )
		[result addObject:[NSValue valueWithRect:rt]];
		
	if ( rb.size.width > 0 && rb.size.height > 0 )
		[result addObject:[NSValue valueWithRect:rb]];

	return result;
}


BOOL		AreSimilarRects( const NSRect a, const NSRect b, const CGFloat epsilon )
{
	// return YES if the rects a and b are within <epsilon> of each other.
	
	if ( ABS( a.origin.x - b.origin.x ) > epsilon )
		return NO;
		
	if( ABS( a.origin.y - b.origin.y ) > epsilon )
		return NO;
		
	if( ABS( a.size.width - b.size.width ) > epsilon )
		return NO;
		
	if( ABS( a.size.height - b.size.height ) > epsilon )
		return NO;
	
	return YES;
}


#pragma mark -
/// return the distance that <inPoint> is from a line defined by two points a and b

CGFloat		PointFromLine( const NSPoint inPoint, const NSPoint a, const NSPoint b )
{
	NSPoint cp = NearestPointOnLine( inPoint, a, b );
	
	return hypotf(( inPoint.x - cp.x ), ( inPoint.y - cp.y ));
}


/// return the distance of <inPoint> from a line segment drawn from a to b.

NSPoint		NearestPointOnLine( const NSPoint inPoint, const NSPoint a, const NSPoint b )
{
	CGFloat mag = hypotf(( b.x - a.x ), ( b.y - a.y ));
	
	if( mag > 0.0 )
	{
		CGFloat u = ((( inPoint.x - a.x ) * ( b.x - a.x )) + (( inPoint.y - a.y ) * ( b.y - a.y ))) / ( mag * mag );
		
		if( u <= 0.0 )
			return a;
		else if ( u >= 1.0 )
			return b;
		else
		{
			NSPoint cp;
		
			cp.x = a.x + u * ( b.x - a.x );
			cp.y = a.y + u * ( b.y - a.y );
		
			return cp;
		}
	}
	else
		return a;
}


NSInteger			PointInLineSegment( const NSPoint inPoint, const NSPoint a, const NSPoint b )
{
	// returns 0 if <inPoint> falls within the region defined by the line segment a-b, -1 if it's beyond the point a, 1 if beyond b. The "region" is an
	// infinite plane defined by all possible lines parallel to a-b.
	
	CGFloat mag = hypotf(( b.x - a.x ), ( b.y - a.y ));
	
	if( mag > 0.0 )
	{
		CGFloat u = ((( inPoint.x - a.x ) * ( b.x - a.x )) + (( inPoint.y - a.y ) * ( b.y - a.y ))) / ( mag * mag );
		return ( u >= 0 && u <= 1.0 )? 0 : ( u < 0 )? -1 : 1;
	}
	else
		return -1;
}


/// given a point on a line a,b, returns the relative distance of the point from 0..1 along the line.

CGFloat		RelPoint( const NSPoint inPoint, const NSPoint a, const NSPoint b )
{
	CGFloat d1, d2;
	
	d1 = LineLength( a, inPoint );
	d2 = LineLength( a, b );
	
	if( d2 != 0.0 )
		return d1/d2;
	else
		return 0.0;
}


#pragma mark -
/// return a point halfway along a line defined by two points

NSPoint		BisectLine( const NSPoint a, const NSPoint b )
{
	NSPoint p;
	
	p.x = ( a.x + b.x ) * 0.5f;
	p.y = ( a.y + b.y ) * 0.5f;
	return p;
}


/// return a point at some proportion of a line defined by two points. <proportion> goes from 0 to 1.

NSPoint		Interpolate( const NSPoint a, const NSPoint b, const CGFloat proportion )
{
	NSPoint p;
	
	p.x = a.x + ((b.x - a.x) * proportion);
	p.y = a.y + ((b.y - a.y) * proportion);
	return p;
}


CGFloat		LineLength( const NSPoint a, const NSPoint b )
{
	return hypotf( b.x - a.x, b.y - a.y );
}


#pragma mark -
CGFloat		SquaredLength( const NSPoint p )
{
	return( p.x * p.x) + ( p.y * p.y );
}


NSPoint		DiffPoint( const NSPoint a, const NSPoint b )
{
	// returns the difference of two points
	
	NSPoint c;
	
	c.x = a.x - b.x;
	c.y = a.y - b.y;
	
	return c;
}


CGFloat		DiffPointSquaredLength( const NSPoint a, const NSPoint b )
{
	// returns the square of the distance between two points
	
	return SquaredLength( DiffPoint( a, b ));
}


NSPoint		SumPoint( const NSPoint a, const NSPoint b )
{
	// returns the sum of two points
	
	NSPoint pn;
	
	pn.x = a.x + b.x;
	pn.y = a.y + b.y;
	
	return pn;
}


#pragma mark -
NSPoint		EndPoint( NSPoint origin, CGFloat angle, CGFloat length )
{
	// returns the end point of a line given its origin, length and angle relative to x axis
	
	NSPoint		ep;
	
	ep.x = origin.x + ( cosf( angle ) * length );
	ep.y = origin.y + ( sinf( angle ) * length );
	return ep;
}


CGFloat		Slope( const NSPoint a, const NSPoint b )
{
	// returns the slope of a line given its end points, in radians
	
	return atan2f( b.y - a.y, b.x - a.x );
}


CGFloat		AngleBetween( const NSPoint a, const NSPoint b, const NSPoint c )
{
	// returns the angle formed between three points abc where b is the vertex.
	
	return Slope( a, b ) - Slope( b, c );
}


CGFloat		DotProduct( const NSPoint a, const NSPoint b )
{
	return (a.x * b.x) + (a.y * b.y);
}


NSPoint		Intersection( const NSPoint aa, const NSPoint ab, const NSPoint ba, const NSPoint bb )
{
	// return the intersecting point of two lines a and b, whose end points are passed in. If the lines are parallel,
	// the result is undefined (NaN)
	
	NSPoint		i;
	CGFloat		sa, sb, ca, cb;
	
	sa = Slope( aa, ab );
	sb = Slope( ba, bb );
	
	ca = aa.y - sa * aa.x;
	cb = ba.y - sb * ba.x;
	
	i.x = ( cb - ca ) / ( sa - sb );
	i.y = sa * i.x + ca;
	
	return i;
}


NSPoint		Intersection2( const NSPoint p1, const NSPoint p2, const NSPoint p3, const NSPoint p4 )
{
	// return the intersecting point of two lines SEGMENTS p1-p2 and p3-p4, whose end points are passed in. If the lines are parallel,
	// the result is NSNotFoundPoint. Uses an alternative algorithm from Intersection() - this is faster and more usable. This only returns a
	// point if the two segments actually intersect - it doesn't project the lines.
	
	CGFloat d = (p4.y - p3.y)*(p2.x - p1.x) - (p4.x - p3.x)*(p2.y-p1.y);
	
	// if d is 0, then lines are parallel and don't intersect
	
	if ( d == 0.0 )
		return NSNotFoundPoint;
		
	CGFloat ua = ((p4.x - p3.x)*(p1.y - p3.y) - (p4.y - p3.y)*(p1.x - p3.x))/d;
	//float ub = ((p2.x - p1.x)*(p1.y - p3.y) - (p2.y - p1.y)*(p1.x - p3.x))/d;
	
	if( ua >= 0.0 && ua <= 1.0 )
	{
		// segments do intersect
	
		NSPoint ip;
	
		ip.x = p1.x + ua*(p2.x - p1.x);
		ip.y = p1.y + ua*(p2.y - p1.y);
	
		return ip;
	}
	else
		return NSNotFoundPoint;
}


#pragma mark -
NSRect		CentreRectOnPoint( const NSRect inRect, const NSPoint p )
{
	// relocates the rect so its centre is at p. Does not change the rect's size
	
	NSRect r = inRect;
	
	r.origin.x = p.x - ( inRect.size.width * 0.5f );
	r.origin.y = p.y - ( inRect.size.height * 0.5f );
	return r;
}


NSPoint		MapPointFromRect( const NSPoint p, const NSRect rect )
{
	// given a point <p> within <rect> this returns it mapped to a 0..1 interval
	NSPoint pn;
	
	pn.x = ( p.x - rect.origin.x ) / rect.size.width;
	pn.y = ( p.y - rect.origin.y ) / rect.size.height;
	
	return pn;
}


NSPoint		MapPointToRect( const NSPoint p, const NSRect rect )
{
	// given a point <p> in 0..1 space, maps it to <rect>
	NSPoint pn;
	
	pn.x = ( p.x * rect.size.width ) + rect.origin.x;
	pn.y = ( p.y * rect.size.height ) + rect.origin.y;
	
	return pn;
}


NSPoint		MapPointFromRectToRect( const NSPoint p, const NSRect srcRect, const NSRect destRect )
{
	// maps a point <p> in <srcRect> to the same relative location within <destRect>
	
	return MapPointToRect( MapPointFromRect( p, srcRect ), destRect );
}


NSRect		MapRectFromRectToRect( const NSRect inRect, const NSRect srcRect, const NSRect destRect )
{
	// maps a rect from <srcRect> to the same relative position within <destRect>
	
	NSPoint p1, p2;
	
	p1 = inRect.origin;
	p2.x = NSMaxX( inRect );
	p2.y = NSMaxY( inRect );
	
	p1 = MapPointFromRectToRect( p1, srcRect, destRect );
	p2 = MapPointFromRectToRect( p2, srcRect, destRect );
	
	return NSRectFromTwoPoints( p1, p2 );
}



#pragma mark -

NSRect		ScaleRect( const NSRect inRect, const CGFloat scale )
{
	// multiplies the width and height of <inrect> by <scale> and offsets the origin by half the difference, which
	// keeps the original centre of the rect at the same point. Values > 1 expand the rect, < 1 shrink it.
	
	NSRect r = inRect;
	
	r.size.width *= scale;
	r.size.height *= scale;
	
	r.origin.x -= 0.5 * ( r.size.width - inRect.size.width );
	r.origin.y -= 0.5 * ( r.size.height - inRect.size.height );
	
	return r;
}



NSRect		ScaledRectForSize( const NSSize inSize, const NSRect fitRect )
{
	// returns a rect having the same aspect ratio as <inSize>, scaled to fit within <fitRect>. The shorter side is centred
	// within <fitRect> as appropriate
	
	CGFloat   ratio = inSize.width / inSize.height;
	NSRect  r;
	
	CGFloat hxs, vxs;
	
	hxs = inSize.width / fitRect.size.width;
	vxs = inSize.height / fitRect.size.height;
	
	if ( hxs >= vxs )
	{
		// fitting width, centering height
	
		r.size.width = fitRect.size.width;
		r.size.height = r.size.width / ratio;
		r.origin.x = fitRect.origin.x;
		r.origin.y = fitRect.origin.y + ((fitRect.size.height - r.size.height) / 2.0);
	}
	else
	{
		// fitting height, centering width
	
		r.size.height = fitRect.size.height;
		r.size.width = r.size.height * ratio;
		r.origin.y = fitRect.origin.y;
		r.origin.x = fitRect.origin.x + ((fitRect.size.width - r.size.width) / 2.0);
	}

	return r;
}


NSRect		CentreRectInRect( const NSRect r, const NSRect cr )
{
	// centres <r> over <cr>, returning a rect the same size as <r>
	
	NSRect	nr;
	
	nr.size = r.size;
	
	nr.origin.x = NSMinX( cr ) + (( cr.size.width - r.size.width ) / 2.0 );
	nr.origin.y = NSMinY( cr ) + (( cr.size.height - r.size.height ) / 2.0 );
	
	return nr;
}


NSBezierPath*		RotatedRect( const NSRect r, const CGFloat radians )
{
	// turns the rect into a path, rotated about its centre by <radians>
	
	NSBezierPath* path = [NSBezierPath bezierPathWithRect:r];
	return path;// rotatedPath:radians];
}


#pragma mark -
NSRect		NormalizedRect( const NSRect r )
{
	// returns the same rect as the input, but adjusts any -ve width or height to be +ve and
	// compensates the origin.
	
	NSRect	nr = r;
	
	if ( r.size.width < 0 )
	{
		nr.size.width = -r.size.width;
		nr.origin.x -= nr.size.width;
	}
	
	if ( r.size.height < 0 )
	{
		nr.size.height = -r.size.height;
		nr.origin.y -= nr.size.height;
	}
	
	return nr;
}


NSAffineTransform*	RotationTransform( const CGFloat angle, const NSPoint cp )
{
	// return a transform that will cause a rotation about the point given at the angle given

	NSAffineTransform*	xfm = [NSAffineTransform transform];
	[xfm translateXBy:cp.x yBy:cp.y];
	[xfm rotateByRadians:angle];
	[xfm translateXBy:-cp.x yBy:-cp.y];

	return xfm;
}


#pragma mark - bezier curve utils

static NSPoint*		ConvertToBezierForm( const NSPoint inp, const NSPoint bez[4] );
static NSInteger			FindRoots( NSPoint* w, NSInteger degree, double* t, NSInteger depth );
static NSInteger			CrossingCount( NSPoint* v, NSInteger degree );
static NSInteger			ControlPolygonFlatEnough( NSPoint* v, NSInteger degree );
static double		ComputeXIntercept( NSPoint* v, NSInteger degree);


#define MAXDEPTH	64
#define	EPSILON		(ldexp(1.0,-MAXDEPTH-1))

#define SGN(a)		(((a)<0) ? -1 : 0)


#pragma mark -
/*
 *  ConvertToBezierForm :
 *		Given a point and a Bezier curve, generate a 5th-degree
 *		Bezier-format equation whose solution finds the point on the
 *	  curve nearest the user-defined point.	*/
static NSPoint*		ConvertToBezierForm( const NSPoint inp, const NSPoint bez[4] )
{
	NSInteger				i, j, k, m, n, ub, lb;	
	NSInteger				row, column;		// Table indices
	NSPoint			c[4];				// V(i)'s - P
	NSPoint			d[3];				// V(i+1) - V(i)
	NSPoint*		w;					// Ctl pts of 5th-degree curve
	double			cdTable[3][4];		// Dot product of c, d
	
	static double z[3][4] = {	/* Precomputed "z" for cubics	*/
	{1.0, 0.6, 0.3, 0.1},
	{0.4, 0.6, 0.6, 0.4},
	{0.1, 0.3, 0.6, 1.0},
	};


	/*Determine the c's -- these are vectors created by subtracting*/
	/* point P from each of the control points				*/
	for (i = 0; i <= 3; i++)
	{
		c[i] = DiffPoint( bez[i], inp );
	}
	
	/* Determine the d's -- these are vectors created by subtracting*/
	/* each control point from the next					*/
	for (i = 0; i < 3; i++)
	{ 
		d[i].x = ( bez[ i + 1 ].x - bez[i].x ) * 3.0;
		d[i].y = ( bez[ i + 1 ].y - bez[i].y ) * 3.0;
	}

	/* Create the c,d table -- this is a table of dot products of the */
	/* c's and d's							*/
	
	for ( row = 0; row < 3; row++ )
	{
		for (column = 0; column <= 3; column++)
		{
			cdTable[row][column] = DotProduct( d[row], c[column] );
		}
	}

	/* Now, apply the z's to the dot products, on the skew diagonal*/
	/* Also, set up the x-values, making these "points"		*/
	
	w = (NSPoint*)	malloc(6 * sizeof(NSPoint));
	
	for (i = 0; i <= 5; i++)
	{
		w[i].y = 0.0;
		w[i].x = (double)(i) / 5;
	}

	n = 3;
	m = 2;
	
	for (k = 0; k <= n + m; k++)
	{
		lb = MAX(0, k - m);
		ub = MIN(k, n);
		
		for (i = lb; i <= ub; i++)
		{
			j = k - i;
			w[i+j].y += cdTable[j][i] * z[j][i];
		}
	}

	return w;
}


/*
 *  FindRoots :
 *	Given a 5th-degree equation in Bernstein-Bezier form, find
 *	all of the roots in the interval [0, 1].  Return the number
 *	of roots found.	*/
static NSInteger FindRoots( NSPoint* w, NSInteger degree, double* t, NSInteger depth )
{  
	NSInteger			i;
	NSPoint 	Left[6], Right[6];	// control polygons
	NSInteger			left_count,	 right_count;
	double		left_t[6], right_t[6];

	switch ( CrossingCount( w, degree ))
	{
	   	default:
			break;
			
		case 0:	// No solutions here
			return 0;	

		case 1:	// Unique solution
			// Stop recursion when the tree is deep enough
			// if deep enough, return 1 solution at midpoint
		
			if (depth >= MAXDEPTH)
			{
				t[0] = ( w[0].x + w[5].x) / 2.0;
				return 1;
			}
			
			if ( ControlPolygonFlatEnough( w, degree ))
			{
				t[0] = ComputeXIntercept( w, degree );
				return 1;
			}
			break;
	}

	// Otherwise, solve recursively after
	// subdividing control polygon
	
	Bezier( w, degree, 0.5, Left, Right );
	left_count  = FindRoots( Left,  degree, left_t, depth+1 );
	right_count = FindRoots( Right, degree, right_t, depth+1 );

	// Gather solutions together
	for (i = 0; i < left_count; i++)
	{
		t[i] = left_t[i];
	}
	for (i = 0; i < right_count; i++)
	{
 		t[i+left_count] = right_t[i];
	}

	// Send back total number of solutions
	
	return (left_count + right_count);
}


/*
 * CrossingCount :
 *	Count the number of times a Bezier control polygon 
 *	crosses the 0-axis. This number is >= the number of roots.
 *	*/
static NSInteger CrossingCount( NSPoint* v, NSInteger degree )
{
	NSInteger 	i;	
	NSInteger 	n_crossings = 0;	/*  Number of zero-crossings	*/
	NSInteger		sign, old_sign;		/*  Sign of coefficients	*/

	old_sign = SGN( v[0].y );
	
	for ( i = 1; i <= degree; i++ )
	{
		sign = SGN( v[i].y );
		
		if (sign != old_sign)
			n_crossings++;
		old_sign = sign;
	}
	return n_crossings;
}


/*
 *  ControlPolygonFlatEnough :
 *	Check if the control polygon of a Bezier curve is flat enough
 *	for recursive subdivision to bottom out.
 *	*/
static NSInteger ControlPolygonFlatEnough( NSPoint* v, NSInteger degree )
{
	NSInteger			i;					// Index variable
	double*		distance;			// Distances from pts to line
	double		max_distance_above;	// maximum of these
	double		max_distance_below;
	double		error;				// Precision of root
	double		intercept_1,
				intercept_2,
				left_intercept,
				right_intercept;
	double		a, b, c;			// Coefficients of implicit
									// eqn for line from V[0]-V[deg]

	/* Find the  perpendicular distance		*/
	/* from each interior control point to 	*/
	/* line connecting V[0] and V[degree]	*/
	distance = (double*) malloc((NSUInteger)(degree + 1) * sizeof(double));
	double	abSquared;

	/* Derive the implicit equation for line connecting first */
	/*  and last control points */
	
	a = v[0].y - v[degree].y;
	b = v[degree].x - v[0].x;
	c = v[0].x * v[degree].y - v[degree].x * v[0].y;

	abSquared = (a * a) + (b * b);

	for (i = 1; i < degree; i++)
	{
		// Compute distance from each of the points to that line
		distance[i] = a * v[i].x + b * v[i].y + c;
		if (distance[i] > 0.0)
		{
			distance[i] = (distance[i] * distance[i]) / abSquared;
		}
		if (distance[i] < 0.0)
		{
			distance[i] = -((distance[i] * distance[i]) / abSquared);
		}
	}

	/* Find the largest distance	*/
	max_distance_above = 0.0;
	max_distance_below = 0.0;
	for (i = 1; i < degree; i++)
	{
		if (distance[i] < 0.0)
		{
			max_distance_below = MIN(max_distance_below, distance[i]);
		}
		if (distance[i] > 0.0)
		{
			max_distance_above = MAX(max_distance_above, distance[i]);
		}
	}
	free((char *)distance);

	double	det, dInv;
	double	a1, b1, c1, a2, b2, c2;

	/*  Implicit equation for zero line */
	a1 = 0.0;
	b1 = 1.0;
	c1 = 0.0;

	/*  Implicit equation for "above" line */
	a2 = a;
	b2 = b;
	c2 = c + max_distance_above;

	det = a1 * b2 - a2 * b1;
	dInv = 1.0/det;
	
	intercept_1 = (b1 * c2 - b2 * c1) * dInv;

	/*  Implicit equation for "below" line */
	a2 = a;
	b2 = b;
	c2 = c + max_distance_below;
	
	det = a1 * b2 - a2 * b1;
	dInv = 1.0/det;
	
	intercept_2 = (b1 * c2 - b2 * c1) * dInv;

	/* Compute intercepts of bounding box	*/
	left_intercept = MIN(intercept_1, intercept_2);
	right_intercept = MAX(intercept_1, intercept_2);

	error = 0.5 * (right_intercept - left_intercept);	
	if (error < EPSILON)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}


/*
 *  ComputeXIntercept :
 *	Compute intersection of chord from first control point to last
 *  	with 0-axis.
 * 	*/

static double ComputeXIntercept( NSPoint* v, NSInteger degree)
{
	double	XLK, YLK, XNM, YNM, XMK, YMK;
	double	det, detInv;
	double	S;
	double	X;

	XLK = 1.0;
	YLK = 0.0;
	XNM = v[degree].x - v[0].x;
	YNM = v[degree].y - v[0].y;
	XMK = v[0].x;
	YMK = v[0].y;

	det = XNM*YLK - YNM*XLK;
	detInv = 1.0/det;

	S = (XNM*YMK - YNM*XMK) * detInv;
	X = XLK * S;

	return X;
}


#pragma mark -
/*
 *  NearestPointOnCurve :
 *  	Compute the parameter value of the point on a Bezier
 *		curve segment closest to some arbtitrary, user-input point.
 *		Return the point on the curve at that parameter value.
 *	*/

NSPoint		NearestPointOnCurve( const NSPoint inp, const NSPoint bez[4], double* tValue )
{
	NSPoint*	w;						// Ctl pts for 5th-degree eqn
	double		t_candidate[5];			// Possible roots	
	NSInteger			n_solutions;			// Number of roots found
	double		t;						// Parameter value of closest pt

	// Convert problem to 5th-degree Bezier form
	
	w = ConvertToBezierForm( inp, bez );

	// Find all possible roots of 5th-degree equation
	
	n_solutions = FindRoots( w, 5, t_candidate, 0 );
	free((char*) w);

	// Compare distances of P to all candidates, and to t=0, and t=1

	double		dist, new_dist;
	NSPoint 	p;
	NSInteger			i;

	// Check distance to beginning of curve, where t = 0
	
	dist = DiffPointSquaredLength( inp, bez[0] );
	t = 0.0;

	// Find distances for candidate points
	
	for (i = 0; i < n_solutions; i++)
	{
		p = Bezier( bez, 3, t_candidate[i], NULL, NULL );
		
		new_dist = DiffPointSquaredLength( inp, p );
		if ( new_dist < dist )
		{
			dist = new_dist;
			t = t_candidate[i];
		}
	}

	// Finally, look at distance to end point, where t = 1.0
	
	new_dist = DiffPointSquaredLength( inp, bez[3]);
	if (new_dist < dist)
	{
		t = 1.0;
	}
 
	/*  Return the point on the curve at parameter value t */
//	LogEvent_(kInfoEvent, @"t : %4.12f", t);
	
	if ( tValue )
		*tValue = t;
		
	return Bezier( bez, 3, t, NULL, NULL);
}


/*
 *  Bezier : 
 *	Evaluate a Bezier curve at a particular parameter value
 *	  Fill in control points for resulting sub-curves if "Left" and
 *	"Right" are non-null.
 * 	*/
NSPoint		Bezier( const NSPoint* v, const NSInteger degree, const double t, NSPoint* Left, NSPoint* Right )
{
	NSInteger			i, j;		/* Index variables	*/
	NSPoint 	Vtemp[6][6];


	/* Copy control points	*/
	for (j =0; j <= degree; j++)
	{
		Vtemp[0][j] = v[j];
	}

	/* Triangle computation	*/
	for (i = 1; i <= degree; i++)
	{	
		for (j =0 ; j <= degree - i; j++)
		{
			Vtemp[i][j].x = (1.0 - t) * Vtemp[i-1][j].x + t * Vtemp[i-1][j+1].x;
			Vtemp[i][j].y = (1.0 - t) * Vtemp[i-1][j].y + t * Vtemp[i-1][j+1].y;
		}
	}
	
	if ( Left )
	{
		for (j = 0; j <= degree; j++)
		{
			Left[j]  = Vtemp[j][0];
		}
	}
	if ( Right)
	{
		for (j = 0; j <= degree; j++)
		{
			Right[j] = Vtemp[degree-j][j];
		}
	}

	return (Vtemp[degree][0]);
}


#pragma mark -
CGFloat		BezierSlope( const NSPoint bez[4], const CGFloat t )
{
	// returns the slope of the curve defined by the bezier control points <bez[0..3]> at the t value given. This slope can be used to determine
	// the angle of something placed at that point tangent to the curve, such as a text character, etc. Add 90 degrees to get the normal to any
	// point. For text on a path, you also need to calculate t based on a linear length along the path.

	double			x, y, tt;
	double			ax, bx, cx;			// coefficients for cubic in x 
	double			ay, by, cy;			// coefficients for cubic in y
	
	// compute the coefficients of the bezier function:
	
	cx = 3.0 * (bez[1].x - bez[0].x);
	bx = 3.0 * (bez[2].x - bez[1].x) - cx;
	ax = bez[3].x - bez[0].x - cx - bx;
	
	cy = 3.0 * (bez[1].y - bez[0].y);
	by = 3.0 * (bez[2].y - bez[1].y) - cy;
	ay = bez[3].y - bez[0].y - cy - by;
		
	tt = LIMIT( t, 0.0, 1.0 );
	
	// tangent is first derivative, i.e. quadratic differentiated from cubic:
	
	x = ( 3.0 * ax * tt * tt ) + ( 2.0 * bx * tt ) + cx; 
	y = ( 3.0 * ay * tt * tt ) + ( 2.0 * by * tt ) + cy; 
	
	return atan2( y, x );
}
