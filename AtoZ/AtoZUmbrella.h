
#pragma mark - Color Logging

/*	Foreground color:
		Insert the ESCAPE_SEQ into your string, followed by "fg124,12,255;" where r=124, g=12, b=255.
	Background color:
		Insert the ESCAPE_SEQ into your string, followed by "bg12,24,36;" where r=12, g=24, b=36.
	Reset the foreground color (to default value):
		Insert the ESCAPE_SEQ into your string, followed by "fg;"
	Reset the background color (to default value):
		Insert the ESCAPE_SEQ into your string, followed by "bg;"
	Reset the foreground and background color (to default values) in one operation:
		Insert the ESCAPE_SEQ into your string, followed by ";"
*/
#define XCODE_COLORS_ESCAPE_MAC @"\033["
#define XCODE_COLORS_ESCAPE_IOS @"\xC2\xA0["

#if TARGET_OS_IPHONE
#define XCODE_COLORS_ESCAPE  XCODE_COLORS_ESCAPE_IOS
#else
#define XCODE_COLORS_ESCAPE  XCODE_COLORS_ESCAPE_MAC
#endif

#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color


#define COLOR_RESET XCODE_COLORS_RESET
#define COLOR_ESC XCODE_COLORS_ESCAPE
#define COLOR_WARN COLOR_ESC @"fg:74,203,68;"
//#define MAKEWARN(A) [NSString stringWithFormat:@"%@ %@ %@", COLOR_WARN, (A), COLOR_RESET]

//#define WARN(A) NSLog(@"%@", MAKEWARN(A))

#define XCODE_COLORS 0

#pragma mark - GLOBAL CONSTANTS



#define BLKVIEW BNRBlockView
#define CAA CAAnimation
#define CAAG CAAnimationGroup
#define CABA CABasicAnimation
#define CAGA CAGroupAnimation
#define CAGL CAGradientLayer
#define CAKA CAKeyframeAnimation
#define CAL CALayer
#define CALNA CALayerNonAnimating
#define CALNH CALayerNoHit
#define CAMTF CAMediaTimingFunction
#define CASLNH CAShapeLayerNoHit
#define CASHL CAShapeLayer
#define CASCRLL CAScrollLayer
//#define CASHL CAShapeLayer
#define CASL CAShapeLayer
#define CATLNH CATextLayerNoHit
#define CAT CATransaction
#define CAT3 CATransform3D
#define CAT3D CATransform3D
#define CAT3DR CATransform3DRotate
#define CAT3DTR CATransform3DTranslate
#define CATL CATransformLayer
#define CATXTL CATextLayer

#define CATRANNY CATransition
#define CFTI CFTimeInterval
#define CGCR CGColorRef
#define CGF CGFloat
#define CGP CGPoint
#define CGPR CGPathRef
#define CGR CGRect
#define CGS CGSize
#define CGSZ CGSize
#define CIF CIFilter

#define IBO IBOutlet
#define IBA IBAction
#define ID3D CATransform3DIdentity

#define AZRUNFOREVER [NSRunLoop.currentRunLoop runMode:NSDefaultRunLoopMode beforeDate:NSDate.distantFuture]

#define CGRGB CGColorCreateGenericRGB
#define CGCREF CGContextRef

#define JSCREF JSContextRef
#define CGWL CGWindowLevel

#define NSA NSArray
#define NSACLASS NSArray.class
#define NSAorDCLASS @[NSArray.class, NSDictionary.class]

#define ISADICT isKindOfClass:NSDictionary.class
#define ISANARRAY isKindOfClass:NSArray.class
#define ISADICTorARRAY isKindOfAnyClass:NSAorDCLASS

#define NSSCLASS NSString.class

#define NSAPP NSApplication
#define NSAC NSArrayController
#define NSAS NSAttributedString
#define NSAT NSAffineTransform
#define NSB NSBundle
#define NSBUTT NSButton
#define NSBP NSBezierPath
#define NSBIR NSBitmapImageRep
#define NSBLO NSBlockOperation

#define NSCOMPR NSComparisonResult
#define NSDE NSDirectoryEnumerator
#define NSGC NSGraphicsContext
#define NSC NSColor
#define NSCL NSColorList
#define NSCS NSCountedSet
#define NSD NSDictionary
#define NSDCLASS NSDictionary.class
#define NSE NSEvent
#define NSERR NSError
#define NSF NSFont
#define NSG NSGradient

#define NSI NSInteger
#define NSIP NSIndexPath
#define NSIMG NSImage
#define NSIS NSIndexSet
#define NSIV NSImageView
#define NSMA NSMutableArray
#define NSMAS NSMutableAttributedString
#define NSMD NSMutableDictionary
#define NSM NSMenu
#define NSMI NSMenuItem
#define NSMenuI	NSMenuItem
#define NSMS NSMutableString
#define NSMSet NSMutableSet
#define NSMIS NSMutableIndexSet
#define NSMPS NSMutableParagraphStyle
#define NSN NSNumber
#define NSNOT NSNotification
#define NSO NSObject
#define NSOQ NSOperationQueue
#define NSOP NSOperation
#define AZOQMAX NSOperationQueueDefaultMaxConcurrentOperationCount

#define NSP NSPoint
#define NSPInRect NSPointInRect
#define NSPI NSProgressIndicator
#define NSPUBUTT NSPopUpButton
#define NSR NSRect
#define NSRNG NSRange

#define NSRFill NSRectFill
#define NSS NSString
#define NSSI NSStatusItem
#define NSSHDW NSShadow
#define NSSZ NSSize
#define NSST NSSet
#define NST NSTimer
#define NSSV NSScrollView

#define NSTA NSTrackingArea
#define NSTI NSTimeInterval
#define NSTV NSTableView
#define NSTC NSTableColumn
#define NSTXTF NSTextField
#define NSTXTV NSTextView
#define NSUI NSUInteger

#define NSURLC NSURLConnection
#define NSMURLREQ 	NSMutableURLRequest
#define NSURLREQ NSURLRequest
#define NSURLRES NSURLResponse
#define NSV NSView
#define NSVC NSViewController
#define NSWC NSWindowController
#define NSVAL NSValue
#define NSVT NSValueTransformer

#define NSTABV NSTabView
#define NSTBAR NSToolbar
#define NSW NSWindow


#define TUINSV TUINSView
#define TUINSW TUINSWindow
#define TUIV TUIView

#define VBLK VoidBlock

#define NSWINDOWINIT(A,B) [NSWindow.alloc initWithContentRect:A styleMask:( B ?: NSResizableWindowMask) backing:NSBackingStoreBuffered defer:NO]

#define AZWINDOWINIT NSWINDOWINIT

#define AZBORDLESSWINDOWINIT(A) [NSWindow.alloc initWithContentRect:A styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO] // screen:self.screen];
#define AZTEMPD NSTemporaryDirectory()

#define RNG AZRange
#define SHAREDLOG [DDTTYLogger sharedInstance]

//#define ID \(NSObject*\)
#define lMGR layoutManager
#define bgC backgroundColor
#define fgC foregroundColor
#define arMASK autoresizingMask
#define mTB masksToBounds
#define cRadius cornerRadius
#define aPoint anchorPoint
#define NDOBC needsDisplayOnBoundsChange
#define nDoBC needsDisplayOnBoundsChange
#define CASIZEABLE kCALayerWidthSizable | kCALayerHeightSizable
#define NSSIZEABLE NSViewHeightSizable | NSViewWidthSizable

#define NSSIZEABLE NSViewHeightSizable | NSViewWidthSizable

#define sepByCharsInSet componentsSeparatedByCharactersInSet
#define sepByString componentsSeparatedByString
#define sansLast arrayByRemovingLastObject

#define removedOnC removedOnCompletion




