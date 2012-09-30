//
//  AtoZFunctions.m
//  AtoZ
//
//  Created by Alex Gray on 9/10/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AtoZFunctions.h"
#import "AtoZ.h"
#import "AtoZUmbrella.h"

#import <objc/message.h>
#import <sys/time.h>



//static void glossInterpolation(void *info, const float *input);
//float *output);

//static
void glossInterpolation(void *info, const CGFloat *input, CGFloat *output);
//static void glossInterpolation(void *info, const CGFloat *input);

void perceptualCausticColorForColor(CGFloat *inputComponents, CGFloat *outputComponents);
extern void DrawGlossGradient(CGContextRef context, NSColor *color, NSRect inRect);
extern void DrawLabelAtCenterPoint(NSString* string, NSPoint center);





//void _AZSimpleLog(const char *file, int lineNumber, const char *funcName, NSString *format,...){
// va_list argList;
// va_start (argList, format);
// NSString *path = [[NSString stringWithUTF8String:file] lastPathComponent];
// NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
// fprintf (stderr, "[%s]:%i %s \n", [path UTF8String], lineNumber, [message UTF8String]);
// va_end  (argList);
// //	const char *threadName = [[[NSThread currentThread] name] UTF8String];
//}

//#define WIDTH 13600
//#define HEIGHT 100
//#define STEP 100

//void drawLines(BOOL horizontal, CGFloat from, CGFloat to, CGFloat step, NSRect bounds) {
//{
//    for (CGFloat i = from; i <= to; i += step) {
//        NSRect rect;
//        if (horizontal) rect = NSMakeRect (bounds.origin.x - x + i, bounds.origin.y + bounds.size.height - 1 + y - HEIGHT, 1, HEIGHT + 1);
//         else rect = NSMakeRect(bounds.origin.x - x, bounds.origin.y + bounds.size.height - 1 + y - i, WIDTH + 1, 1);
//
//		NSString *string = [NSString stringWithFormat:@"%i",(int) (i/STEP)];
//			//    	NSRect bounds = self.bounds;
//    	[string drawAtPoint:AGCenterOfRect(bounds) withAttributes:nil];
//		 // NSMakePoint(10, bounds.origin.y + bounds.size.height - 20)
//		[NSBezierPath setDefaultLineWidth:5];
//		[NSBezierPath set
//		[RANDOMCOLOR set];
//		[NSBezierPath strokeRect:rect];
//		[NSBezierPath fillRect:rect];
//    }
//}


NSUInteger normalizedNumberLessThan (id number, NSUInteger max){
	NSUInteger u= [number integerValue];
	u = u <=max ? u : max;
	return u;
}

BOOL IsEmpty(id obj) {
	return 		obj == nil
			|| 	(NSNull *)obj == [NSNull null]
			||	([obj respondsToSelector:@selector(length)] && [obj length] == 0)
			|| 	([obj respondsToSelector:@selector(count)] 	&& [obj count] 	== 0);
}

extern CGFloat percent(CGFloat val)
{	return val > 5 && val < 100 ? val/100 : val > 1 ? 1 : val < 0 ? 0 : val; }

extern void ApplicationsInDirectory(NSString *searchPath, NSMutableArray *applications) {
	__block BOOL isDir;
	[[AZFILEMANAGER contentsOfDirectoryAtPath:searchPath error:nil]az_each:^(id obj, NSUInteger index, BOOL *stop) {
		[AZFILEMANAGER changeCurrentDirectoryPath:searchPath];
        if ([AZFILEMANAGER fileExistsAtPath:obj isDirectory:&isDir] && isDir) {
            NSString *fullpath = [searchPath stringByAppendingPathComponent:obj];
            if ([[obj pathExtension] isEqualToString:@"app"])
					[applications addObject:fullpath];
            else ApplicationsInDirectory(fullpath, applications);
        }
    }];
}



//	BOOL isDir;
//    NSFileManager *manager = [NSFileManager defaultManager];
//    NSArray *files = [manager contentsOfDirectoryAtPath:searchPath error:nil];
//
//    NSEnumerator *fileEnum = [files objectEnumerator]; NSString *file;
//    while (file = [fileEnum nextObject]) {
//        [manager changeCurrentDirectoryPath:searchPath];
//        if ([manager fileExistsAtPath:file isDirectory:&isDir] && isDir) {
//            NSString *fullpath = [searchPath stringByAppendingPathComponent:file];
//            if ([[file pathExtension] isEqualToString:@"app"]) [applications addObject:fullpath];
//            else ApplicationsInDirectory(fullpath, applications);
//        }
//    }
//}


//void WithAutoreleasePool(BasicBlock block) {
//	@autoreleasepool {
//		block();
//}	}

//USAGE		//for(id obj in array) WithAutoreleasePool(^{  	[self createLotsOfTemporaryObjectsWith:obj];  });

NSString *const AZMouseNotification = @"okWindowFadeOutNow";

BOOL isPathAccessible(NSString *path, SandBox mode) {
	return access([path UTF8String], mode) == 0;
}

static CGEventRef myEventTapCallback (	CGEventTapProxy proxy,	CGEventType type,	CGEventRef event,	void * refcon ) {

		// If we would get different kind of events, we can distinguish them by the variable "type", but we know we only get mouse moved events
    CGPoint mouseLocation = CGEventGetLocation(event);
    printf(	"Mouse is at x/y: %u/%u\n",(unsigned int)mouseLocation.x,  (unsigned int)mouseLocation.y );
	[[ NSNotificationCenter defaultCenter] postNotificationName:@"mouseMoved" object:nil];

		// Pass on the event, we must not modify it anyway, we are a listener
    return event;
}



void trackMouse() {

	CGEventMask emask;
	CFMachPortRef myEventTap;
	CFRunLoopSourceRef eventTapRLSrc;

		// We only want one kind of event at the moment: The mouse has moved
	emask = CGEventMaskBit(kCGEventMouseMoved);			// Create the Tap
	myEventTap = CGEventTapCreate (		kCGSessionEventTap, // Catch all events for current user session
								   kCGTailAppendEventTap, // Append to end of EventTap list
								   kCGEventTapOptionListenOnly, // We only listen, we don't modify
								   emask,	&myEventTapCallback, NULL // We need no extra data in the callback
								   );																		// Create a RunLoop Source for it
	eventTapRLSrc = CFMachPortCreateRunLoopSource(		kCFAllocatorDefault,	myEventTap,   0		);
		// Add the source to the current RunLoop
	CFRunLoopAddSource(		CFRunLoopGetCurrent(),		eventTapRLSrc, 		kCFRunLoopDefaultMode   );
		// Keep the RunLoop running forever
	CFRunLoopRun();
}

//
//	// In a source file
//NSString *const FormatTypeName[FormatTypeCount] = {
//	[JSON] = @"JSON",
//	[XML] = @"XML",
//	[Atom] = @"Atom",
//	[RSS] = @"RSS",
//};

	//NSString *const AZOrientName[AZOrientCount] = {
	//	[AZOrientTop] = @"Top",
	//	[AZOrientLeft] = @"Left",
	//	[AZOrientBottom] = @"Bottom",
	//	[AZOrientRight] = @"Right",
	//	[AZOrientFiesta] = @"Fiesta",
	////	[AZOrientCount] = @"Count",
	//};

	// Log levels: off, error, warn, info, verbose
	//static const int ddLogLevel = LOG_LEVEL_VERBOSE;


