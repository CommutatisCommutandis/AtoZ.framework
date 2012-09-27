//
//  AtoZFunctions.h
//  AtoZ
//

//#import "AtoZ.h"


//	#define NSLog(args...) _AZSimpleLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);
//NS_INLINE  void QuietLog (const char *file, int lineNumber, const char *funcName, NSString *format, ...);
//#define NSLog(args...) QuietLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args)
//NS_INLINE void _AZLog(const char *file, int lineNumber, const char *funcName, NSString *format,...);
//NS_INLINE NSRect SFCopyRect(NSRect toCopy) {	return NSMakeRect(toCopy.origin.x, toCopy.origin.y, toCopy.size.width, toCopy.size.height); }
//NS_INLINE NSRect SFMakeRect(NSPoint origin, NSSize size) {	return NSMakeRect(origin.x, origin.y, size.width, size.height); }
//NS_INLINE NSPoint SFCopyPoint(NSPoint toCopy) {	return NSMakePoint(toCopy.x, toCopy.y);	}
//static inline CGRect convertToCGRect(NSRect rect) {	return *(const CGRect *)&rect;}
//static inline NSRect convertToNSRect(CGRect rect) { 	return *(const NSRect *)&rect;	}
//static inline NSPoint convertToNSPoint(CGPoint point) {	return *(const NSPoint *)&point;	}
//static inline CGPoint convertToCGPoint(NSPoint point) {	return *(const CGPoint *)&point;	}

extern BOOL IsEmpty(id obj);

extern CGFloat percent(CGFloat val);

extern void ApplicationsInDirectory(NSString *searchPath, NSMutableArray *applications);

static double frandom(double start, double end);

extern void DrawLabelAtCenterPoint(NSString* string, NSPoint center);

extern void DrawGlossGradient(CGContextRef context, NSColor *color, NSRect inRect);

extern CGFloat perceptualGlossFractionForColor(CGFloat *inputComponents);

static void glossInterpolation(void *info, const CGFloat *input, CGFloat *output);

extern void PoofAtPoint( NSPoint pt, CGFloat radius);


//@interface Slice : NSObject
//@property NSInteger start;
//@property NSInteger length;
//@end

//@interface NSArray (Slicing)
//- (id)objectForKeyedSubscript: (id)subscript;
//@end

//@interface NSNumber (SliceCreation)
//- (Slice *): (NSInteger)length;
//@end


/*
	// make sure non-Clang compilers can still compile
#ifndef __has_feature
#define __has_feature(x) 0
#endif

	// no ARC ? -> declare the ARC attributes we use to be a no-op, so the compiler won't whine
#if ! __has_feature( objc_arc )
#define __autoreleasing
#define __bridge
#endif


#define ARRAY(...) ([NSArray arrayWithObjects: IDARRAY(__VA_ARGS__) count: IDCOUNT(__VA_ARGS__)])
#define SET(...) ([NSSet setWithObjects: IDARRAY(__VA_ARGS__) count: IDCOUNT(__VA_ARGS__)])

	// this is key/object order, not object/key order, thus all the fuss
#define DICT(...) MADictionaryWithKeysAndObjects(IDARRAY(__VA_ARGS__), IDCOUNT(__VA_ARGS__) / 2)

#define MAP(collection, ...) EACH_WRAPPER([collection ma_map: ^id (id obj) { return (__VA_ARGS__); }])
#define SELECT(collection, ...) EACH_WRAPPER([collection ma_select: ^BOOL (id obj) { return (__VA_ARGS__) != 0; }])
#define REJECT(collection, ...) EACH_WRAPPER([collection ma_select: ^BOOL (id obj) { return (__VA_ARGS__) == 0; }])
#define MATCH(collection, ...) EACH_WRAPPER([collection ma_match: ^BOOL (id obj) { return (__VA_ARGS__) != 0; }])
#define REDUCE(collection, initial, ...) EACH_WRAPPER([collection ma_reduce: (initial) block: ^id (id a, id b) { return (__VA_ARGS__); }])

#define EACH(array) MAEachHelper(array, &MA_eachTable)
*/

/**  Sometimes it's useful to work on multiple arrays in parallel. For example, imagine that you have two arrays of strings and you want to create a third array that contains the contents of the two arrays combined into a single string. With MACollectionUtilities this is extremely easy:
*/

//	NSArray *first = ARRAY(@"alpha", @"air", @"bicy");
//	NSArray *second = ARRAY(@"bet", @"plane", @"cle");
//	NSArray *words = MAP(first, [obj stringByAppendingString: EACH(second)]);

// 		words now contains alphabet, airplane, bicycle

/*** The EACH macro depends on context set up by the other macros. You can only use it with the macros, not with the methods.
	You can use multiple arrays with multiple EACH macros to enumerate several collections in parallel:
***/