#define pBCN postsBoundsChangedNotifications
#define pFCN postsFrameChangedNotifications

#define vFk valueForKey
#define pV pointValue
#define rV rectValue
#define fV floatValue
#define loM layoutManager
#define sblrs sublayers
#define zPos zPosition
#define NSZeroRange NSMakeRange(0,0)

#define REQ RouteRequest
#define RES RouteResponse
#define $SHORT(A,B) [Shortcut.alloc initWithURI:A syntax:B]
#define	vLOG(A)	[((AppDelegate*)[NSApp sharedApplication].delegate).textOutField appendToStdOutView:A] // $(@"%s: %@", __PRETTY_FUNCTION__, [NSString stringWithFormat: args])]


#define LOCALIZED_STRING(key) [[NSBundle bundleForClass:[AtoZ class]]localizedStringForKey:(key) value:@"" table:nil]
/* You cannot take the address of a return value like that, only a variable. Thus, you’d have to put the result in a temporary variable:
 The way to get around this problem is use another GCC extension allowing statements in expressions. Thus, the macro creates a temporary variable, _Y_, with the same type of _X_ (again using typeof) and passes the address of this temporary to the function.
 http://www.dribin.org/dave/blog/archives/2008/09/22/convert_to_nsstring/
 */
#define AZString(_X_) ({typeof(_X_) _Y_ = (_X_);\
AZToStringFromTypeAndValue(@encode(typeof(_X_)), &_Y_);})

#pragma mark - CONSTANT defines

#define AZIDCAA (id<CAAction>)

#define RONLY readonly
#define RDWRT readwrite
#define ASSGN assign
#define NATOM nonatomic
#define STRNG strong
#define ASS assign
#define CP copy
#define SET setter
#define GET getter
#define WK weak
#define UNSF unsafe_unretained
#define prop property
#define IBO IBOutlet

#define setPBCN setPostsBoundsChangedNotifications:YES
#define setPFCN setPostsFrameChangedNotifications:YES

#define pBCN postsBoundsChangedNotifications
#define pFCN postsFrameChangedNotifications


#define NSKVOBEFOREAFTER NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
#define KVONEW NSKeyValueObservingOptionNew
#define KVOOLD NSKeyValueObservingOptionOld


#define NSEVENTLOCALMASK NSEvent addLocalMonitorForEventsMatchingMask
#define NSEVENTGLOBALMASK NSEvent addGlobalMonitorForEventsMatchingMask


#define MOUSEDRAG NSLeftMouseDraggedMask
#define MOUSEUP NSLeftMouseUpMask
#define MOUSEDOWN NSLeftMouseDownMask
#define MOUSEDRAGGING MOUSEDOWN | MOUSEDRAG | MOUSEUP

#define FUTURE NSDate.distantFuture


#define kIMG 	@"image"
#define kCLR 	@"color"
#define kIDX 	@"index"
#define kLAY 	@"layer"
#define kPOS 	@"position"
#define kPSTRING @"pString"
#define kSTR 	@"string"
#define kFRM 	@"frame"
#define kHIDE 	@"hide"

#define AZFWORKBUNDLE [NSBundle bundleForClass:[AtoZ class]]
#define AZFWRESOURCES [AZFWORKBUNDLE resourcePath]

#define  AZAPPBUNDLE [NSBundle mainBundle]
#define  AZAPPRESOURCES [[NSBundle mainBundle]resourcePath]

#define   CAMEDIAEASEOUT [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]
#define   CAMEDIAEASEIN [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]
#define   CAMEDIAEASY [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]
#define   AZWORKSPACE [NSWorkspace sharedWorkspace]
#define	AZUSERDEFS [NSUserDefaults standardUserDefaults]
#define	AZUSERDEFSCTR [NSUserDefaultsController sharedUserDefaultsController]
#define   AZNOTCENTER [NSNotificationCenter defaultCenter]
#define AZFILEMANAGER [NSFileManager defaultManager]
#define AZGRAPHICSCTX [NSGraphicsContext currentContext]
#define AZCURRENTCTX AZGRAPHICSCTX
#define  AZQTZCONTEXT [[NSGraphicsContext currentContext] graphicsPort]
#define   AZSHAREDAPP [NSApplication sharedApplication]
#define   AZWEBPREFS [WebPreferences standardPreferences]


#define AZPROCINFO [NSProcessInfo processInfo]
#define AZPROCNAME [NSProcessInfo.processInfo processName]


#pragma mark - MACROS

#define DCHECK(__CONDITION__)
//#define check(x)		if (!(x)) return 0;
#define NOT_REACHED() \
do { \
AZLOG(@"<INTERNAL INCONSISTENCY>"); \
} while (0)


//#define loMismo isEqualToString

#define APP_NAME [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]
#define APP_VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
#define OPEN_URL(urlString) [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:urlString]]

/* Retrieving preference values */

#define PREF_KEY_VALUE(x) [[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:(x)]
#define PREF_KEY_BOOL(x) [(PREF_KEY_VALUE(x)) boolValue]
#define PREF_SET_KEY_VALUE(x, y) [[[NSUserDefaultsController sharedUserDefaultsController] values] setValue:(y) forKey:(x)]
#define PREF_OBSERVE_VALUE(x, y) [[NSUserDefaultsController sharedUserDefaultsController] addObserver:y forKeyPath:x options:NSKeyValueObservingOptionOld context:nil]

/* key, observer, object */

#define OB_OBSERVE_VALUE(x, y, z) [(z) addObserver:y forKeyPath:x options:NSKeyValueObservingOptionOld context:nil];
#define AZBUNDLE [NSBundle bundleForClass:[AtoZ class]]

#define AZLocalizedString(key) NSLocalizedStringFromTableInBundle(key,nil,AZBUNDLE,nil)

//#define AZLocalizedString(key, comment) NSLocalizedStringFromTableInBundle((key)nil, [NSBundle bundleWithIdentifier:AZBUNDLE,(comment))

//Usage:
//AZLocalizedString(@"ZeebaGreeting", @"Huluu zeeba")
//+ (NSString*)typeStringForType:(IngredientType)_type {
//	NSString *key = [NSString stringWithFormat:@"IngredientType_%i", _type];
//	return NSLocalizedString(key, nil);
//}


//typedef ((NSTask*)(^launchMonitorReturnTask) NSTask* task);
//typedef (^TaskBlock);
//#define AZLAUNCHMONITORRETURNTASK(A) ((NSTask*)(^launchMonitorReturnTask)(A))
// ^{ [A launch]; monitorTask(A); return A; }()

#define AZNEWPIPE NSPipe.pipe
#define AZNEWMUTEA NSMutableArray.array
#define AZNEWMUTED NSMutableDictionary.new

#define AZSTRONGSTRING(A) @property (nonatomic, strong) NSString* A
#define AZPROP(A,B) @property (nonatomic, strong) A* B
#define AZPROPASS(A,B) @property (NATOM,ASS) A B
#define AZPROPIBO(A,B) @property (ASS) IBOutlet A *B

//#define PROPSTRONG (@property (nonatomic,strong) )
//#define PROPASSIGN (@property (nonatomic,assign) )

#define UNSFE unsafe_unretained
//#define STRONG ((nonatomic,strong) )
//#define ASSIGN ((nonatomic,assign) )

#define CGSUPRESSINTERVAL(x) CGEventSourceSetLocalEventsSuppressionInterval(nil,x)
#define AZPOS AZWindowPosition

#define AZSSOQ AZSharedSingleOperationQueue()
#define AZSOQ AZSharedOperationQueue()
#define AZOS AZSharedOperationStack()

#define AZNULL [NSNull null]
#define ELSENULL ?: [NSNull null]
#define AZGView AtoZGridView
#define AZGVItem AtoZGridViewItem
#define AZP AZPalette
#define AZIS AZInstallationStatus