//
//void _AZLog(const char *file, int lineNumber, const char *funcName, NSString *format,...) {
//	va_list arglist;
//
//	va_start (arglist, format);
//	if (![format hasSuffix: @"\n"]) {
//		format = [format stringByAppendingString: @"\n"];
//	}
//	NSString *body =  [[NSString alloc] initWithFormat: format arguments: arglist];
//	va_end (arglist);
//	const char *threadName = [[[NSThread currentThread] name] UTF8String];
//	NSString *fileName=[[NSString stringWithUTF8String:file] lastPathComponent];
//		//	if (threadName) {
//		//		fprintf(stderr,"%s/%s (%s:%d) %s",threadName,funcName,[fileName UTF8String],lineNumber,[body UTF8String]);
//		//	} else {
//		//		fprintf(stderr,"%p/%s (%s:%d) %s",[NSThread currentThread],funcName,[fileName UTF8String],lineNumber,[body UTF8String]);
//		//	}
//#ifdef PRINTMETHODS
//	fprintf(stderr,"%s:%d [%s] %s",[fileName UTF8String],lineNumber,funcName, [body UTF8String]);
//#else
//	fprintf(stderr,"line:%d %s",lineNumber, [body UTF8String]);
//#endif
//		//
//	[body release];
//}
//
//void _AZLog(const char *file, int lineNumber, const char *funcName, NSString *format,...);
//
//void QuietLog (const char *file, int lineNumber, const char *funcName, NSString *format, ...) {
//    if (format == nil) {
//        printf("nil\n");
//        return;
//    }
//		// Get a reference to the arguments that follow the format parameter
//    va_list argList;
//    va_start(argList, format);
//		// Perform format string argument substitution, reinstate %% escapes, then print
//    NSString *s = [[[NSString alloc] initWithFormat:format arguments:argList]stringByReplacingAllOccurancesOfString:@"fff" withString:@"%.1f"];
//		//for float the format specifier is %f and we can restrict it to print only two decimal place value by %.2f
//    printf("%s\n", [[s stringByReplacingOccurrencesOfString:@"%%" withString:@"%%%%"] UTF8String]);
//    [s release];
//    va_end(argList);
//}



//void QuietLog (NSString *format, ...) { if (format == nil) { printf("nil\n"); return; }
//	// Get a reference to the arguments that follow the format parameter
//    va_list argList;  va_start(argList, format);
//	// Perform format string argument substitution, reinstate %% escapes, then print
//    NSString *s = [[NSString alloc] initWithFormat:format arguments:argList];
//    printf("%s\n", [[s stringByReplacingOccurrencesOfString:@"%%" withString:@"%%%%"] UTF8String]);
//    [s release];
//    va_end(argList);
//}

// NSLog() writes out entirely too much stuff.  Most of the time I'm  not interested in the program name, process ID, and current time down to the subsecond level.
// This takes an NSString with printf-style format, and outputs it. regular old printf can't be used instead because it doesn't support the '%@' format option.

void QuietLog (NSString *format, ...) {
	va_list argList; va_start (argList, format);
	NSS *message = 	[[NSS alloc] initWithFormat: format arguments: argList];
	printf ("%s", [message UTF8String]); va_end  (argList);
} // QuietLog

#ifndef NDEBUG
#import <Foundation/Foundation.h>
#import <stdio.h>

extern void _NSSetLogCStringFunction(void (*)(const char *string, unsigned length, BOOL withSyslogBanner));

static void PrintNSLogMessage(const char *string, unsigned length, BOOL withSyslogBanner){
	puts(string);
}

static void HackNSLog(void) __attribute__((constructor));
static void HackNSLog(void){
	_NSSetLogCStringFunction(PrintNSLogMessage);
}
#endif

//void QuietLog (NSString *format, ...) {
//	va_list argList;	va_start (argList, format);
//	NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
//	fprintf (stderr, "*** %s ***\n", [message UTF8String]); 	va_end  (argList);
//} // QuietLog


void perceptualCausticColorForColor(CGFloat *inputComponents, CGFloat *outputComponents) {
    const CGFloat CAUSTIC_FRACTION = 0.60;
    const CGFloat COSINE_ANGLE_SCALE = 1.4;
    const CGFloat MIN_RED_THRESHOLD = 0.95;
    const CGFloat MAX_BLUE_THRESHOLD = 0.7;
    const CGFloat GRAYSCALE_CAUSTIC_SATURATION = 0.2;

    NSColor *source = [NSColor colorWithCalibratedRed:inputComponents[0] green:inputComponents[1] blue:inputComponents[2]	 alpha:inputComponents[3]];

    CGFloat hue_, saturation_, brightness_, alpha_, targetHue, targetSaturation, targetBrightness;
    [source getHue:&hue_ saturation:&saturation_ brightness:&brightness_ alpha:&alpha_];
    [[NSColor yellowColor] getHue:&targetHue saturation:&targetSaturation brightness:&targetBrightness alpha:&alpha_];
    if (saturation_ < 1e-3) {        hue_ = targetHue;        saturation_ = GRAYSCALE_CAUSTIC_SATURATION;	}
    if (hue_ > MIN_RED_THRESHOLD)        hue_ -= 1.0;
    else if (hue_ > MAX_BLUE_THRESHOLD)
        [[NSColor magentaColor] getHue:&targetHue saturation:&targetSaturation brightness:&targetBrightness alpha:&alpha_];
    float scaledCaustic = CAUSTIC_FRACTION * 0.5 * (1.0 + cos(COSINE_ANGLE_SCALE * M_PI * (hue_ - targetHue)));
    NSColor *targetColor =
	[NSColor	 colorWithCalibratedHue:hue_ * (1.0 - scaledCaustic) + targetHue * scaledCaustic saturation:saturation_
						  brightness:brightness_ * (1.0 - scaledCaustic) + targetBrightness * scaledCaustic	 alpha:inputComponents[3]];
    [targetColor getComponents:outputComponents];
}

static void glossInterpolation(void *info, const CGFloat *input, CGFloat *output) {
    GlossParameters *params = (GlossParameters *)info;
    CGFloat progress = *input;
    if (progress < 0.5)	{
        progress = progress * 2.0;
        progress =
		1.0 - params->expScale * (expf(progress * -params->expCoefficient) - params->expOffset);
        CGFloat currentWhite = progress * (params->finalWhite - params->initialWhite) + params->initialWhite;
        output[0] = params->color[0] * (1.0 - currentWhite) + currentWhite;
        output[1] = params->color[1] * (1.0 - currentWhite) + currentWhite;
        output[2] = params->color[2] * (1.0 - currentWhite) + currentWhite;
        output[3] = params->color[3] * (1.0 - currentWhite) + currentWhite;
	} else {
        progress = (progress - 0.5) * 2.0;
        progress = params->expScale *
		(expf((1.0 - progress) * -params->expCoefficient) - params->expOffset);
        output[0] = params->color[0] * (1.0 - progress) + params->caustic[0] * progress;
        output[1] = params->color[1] * (1.0 - progress) + params->caustic[1] * progress;
        output[2] = params->color[2] * (1.0 - progress) + params->caustic[2] * progress;
        output[3] = params->color[3] * (1.0 - progress) + params->caustic[3] * progress;
	}
}