///	NSArray *result = MAP(objects, [obj performSelector: NSSelectorFromString(EACH(selectorNames))
///                                        withObject: EACH(firstArguments)
///										withObject: EACH(secondArguments)];

/*** The EACH macro works by creating and tracking an NSEnumerator internally. It lazily creates the enumerator on the first use, and then uses nextObject at each call. Thus if your arrays are not the same length, it will begin to return nil, watch out.

Because they are unordered, parallel enumeration doesn't make sense for NSSet and EACH is not supported for them.
***/

/*
#define SORTED(collection, ...) [collection ma_sorted: ^BOOL (id a, id b) { return (__VA_ARGS__) != 0; }]

	// ===========================================================================
	// internal utility whatnot that needs to be externally visible for the macros
#define IDARRAY(...) ((__autoreleasing id[]){ __VA_ARGS__ })
#define IDCOUNT(...) (sizeof(IDARRAY(__VA_ARGS__)) / sizeof(id))
#define EACH_WRAPPER(...) (^{ __block CFMutableDictionaryRef MA_eachTable = nil; \
(void)MA_eachTable; \
__typeof__(__VA_ARGS__) MA_retval = __VA_ARGS__; \
if(MA_eachTable) \
CFRelease(MA_eachTable); \
return MA_retval; \
}())

static inline NSDictionary *MADictionaryWithKeysAndObjects(id *keysAndObjs, NSUInteger count)
{
    id keys[count];
    id objs[count];
    for(NSUInteger i = 0; i < count; i++)
    {
        keys[i] = keysAndObjs[i * 2];
        objs[i] = keysAndObjs[i * 2 + 1];
    }

    return [NSDictionary dictionaryWithObjects: objs forKeys: keys count: count];
}

static inline id MAEachHelper(NSArray *array, CFMutableDictionaryRef *eachTablePtr)
{
    if(!*eachTablePtr)
    {
        CFDictionaryKeyCallBacks keycb = {
            0,
            kCFTypeDictionaryKeyCallBacks.retain,
            kCFTypeDictionaryKeyCallBacks.release,
            kCFTypeDictionaryKeyCallBacks.copyDescription,
            NULL,
            NULL
        };
        *eachTablePtr = CFDictionaryCreateMutable(NULL, 0, &keycb, &kCFTypeDictionaryValueCallBacks);
    }

    NSEnumerator *enumerator = (__bridge id)CFDictionaryGetValue(*eachTablePtr, (__bridge CFArrayRef)array);
    if(!enumerator)
    {
        enumerator = [array objectEnumerator];
        CFDictionarySetValue(*eachTablePtr, (__bridge CFArrayRef)array, (__bridge void *)enumerator);
    }
    return [enumerator nextObject];
}

*/








CGFloat DegreesToRadians(CGFloat degrees);
NSNumber* DegreesToNumber(CGFloat degrees);






	//CGFloat DEGREEtoRADIAN(CGFloat degrees) {return degrees * M_PI / 180;};
	//CGFloat RADIANtoDEGREEES(CGFloat radians) {return radians * 180 / M_PI;};

CGImageRef ApplyQuartzComposition(const char* compositionName, const CGImageRef srcImage);

static inline float RandomComponent() {  return (float)random() / (float)LONG_MAX; }