#define performDelegateSelector(sel) if ([delegate respondsToSelector:sel]) { [delegate performSelector:sel]; }
#define performBlockIfDelegateRespondsToSelector(block, sel) if ([delegate respondsToSelector:sel]) { block(); }


#define AZBindSelector(observer,sel,keypath,obj) [AZNOTCENTER addObserver:observer selector:sel name:keypath object:obj]

#define AZBind(binder,binding,toObj,keyPath) [binder bind:binding toObject:toObj withKeyPath:keyPath options:nil]

#define  AZLAYOUTMGR [CAConstraintLayoutManager layoutManager]

#define  AZTALK(log) 	 [[AZTalker new] say:log]
#define  AZBezPath(rect) [NSBezierPath bezierPathWithRect:rect]
#define  NSBezPath(rect) AZBezPath(rect)
#define  AZQtzPath(rect) [[NSBezierPath bezierPathWithRect:rect]quartzPath]

#define AZContentBounds [[[self window]contentView]bounds]

#define  AZVinstall(p) [NSValue valueWithInstallStatus:	  p]
#define  AZVposi(p) [NSValue valueWithPosition:	  p]
#define AZVpoint(p) [NSValue valueWithPoint:		 p]
#define  AZVrect(r) [NSValue valueWithRect:		  r]
#define  AZVsize(s) [NSValue valueWithSize:		  s]
#define   AZV3d(t) [NSValue valueWithCATransform3D: t]

#define kContentTitleKey @"itemTitle"
#define kContentColorKey @"itemColor"
#define kContentImageKey @"itemImage"
#define kItemSizeSliderPositionKey @"ItemSizeSliderPosition"


#define CATransform3DPerspective(t, x, y) (CATransform3DConcat(t, CATransform3DMake(1, 0, 0, x, 0, 1, 0, y, 0, 0, 1, 0, 0, 0, 0, 1)))
#define CATransform3DMakePerspective(x, y) (CATransform3DPerspective(CATransform3DIdentity, x, y))


#define AZSuperLayerSuper (@"superlayer")

#define CATIMENOW CACurrentMediaTime()

//#define CACcWA CAConstraint constraintWithAttribute

#define AZConstraint(attr,rel) [CAConstraint constraintWithAttribute \
:attr relativeTo:rel attribute:attr]

#define AZConst(attrib, relate) [CAConstraint constraintWithAttribute: \
attrib relativeTo:rel attribute:attrib]

#define AZConstScaleOff(attr, rel, scl, off) [CAConstraint constraintWithAttribute\
:attr relativeTo:rel attribute:attr scale:scl offset:off]

#define AZConstRelSuper(attr) [CAConstraint constraintWithAttribute\
:attr relativeTo:@"superlayer" attribute:attr]

#define AZConstRelSuperScaleOff(attr, scl, off) [CAConstraint constraintWithAttribute\
:attr relativeTo:AZSuperLayerSuper attribute:attr scale:scl offset:off]

#define AZConstAttrRelNameAttrScaleOff(attr1, relName, attr2, scl, off) [CAConstraint constraintWithAttribute:\
attr1 relativeTo:relName attribute:attr2 scale:scl offset:off]

#define AZTArea(frame) [[NSTrackingArea alloc] initWithRect:frame options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingInVisibleRect | NSTrackingMouseMoved ) owner:self userInfo:nil]

#define AZTAreaInfo(frame,info) [[NSTrackingArea alloc] initWithRect: frame options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingInVisibleRect | NSTrackingMouseMoved ) owner:self userInfo:info];
#define CLAMP(value, lowerBound, upperbound) MAX( lowerBound, MIN( upperbound, value ))

#define AZDistance(A,B) sqrtf(powf(fabs(A.x - B.x), 2.0f) + powf(fabs(A.y - B.y), 2.0f))
#define rand() (arc4random() % ((unsigned)RAND_MAX + 1))

#define NEG(a) -a
#define HALF(a) (a / 2.0)

//#define MAX(a, b) ((a) > (b) ? (a) : (b))
//#define MIN(a, b) ((a) < (b) ? (a) : (b))


#define AZLOG(a) NSLog(@"%@", a)

//static inline void AZLOG(id args){ _AZSimpleLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args); }

#define StringFromBOOL(b) (b?@"YES":@"NO")

//#define YESNO ( b )		  ( (b) ? @"YES" : @"NO" )
//#define YESNO ( b )	b ? @"YES" : @"NO"

// degree to radians
#define ARAD 0.017453f
#define DEG2RAD(x) ((x)*ARAD)
#define P(x,y) CGPointMake(x, y)
#define R(x,y) CGRectMake(0,0,x, y)
#define S(w,h) NSMakeSize(w,h)

#define TWOPI (2 * 3.1415926535)

#define RAD2DEG (rad) (rad * 180.0f / M_PI)
//returns float in range 0 - 1.0f
//usage RAND01()*3, or (int)RAND01()*3 , so there is no risk of dividing by zero

#define RAND01() ((random() / (float)0x7fffffff ))


#define NOISY(C)   [C colorWithNoiseWithOpacity:.2 andBlendMode:kCGBlendModeMultiply]
#define RANDOMNOISYCOLOR  NOISY(RANDOMCOLOR)

//#define rand() (arc4random() % ((unsigned)RAND_MAX + 1))
#define LINEN [NSColor linen]
#define RANDOMLINEN [NSColor linenTintedWithColor:RANDOMCOLOR]
#define CHECKERS [NSColor checkerboardWithFirstColor: BLACK secondColor: WHITE squareWidth:25]

#define RED				[NSColor colorWithCalibratedRed:0.797 green:0.000 blue:0.043 alpha:1.000]
#define ORANGE			[NSColor colorWithCalibratedRed:0.888 green:0.492 blue:0.000 alpha:1.000]
#define YELLOw			[NSColor colorWithCalibratedRed:0.830 green:0.801 blue:0.277 alpha:1.000]
#define GREEN			[NSColor colorWithCalibratedRed:0.367 green:0.583 blue:0.179 alpha:1.000]
#define BLUE			[NSColor colorWithCalibratedRed:0.267 green:0.683 blue:0.979 alpha:1.000]
#define BLACK			[NSColor blackColor]
#define GREY			[NSColor grayColor]
#define WHITE			[NSColor whiteColor]
#define RANDOMCOLOR		[NSColor randomColor]
#define CLEAR			[NSColor clearColor]
#define PURPLE 			[NSColor colorWithCalibratedRed:0.617 green:0.125 blue:0.628 alpha:1.000]
#define LGRAY			[NSColor colorWithCalibratedWhite:.5 alpha:.6]
#define GRAY1			[NSColor colorWithCalibratedWhite:.1 alpha:1]
#define GRAY2			[NSColor colorWithCalibratedWhite:.2 alpha:1]
#define GRAY3			[NSColor colorWithCalibratedWhite:.3 alpha:1]
#define GRAY4			[NSColor colorWithCalibratedWhite:.4 alpha:1]
#define GRAY5			[NSColor colorWithCalibratedWhite:.5 alpha:1]
#define GRAY6			[NSColor colorWithCalibratedWhite:.6 alpha:1]
#define GRAY7			[NSColor colorWithCalibratedWhite:.7 alpha:1]
#define GRAY8			[NSColor colorWithCalibratedWhite:.8 alpha:1]
#define GRAY9			[NSColor colorWithCalibratedWhite:.9 alpha:1]

#define cgRED			[RED 		 			CGColor]
#define cgORANGE		[ORANGE 	 			CGColor]
#define cgYELLOW		[YELLOW		 			CGColor]
#define cgGREEN			[GREEN		 			CGColor]
#define cgPURPLE		[PURPLE		 			CGColor]
#define cgRANDOMCOLOR	[RANDOMCOLOR 			CGColor]