CGFloat perceptualGlossFractionForColor(CGFloat *inputComponents)
{
    const CGFloat REFLECTION_SCALE_NUMBER = 0.2;
    const CGFloat NTSC_RED_FRACTION = 0.299;
    const CGFloat NTSC_GREEN_FRACTION = 0.587;
    const CGFloat NTSC_BLUE_FRACTION = 0.114;

    CGFloat glossScale =
	NTSC_RED_FRACTION * inputComponents[0] +
	NTSC_GREEN_FRACTION * inputComponents[1] +
	NTSC_BLUE_FRACTION * inputComponents[2];
    glossScale = pow(glossScale, REFLECTION_SCALE_NUMBER);
    return glossScale;
}


void DrawGlossGradient(CGContextRef context, NSColor *color, NSRect inRect) {
    const CGFloat EXP_COEFFICIENT = 1.2;
    const CGFloat REFLECTION_MAX = 0.60;
    const CGFloat REFLECTION_MIN = 0.20;
    GlossParameters params;
    params.expCoefficient = EXP_COEFFICIENT;
    params.expOffset = expf(-params.expCoefficient);
    params.expScale = 1.0 / (1.0 - params.expOffset);

    NSColor *source =	[color colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    [source getComponents:params.color];
    if ([source numberOfComponents] == 3)
        params.color[3] = 1.0;
    perceptualCausticColorForColor(params.color, params.caustic);
    CGFloat glossScale = perceptualGlossFractionForColor(params.color);
    params.initialWhite = glossScale * REFLECTION_MAX;
    params.finalWhite = glossScale * REFLECTION_MIN;
    static const CGFloat input_value_range[2] = {0, 1};
    static const CGFloat output_value_ranges[8] = {0, 1, 0, 1, 0, 1, 0, 1};
    CGFunctionCallbacks callbacks = {0, glossInterpolation, NULL};
    CGFunctionRef gradientFunction = CGFunctionCreate(
													  (void *)&params,
													  1, // number of input values to the callback
													  input_value_range,
													  4, // number of components (r, g, b, a)
													  output_value_ranges,
													  &callbacks);

    CGPoint startPoint = CGPointMake(NSMinX(inRect), NSMaxY(inRect));
    CGPoint endPoint = CGPointMake(NSMinX(inRect), NSMinY(inRect));

    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGShadingRef shading = CGShadingCreateAxial(colorspace, startPoint,
												endPoint, gradientFunction, FALSE, FALSE);

    CGContextSaveGState(context);
    CGContextClipToRect(context, NSRectToCGRect(inRect));
    CGContextDrawShading(context, shading);
    CGContextRestoreGState(context);

    CGShadingRelease(shading);
    CGColorSpaceRelease(colorspace);
    CGFunctionRelease(gradientFunction);
}



void PoofAtPoint( NSPoint pt, CGFloat radius){
	NSShowAnimationEffect(NSAnimationEffectPoof, pt, (CGSize){radius, radius}, nil, 0, nil);
}




extern void DrawLabelAtCenterPoint(NSString* string, NSPoint center) {
		//    NSString *labelString = [NSString stringWithFormat:@"%ld", (long)dimension];
    NSDictionary *attributes = $map([NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSRegularControlSize]], NSFontAttributeName, BLACK, NSForegroundColorAttributeName, WHITE, NSBackgroundColorAttributeName);
    NSSize labelSize = [string sizeWithAttributes:attributes];
    NSRect labelRect = NSMakeRect(center.x - 0.5 * labelSize.width, center.y - 0.5 * labelSize.height, labelSize.width, labelSize.height);
    [string drawInRect:labelRect withAttributes:attributes];
}




static double frandom(double start, double end)
{
	double r = random();
	r /= RAND_MAX;
	r = start + r*(end-start);

	return r;
}

//@implementation Slice
//@end

//@implementation NSNumber (SliceCreation)
//
//- (Slice *): (NSInteger)length
//{
//    Slice *slice = [[Slice alloc] init];
//    [slice setStart: [self integerValue]];
//    [slice setLength: length];
//    return slice;
//}
//
//@end

//@implementation NSArray (slicing)
//- (id)objectForKeyedSubscript: (id)subscript		{	Slice *slice = subscript;
//    return [self subarrayWithRange: NSMakeRange([slice start], [slice length])];
//}
//@end


/*
int main(int argc, char **argv)
{	@autoreleasepool
    {	NSMutableArray *array = [NSMutableArray array];
        for(int i = 0; i < 100; i++)
            [array addObject: @(i * i)];

        NSArray *sliced = array[[@5:8]];
        NSLog(@"%@", sliced);
    }
}
*/
	// 2012-07-09 17:15:12.705 a.out[84967:707] (
	//     25,
	//     36,
	//     49,
	//     64,
	//     81,
	//     100,
	//     121,
	//     144
	// )




	//@interface  NSArray (SubscriptsAdd)
	//- (id)objectAtIndexedSubscript:(NSUInteger)index;
	//@end

	//@interface NSMutableArray (SubscriptsAdd)
	//- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)index;
	//@end
	//@interface  NSDictionary (SubscriptsAdd)
	//- (id)objectForKeyedSubscript:(id)key;
	//@end
	//@interface  NSMutableDictionary (SubscriptsAdd)
	//- (void)setObject:(id)object forKeyedSubscript:(id)key;
	//@end


#include <AvailabilityMacros.h>
#include <TargetConditionals.h>

#if TARGET_OS_IPHONE
#include <Availability.h>
#endif //  TARGET_OS_IPHONE

	// Not all MAC_OS_X_VERSION_10_X macros defined in past SDKs
#ifndef MAC_OS_X_VERSION_10_5
#define MAC_OS_X_VERSION_10_5 1050
#endif
#ifndef MAC_OS_X_VERSION_10_6
#define MAC_OS_X_VERSION_10_6 1060
#endif
#ifndef MAC_OS_X_VERSION_10_7
#define MAC_OS_X_VERSION_10_7 1070
#endif

	// Not all __IPHONE_X macros defined in past SDKs
#ifndef __IPHONE_3_0
#define __IPHONE_3_0 30000
#endif
#ifndef __IPHONE_3_1
#define __IPHONE_3_1 30100
#endif
#ifndef __IPHONE_3_2
#define __IPHONE_3_2 30200
#endif
#ifndef __IPHONE_4_0
#define __IPHONE_4_0 40000
#endif
#ifndef __IPHONE_4_3
#define __IPHONE_4_3 40300
#endif
#ifndef __IPHONE_5_0
#define __IPHONE_5_0 50000
#endif

