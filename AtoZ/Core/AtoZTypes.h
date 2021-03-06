

#import "AtoZMacroDefines.h"
#import "AtoZUmbrella.h"


/** When defining a new class use the GENERICSABLE macro.
	
	GENERICSABLE(MyClass)
	#@interface MyClass : NSObject<MyClass>	
	@property (nonatomic, strong) NSString* name;
	@end
	# Now you can use generics with arrays and sets just as you normally do in Java, C#, etc. 
*/


#if NS_BLOCKS_AVAILABLE
#define GENERICSABLE(__className) \
GENERICSABLEWITHOUTBLOCKS(__className) \
GENERICSABLEWITHBLOCKS(__className)
#else
#define GENERICSABLE(__className) GENERICSABLEWITHOUTBLOCKS(__className)
#endif

#define GENERICSABLEWITHOUTBLOCKS(__className)\
@protocol __className <NSObject> \
@end \
@class __className;  \
typedef NSComparisonResult (^__className##Comparator)(__className* obj1, __className* obj2);  \
\
@interface NSEnumerator (__className##_NSEnumerator_Generics) <__className>  \
- (__className*)nextObject;  \
- (NSArray<__className>*)allObjects; \
@end  \
\
@interface NSArray (__className##_NSArray_Generics) <__className> \
\
- (__className*)objectAtIndex:(NSUInteger)index; \
- (NSArray<__className>*)arrayByAddingObject:(__className*)anObject; \
- (NSArray*)arrayByAddingObjectsFromArray:(NSArray<__className>*)otherArray; \
- (BOOL)containsObject:(__className*)anObject; \
- (__className*)firstObjectCommonWithArray:(NSArray<__className>*)otherArray; \
- (NSUInteger)indexOfObject:(__className*)anObject; \
- (NSUInteger)indexOfObject:(__className*)anObject inRange:(NSRange)range; \
- (NSUInteger)indexOfObjectIdenticalTo:(__className*)anObject; \
- (NSUInteger)indexOfObjectIdenticalTo:(__className*)anObject inRange:(NSRange)range; \
- (BOOL)isEqualToArray:(NSArray<__className>*)otherArray; \
- (__className*)lastObject; \
- (NSEnumerator<__className>*)objectEnumerator; \
- (NSEnumerator<__className>*)reverseObjectEnumerator; \
- (NSArray<__className>*)sortedArrayUsingFunction:(NSInteger (*)(__className*, __className*, void *))comparator context:(void *)context; \
- (NSArray<__className>*)sortedArrayUsingFunction:(NSInteger (*)(__className*, __className*, void *))comparator context:(void *)context hint:(NSData *)hint; \
- (NSArray<__className>*)sortedArrayUsingSelector:(SEL)comparator; \
- (NSArray<__className>*)subarrayWithRange:(NSRange)range; \
- (NSArray<__className>*)objectsAtIndexes:(NSIndexSet *)indexes; \
- (__className*)objectAtIndexedSubscript:(NSUInteger)idx NS_AVAILABLE(10_8, 6_0); \
\
+ (NSArray<__className>*)array; \
+ (NSArray<__className>*)arrayWithObject:(__className*)anObject; \
+ (NSArray<__className>*)arrayWithObjects:(const id [])objects count:(NSUInteger)cnt; \
+ (NSArray<__className>*)arrayWithObjects:(__className*)firstObj, ... NS_REQUIRES_NIL_TERMINATION; \
+ (NSArray<__className>*)arrayWithArray:(NSArray<__className>*)array; \
\
- (NSArray<__className>*)initWithObjects:(const id [])objects count:(NSUInteger)cnt; \
- (NSArray<__className>*)initWithObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION; \
- (NSArray<__className>*)initWithArray:(NSArray *)array; \
- (NSArray<__className>*)initWithArray:(NSArray *)array copyItems:(BOOL)flag; \
\
+ (NSArray<__className>*)arrayWithContentsOfFile:(NSString *)path; \
+ (NSArray<__className>*)arrayWithContentsOfURL:(NSURL *)url; \
- (NSArray<__className>*)initWithContentsOfFile:(NSString *)path; \
- (NSArray<__className>*)initWithContentsOfURL:(NSURL *)url; \
\
@end \
\
@interface NSMutableArray (__className##_NSMutableArray_Generics) <__className> \
\
- (void)addObjectsFromArray:(NSArray<__className>*)otherArray; \
- (void)removeObject:(__className*)anObject inRange:(NSRange)range; \
- (void)removeObject:(__className*)anObject; \
- (void)removeObjectIdenticalTo:(__className*)anObject inRange:(NSRange)range; \
- (void)removeObjectIdenticalTo:(__className*)anObject; \
- (void)removeObjectsInArray:(NSArray<__className>*)otherArray; \
\
- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray<__className>*)otherArray range:(NSRange)otherRange; \
- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray<__className>*)otherArray; \
- (void)setArray:(NSArray<__className>*)otherArray; \
- (void)sortUsingFunction:(NSInteger (*)(__className*, __className*, void *))compare context:(void *)context; \
\
- (void)insertObjects:(NSArray<__className>*)objects atIndexes:(NSIndexSet *)indexes; \
- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes; \
- (void)replaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray<__className>*)objects; \
\
- (void)setObject:(__className*)obj atIndexedSubscript:(NSUInteger)idx NS_AVAILABLE(10_8, 6_0); \
\
+ (NSMutableArray<__className>*)array; \
+ (NSMutableArray<__className>*)arrayWithObject:(__className*)anObject; \
+ (NSMutableArray<__className>*)arrayWithObjects:(const id [])objects count:(NSUInteger)cnt; \
+ (NSMutableArray<__className>*)arrayWithObjects:(__className*)firstObj, ... NS_REQUIRES_NIL_TERMINATION; \
+ (NSMutableArray<__className>*)arrayWithArray:(NSArray<__className>*)array; \
\
- (NSMutableArray<__className>*)initWithObjects:(const id [])objects count:(NSUInteger)cnt; \
- (NSMutableArray<__className>*)initWithObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION; \
- (NSMutableArray<__className>*)initWithArray:(NSArray *)array; \
- (NSMutableArray<__className>*)initWithArray:(NSArray *)array copyItems:(BOOL)flag; \
\
+ (NSMutableArray<__className>*)arrayWithContentsOfFile:(NSString *)path; \
+ (NSMutableArray<__className>*)arrayWithContentsOfURL:(NSURL *)url; \
- (NSMutableArray<__className>*)initWithContentsOfFile:(NSString *)path; \
- (NSMutableArray<__className>*)initWithContentsOfURL:(NSURL *)url; \
\
@end \
\
@interface NSSet (__className##_NSSet_Generics) <__className> \
\
- (__className*)member:(__className*)object; \
- (NSEnumerator<__className>*)objectEnumerator; \
\
- (NSArray<__className>*)allObjects; \
- (__className*)anyObject; \
- (BOOL)containsObject:(__className*)anObject; \
- (BOOL)intersectsSet:(NSSet<__className>*)otherSet; \
- (BOOL)isEqualToSet:(NSSet<__className>*)otherSet; \
- (BOOL)isSubsetOfSet:(NSSet<__className>*)otherSet; \
\
- (NSSet<__className>*)setByAddingObject:(__className*)anObject NS_AVAILABLE(10_5, 2_0); \
- (NSSet<__className>*)setByAddingObjectsFromSet:(NSSet<__className>*)other NS_AVAILABLE(10_5, 2_0); \
- (NSSet<__className>*)setByAddingObjectsFromArray:(NSArray *)other NS_AVAILABLE(10_5, 2_0); \
\
+ (NSSet<__className>*)set; \
+ (NSSet<__className>*)setWithObject:(__className*)object; \
+ (NSSet<__className>*)setWithObjects:(const id [])objects count:(NSUInteger)cnt; \
+ (NSSet<__className>*)setWithObjects:(__className*)firstObj, ... NS_REQUIRES_NIL_TERMINATION; \
+ (NSSet<__className>*)setWithSet:(NSSet<__className>*)set; \
+ (NSSet<__className>*)setWithArray:(NSArray<__className>*)array; \
\
- (NSSet<__className>*)initWithObjects:(const id [])objects count:(NSUInteger)cnt; \
- (NSSet<__className>*)initWithObjects:(__className*)firstObj, ... NS_REQUIRES_NIL_TERMINATION; \
- (NSSet<__className>*)initWithSet:(NSSet<__className>*)set; \
- (NSSet<__className>*)initWithSet:(NSSet<__className>*)set copyItems:(BOOL)flag; \
- (NSSet<__className>*)initWithArray:(NSArray<__className>*)array; \
\
@end \
\
@interface NSMutableSet (__className##_NSMutableSet_Generics) <__className> \
\
- (void)addObject:(__className*)object; \
- (void)removeObject:(__className*)object; \
- (void)addObjectsFromArray:(NSArray<__className>*)array; \
- (void)intersectSet:(NSSet<__className>*)otherSet; \
- (void)minusSet:(NSSet<__className>*)otherSet; \
- (void)unionSet:(NSSet<__className>*)otherSet; \
\
- (void)setSet:(NSSet<__className>*)otherSet; \
+ (NSSet<__className>*)setWithCapacity:(NSUInteger)numItems; \
- (NSSet<__className>*)initWithCapacity:(NSUInteger)numItems; \
\
@end \
\
@interface NSCountedSet (__className##_NSCountedSet_Generics) <__className> \
\
- (NSSet<__className>*)initWithCapacity:(NSUInteger)numItems;  \
- (NSSet<__className>*)initWithArray:(NSArray<__className>*)array; \
- (NSSet<__className>*)initWithSet:(NSSet<__className>*)set; \
- (NSUInteger)countForObject:(__className*)object; \
- (NSEnumerator<__className>*)objectEnumerator; \
- (void)addObject:(__className*)object; \
- (void)removeObject:(__className*)object; \
\
@end \

#if NS_BLOCKS_AVAILABLE

#define GENERICSABLEWITHBLOCKS(__className) \
\
@interface NSMutableArray (__className##_NSMutableArray_BLOCKS_Generics) <__className> \
- (void)sortUsingComparator:(__className##Comparator)cmptr NS_AVAILABLE(10_6, 4_0); \
- (void)sortWithOptions:(NSSortOptions)opts usingComparator:(__className##Comparator)cmptr NS_AVAILABLE(10_6, 4_0); \
@end \
@interface NSSet (__className##_NSSet_BLOCKS_Generics) <__className> \
- (void)enumerateObjectsUsingBlock:(void (^)(__className* obj, BOOL *stop))block NS_AVAILABLE(10_6, 4_0); \
- (void)enumerateObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(__className* obj, BOOL *stop))block NS_AVAILABLE(10_6, 4_0); \
- (NSSet<__className>*)objectsPassingTest:(BOOL (^)(__className* obj, BOOL *stop))predicate NS_AVAILABLE(10_6, 4_0); \
- (NSSet<__className>*)objectsWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (^)(__className* obj, BOOL *stop))predicate NS_AVAILABLE(10_6, 4_0); \
@end \

#endif

/*  Created by Benedict Cohen on 10/01/2012.

 A Record is a Block (a.k.a. closure) that returns a struct. Unlike struct, Records handle memory management of their fields.
 The fields can be Objective-C objects or basic C types. Because Records are Blocks they can be treated like objects.

 To declare a Record you must define its fields and implement a function for creating an instance of the record. 2 types are
 available once a record has been declare:
 - A struct that contains the defined fields
 - A block that takes zero arguments and returns a struct

 Declaration example
 ===================
 //Person Record declaration
 RECORD(Person,	RECORD_FIELD_OBJ	(NSString *name)
						RECORD_FIELD_PRM	(float 		age)
 );

 ++++ ---->
 typedef struct Person_ {
 	__unsafe_unretained NSString *name;
	 float age;
 } Person;

 typedef Person(^PersonRecord)(void);
________.

 The creation function must return a Record. All object fields must be captured inside the returned block.

 Creation function example
 =========================
 static PersonRecord createPersonRecord(NSString *name, float age)
 {
 PersonRecord spartacus = ^(void) {
	 	Person p;
		p.name 	= name;
		p.age 	= age;
 return p;
 };
 return spartacus;     //for ARC code

 //for non-ARC code	return (PersonRecord)[[spartacus copy] autorelease];
 }

 Useage example
 ==============
 PersonRecord bill    = createPersonRecord(@"Bill Wyman",     75);
 PersonRecord charlie = createPersonRecord(@"Charlie Wattts", 70);
 PersonRecord keith   = createPersonRecord(@"Keith Richards", 68);
 PersonRecord mick    = createPersonRecord(@"Mick Jagger",    68);
 PersonRecord ronnie  = createPersonRecord(@"Ronnie Wood",    64);

 NSArray *stones = [NSArray arrayWithObjects: bill, charlie, keith, mick, ronnie, nil];

 for (PersonRecord stone in stones)
 {
	 Person p = stone();
	 NSLog(@"%@  %f", p.name, p.age);
 }

 It's worth noting that the creation function has the potentinal to do interesting things.
 */

#define RECORD_FIELD_OBJ(FIELD_TYPE_AND_NAME...) __unsafe_unretained FIELD_TYPE_AND_NAME;
#define RECORD_FIELD_PRM(FIELD_TYPE_AND_NAME...) FIELD_TYPE_AND_NAME;

#define RECORD(RECORD_NAME, FIELDS...) \/*Typedef for struct returned by Record */ \
typedef struct RECORD_NAME ## _ {	FIELDS	} RECORD_NAME; \
typedef RECORD_NAME(^RECORD_NAME ## Record)(void);	/*typedef of Rec. that returns struct*/


//static NSA *_pos = nil;
//#define AZWindowPositionTypeArray @"Left",@"Bottom",@"Right",@"Top",@"TopLeft",@"BottomLeft",@"TopRight",@"BottomRight",@"Automatic", nil

/*
 Binary Math
 0 + 0 = 0
 0 + 1 = 1
 1 + 1 = 10

 Binary to Decimal Conversion
 00010011 = 0*2**7 + 0*2**6 + 0*2**5 + 1*2**4 + 0*2**3 + 0*2**2 + 1*2**1 + 1*2**0
 = 		 0 + 		 0 + 		 0 + 		16 + 		 0 + 		 0 + 		 2 + 		 1
 = 																							19
 */

/*
 // Constants to hold bit masks for desired flags
 static int flagAllOff 	=   0;	//         000...00000000 (empty mask)
 static int flagbit1 		=   1;   // 2^^0    000...00000001
 static int flagbit2 		=   2;   // 2^^1    000...00000010
 static int flagbit3 		=   4;   // 2^^2    000...00000100
 static int flagbit4 		=   8;   // 2^^3    000...00001000
 static int flagbit5 		=  16;   // 2^^4    000...00010000
 static int flagbit6 		=  32;   // 2^^5    000...00100000
 static int flagbit7 		=  64;   // 2^^6    000...01000000
 static int flagbit8 		= 128;  	// 2^^7    000...10000000
 */
#define AZA AZAlign
#define AZPOS AZA

//JROptionsDeclare(AZAlign, 	AZAlignLeft       = flagbit1, //0x00000001,
//									AZAlignRight      = flagbit2, //0x00000010,
//									AZAlignTop        = flagbit3, //0x00000100,
//									AZAlignBottom     = flagbit4, //0x00001000,
//									AZAlignTopLeft    = flagbit5, //0x00000101,
//									AZAlignBottomLeft = flagbit6, //0x00001001,
//									AZAlignTopRight   = flagbit7, //0x00000110,
//									AZAlignBottomRight = flagbit8 // 0x00001010
//);


//JREnumDeclare (AZAlign,

//JROptionsDeclare(AZ_arc, 	AZ_arc_NATOM	       	= 0x00000001,
//					  AZ_arc_RONLY 	     		= 0x00000010,
//					  AZ_arc_STRNG	        	= 0x00000100,
//					  AZ_arc_ASSGN  		   	= 0x00001000,
//					  AZ_arc__COPY 		   	= 0x00010000,
//					  AZ_arc__WEAK				= 0x00100000);


#define QUALIFIER_FROM_BITMASK(q) q&AZ_arc_NATOM 					? nonatomic 			:\
q&AZ_arc_NATOM|AZ_arc_STRNG 	? nonatomic,strong 	:\
q&AZ_arc_RONLY 					? readonly 				:\
q&AZ_arc__COPY 					? copy 					:\
q&AZ_arc_NATOM|AZ_arc__COPY 	? nonatomic,copy 		:\
q&AZ_arc__WEAK 					? weak    : assign


//  AZPROP_HINTED(NSUI,ASS,poop);   -> @property (assign) NSUInteger _name;
#define AZPROP_HINTED(_type_,_directives_,_name_) @property (_directives_) _type_ _name

#define AZPROPS(_type_,_directives_,...) for(int i=2, i<VA_NUM_ARGS, i++) AZPROP


#define NATOM_STR nonatomic,strong


#define AZINTERFACE(_super_,_name_) @interface _name_ : _super_
//#define AZINTERFACE(_name_,...) @interface _name_ : __VA_ARGS__ ?: NSObject   // AZINTERFACE(NSMA,Alex) -> @interface Alex : NSMutableArray


#define STRONGNATOM strong,nonatomic
#define AZPROPERTY(_kind_,_arc_,...) @property (_arc_) _kind_   __VA_ARGS__;
#define AZPROPERTYIBO(_kind_,...) @property (assign) IBOutlet  _kind_   __VA_ARGS__;

#define AZINTERFACEIMPLEMENTED(_super_,_name_,_BLOCK__)\
	AZINTERFACE(_super_,_name_)\
	_BLOCK__();\
@end\
@implementation _name_\
@end

//											 #QUALIFIER_FROM_BITMASK(_arc_)

#define                                   AZSTRONGSTRING(A) @property (nonatomic, strong) NSString* A

//AZPROPASS(_kind_...) @property (NATOM,ASS) _kind_ __VA_ARGS__


JROptionsDeclare(AZAlign, 	AZAlignLeft       	= 0x00000001,
					  AZAlignRight      	= 0x00000010,
					  AZAlignTop	        	= 0x00000100,
					  AZAlignBottom     	= 0x00001000,
					  AZAlignTopLeft 	   = 0x00000101,
					  AZAlignBottomLeft		= 0x00001001,
					  AZAlignTopRight   	= 0x00000110,
					  AZAlignBottomRight  	= 0x00001010,
					  AZAlignAutomatic		= 0x11111111	);

/*  expanded....

 typedef enum AZAlign : NSUInteger AZAlign;
 enum AZAlign : NSUInteger { AZAlignLeft 			= 0x00000001,
 AZAlignRight 			= 0x00000010,
 AZAlignTop 				= 0x00000100,
 AZAlignBottom 			= 0x00001000,
 AZAlignTopLeft 		= 0x00000101,
 AZAlignBottomLeft 	= 0x00001001,
 AZAlignTopRight 		= 0x00000110,
 AZAlignBottomRight 	= 0x00001010 };
 extern NSDictionary* AZAlignByValue();
 extern NSDictionary* AZAlignByLabel();
 extern NSString* AZAlignToString(int enumValue);
 extern BOOL AZAlignFromString(NSString *enumLabel, AZAlign *enumValue);
 static NSString *_AZAlign_constants_string = @"" "AZAlignLeft = 0x00000001, AZAlignRight = 0x00000010, AZAlignTop = 0x00000100, AZAlignBottom = 0x00001000, AZAlignTopLeft = 0x00000101, AZAlignBottomLeft = 0x00001001, AZAlignTopRight = 0x00000110, AZAlignBottomRight = 0x00001010";;

 */

//				AZAlignNone	= 0, // 0
//		AZAlignBottomLeft = 0x10000001, // 2 << 0  (0x1 << 1), // => 0x00000010
//			 AZAlignBottom	= 0x00000010,
//	  AZAlignBottomRight	= 0x00000110,
//	     	  AZAlignRight = 0x00001000,
//  	     AZAlignTopRight = 0x00001100,
//	          AZAlignTop = 0x00000000,
//			AZAlignTopLeft = 0x00000101,
//				AZAlignLeft = 0x00011100 // 1 << 0   aka (0x1 << 0), // => 0x00000001
////	       = 0x00001000,
//	   = 0x00001001,
//	  = 0x00001010



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

typedef NS_ENUM (NSUI, AGImageResizingMethod) {	AGImageResizeCrop,AGImageResizeCropStart,	AGImageResizeCropEnd, AGImageResizeScale };


typedef NS_OPTIONS(NSUInteger, AZInstallationStatus) {
	AZNotInstalled			= 0,
	AZInstalled				= 1 << 0,
	AZNeedsUpdate			= 1 << 1,
	//	UIViewAutoresizingFlexibleRightMargin  = 1 << 2,
	//	UIViewAutoresizingFlexibleTopMargin	= 1 << 3,
	//	UIViewAutoresizingFlexibleHeight	   = 1 << 4,
	//	UIViewAutoresizingFlexibleBottomMargin = 1 << 5,
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

NS_INLINE NSUI AZAlignToNormalBitmask(AZA a){return

	a == AZAlignLeft ? 2 :
	a == AZAlignRight ? 3 :
	a == AZAlignTop	 ? 0 :
	a == AZAlignBottom  ? 1 : NSNotFound;
	//	AZAlignTopLeft 	   = 0x00000101,
	//	AZAlignBottomLeft		= 0x00001001,
	//	AZAlignTopRight   	= 0x00000110,
	//	AZAlignBottomRight  	= 0x00001010
}
JREnumDeclare(AZCompass,AZCompassN, AZCompassS, AZCompassW, AZCompassE, AZCompassNW, AZCompassNE, AZCompassSE, AZCompassSW );

//CASCROLLVIEW
//minimizing = 0x01, // 00000001
//maximizing = 0x02, // 00000010
//minimized  = 0x04, // 00000100
//maximized  = 0x08  // 00001000

typedef NS_OPTIONS(NSUI, ScrollFix)	{	LayerInsertFront, 		//= 0x01, // 00000001
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
#define ScrollFixTypeArray @"LayerInsertFront",	@"LayerInsertEnd",				 @"LayerRemoveFront",	@"LayerRemoveEnd", \
@"LayerStateOK",		@"LayerStateUnresolved",  @"LayerStateUnset",  	nil

//@"LayerCopyInsertFront",@"LayerCopyInsertEnd"
NS_INLINE NSS* stringForScrollFix(ScrollFix val) { return [[NSArray.alloc initWithObjects:ScrollFixTypeArray]objectAtIndex:val]; }




//NSDATE NSSTRING ETC
__unused static OSSpinLock _calendarSpinLock = 0;
__unused static OSSpinLock _formattersSpinLock = 0;
__unused static OSSpinLock _staticSpinLock = 0;



typedef NS_ENUM(NSUI, AppCat) {
	Games, Education, Entertainment,
	Books, Lifestyle, Utilities, Business,
	Travel, Music, Reference, Sports,
	Productivity, News, HealthcareFitness,
	Photography, Finance, Medical, SocialNetworking,
	Navigation, Weather, Catalogs, FoodDrink, Newsstand
};

#define AppCatTypeArray @"Games", @"Education", @"Entertainment", @"Books", @"Lifestyle", @"Utilities", @"Business", @"Travel", @"Music", @"Reference", @"Sports", @"Productivity", @"News", @"Healthcare & Fitness", @"Photography", @"Finance", @"Medical", @"Social Networking", @"Navigation", @"Weather", @"Catalogs", @"Food & Drink", @"Newsstand", nil


typedef NS_ENUM(NSI,          AZStatus) { AZMIXED = -1, AZOFF =  0, AZON =  1 };
typedef NS_ENUM(NSI, 		 	AZState ) {	AZOff, AZOn, AZModifyingState, AZIdleState, AZCreatingState, AZDeletingState				};

typedef NSInteger NSCellStateValue;

typedef NS_ENUM(NSUI,    AZSlideState ) { AZIn, AZOut, AZToggle																						};

typedef NS_ENUM(NSUI,    AZTrackState ) { LeftOn, LeftOff, TopOn, TopOff, RightOn, RightOff, BottomOn, BottomOff						};
typedef NS_ENUM(NSUI,      AZDockSort ) { AZDockSortNatural, AZDockSortColor, AZDockSortPoint, AZDockSortPointNew						};
typedef NS_ENUM(NSUI,      AZSearchBy ) { AZSearchByCategory, AZSearchByColor, AZSearchByName, AZSearchByRecent						};
typedef NS_ENUM(NSUI,  AZMenuPosition ) { AZMenuN, AZMenuS, AZMenuE, AZMenuW, AZMenuPositionCount											};
typedef NS_ENUM(NSUI, AZTrackPosition ) { AZTrackN, AZTrackS, AZTrackE, AZTrackW, AZTrackPositionCount									};
typedef NS_ENUM(NSUI,  	AZInfiteScale ) { AZInfiteScale0X, AZInfiteScale1X, AZInfiteScale2X, AZInfiteScale3X, AZInfiteScale10X	};

JREnumDeclare(AZOrient,	AZOrientTop, 	AZOrientLeft, 		AZOrientBottom, 	AZOrientRight,
				  AZOrientGrid, 	AZOrientPerimeter,AZOrientFiesta,	AZOrientVertical, AZOrientHorizontal);

#define AZTW AZTrackingWindow
#define iC iCarousel
/*
 //#ifndef ATOZTOUCH
 typedef NS_OPTIONS(NSUI, AZWindowPosition) {
 AZPositionLeft 			= NSMinXEdge, // 0  NSDrawer
 AZPositionRight			= NSMaxXEdge, // 2  preferredEdge
 AZPositionTop		   	= NSMaxYEdge, // 3  compatibility
 AZPositionBottom			= NSMinYEdge, // 1  numbering!
 AZPositionTopLeft	   	= 4,
 AZPositionBottomLeft		= 5,
 AZPositionTopRight	 	= 6,
 AZPositionBottomRight   = 7,
 AZPositionAutomatic	 	= 8
 };// AZWindowPosition;
 */
#define  AZPositionToString AZWindowPositionToString
#define AZPosition AZAlign
#define AZWindowPosition AZPosition
//JREnumDeclare(AZPosition,
//	AZPositionLeft 			= 0,// NSMinXEdge, // 0  NSDrawer
//	AZPositionRight			= 2, //NSMaxXEdge, // 2  preferredEdge
//	AZPositionTop		   	= 3, //NSMaxYEdge, // 3  compatibility
//	AZPositionBottom			= 1,  //NSMinYEdge, // 1  numbering!
//	AZPositionTopLeft	   	= 4,
//	AZPositionBottomLeft		= 5,
//	AZPositionTopRight	 	= 6,
//	AZPositionBottomRight   = 7,
//	AZPositionAutomatic	 	= 8 );// AZWindowPosition;

#define AZPositionLeft 		AZAlignLeft
#define AZPositionRight		AZAlignRight		//			= 2, //NSMaxXEdge, // 2  preferredEdge
#define 	AZPositionTop		AZAlignTop		   //	= 3, //NSMaxYEdge, // 3  compatibility
#define 	AZPositionBottom		AZAlignBottom//			= 1,  //NSMinYEdge, // 1  numbering!
#define 	AZPositionTopLeft 		AZAlignTopLeft//	   	= 4,
#define 	AZPositionBottomLeft		AZAlignBottomLeft//		= 5,
#define 	AZPositionTopRight		AZAlignTopRight//	 	= 6,
#define 	AZPositionBottomRight		AZAlignBottomRight//   = 7,
#define 	AZPositionAutomatic		AZAlignAutomatic   //	 	= 8 );// AZWindowPosition;

#define AZLft 		AZPositionLeft
#define AZRgt		AZPositionRight
#define AZTop		AZPositionTop
#define AZBot		AZPositionBottom
#define AZTpLft	AZPositionTopLeft
#define AZBtLft	AZPositionBottomLeft
#define AZTpRgt	AZPositionTopRight
#define AZBtRgt	AZPositionBottomRight

//NSS* stringForPosition(AZWindowPosition enumVal);

//NS_INLINE NSS* stringForPosition(AZPOS e) {	_pos = _pos ?: [NSA arrayWithObjects:AZWindowPositionTypeArray];
//	return _pos.count >= e ? _pos[e] : @"outside of range for Positions";
//}
//NS_INLINE AZPOS positionForString(NSS* s)	{	_pos = _pos ?: [NSA arrayWithObjects:AZWindowPositionTypeArray];
//															return (AZPOS) [_pos indexOfObject:s];
//}


typedef struct AZWhatever {
	NSUI position;
	char *aString;
	int  anInt;
} AZWhatever;

// NSVALUE defined, see NSValue+AtoZ.h
//#define AZWindowPositionTypeArray @[@"Left",@"Bottom",@"Right",@"Top",@"TopLeft",@"BottomLeft",@"TopRight",@"BottomRight",@"Automatic"]
//#endif

#define QUAD AZQuad


//JREnum() is fine for when you have an enum that lives solely in an .m file. But if you're exposing an enum in a header file, you'll have to use the alternate macros. In your .h, use JREnumDeclare():
//	JREnumDeclare(StreamState,	   Stream_Disconnected,   	Stream_Connecting,                                                    										Stream_Connected, 		Stream_Disconnecting);
//And then use JREnumDefine() in your .m:
//	JREnumDefine(StreamState); for Free!!
// NSString* AZQuadrantToString(int value);

//JREnumDeclare( AZQuadrant, AZTopLeftQuad = 0, AZTopRightQuad, AZBotRightQuad, AZBotLeftQuad);
JREnumDeclare( AZQuad, AZQuadTopLeft = 0, AZQuadTopRight, AZQuadBotRight, AZQuadBotLeft);

//typedef NS_ENUM(NSUI, AZQuadrant){
//	AZTopLeftQuad = 0,
//	AZTopRightQuad,
//	AZBotRightQuad,
//	AZBotLeftQuad
//};


typedef struct {	CGFloat tlX; CGFloat tlY;
	CGFloat trX; CGFloat trY;
	CGFloat blX; CGFloat blY;
	CGFloat brX; CGFloat brY;
} CIPerspectiveMatrix;

//extern NSString *const AZOrientName[AZOrientCount];
extern NSString *const AZMenuPositionName[AZMenuPositionCount];
// NSLog(@"%@", FormatTypeName[XML]);
//NSString *const FormatTypeName[FormatTypeCount] = { [JSON]=@"JSON", [XML]=@"XML", [Atom] = @"Atom", [RSS] = @"RSS", };

typedef NS_ENUM( NSUI, AZItemsViewFormat ){	AZItemsAsBundleIDs,	AZItemsAsPaths,	AZItemsAsNames	};

typedef NS_ENUM(NSUI, SandBox) {	ReadAccess = R_OK,	WriteAccess = W_OK,	ExecuteAccess = X_OK,	PathExists = F_OK };


NS_INLINE void AZPrintEncodingTypes(){
	NSLog(@"%15s: %s","AZPOS", @encode( AZPOS ));
	NSLog(@"%15s: %s",  "NSP", @encode(   NSP ));
	NSLog(@"%15s: %s","NSRGG", @encode( NSRNG ));
	NSLog(@"%15s: %s", "NSSZ", @encode(  NSSZ ));
	NSLog(@"%15s: %s",  "NSR", @encode(   NSR ));
	NSLog(@"%15s: %s", "BOOL", @encode(  BOOL ));
	NSLog(@"%15s: %s","AZPOS", @encode( AZPOS ));
	NSLog(@"%15s: %s",  "CGF", @encode(   CGF ));
	NSLog(@"%15s: %s", "NSUI", @encode(  NSUI ));
	NSLog(@"%15s: %s",  "int", @encode(   int ));
	NSLog(@"%15s: %s",  "NSI", @encode(   NSI ));
	NSLog(@"%15s: %s", "CGCR", @encode(  CGCR ));
	NSLog(@"%15s: %s",   "id", @encode(    id ));
	NSLog(@"%15s: %s",  "NSA", @encode(   NSA ));
}

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