#define cgBLUE			[[NSColor  blueColor]	CGColor]
#define cgBLACK			[[NSColor blackColor]	CGColor]
#define cgGREY			[[NSColor  grayColor]	CGColor]
#define cgWHITE			[[NSColor whiteColor]	CGColor]
#define cgCLEARCOLOR	[[NSColor clearColor]	CGColor]

#define RANDOMGRAY [NSColor colorWithDeviceWhite:RAND_FLOAT_VAL(0,1) alpha:1]
#define cgRANDOMGRAY CGColorCreateGenericGray( RAND_FLOAT_VAL(0,1), 1)
#define kBlackColor 	[[NSColor  blackColor]	CGColor]
#define kWhiteColor 	[[NSColor  whiteColor]	CGColor]
#define kHighlightColor [[NSColor randomColor]  CGColor]
#define kRedColor   	[[NSColor	redColor]  CGColor]
#define kLightBlueColor [[NSColor   blueColor]	CGColor]

#define CGSHADOW(A) CGColorCreate( kCGColorSpaceGenericGray, {0.0, 0.0, A})
#define CGPATH(A)	CGPathCreateWithRect(R)

#define kTranslucentGrayColor CGColorCreate( kCGColorSpaceGenericGray, {0.0, 0.5, 1.0})
#define kTranslucentLightGrayColor cgGREY
#define	kAlmostInvisibleWhiteColor CGColorCreate( kCGColorSpaceGenericGray, {1, 0.05, 1.0})
// random macros utilizing arc4random()
#define RAND_UINT_MAX		0xFFFFFFFF
#define RAND_INT_MAX		0x7FFFFFFF

// RAND_UINT() positive unsigned integer from 0 to RAND_UINT_MAX
// RAND_INT() positive integer from 0 to RAND_INT_MAX
// RAND_INT_VAL(a,b) integer on the interval [a,b] (includes a and b)
#define RAND_UINT()				arc4random()
#define RAND_INT()				((int)(arc4random() & 0x7FFFFFFF))
#define RAND_INT_VAL(a,b)		((arc4random() % ((b)-(a)+1)) + (a))

// RAND_FLOAT() float between 0 and 1 (including 0 and 1)
// RAND_FLOAT_VAL(a,b) float between a and b (including a and b)
#define RAND_FLOAT()			(((float)arc4random()) / RAND_UINT_MAX)
#define RAND_FLOAT_VAL(a,b)		(((((float)arc4random()) * ((b)-(a))) / RAND_UINT_MAX) + (a))

// note: Random doubles will contain more precision than floats, but will NOT utilize the
//		full precision of the double. They are still limited to the 32-bit precision of arc4random
// RAND_DOUBLE() double between 0 and 1 (including 0 and 1)
// RAND_DOUBLE_VAL(a,b) double between a and b (including a and b)
#define RAND_DOUBLE()			(((double)arc4random()) / RAND_UINT_MAX)
#define RAND_DOUBLE_VAL(a,b)	(((((double)arc4random()) * ((b)-(a))) / RAND_UINT_MAX) + (a))

// RAND_BOOL() a random boolean (0 or 1)
// RAND_DIRECTION() -1 or +1 (usage: int steps = 10*RAND_DIRECTION();  will get you -10 or 10)
#define RAND_BOOL()				(arc4random() & 1)
#define RAND_DIRECTION()		(RAND_BOOL() ? 1 : -1)





// pinning a value between a lower and upper limit

#define LIMIT( value, min, max )		(((value) < (min))? (min) : (((value) > (max))? (max) : (value)))

// converting from radians to degrees

#define	DEGREES_TO_RADIANS( d )			((d) * 0.0174532925199432958)
#define RADIANS_TO_DEGREES( r )			((r) * 57.29577951308232)

// some useful angular constants

#define FIFTEEN_DEGREES					(0.261799387799)
#define NINETY_DEGREES					(pi * 0.5)
#define FORTYFIVE_DEGREES				(pi * 0.25)
#define HALF_PI							(pi * 0.5)

// exception safe save/restore of the current graphics context

#define	SAVE_GRAPHICS_CONTEXT			@try { [NSGraphicsContext saveGraphicsState];
#define RESTORE_GRAPHICS_CONTEXT		} @finally { [NSGraphicsContext restoreGraphicsState]; }




//void _AZSimpleLog( const char *file, int lineNumber, const char *funcName, NSString *format, ... ) {
//NS_INLINE void ConditionalLog( const char *filename, int line, const char *funcName, NSS *format, ... ) { 	

//	BOOL YESORNO = strcmp(getenv(XCODE_COLORS), "YES") == 0;
//	va_list   argList;
//	va_start (argList, format);
//	NSS *path  	= [[NSS stringWithFormat:@"%s",filename] lastPathComponent];
//	NSS *mess   = [NSString.alloc initWithFormat:format arguments:argList];
////	NSS *toLog;
//	char *xcode_colors = getenv(XCODE_COLORS);
	
//	va_list vl; 
//	va_start(vl, formatted);
//	NSS* str = [NSString.alloc initWithFormat:(NSS*)formatted arguments:vl];
//	va_end(vl);
//
//	YESORNO 	? 
//	NSLog(@"%s [Line %d] " XCODE_COLORS_ESCAPE @"fg218,147,0; %@" XCODE_COLORS_RESET, 
//																				  __PRETTY_FUNCTION__, __LINE__, str)
//				: 	NSLog(@"%@",str);
//}


#pragma mark - FUNCTION defines
//#define LOGWARN(fmt,...) 	ConditionalLog(__VA_ARGS__)

//#define LOGWARN(fmt,...) _AZConditionalLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args)
//	BOOL YESORNO = strcmp(getenv(XCODE_COLORS), "YES") == 0;					\
//	va_list vl;																				\
//	va_start(vl, fmt);																	\
//	NSS* str = [NSString.alloc initWithFormat:(NSS*)fmt arguments:vl];	\
//	va_end(vl);																				\
//	YESORNO 	? 	NSLog(@"%s [Line %d] " XCODE_COLORS_ESCAPE @"fg218,147,0;" @"%@" XCODE_COLORS_RESET, __PRETTY_FUNCTION__, __LINE__, str) \
//				: 	NSLog(@"%@",str); \
//}()

//strcmp(getenv(XCODE_COLORS), "YES") == 0 \
//									? NSLog(	(@"%s [Line %d] " XCODE_COLORS_ESCAPE @"fg218,147,0;" fmt XCODE_COLORS_RESET)\
//												, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__) \
//									: NSLog(fmt,__VA_ARGS__)



#define NSLog(args...) _AZSimpleLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);



// 64-bit float macros

//#ifdef __LP64__
//	#define _CGFloatFabs( n )	fabs( n )
//	#define _CGFloatTrunc( n )	trunc( n )
//	#define _CGFloatLround( n )	roundtol( n )
//	#define _CGFloatFloor( n )	floor( n )
//	#define _CGFloatCeil( n )	ceil( n )
//	#define _CGFloatExp( n )	exp( n )
//	#define _CGFloatSqrt( n )	sqrt( n )
//	#define _CGFloatLog( n )	log( n )
//#else
//	#define _CGFloatFabs( n )	fabsf( n )
//	#define _CGFloatTrunc( n )	truncf( n )
//	#define _CGFloatLround( n )	roundtol((double) n )
//	#define _CGFloatFloor( n )	floorf( n )
//	#define _CGFloatCeil( n )	ceilf( n )
//	#define _CGFloatExp( n )	expf( n )
//	#define _CGFloatSqrt( n )	sqrtf( n )
//	#define _CGFloatLog( n )	logf( n )
//#endif



#define $point(A)	   	[NSValue valueWithPoint:A]
#define $points(A,B)	   	[NSValue valueWithPoint:CGPointMake(A,B)]
#define $rect(A,B,C,D)		[NSValue valueWithRect:CGRectMake(A,B,C,D)]