/*	// ----------------------------------------------------------------------------
	// CPP symbols that can be overridden in a prefix to control how the toolbox
	// is compiled.
	// ----------------------------------------------------------------------------


	// By setting the _CONTAINERS_VALIDATION_FAILED_LOG and
	// GTM_CONTAINERS_VALIDATION_FAILED_ASSERT macros you can control what happens
	// when a validation fails. If you implement your own validators, you may want
	// to control their internals using the same macros for consistency.
#ifndef GTM_CONTAINERS_VALIDATION_FAILED_ASSERT
#define GTM_CONTAINERS_VALIDATION_FAILED_ASSERT 0
#endif

	// Give ourselves a consistent way to do inlines.  Apple's macros even use
	// a few different actual definitions, so we're based off of the foundation
	// one.
#if !defined(GTM_INLINE)
#if (defined (__GNUC__) && (__GNUC__ == 4)) || defined (__clang__)
#define GTM_INLINE static __inline__ __attribute__((always_inline))
#else
#define GTM_INLINE static __inline__
#endif
#endif

	// Give ourselves a consistent way of doing externs that links up nicely
	// when mixing objc and objc++
#if !defined (GTM_EXTERN)
#if defined __cplusplus
#define GTM_EXTERN extern "C"
#define GTM_EXTERN_C_BEGIN extern "C" {
#define GTM_EXTERN_C_END }
#else
#define GTM_EXTERN extern
#define GTM_EXTERN_C_BEGIN
#define GTM_EXTERN_C_END
#endif
#endif

	// Give ourselves a consistent way of exporting things if we have visibility
	// set to hidden.
#if !defined (GTM_EXPORT)
#define GTM_EXPORT __attribute__((visibility("default")))
#endif

	// Give ourselves a consistent way of declaring something as unused. This
	// doesn't use __unused because that is only supported in gcc 4.2 and greater.
#if !defined (GTM_UNUSED)
#define GTM_UNUSED(x) ((void)(x))
#endif

	// _GTMDevLog & _GTMDevAssert

	// _GTMDevLog & _GTMDevAssert are meant to be a very lightweight shell for
	// developer level errors.  This implementation simply macros to NSLog/NSAssert.
	// It is not intended to be a general logging/reporting system.

	// Please see http://code.google.com/p/google-toolbox-for-mac/wiki/DevLogNAssert
	// for a little more background on the usage of these macros.

	//    _GTMDevLog           log some error/problem in debug builds
	//    _GTMDevAssert        assert if conditon isn't met w/in a method/function
	//                           in all builds.

	// To replace this system, just provide different macro definitions in your
	// prefix header.  Remember, any implementation you provide *must* be thread
	// safe since this could be called by anything in what ever situtation it has
	// been placed in.


	// We only define the simple macros if nothing else has defined this.
#ifndef _GTMDevLog

#ifdef DEBUG
#define _GTMDevLog(...) NSLog(__VA_ARGS__)
#else
#define _GTMDevLog(...) do { } while (0)
#endif

#endif // _GTMDevLog

#ifndef _GTMDevAssert
	// we directly invoke the NSAssert handler so we can pass on the varargs
	// (NSAssert doesn't have a macro we can use that takes varargs)
#if !defined(NS_BLOCK_ASSERTIONS)
#define _GTMDevAssert(condition, ...)                                       \
do {                                                                      \
if (!(condition)) {                                                     \
[[NSAssertionHandler currentHandler]                                  \
handleFailureInFunction:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
file:[NSString stringWithUTF8String:__FILE__]  \
lineNumber:__LINE__                                  \
description:__VA_ARGS__];                             \
}                                                                       \
} while(0)
#else // !defined(NS_BLOCK_ASSERTIONS)
#define _GTMDevAssert(condition, ...) do { } while (0)
#endif // !defined(NS_BLOCK_ASSERTIONS)

#endif // _GTMDevAssert

	// _GTMCompileAssert
	// _GTMCompileAssert is an assert that is meant to fire at compile time if you
	// want to check things at compile instead of runtime. For example if you
	// want to check that a wchar is 4 bytes instead of 2 you would use
	// _GTMCompileAssert(sizeof(wchar_t) == 4, wchar_t_is_4_bytes_on_OS_X)
	// Note that the second "arg" is not in quotes, and must be a valid processor
	// symbol in it's own right (no spaces, punctuation etc).

	// Wrapping this in an #ifndef allows external groups to define their own
	// compile time assert scheme.
#ifndef _GTMCompileAssert
	// We got this technique from here:
	// http://unixjunkie.blogspot.com/2007/10/better-compile-time-asserts_29.html

#define _GTMCompileAssertSymbolInner(line, msg) _GTMCOMPILEASSERT ## line ## __ ## msg
#define _GTMCompileAssertSymbol(line, msg) _GTMCompileAssertSymbolInner(line, msg)
#define _GTMCompileAssert(test, msg) \
typedef char _GTMCompileAssertSymbol(__LINE__, msg) [ ((test) ? 1 : -1) ]
#endif // _GTMCompileAssert

	// ----------------------------------------------------------------------------
	// CPP symbols defined based on the project settings so the GTM code has
	// simple things to test against w/o scattering the knowledge of project
	// setting through all the code.
	// ----------------------------------------------------------------------------

	// Provide a single constant CPP symbol that all of GTM uses for ifdefing
	// iPhone code.
#if TARGET_OS_IPHONE // iPhone SDK
					 // For iPhone specific stuff
#define GTM_IPHONE_SDK 1
#if TARGET_IPHONE_SIMULATOR
#define GTM_IPHONE_SIMULATOR 1
#else
#define GTM_IPHONE_DEVICE 1
#endif  // TARGET_IPHONE_SIMULATOR
		// By default, GTM has provided it's own unittesting support, define this
		// to use the support provided by Xcode, especially for the Xcode4 support
		// for unittesting.
#ifndef GTM_IPHONE_USE_SENTEST
#define GTM_IPHONE_USE_SENTEST 0
#endif
#else
	// For MacOS specific stuff
#define GTM_MACOS_SDK 1
#endif

	// Some of our own availability macros
#if GTM_MACOS_SDK
#define GTM_AVAILABLE_ONLY_ON_IPHONE UNAVAILABLE_ATTRIBUTE
#define GTM_AVAILABLE_ONLY_ON_MACOS
#else
#define GTM_AVAILABLE_ONLY_ON_IPHONE
#define GTM_AVAILABLE_ONLY_ON_MACOS UNAVAILABLE_ATTRIBUTE
#endif

	// Provide a symbol to include/exclude extra code for GC support.  (This mainly
	// just controls the inclusion of finalize methods).
#ifndef GTM_SUPPORT_GC
#if GTM_IPHONE_SDK
	// iPhone never needs GC
#define GTM_SUPPORT_GC 0
#else
	// We can't find a symbol to tell if GC is supported/required, so best we
	// do on Mac targets is include it if we're on 10.5 or later.
#if MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5
#define GTM_SUPPORT_GC 0
#else
#define GTM_SUPPORT_GC 1
#endif
#endif
#endif
*/


	// To simplify support for 64bit (and Leopard in general), we provide the type
	// defines for non Leopard SDKs
#if !(MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
	// NSInteger/NSUInteger and Max/Mins
#ifndef NSINTEGER_DEFINED
#if __LP64__ || NS_BUILD_32_LIKE_64
typedef long NSInteger;
typedef unsigned long NSUInteger;
#else
typedef int NSInteger;
typedef unsigned int NSUInteger;
#endif
#define NSIntegerMax    LONG_MAX
#define NSIntegerMin    LONG_MIN
#define NSUIntegerMax   ULONG_MAX
#define NSINTEGER_DEFINED 1
#endif  // NSINTEGER_DEFINED
		// CGFloat