/*
 extern NSArray* iconic = [iconicStrings array]
 static NSArray* iconicStrings = @[ @"ampersand.pdf", @"aperture_alt.pdf", @"aperture.pdf", @"arrow_down_alt1.pdf", @"arrow_down_alt2.pdf", @"arrow_down.pdf", @"arrow_left_alt1.pdf", @"arrow_left_alt2.pdf", @"arrow_left.pdf", @"arrow_right_alt1.pdf", @"arrow_right_alt2.pdf", @"arrow_right.pdf", @"arrow_up_alt1.pdf", @"arrow_up_alt2.pdf", @"arrow_up.pdf", @"article.pdf", @"at.pdf", @"award_fill.pdf", @"award_stroke.pdf", @"bars_alt.pdf", @"bars.pdf", @"battery_charging.pdf", @"battery_empty.pdf", @"battery_full.pdf", @"battery_half.pdf", @"beaker_alt.pdf", @"beaker.pdf", @"bolt.pdf", @"book_alt.pdf", @"book_alt2.pdf", @"book.pdf", @"box.pdf", @"brush_alt.pdf", @"brush.pdf", @"calendar_alt_fill.pdf", @"calendar_alt_stroke.pdf", @"calendar.pdf", @"camera.pdf", @"cd.pdf", @"chart_alt.pdf", @"chart.pdf", @"chat_alt_fill.pdf", @"chat_alt_stroke.pdf", @"chat.pdf", @"check_alt.pdf", @"check.pdf", @"clock.pdf", @"cloud_download.pdf", @"cloud_upload.pdf", @"cloud.pdf", @"cog_alt.pdf", @"cog.pdf", @"comment_alt1_fill.pdf", @"comment_alt1_stroke.pdf", @"comment_alt2_fill.pdf", @"comment_alt2_stroke.pdf", @"comment_alt3_fill.pdf", @"comment_alt3_stroke.pdf", @"comment_fill.svg.pdf", @"comment_stroke.svg.pdf", @"compass.svg.pdf", @"cursor.svg.pdf", @"curved_arrow.svg.pdf", @"denied_alt.svg.pdf", @"denied.svg.pdf", @"dial.svg.pdf", @"document_alt_fill.svg.pdf", @"document_alt_stroke.svg.pdf", @"document_fill.svg.pdf", @"document_stroke.svg.pdf", @"download.svg.pdf", @"eject.svg.pdf", @"equalizer.svg.pdf", @"eye.svg.pdf", @"eyedropper.svg.pdf", @"first.svg.pdf", @"folder_fill.svg.pdf", @"folder_stroke.svg.pdf", @"fork.svg.pdf", @"fullscreen_alt.svg.pdf", @"fullscreen_exit_alt.svg.pdf", @"fullscreen_exit.svg.pdf", @"fullscreen.svg.pdf", @"hash.svg.pdf", @"headphones.svg.pdf", @"heart_fill.svg.pdf", @"heart_stroke.svg.pdf", @"home.svg.pdf", @"image.svg.pdf", @"info.svg.pdf", @"iphone.svg.pdf", @"key_fill.svg.pdf", @"key_stroke.svg.pdf", @"last.svg.pdf", @"layers_alt.svg.pdf", @"layers.svg.pdf", @"left_quote_alt.svg.pdf", @"left_quote.svg.pdf", @"lightbulb.svg.pdf", @"link.svg.pdf", @"list.svg.pdf", @"lock_fill.svg.pdf", @"lock_stroke.svg.pdf", @"loop_alt1.svg.pdf", @"loop_alt2.svg.pdf", @"loop_alt3.svg.pdf", @"loop_alt4.svg.pdf", @"loop.svg.pdf", @"magnifying_glass_alt.svg.pdf", @"magnifying_glass.svg.pdf", @"mail_alt.svg.pdf", @"mail.svg.pdf", @"map_pin_alt.svg.pdf", @"map_pin_fill.svg.pdf", @"map_pin_stroke.svg.pdf", @"mic.svg.pdf", @"minus_alt.svg.pdf", @"minus.svg.pdf", @"moon_fill.svg.pdf", @"moon_stroke.svg.pdf", @"move_alt1.svg.pdf", @"move_alt2.svg.pdf", @"move_horizontal_alt1.svg.pdf", @"move_horizontal_alt2.svg.pdf", @"move_horizontal.svg.pdf", @"move_vertical_alt1.svg.pdf", @"move_vertical_alt2.svg.pdf", @"move_vertical.svg.pdf", @"move.svg.pdf", @"movie.svg.pdf", @"new_window.svg.pdf", @"pause.svg.pdf", @"pen_alt_fill.svg.pdf", @"pen_alt_stroke.svg.pdf", @"pen_alt2.svg.pdf", @"pen.svg.pdf", @"pilcrow.svg.pdf", @"pin.svg.pdf", @"play_alt.svg.pdf", @"play.svg.pdf", @"plus_alt.svg.pdf", @"plus.svg.pdf", @"question_mark.svg.pdf", @"rain.svg.pdf", @"read_more.svg.pdf", @"reload_alt.svg.pdf", @"reload.svg.pdf", @"right_quote_alt.svg.pdf", @"right_quote.svg.pdf", @"rss_alt.svg.pdf", @"rss.svg.pdf", @"share.svg.pdf", @"spin_alt.svg.pdf", @"spin.svg.pdf", @"star.svg.pdf", @"steering_wheel.svg.pdf", @"stop.svg.pdf", @"sun_alt_fill.svg.pdf", @"sun_alt_stroke.svg.pdf", @"sun.svg.pdf", @"tag_fill.svg.pdf", @"tag_stroke.svg.pdf", @"target.pdf", @"transfer.pdf", @"trash_fill.pdf", @"trash_stroke.pdf", @"umbrella.pdf", @"undo.pdf", @"unlock_fill.pdf", @"unlock_stroke.pdf", @"upload.pdf", @"user.pdf", @"volume_mute.pdf", @"volume.pdf", @"wrench.pdf", @"x_alt.pdf", @"x.pdf"];
 */