#define ptmake(A,B)			CGPointMake(A,B)stringByAppendingPathComponent

#define $URL(A)				((NSURL *)[NSURL URLWithString:A])
#define $SEL(A)				NSSelectorFromString(A)
#define AZStringFromSet(A) [NSS stringFromArray:A.allObjects]

//#define $#(A)				((NSString *)[NSString string
#define $(...)				((NSString *)[NSString stringWithFormat:__VA_ARGS__,nil])
#define $UTF8(A)			((NSString *)[NSS stringWithUTF8String:A])
#define $array(...)  		((NSArray *)[NSArray arrayWithObjects:__VA_ARGS__,nil])
#define $set(...)		 	((NSSet *)[NSSet setWithObjects:__VA_ARGS__,nil])
#define $map(...)	 		((NSDictionary *)[NSDictionary dictionaryWithObjectsAndKeys:__VA_ARGS__,nil])
#define $int(A)	   			@(A) // [NSNumber numberWithInt:(A)]
#define $ints(...)			[NSArray arrayWithInts:__VA_ARGS__,NSNotFound]
#define $float(A)	 		[NSNumber numberWithFloat:(A)]
#define $doubles(...) 		[NSArray arrayWithDoubles:__VA_ARGS__,MAXFLOAT]
#define $words(...)   		[[@#__VA_ARGS__ splitByComma] trimmedStrings]



#define $ARRAYSET(A) [NSSet setWithArray:(A)]

//#define $concat(A,...) { A = [A arrayByAddingObjectsFromArray:((NSArray *)[NSArray arrayWithObjects:__VA_ARGS__,nil])]; }
// s stringByReplacingOccurrencesOfString:@"fff	" withString:@"%%%%"] )
//#define AZLOG(log,...) NSLog(@"%@", [log s stringByReplacingOccurrencesOfString:@"fff	" withString:@"%%%%"] )

//#ifdef DEBUG
//#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
//#else
//#   define DLog(...)
//#endif
//#define NSLog(args...) _AZSimpleLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);

//#define NSLog(args...) _AZLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);

//void _AZLog(const char *file, int lineNumber, const char *funcName, NSString *format,...);
//void _AZSimpleLog(const char *file, int lineNumber, const char *funcName, NSString *format,...);

//BOOL flag = YES;
//NSLog(flag ? @"Yes" : @"No");
//?: is the ternary conditional operator of the form:
//condition ? result_if_true : result_if_false
#define LogProps(a) NSLog(@"%@", a.propertiesPlease)
#define logprop(a) NSLog(@"%@", [a propertiesPlease])
//#define logobj(a) id logit = a \		 NSLog(@"%@", a)
#define desc(a) NSLog(@"%@", [a description])


#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


#pragma - General Functions

//#define NSDICT (...) [NSDictionary dictionaryWithObjectsAndKeys: __VA_ARGS__, nil]
//#define NSARRAY(...) [NSArray arrayWithObjects: __VA_ARGS__, nil]
//#define NSBOOL (_X_) [NSNumber numberWithBool:(_X_)]
//#define NSSET  (...) [NSSet setWithObjects: __VA_ARGS__, nil]

//#define NSCOLOR	   (r,g,b,a) [NSColor colorWithCalibratedRed:r green:g blue:b alpha:a]
//#define NSDEVICECOLOR (r,g,b,a) [NSColor colorWithDeviceRed:r green:g blue:b alpha:a]
//#define NSCOLORHSB	(h,s,b,a) [NSColor colorWithDeviceHue:h saturation:s brightness:b alpha:a]

//#pragma - Log Functions
//
//#ifdef DEBUG
//#	define CWPrintClassAndMethod() NSLog(@"%s%i:\n",__PRETTY_FUNCTION__,__LINE__)
//#	define CWDebugLog(args...) NSLog(@"%s%i: %@",__PRETTY_FUNCTION__,__LINE__,[NSString stringWithFormat:args])
//#else
//#	define CWPrintClassAndMethod() /**/
//#	define CWDebugLog(args...) /**/
//#endif
//
//#define CWLog(args...) NSLog(@"%s%i: %@",__PRETTY_FUNCTION__,__LINE__,[NSString stringWithFormat:args])
//#define CWDebugLocationString() [NSString stringWithFormat:@"%s[%i]",__PRETTY_FUNCTION__,__LINE__]
//
//#define nilease(A) [A release]; A = nil
//
//#define $affectors(A,...) +(NSSet *)keyPathsForValuesAffecting##A { static NSSet *re = nil; \
//if (!re) { re = [[[@#__VA_ARGS__ splitByComma] trimmedStrings] set]; } return re; }

#import <QuartzCore/QuartzCore.h>




//NSDATE NSSTRING ETC
static OSSpinLock _calendarSpinLock = 0;
static OSSpinLock _formattersSpinLock = 0;
static OSSpinLock _staticSpinLock = 0;




typedef struct {
	CAConstraintAttribute constraint;
	CGFloat scale;
	CGFloat offset;
}	AZCAConstraint;

#define AZCACMaxX		AZConstraint(kCAConstraintMaxX,@"superlayer")
#define AZCACMaxY		AZConstraint(kCAConstraintMaxY,@"superlayer")
#define AZCACSuperW 	AZConstraint(kCAConstraintWidth,@"superlayer")
#define AZCACSuperH 	AZConstraint(kCAConstraintHeight,@"superlayer")


typedef NS_ENUM(NSUI, AppCat) {
	Games, Education, Entertainment,
	Books, Lifestyle, Utilities, Business,
	Travel, Music, Reference, Sports,
	Productivity, News, HealthcareFitness,
	Photography, Finance, Medical, SocialNetworking,
	Navigation, Weather, Catalogs, FoodDrink, Newsstand
};

#define AppCatTypeArray @"Games", @"Education", @"Entertainment", @"Books", @"Lifestyle", @"Utilities", @"Business", @"Travel", @"Music", @"Reference", @"Sports", @"Productivity", @"News", @"Healthcare & Fitness", @"Photography", @"Finance", @"Medical", @"Social Networking", @"Navigation", @"Weather", @"Catalogs", @"Food & Drink", @"Newsstand", nil
typedef NS_ENUM(NSUI, AZOrient) {
	AZOrientTop,
	AZOrientLeft,
	AZOrientBottom,
	AZOrientRight,
	AZOrientGrid,
	AZOrientPerimeter,
	AZOrientFiesta,
	AZOrientVertical,
	AZOrientHorizontal,
};

typedef NS_ENUM(NSUI,  	AZInfiteScale) {
	AZInfiteScale0X,
	AZInfiteScale1X,
	AZInfiteScale2X,
	AZInfiteScale3X,
	AZInfiteScale10X
};

typedef NS_ENUM(NSUI, AZState) {
	AZIdleState,
	AZCreatingState,
	AZModifyingState,
	AZDeletingState,
	AZOn,
	AZOff
};

typedef NS_ENUM(NSUI, AZTrackState) { LeftOn,LeftOff,TopOn,TopOff,RightOn,RightOff,BottomOn,BottomOff	};
typedef NS_ENUM(NSUI, AZDockSort)	{	AZDockSortNatural,AZDockSortColor,AZDockSortPoint,AZDockSortPointNew	};
typedef enum  {	AZSearchByCategory,AZSearchByColor,AZSearchByName,AZSearchByRecent		} AZSearchBy;
typedef NS_ENUM(NSUI, AZSlideState)	  {	AZIn, AZOut, AZToggle									};
typedef NS_ENUM(NSUI, AZMenuPosition) { AZMenuN,AZMenuS,AZMenuE,AZMenuW,AZMenuPositionCount						};
typedef NS_ENUM(NSUI, AZTrackPosition) { AZTrackN,AZTrackS,AZTrackE,AZTrackW,AZTrackPositionCount				};