#ifndef CGFLOAT_DEFINED
#if defined(__LP64__) && __LP64__
	// This really is an untested path (64bit on Tiger?)
typedef double CGFloat;
#define CGFLOAT_MIN DBL_MIN
#define CGFLOAT_MAX DBL_MAX
#define CGFLOAT_IS_DOUBLE 1
#else /* !defined(__LP64__) || !__LP64__ */
typedef float CGFloat;
#define CGFLOAT_MIN FLT_MIN
#define CGFLOAT_MAX FLT_MAX
#define CGFLOAT_IS_DOUBLE 0
#endif /* !defined(__LP64__) || !__LP64__ */
#define CGFLOAT_DEFINED 1
#endif // CGFLOAT_DEFINED
#endif  // MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5

	// Some support for advanced clang static analysis functionality
	// See http://clang-analyzer.llvm.org/annotations.html
#ifndef __has_feature      // Optional.
#define __has_feature(x) 0 // Compatibility with non-clang compilers.
#endif

#ifndef NS_RETURNS_RETAINED
#if __has_feature(attribute_ns_returns_retained)
#define NS_RETURNS_RETAINED __attribute__((ns_returns_retained))
#else
#define NS_RETURNS_RETAINED
#endif
#endif

#ifndef NS_RETURNS_NOT_RETAINED
#if __has_feature(attribute_ns_returns_not_retained)
#define NS_RETURNS_NOT_RETAINED __attribute__((ns_returns_not_retained))
#else
#define NS_RETURNS_NOT_RETAINED
#endif
#endif

#ifndef CF_RETURNS_RETAINED
#if __has_feature(attribute_cf_returns_retained)
#define CF_RETURNS_RETAINED __attribute__((cf_returns_retained))
#else
#define CF_RETURNS_RETAINED
#endif
#endif

#ifndef CF_RETURNS_NOT_RETAINED
#if __has_feature(attribute_cf_returns_not_retained)
#define CF_RETURNS_NOT_RETAINED __attribute__((cf_returns_not_retained))
#else
#define CF_RETURNS_NOT_RETAINED
#endif
#endif

#ifndef NS_CONSUMED
#if __has_feature(attribute_ns_consumed)
#define NS_CONSUMED __attribute__((ns_consumed))
#else
#define NS_CONSUMED
#endif
#endif

#ifndef CF_CONSUMED
#if __has_feature(attribute_cf_consumed)
#define CF_CONSUMED __attribute__((cf_consumed))
#else
#define CF_CONSUMED
#endif
#endif

#ifndef NS_CONSUMES_SELF
#if __has_feature(attribute_ns_consumes_self)
#define NS_CONSUMES_SELF __attribute__((ns_consumes_self))
#else
#define NS_CONSUMES_SELF
#endif
#endif


//#else /* !defined(__LP64__) || !__LP64__ */
//typedef float CGFloat;
//#define CGFLOAT_MIN FLT_MIN
//#define CGFLOAT_MAX FLT_MAX
//#define CGFLOAT_IS_DOUBLE 0
//#endif /* !defined(__LP64__) || !__LP64__ */
//#define CGFLOAT_DEFINED 1
//#endif // CGFLOAT_DEFINED
//#endif  // MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5

	// Some support for advanced clang static analysis functionality
	// See http://clang-analyzer.llvm.org/annotations.html
#ifndef __has_feature      // Optional.
#define __has_feature(x) 0 // Compatibility with non-clang compilers.
#endif

#ifndef NS_RETURNS_RETAINED
#if __has_feature(attribute_ns_returns_retained)
#define NS_RETURNS_RETAINED __attribute__((ns_returns_retained))
#else
#define NS_RETURNS_RETAINED
#endif
#endif

#ifndef NS_RETURNS_NOT_RETAINED
#if __has_feature(attribute_ns_returns_not_retained)
#define NS_RETURNS_NOT_RETAINED __attribute__((ns_returns_not_retained))
#else
#define NS_RETURNS_NOT_RETAINED
#endif
#endif

#ifndef CF_RETURNS_RETAINED
#if __has_feature(attribute_cf_returns_retained)
#define CF_RETURNS_RETAINED __attribute__((cf_returns_retained))
#else
#define CF_RETURNS_RETAINED
#endif
#endif

#ifndef CF_RETURNS_NOT_RETAINED
#if __has_feature(attribute_cf_returns_not_retained)
#define CF_RETURNS_NOT_RETAINED __attribute__((cf_returns_not_retained))
#else
#define CF_RETURNS_NOT_RETAINED
#endif
#endif

#ifndef NS_CONSUMED
#if __has_feature(attribute_ns_consumed)
#define NS_CONSUMED __attribute__((ns_consumed))
#else
#define NS_CONSUMED
#endif
#endif

#ifndef CF_CONSUMED
#if __has_feature(attribute_cf_consumed)
#define CF_CONSUMED __attribute__((cf_consumed))
#else
#define CF_CONSUMED
#endif
#endif

#ifndef NS_CONSUMES_SELF
#if __has_feature(attribute_ns_consumes_self)
#define NS_CONSUMES_SELF __attribute__((ns_consumes_self))
#else
#define NS_CONSUMES_SELF
#endif
#endif

	// Defined on 10.6 and above.
#ifndef NS_FORMAT_ARGUMENT
#define NS_FORMAT_ARGUMENT(A)
#endif

	// Defined on 10.6 and above.
#ifndef NS_FORMAT_FUNCTION
#define NS_FORMAT_FUNCTION(F,A)
#endif

	// Defined on 10.6 and above.
#ifndef CF_FORMAT_ARGUMENT
#define CF_FORMAT_ARGUMENT(A)
#endif

	// Defined on 10.6 and above.