#define AZTW AZTrackingWindow
#define iC iCarousel

//#ifndef ATOZTOUCH
typedef NS_ENUM(NSUI, AZWindowPosition) {
	AZPositionLeft 			= NSMinXEdge, // 0  NSDrawer
	AZPositionRight		 = NSMaxXEdge, // 2  preferredEdge
	AZPositionTop		   = NSMaxYEdge, // 3  compatibility
	AZPositionBottom		= NSMinYEdge, // 1  numbering!
	AZPositionTopLeft	   = 4,
	AZPositionBottomLeft	= 5,
	AZPositionTopRight	  = 6,
	AZPositionBottomRight   = 7,
	AZPositionAutomatic	 = 8
};// AZWindowPosition;

// NSVALUE defined, see NSValue+AtoZ.h
#define AZWindowPositionTypeArray @"Left",@"Bottom",@"Right",@"Top",@"TopLeft",@"BottomLeft",@"TopRight",@"BottomRight",@"Automatic",nil
//#endif

#define QUAD AZQuadrant

typedef NS_ENUM(NSUI, AZQuadrant){
	AZTopLeftQuad = 0,
	AZTopRightQuad,
	AZBotRightQuad,
	AZBotLeftQuad
};


typedef struct {	CGFloat tlX; CGFloat tlY;
	CGFloat trX; CGFloat trY;
	CGFloat blX; CGFloat blY;
	CGFloat brX; CGFloat brY;
} CIPerspectiveMatrix;

//extern NSString *const AZOrientName[AZOrientCount];
extern NSString *const AZMenuPositionName[AZMenuPositionCount];
// NSLog(@"%@", FormatTypeName[XML]);

//NSString *const FormatTypeName[FormatTypeCount] = { [JSON]=@"JSON", [XML]=@"XML", [Atom] = @"Atom", [RSS] = @"RSS", };
typedef enum {	AZItemsAsBundleIDs,
	AZItemsAsPaths,
	AZItemsAsNames
} AZItemsViewFormat;
typedef enum {	ReadAccess = R_OK,
	WriteAccess = W_OK,
	ExecuteAccess = X_OK,
	PathExists = F_OK
} SandBox;

BOOL isPathAccessible(NSString *path, SandBox mode);
void trackMouse();
// In a header file




//void _AZSimpleLog( const char *file, int lineNumber, const char *funcName, NSString *format, ... ) {


//void COLORLOGFORMAT(

void _AZColorLog( NSC *color, const char *filename, int line, const char *funcName, NSS *format, ... );
//
//	NSS *colorString = @"fg218,147,0";
//	NSS* envStr = @(getenv("XCODE_COLORS")) ?: @"YES";
//	BOOL YESORNO = [envStr boolValue]; 
//	if (color !=nil && YESORNO) { 
//		float r, g, b;  
//		r = color.redComponent; 
//		g = color.greenComponent; 
//		b = color.blueComponent;
//		colorString = $(@"fg%.0f,%.0f,%.0f; ", r*255, g*255, b*255);
//	}
//	va_list   argList;	va_start (argList, format);
//	NSS*pathStr = $UTF8(filename);
//	NSS *path  	= [pathStr lastPathComponent];
//	NSS *mess   = [NSS.alloc initWithFormat:format arguments:argList];
//	NSS *toLog  = YESORNO ? $(@"[%@]:%i" XCODE_COLORS_ESCAPE  @"%@%@" XCODE_COLORS_RESET @"\n", path, line,colorString, mess)
//								 :	$(@"[%@]:%i %@\n", path, line, mess ); 
//	fprintf ( stderr, "%s", toLog.UTF8String);//
//	va_end  (argList);
//}

//#define _AZConditionalLog(fmt...) { _AZColorLog(nil, f, ln, func, fmt,...);	}

//	va_list vl; va_start(vl, formatted);	NSS* str = [NSString.alloc initWithFormat:(NSS*)formatted arguments:vl];
//	va_end(vl);	YESORNO 	? 	NSLog(@"%s [Line %d] " XCODE_COLORS_ESCAPE @"fg218,147,0; %@" XCODE_COLORS_RESET, 
//																				  __PRETTY_FUNCTION__, __LINE__, str)
//				: 	NSLog(@"%@",str);}
#pragma mark - FUNCTION defines
//#define LOGWARN(fmt,...) 	ConditionalLog(__VA_ARGS__)

#define COLORLOG(color,fmt...) _AZColorLog(color,__FILE__,__LINE__,__PRETTY_FUNCTION__,fmt)
#define LOGWARN(fmt...) _AZColorLog(nil,__FILE__,__LINE__,__PRETTY_FUNCTION__,fmt)
//		\
//	BOOL YESORNO = strcmp(getenv(XCODE_COLORS), "YES") == 0;					\
//	va_list vl;																				\
//	va_start(vl, fmt);																	\
//	NSS* str = [NSString.alloc initWithFormat:(NSS*)fmt arguments:vl];	\
//	va_end(vl);																				\
//	YESORNO 	? 	NSLog(@"%s [Line %d] " XCODE_COLORS_ESCAPE @"fg218,147,0;" @"%@" XCODE_COLORS_RESET, __PRETTY_FUNCTION__, __LINE__, str) \
//				: 	NSLog(@"%@",str); \
//}()

//strcmp(getenv(XCODE_COLORS), "YES") == 0 \
//									? NSLog(	(@"%s [Line %d] " XCODE_COLORS_ESCAPE @"fg218,147,0;" fmt XCODE_COLORS_RESET)\
//												, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__) \
//									: NSLog(fmt,__VA_ARGS__)



#define NSLog(fmt...) _AZColorLog(nil,__FILE__,__LINE__,__PRETTY_FUNCTION__,fmt)  
//_AZColorLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);


/**	const

 	extern NSString * const MyConstant;

	You'll see this in header files. It tells the compiler that the variable MyConstant exists and can be used in your implementation files.	More likely than not, the variable is set something like:

	NSString * const MyConstant = @"foo";
 	The value can't be changed. If you want a global that can be changed, then drop the const from the declaration.
 	The position of the const keyword relative to the type identifier doesn't matter
		const NSString *MyConstant = @"foo";  ===  NSString const *MyConstant = @"foo";
	You can also legally declare both the pointer and the referenced value const, for maximum constness:
 		const NSString * const MyConstant = @"foo";
extern

	Allows you to declare a variable in one compilation unit, and let the compiler know that you've defined that variable in a separate compilation unit. You would generally use this only for global values and constants.

 	A compilation unit is a single .m file, as well as all the .h files it includes. At build time the compiler compiles each .m file into a separate .o file, and then the linker hooks them all together into a single binary. Usually the way one compilation unit knows about identifiers (such as a class name) declared in another compilation unit is by importing a header file. But, in the case of globals, they are often not part of a class's public interface, so they're frequently declared and defined in a .m file.
	
 	If compilation unit A declares a global in a .m file:

		#import "A.h"
		NSString *someGlobalValue;

	and compilation unit B wants to use that global:

		#import "B.h"
		extern NSString *someGlobalValue;

		@implementation B
		- (void)someFunc {  
			NSString *localValue = [self getSomeValue];
			[localValue isEqualToString:someGlobalValue] ? ^{ ... }() : ^{ ... }();
		}

	unit B has to somehow tell the compiler to use the variable declared by unit A. It can't import the .m file where the declaration occurs, so it uses extern to tell the compiler that the variable exists elsewhere.
	Note that if unit A and unit B both have this line at the top level of the file:

		NSString *someGlobalValue;
	
 	then you have two compilation units declaring the same global variable, and the linker will fail with a duplicate symbol error. If you want to have a variable like this that exists only inside a compilation unit, and is invisible to any other compilation units (even if they use extern), you can use the static keyword:

		static NSString * const someFileLevelConstant = @"wibble";

 	This can be useful for constants that you want to use within a single implementation file, but won't need elsewhere
**/