#ifndef CF_FORMAT_FUNCTION
#define CF_FORMAT_FUNCTION(F,A)
#endif
/*
#ifndef GTM_NONNULL
#define GTM_NONNULL(x) __attribute__((nonnull(x)))
//#endif
//
//#ifdef __OBJC__
//
//	// Declared here so that it can easily be used for logging tracking if
//	// necessary. See GTMUnitTestDevLog.h for details.
//@class NSString;
//GTM_EXTERN void _GTMUnitTestDevLog(NSString *format, ...);
//


	// Macro to allow you to create NSStrings out of other macros.
	// #define FOO foo
	// NSString *fooString = GTM_NSSTRINGIFY(FOO);
#if !defined (GTM_NSSTRINGIFY)
#define GTM_NSSTRINGIFY_INNER(x) @#x
#define GTM_NSSTRINGIFY(x) GTM_NSSTRINGIFY_INNER(x)
#endif

	// Macro to allow fast enumeration when building for 10.5 or later, and
	// reliance on NSEnumerator for 10.4.  Remember, NSDictionary w/ FastEnumeration
	// does keys, so pick the right thing, nothing is done on the FastEnumeration
	// side to be sure you're getting what you wanted.
#ifndef GTM_FOREACH_OBJECT
#if TARGET_OS_IPHONE || !(MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5)
#define GTM_FOREACH_ENUMEREE(element, enumeration) \
for (element in enumeration)
#define GTM_FOREACH_OBJECT(element, collection) \
for (element in collection)
#define GTM_FOREACH_KEY(element, collection) \
for (element in collection)
#else
#define GTM_FOREACH_ENUMEREE(element, enumeration) \
for (NSEnumerator *_ ## element ## _enum = enumeration; \
(element = [_ ## element ## _enum nextObject]) != nil; )
#define GTM_FOREACH_OBJECT(element, collection) \
GTM_FOREACH_ENUMEREE(element, [collection objectEnumerator])
#define GTM_FOREACH_KEY(element, collection) \
GTM_FOREACH_ENUMEREE(element, [collection keyEnumerator])
#endif
#endif

	//GTMDefines

#import <objc/objc-api.h>
#import <objc/objc-auto.h>



	// The file objc-runtime.h was moved to runtime.h and in Leopard, objc-runtime.h
	// was just a wrapper around runtime.h. For the iPhone SDK, this objc-runtime.h
	// is removed in the iPhoneOS2.0 SDK.

	// The |Object| class was removed in the iPhone2.0 SDK too.
#if GTM_IPHONE_SDK
#import <objc/message.h>
#import <objc/runtime.h>
#else
#import <objc/objc-runtime.h>
#import <objc/Object.h>
#endif

#import <libkern/OSAtomic.h>
#import "objc/Protocol.h"

OBJC_EXPORT Class object_getClass(id obj);
OBJC_EXPORT const char *class_getName(Class cls);
OBJC_EXPORT BOOL class_conformsToProtocol(Class cls, Protocol *protocol);
OBJC_EXPORT BOOL class_respondsToSelector(Class cls, SEL sel);
OBJC_EXPORT Class class_getSuperclass(Class cls);
OBJC_EXPORT Method *class_copyMethodList(Class cls, unsigned int *outCount);
OBJC_EXPORT SEL method_getName(Method m);
OBJC_EXPORT void method_exchangeImplementations(Method m1, Method m2);
OBJC_EXPORT IMP method_getImplementation(Method method);
OBJC_EXPORT IMP method_setImplementation(Method method, IMP imp);
OBJC_EXPORT struct objc_method_description protocol_getMethodDescription(Protocol *p,
                                                                         SEL aSel,
                                                                         BOOL isRequiredMethod,
                                                                         BOOL isInstanceMethod);
OBJC_EXPORT BOOL sel_isEqual(SEL lhs, SEL rhs);

*/



int max(int x, int y)
{
    return x > y ? x : y;
}





	// Released by Drew McCormack into the pubic domain (2010).



#if MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5
#import <stdlib.h>
#import <string.h>

Class object_getClass(id obj) {
	if (!obj) return NULL;
	return obj->isa;
}

const char *class_getName(Class cls) {
	if (!cls) return "nil";
	return cls->name;
}

BOOL class_conformsToProtocol(Class cls, Protocol *protocol) {
		// We intentionally don't check cls as it crashes on Leopard so we want
		// to crash on Tiger as well.
		// I logged
		// Radar 5572978 class_conformsToProtocol crashes when arg1 is passed as nil
		// because it seems odd that this API won't accept nil for cls considering
		// all the other apis will accept nil args.
		// If this does get fixed, remember to enable the unit tests.
	if (!protocol) return NO;

	struct objc_protocol_list *protos;
	for (protos = cls->protocols; protos != NULL; protos = protos->next) {
		for (long i = 0; i < protos->count; i++) {
			if ([protos->list[i] conformsTo:protocol]) {
				return YES;
			}
		}
	}
	return NO;
}

Class class_getSuperclass(Class cls) {
	if (!cls) return NULL;
	return cls->super_class;
}

BOOL class_respondsToSelector(Class cls, SEL sel) {
	return class_getInstanceMethod(cls, sel) != nil;
}

Method *class_copyMethodList(Class cls, unsigned int *outCount) {
	if (!cls) return NULL;

	unsigned int count = 0;
	void *iterator = NULL;
	struct objc_method_list *mlist;
	Method *methods = NULL;
	if (outCount) *outCount = 0;

	while ( (mlist = class_nextMethodList(cls, &iterator)) ) {
		if (mlist->method_count == 0) continue;
		methods = (Method *)realloc(methods,
									sizeof(Method) * (count + mlist->method_count + 1));
		if (!methods) {
				//Memory alloc failed, so what can we do?
			return NULL;  // COV_NF_LINE
		}
		for (int i = 0; i < mlist->method_count; i++) {
			methods[i + count] = &mlist->method_list[i];
		}
		count += mlist->method_count;
	}

		// List must be NULL terminated
	if (methods) {
		methods[count] = NULL;
	}
	if (outCount) *outCount = count;
	return methods;
}

SEL method_getName(Method method) {
	if (!method) return NULL;
	return method->method_name;
}

IMP method_getImplementation(Method method) {
	if (!method) return NULL;
	return method->method_imp;
}

IMP method_setImplementation(Method method, IMP imp) {
		// We intentionally don't test method for nil.
		// Leopard fails here, so should we.
		// I logged this as Radar:
		// 5572981 method_setImplementation crashes if you pass nil for the
		// method arg (arg 1)
		// because it seems odd that this API won't accept nil for method considering
		// all the other apis will accept nil args.
		// If this does get fixed, remember to enable the unit tests.
		// This method works differently on SnowLeopard than
		// on Leopard. If you pass in a nil for IMP on SnowLeopard
		// it doesn't change anything. On Leopard it will. Since
		// attempting to change a sel to nil is probably an error
		// we follow the SnowLeopard way of doing things.
	IMP oldImp = NULL;
	if (imp) {
		oldImp = method->method_imp;
		method->method_imp = imp;
	}
	return oldImp;
}

void method_exchangeImplementations(Method m1, Method m2) {
	if (m1 == m2) return;
	if (!m1 || !m2) return;
	IMP imp2 = method_getImplementation(m2);
	IMP imp1 = method_setImplementation(m1, imp2);
	method_setImplementation(m2, imp1);
}

struct objc_method_description protocol_getMethodDescription(Protocol *p,
                                                             SEL aSel,
                                                             BOOL isRequiredMethod,
                                                             BOOL isInstanceMethod) {
	struct objc_method_description *descPtr = NULL;
		// No such thing as required in ObjC1.
	if (isInstanceMethod) {
		descPtr = [p descriptionForInstanceMethod:aSel];
	} else {
		descPtr = [p descriptionForClassMethod:aSel];
	}

	struct objc_method_description desc;
	if (descPtr) {
		desc = *descPtr;
	} else {
		bzero(&desc, sizeof(desc));
	}
	return desc;
}

BOOL sel_isEqual(SEL lhs, SEL rhs) {
		// Apple (informally) promises this will work in the future:
		// http://twitter.com/#!/gparker/status/2400099786
	return (lhs == rhs) ? YES : NO;
}

#endif








NSString *const AtoZSharedInstanceUpdated = @"AtoZSharedInstanceUpdated";
NSString *const AtoZDockSortedUpdated = @"AtoZDockSortedUpdated";
NSString *const AtoZSuperLayer = @"superlayer";