#define nAZColorWellChanged @"AtoZColorWellChangedColors"

//static NSString* MakeCritical(NSString *format,...) {
//   NSString *string;
//   va_list   arguments;
//	
//   va_start(arguments,format);
//   string = $(format,arguments);
//   va_end(arguments);
//	return string;
//}
//
//#define CRITICAL(A) MakeCritical(XCODE_COLORS_ESCAPE @"fg218,147,0;" @"%@" XCODE_COLORS_RESET, A)
//



//NS_INLINE void _AZSimpleLog(const char *file, int lineNumber, const char *funcName, NSString *format,...);
FOUNDATION_EXPORT void _AZSimpleLog( const char *file, int lineNumber, const char *funcName, NSString *format, ... );
/*{
	static NSA* colors;  colors = colors ?: NSC.randomPalette;
	static NSUI idx = 0;
	va_list   argList;
	va_start (argList, format);
	NSS *path  	= [$UTF8(file) lastPathComponent];
	NSS *mess   = [NSString.alloc initWithFormat:format arguments:argList];
//	NSS *justinfo = $(@"[%s]:%i",path.UTF8String, lineNumber);
//	NSS *info   = [NSString stringWithFormat:@"word:%-11s rank:%u", [word UTF8String], rank];
	NSS *info 	= $( XCODE_COLORS_ESCAPE @"fg82,82,82;" @"  [%s]" XCODE_COLORS_RESET
						 XCODE_COLORS_ESCAPE @"fg140,140,140;" @":%i" XCODE_COLORS_RESET	, path.UTF8String, lineNumber);
	int max 			= 130;
	int cutTo			= 22;
	BOOL longer 	= mess.length > max;
	NSC *c = [colors normal:idx]; 
	NSS *cs = $(@"%i%i%i",(int)c.redComponent, (int)c.greenComponent, (int)c.blueComponent); idx++;
	NSS* nextLine 	= longer ? $(XCODE_COLORS_ESCAPE @"fg%@;" XCODE_COLORS_RESET @"\n\t%@\n", cs, [mess substringFromIndex:max - cutTo]) : @"\n";
	mess 				= longer ? [mess substringToIndex:max - cutTo] : mess;
	int add = max - mess.length - cutTo;
	if (add > 0) {
		NSS *pad = [NSS.string stringByPaddingToLength:add withString:@" " startingAtIndex:0];
		info = [pad stringByAppendingString:info];
	}
	NSS *toLog 	= $(XCODE_COLORS_ESCAPE @"fg%@;" @"%@" XCODE_COLORS_RESET @"%@%@", cs, mess, info, nextLine);
	fprintf ( stderr, "%s", toLog.UTF8String);//[%s]:%i %s \n", [path UTF8String], lineNumber, [message UTF8String] );
	va_end  (argList);
*/
//	NSS *toLog 	= $( XCODE_COLORS_RESET	@"%s" XCODE_COLORS_ESCAPE @"fg82,82,82;" @"%-70s[%s]" XCODE_COLORS_RESET
//									XCODE_COLORS_ESCAPE @"fg140,140,140;" @":%i\n" XCODE_COLORS_RESET	, 
//								    mess.UTF8String, "", path.UTF8String, lineNumber);
																
//	NSLog(XCODE_COLORS_ESCAPE @"bg89,96,105;" @"Grey background" XCODE_COLORS_RESET);
//	NSLog(XCODE_COLORS_ESCAPE @"fg0,0,255;"
//			XCODE_COLORS_ESCAPE @"bg220,0,0;"
//			@"Blue text on red background"
//			XCODE_COLORS_RESET);


	/**
	if ( [[NSApplication sharedApplication] delegate] ) {
		id appD = [[NSApplication sharedApplication] delegate];
//		fprintf ( stderr, "%s", [[appD description]UTF8String] );
		if ( [(NSObject*)appD respondsToSelector:NSSelectorFromString(@"stdOutView")]) {
			NSTextView *tv 	= ((NSTextView*)[appD valueForKey:@"stdOutView"]);
			if (tv) [tv autoScrollText:toLog];
		}
	}
	*/
	// $(@"%s: %@", __PRETTY_FUNCTION__, [NSString stringWithFormat: args])	]
	//	const char *threadName = [[[NSThread currentThread] name] UTF8String];
//}



typedef NS_ENUM(NSUI, AssetType){ JS, CSS, HTML, PHP, BASH,	ObjC, TXT,	UNKNOWN = 99 };
extern NSString * const assetStringValue[];
extern NSString * const assetTagName[];



typedef NS_ENUM(NSUI, CharacterSet) {
	kCharacterSet_Newline = 0,
	kCharacterSet_WhitespaceAndNewline,
	kCharacterSet_WhitespaceAndNewline_Inverted,
	kCharacterSet_UppercaseLetters,
	kCharacterSet_DecimalDigits_Inverted,
	kCharacterSet_WordBoundaries,
	kCharacterSet_SentenceBoundaries,
	kCharacterSet_SentenceBoundariesAndNewlineCharacter,
	kNumCharacterSets
};


typedef NS_OPTIONS(NSUInteger, AZInstallationStatus) {
	AZNotInstalled			= 0,
    AZInstalled				= 1 << 0,
    AZNeedsUpdate			= 1 << 1,
	//    UIViewAutoresizingFlexibleRightMargin  = 1 << 2,
	//    UIViewAutoresizingFlexibleTopMargin    = 1 << 3,
	//    UIViewAutoresizingFlexibleHeight       = 1 << 4,
	//    UIViewAutoresizingFlexibleBottomMargin = 1 << 5,
	AZInstalledNeedsUpdate 	= AZInstalled|AZNeedsUpdate
};


typedef NS_ENUM(NSUInteger, PXListViewDropHighlight) {
	PXListViewDropNowhere,
	PXListViewDropOn,
	PXListViewDropAbove,
	PXListViewDropBelow
};


typedef NS_ENUM(NSUI,  	OSCornerType) {
	//typedef NS_NSENUM( OSCornerTypes {
	OSTopLeftCorner = 1,
	OSBottomLeftCorner = 2,
	OSTopRightCorner = 4,
	OSBottomRightCorner = 8
};// OSCornerType;

typedef enum {
	AMTriangleUp = 0,
	AMTriangleDown,
	AMTriangleLeft,
	AMTriangleRight
} AMTriangleOrientation;



//CASCROLLVIEW
//minimizing = 0x01, // 00000001
//maximizing = 0x02, // 00000010
//minimized  = 0x04, // 00000100
//maximized  = 0x08  // 00001000

typedef NS_ENUM (NSUI, ScrollFix)	{	LayerInsertFront, 		//= 0x01, // 00000001
													LayerInsertEnd,
													LayerRemoveFront,
													LayerRemoveEnd,
													LayerStateOK,// 			= 0x04, // 00000100
													LayerStateUnresolved,// = 0x08,  // 00001000
													LayerStateUnset
};

typedef NS_ENUM (NSUI, StateStyle)	{	Lasso,			InnerShadow,
										DarkenOthers,	None				};

#define VRT AZOrientVertical
#define HRZ AZOrientHorizontal
#define ScrollFixTypeArray @"LayerInsertFront",	@"LayerInsertEnd",			     @"LayerRemoveFront",	@"LayerRemoveEnd", \
									@"LayerStateOK",		@"LayerStateUnresolved",  @"LayerStateUnset",  	nil

//@"LayerCopyInsertFront",@"LayerCopyInsertEnd"
NS_INLINE NSS* stringForScrollFix(ScrollFix val) { return [NSArray.alloc initWithObjects:ScrollFixTypeArray][val]; }