CGFloat ScreenWidess(){
	return  [[NSScreen mainScreen]frame].size.width;
}
CGFloat ScreenHighness 	(){
	return	[[NSScreen mainScreen]frame].size.height;
}

	//  usage  		profile("Long Task", ^{ performLongTask() } );
void profile (const char *name, void (^work) (void)) {
    struct timeval start, end;
    gettimeofday (&start, NULL);
    work();
    gettimeofday (&end, NULL);

    double fstart = (start.tv_sec * 1000000.0 + start.tv_usec) / 1000000.0;
    double fend = (end.tv_sec * 1000000.0 + end.tv_usec) / 1000000.0;

    printf("%s took %f seconds", name, fend - fstart);
}

CGFloat DegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
}
NSNumber* DegreesToNumber(CGFloat degrees) {
    return [NSNumber numberWithFloat:
            DegreesToRadians(degrees)];
}





/*
 // Defined on 10.6 and above.
 #ifndef NS_FORMAT_ARGUMENT
 #define NS_FORMAT_ARGUMENT(A)
 #endif

 // Defined on 10.6 and above.
 #ifndef NS_FORMAT_FUNCTION
 #define NS_FORMAT_FUNCTION(F,A)
 #endif

 // Defined on 10.6 and above.
 #ifndef CF_FORMAT_ARGUMENT
 #define CF_FORMAT_ARGUMENT(A)
 #endif

 // Defined on 10.6 and above.
 #ifndef CF_FORMAT_FUNCTION
 #define CF_FORMAT_FUNCTION(F,A)
 #endif
 */

#ifndef GTM_NONNULL
#define GTM_NONNULL(x) __attribute__((nonnull(x)))
#endif