//typedef enum {
//	JSON = 0,		 // explicitly indicate starting index
//	XML,
//	Atom,
//	RSS,
//
//	FormatTypeCount,  // keep track of the enum size automatically
//} FormatType;
//extern NSString *const FormatTypeName[FormatTypeCount];
	//NSLog(@"%@", FormatTypeName[XML]);
	//	// In a source file
	//NSString *const FormatTypeName[FormatTypeCount] = {
	//	[JSON] = @"JSON",
	//	[XML] = @"XML",
	//	[Atom] = @"Atom",
	//	[RSS] = @"RSS",
	//};
//typedef enum {
//	IngredientType_text  = 0,
//	IngredientType_audio = 1,
//	IngredientType_video = 2,
//	IngredientType_image = 3
//} IngredientType;
	//write a method like this in class:
	//+ (NSString*)typeStringForType:(IngredientType)_type {
	//	NSString *key = [NSString stringWithFormat:@"IngredientType_%i", _type];
	//	return NSLocalizedString(key, nil);
	//}
	//have the strings inside Localizable.strings file:
	///* IngredientType_text */
	//"IngredientType_0" = "Text";
	///* IngredientType_audio */
	//"IngredientType_1" = "Audio";
	///* IngredientType_video */
	//"IngredientType_2" = "Video";
	///* IngredientType_image */
	//"IngredientType_3" = "Image";
	//

//typedef struct _GlossParameters{
//	CGFloat color[4];
//	CGFloat caustic[4];
//	CGFloat expCoefficient;
//	CGFloat expScale;
//	CGFloat expOffset;
//	CGFloat initialWhite;
//	CGFloat finalWhite;
//} GlossParameters;

#define AZBONK @throw \
[NSException \
exceptionWithName:@"WriteThisMethod" \
reason:@"You did not write this method, yet!" \
userInfo:nil]

#define GENERATE_SINGLETON(SC) \
static SC * SC##_sharedInstance = nil; \
+(SC *)sharedInstance { \
if (! SC##_sharedInstance) { \
SC##_sharedInstance = [[SC alloc] init]; \
} \
return SC##_sharedInstance; \
}

	//#define AZTransition(duration, type, subtype) CATransition *transition = [CATransition animation];
	//[transition setDuration:1.0];
	//[transition setType:kCATransitionPush];
	//[transition setSubtype:kCATransitionFromLeft];
	//extern NSArray* AZConstraintEdgeExcept(AZCOn attr, rel, scale, off) \
	//[NSArray arrayWithArray:@[
	//AZConstRelSuper( kCAConstraintMaxX ),
	//AZConstRelSuper( kCAConstraintMinX ),
	//AZConstRelSuper( kCAConstraintWidth),
	//AZConstRelSuper( kCAConstraintMinY ),
	//AZConstRelSuperScaleOff(kCAConstraintHeight, .2, 0),

	//#define AZConstraint(attr, rel) \
	//[CAConstraint constraintWithAttribute: attr relativeTo: rel attribute: attr]
	//@property (nonatomic, assign) <\#type\#> <\#name\#>;
	// AZConst(<\#CAConstraintAttribute\#>, <#\NSString\#>);
	// AZConst(<#CAConstraintAttribute#>, <#NSString*#>);
	//#import "AtoZiTunes.h"

	// Sweetness vs. longwindedness

	//  BaseModel.h
	//  Version 2.3.1
	//  ARC Helper
	//  Version 1.3.1

#ifndef AZ_RETAIN
#if __has_feature(objc_arc)
#define AZ_RETAIN(x) (x)
#define AZ_RELEASE(x) (void)(x)
#define AZ_AUTORELEASE(x) (x)
#define AZ_SUPER_DEALLOC (void)(0)
#define __AZ_BRIDGE __bridge
#else
#define __AZ_WEAK
#define AZ_WEAK assign
#define AZ_RETAIN(x) [(x) retain]
#define AZ_RELEASE(x) [(x) release]
#define AZ_AUTORELEASE(x) [(x) autorelease]
#define AZ_SUPER_DEALLOC [super dealloc]
#define __AZ_BRIDGE
#endif
#endif


////  Weak delegate support
//#ifndef ah_weak
//#import <Availability.h>
//#if (__has_feature(objc_arc)) && \
//((defined __IPHONE_OS_VERSION_MIN_REQUIRED && \
//__IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0) || \
//(defined __MAC_OS_X_VERSION_MIN_REQUIRED && \
//__MAC_OS_X_VERSION_MIN_REQUIRED > __MAC_10_7))
//#define ah_weak weak
//#define __ah_weak __weak
//#else
//#define ah_weak unsafe_unretained
//#define __ah_weak __unsafe_unretained
//#endif
//#endif
//  ARC Helper ends


//#define AZRelease(value) \
//if ( value ) { \
//[value release]; \
//value = nil; \
//}

//#define AZAssign(oldValue,newValue) \
//[ newValue retain ]; \
//AZRelease (oldValue); \
//oldValue = newValue;

#define foreach(B,A) A.andExecuteEnumeratorBlock = \
^(B, NSUInteger A##Index, BOOL *A##StopBlock)

	//#define foreach(A,B,C) \
	//A.andExecuteEnumeratorBlock = \
	//  ^(B, NSUInteger C, BOOL *A##StopBlock)




#ifndef _OmniBase_assertions_h_
#define _OmniBase_assertions_h_

//#import <OmniBase/FrameworkDefines.h>
#import <objc/objc.h>

//#if defined(DEBUG) || defined(OMNI_FORCE_ASSERTIONS)
//#define OMNI_ASSERTIONS_ON
//#endif

// This allows you to turn off assertions when debugging
//#if defined(OMNI_FORCE_ASSERTIONS_OFF)
#undef OMNI_ASSERTIONS_ON
//#warning Forcing assertions off!
//#endif


// Make sure that we don't accidentally use the ASSERT macro instead of OBASSERT
#ifdef ASSERT
#undef ASSERT
#endif

typedef void (*OBAssertionFailureHandler)(const char *type, const char *expression, const char *file, unsigned int lineNumber);

#if defined(OMNI_ASSERTIONS_ON)

OmniBase_EXTERN void OBSetAssertionFailureHandler(OBAssertionFailureHandler handler);

OmniBase_EXTERN void OBAssertFailed(const char *type, const char *expression, const char *file, unsigned int lineNumber);


#define OBPRECONDITION(expression)                                            \
do {                                                                        \
if (!(expression))                                                      \
OBAssertFailed("PRECONDITION", #expression, __FILE__, __LINE__);    \
} while (NO)

#define OBPOSTCONDITION(expression)                                           \
do {                                                                        \
if (!(expression))                                                      \
OBAssertFailed("POSTCONDITION", #expression, __FILE__, __LINE__);   \
} while (NO)

#define OBINVARIANT(expression)                                               \
do {                                                                        \
if (!(expression))                                                      \
OBAssertFailed("INVARIANT", #expression, __FILE__, __LINE__);       \
} while (NO)

#define OBASSERT(expression)                                                  \
do {                                                                        \
if (!(expression))                                                      \
OBAssertFailed("ASSERT", #expression, __FILE__, __LINE__);          \
} while (NO)

#define OBASSERT_NOT_REACHED(reason)                                        \
do {                                                                        \
OBAssertFailed("NOTREACHED", reason, __FILE__, __LINE__);              \
} while (NO)


#else	// else insert blank lines into the code

#define OBPRECONDITION(expression)
#define OBPOSTCONDITION(expression)
#define OBINVARIANT(expression)
#define OBASSERT(expression)
#define OBASSERT_NOT_REACHED(reason)

#endif


#endif // _OmniBase_assertions_h_