/*
 #ifdef __OBJC__

 // Declared here so that it can easily be used for logging tracking if
 // necessary. See GTMUnitTestDevLog.h for details.
 @class NSString;
 GTM_EXTERN void _GTMUnitTestDevLog(NSString *format, ...);

 // Macro to allow you to create NSStrings out of other macros.
 // #define FOO foo
 // NSString *fooString = GTM_NSSTRINGIFY(FOO);
 #if !defined (GTM_NSSTRINGIFY)
 #define GTM_NSSTRINGIFY_INNER(x) @#x
 #define GTM_NSSTRINGIFY(x) GTM_NSSTRINGIFY_INNER(x)
 #endif

 // Macro to allow fast enumeration when building for 10.5 or later, and
 // reliance on NSEnumerator for 10.4.  Remember, NSDictionary w/ FastEnumeration
 // does keys, so pick the right thing, nothing is done on the FastEnumeration
 // side to be sure you're getting what you wanted.
 #ifndef GTM_FOREACH_OBJECT
 #if TARGET_OS_IPHONE || !(MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5)
 #define GTM_FOREACH_ENUMEREE(element, enumeration) \
 for (element in enumeration)
 #define GTM_FOREACH_OBJECT(element, collection) \
 for (element in collection)
 #define GTM_FOREACH_KEY(element, collection) \
 for (element in collection)
 #else
 #define GTM_FOREACH_ENUMEREE(element, enumeration) \
 for (NSEnumerator *_ ## element ## _enum = enumeration; \
 (element = [_ ## element ## _enum nextObject]) != nil; )
 #define GTM_FOREACH_OBJECT(element, collection) \
 GTM_FOREACH_ENUMEREE(element, [collection objectEnumerator])
 #define GTM_FOREACH_KEY(element, collection) \
 GTM_FOREACH_ENUMEREE(element, [collection keyEnumerator])
 #endif
 #endif

 // ============================================================================

 // To simplify support for both Leopard and Snow Leopard we declare
 // the Snow Leopard protocols that we need here.
 #if !defined(GTM_10_6_PROTOCOLS_DEFINED) && !(MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_6)
 #define GTM_10_6_PROTOCOLS_DEFINED 1
 @protocol NSConnectionDelegate
 @end
 @protocol NSAnimationDelegate
 @end
 @protocol NSImageDelegate
 @end
 @protocol NSTabViewDelegate
 @end
 #endif  // !defined(GTM_10_6_PROTOCOLS_DEFINED) && !(MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_6)

 // GTM_SEL_STRING is for specifying selector (usually property) names to KVC
 // or KVO methods.
 // In debug it will generate warnings for undeclared selectors if
 // -Wunknown-selector is turned on.
 // In release it will have no runtime overhead.
 #ifndef GTM_SEL_STRING
 #ifdef DEBUG
 #define GTM_SEL_STRING(selName) NSStringFromSelector(@selector(selName))
 #else
 #define GTM_SEL_STRING(selName) @#selName
 #endif  // DEBUG
 #endif  // GTM_SEL_STRING

 #endif // __OBJC__
 #include <AvailabilityMacros.h>
 #include <TargetConditionals.h>

 #if TARGET_OS_IPHONE
 #include <Availability.h>
 #endif //  TARGET_OS_IPHONE

 // Not all MAC_OS_X_VERSION_10_X macros defined in past SDKs
 #ifndef MAC_OS_X_VERSION_10_5
 #define MAC_OS_X_VERSION_10_5 1050
 #endif
 #ifndef MAC_OS_X_VERSION_10_6
 #define MAC_OS_X_VERSION_10_6 1060
 #endif
 #ifndef MAC_OS_X_VERSION_10_7
 #define MAC_OS_X_VERSION_10_7 1070
 #endif

 // Not all __IPHONE_X macros defined in past SDKs
 #ifndef __IPHONE_3_0
 #define __IPHONE_3_0 30000
 #endif
 #ifndef __IPHONE_3_1
 #define __IPHONE_3_1 30100
 #endif
 #ifndef __IPHONE_3_2
 #define __IPHONE_3_2 30200
 #endif
 #ifndef __IPHONE_4_0
 #define __IPHONE_4_0 40000
 #endif
 #ifndef __IPHONE_4_3
 #define __IPHONE_4_3 40300
 #endif
 #ifndef __IPHONE_5_0
 #define __IPHONE_5_0 50000
 #endif

 // ----------------------------------------------------------------------------
 // CPP symbols that can be overridden in a prefix to control how the toolbox
 // is compiled.
 // ----------------------------------------------------------------------------


 // By setting the GTM_CONTAINERS_VALIDATION_FAILED_LOG and
 // GTM_CONTAINERS_VALIDATION_FAILED_ASSERT macros you can control what happens
 // when a validation fails. If you implement your own validators, you may want
 // to control their internals using the same macros for consistency.
 #ifndef GTM_CONTAINERS_VALIDATION_FAILED_ASSERT
 #define GTM_CONTAINERS_VALIDATION_FAILED_ASSERT 0
 #endif

 // Give ourselves a consistent way to do inlines.  Apple's macros even use
 // a few different actual definitions, so we're based off of the foundation
 // one.
 #if !defined(GTM_INLINE)
 #if (defined (__GNUC__) && (__GNUC__ == 4)) || defined (__clang__)
 #define GTM_INLINE static __inline__ __attribute__((always_inline))
 #else
 #define GTM_INLINE static __inline__
 #endif
 #endif

 // Give ourselves a consistent way of doing externs that links up nicely
 // when mixing objc and objc++
 #if !defined (GTM_EXTERN)
 #if defined __cplusplus
 #define GTM_EXTERN extern "C"
 #define GTM_EXTERN_C_BEGIN extern "C" {
 #define GTM_EXTERN_C_END }
 #else
 #define GTM_EXTERN extern
 #define GTM_EXTERN_C_BEGIN
 #define GTM_EXTERN_C_END
 #endif
 #endif

 // Give ourselves a consistent way of exporting things if we have visibility
 // set to hidden.
 #if !defined (GTM_EXPORT)
 #define GTM_EXPORT __attribute__((visibility("default")))
 #endif

 // Give ourselves a consistent way of declaring something as unused. This
 // doesn't use __unused because that is only supported in gcc 4.2 and greater.
 #if !defined (GTM_UNUSED)
 #define GTM_UNUSED(x) ((void)(x))
 #endif

 // _GTMDevLog & _GTMDevAssert

 // _GTMDevLog & _GTMDevAssert are meant to be a very lightweight shell for
 // developer level errors.  This implementation simply macros to NSLog/NSAssert.
 // It is not intended to be a general logging/reporting system.

 // Please see http://code.google.com/p/google-toolbox-for-mac/wiki/DevLogNAssert
 // for a little more background on the usage of these macros.

 //    _GTMDevLog           log some error/problem in debug builds
 //    _GTMDevAssert        assert if conditon isn't met w/in a method/function
 //                           in all builds.

 // To replace this system, just provide different macro definitions in your
 // prefix header.  Remember, any implementation you provide *must* be thread
 // safe since this could be called by anything in what ever situtation it has
 // been placed in.


 // We only define the simple macros if nothing else has defined this.
 #ifndef _GTMDevLog

 #ifdef DEBUG
 #define _GTMDevLog(...) NSLog(__VA_ARGS__)
 #else
 #define _GTMDevLog(...) do { } while (0)
 #endif

 #endif // _GTMDevLog

 #ifndef _GTMDevAssert
 // we directly invoke the NSAssert handler so we can pass on the varargs
 // (NSAssert doesn't have a macro we can use that takes varargs)
 #if !defined(NS_BLOCK_ASSERTIONS)
 #define _GTMDevAssert(condition, ...)                                       \
 do {                                                                      \
 if (!(condition)) {                                                     \
 [[NSAssertionHandler currentHandler]                                  \
 handleFailureInFunction:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
 file:[NSString stringWithUTF8String:__FILE__]  \
 lineNumber:__LINE__                                  \
 description:__VA_ARGS__];                             \
 }                                                                       \
 } while(0)
 #else // !defined(NS_BLOCK_ASSERTIONS)
 #define _GTMDevAssert(condition, ...) do { } while (0)
 #endif // !defined(NS_BLOCK_ASSERTIONS)

 #endif // _GTMDevAssert

 // _GTMCompileAssert
 // _GTMCompileAssert is an assert that is meant to fire at compile time if you
 // want to check things at compile instead of runtime. For example if you
 // want to check that a wchar is 4 bytes instead of 2 you would use
 // _GTMCompileAssert(sizeof(wchar_t) == 4, wchar_t_is_4_bytes_on_OS_X)
 // Note that the second "arg" is not in quotes, and must be a valid processor
 // symbol in it's own right (no spaces, punctuation etc).

 // Wrapping this in an #ifndef allows external groups to define their own
 // compile time assert scheme.
 #ifndef _GTMCompileAssert
 // We got this technique from here:
 // http://unixjunkie.blogspot.com/2007/10/better-compile-time-asserts_29.html

 #define _GTMCompileAssertSymbolInner(line, msg) _GTMCOMPILEASSERT ## line ## __ ## msg
 #define _GTMCompileAssertSymbol(line, msg) _GTMCompileAssertSymbolInner(line, msg)
 #define _GTMCompileAssert(test, msg) \
 typedef char _GTMCompileAssertSymbol(__LINE__, msg) [ ((test) ? 1 : -1) ]
 #endif // _GTMCompileAssert

 // ----------------------------------------------------------------------------
 // CPP symbols defined based on the project settings so the GTM code has
 // simple things to test against w/o scattering the knowledge of project
 // setting through all the code.
 // ----------------------------------------------------------------------------

 // Provide a single constant CPP symbol that all of GTM uses for ifdefing
 // iPhone code.
 #if TARGET_OS_IPHONE // iPhone SDK
 // For iPhone specific stuff
 #define GTM_IPHONE_SDK 1
 #if TARGET_IPHONE_SIMULATOR
 #define GTM_IPHONE_SIMULATOR 1
 #else
 #define GTM_IPHONE_DEVICE 1
 #endif  // TARGET_IPHONE_SIMULATOR
 // By default, GTM has provided it's own unittesting support, define this
 // to use the support provided by Xcode, especially for the Xcode4 support
 // for unittesting.
 #ifndef GTM_IPHONE_USE_SENTEST
 #define GTM_IPHONE_USE_SENTEST 0
 #endif
 #else
 // For MacOS specific stuff
 #define GTM_MACOS_SDK 1
 #endif

 // Some of our own availability macros
 #if GTM_MACOS_SDK
 #define GTM_AVAILABLE_ONLY_ON_IPHONE UNAVAILABLE_ATTRIBUTE
 #define GTM_AVAILABLE_ONLY_ON_MACOS
 #else
 #define GTM_AVAILABLE_ONLY_ON_IPHONE
 #define GTM_AVAILABLE_ONLY_ON_MACOS UNAVAILABLE_ATTRIBUTE
 #endif

 // Provide a symbol to include/exclude extra code for GC support.  (This mainly
 // just controls the inclusion of finalize methods).
 #ifndef GTM_SUPPORT_GC
 #if GTM_IPHONE_SDK
 // iPhone never needs GC
 #define GTM_SUPPORT_GC 0
 #else
 // We can't find a symbol to tell if GC is supported/required, so best we
 // do on Mac targets is include it if we're on 10.5 or later.
 #if MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5
 #define GTM_SUPPORT_GC 0
 #else
 #define GTM_SUPPORT_GC 1
 #endif
 #endif
 #endif

 // To simplify support for 64bit (and Leopard in general), we provide the type
 // defines for non Leopard SDKs
 #if !(MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
 // NSInteger/NSUInteger and Max/Mins
 #ifndef NSINTEGER_DEFINED
 #if __LP64__ || NS_BUILD_32_LIKE_64
 typedef long NSInteger;
 typedef unsigned long NSUInteger;
 #else
 typedef int NSInteger;
 typedef unsigned int NSUInteger;
 #endif
 #define NSIntegerMax    LONG_MAX
 #define NSIntegerMin    LONG_MIN
 #define NSUIntegerMax   ULONG_MAX
 #define NSINTEGER_DEFINED 1
 #endif  // NSINTEGER_DEFINED
 // CGFloat
 #ifndef CGFLOAT_DEFINED
 #if defined(__LP64__) && __LP64__
 // This really is an untested path (64bit on Tiger?)
 typedef double CGFloat;
 #define CGFLOAT_MIN DBL_MIN
 #define CGFLOAT_MAX DBL_MAX
 #define CGFLOAT_IS_DOUBLE 1
 */
