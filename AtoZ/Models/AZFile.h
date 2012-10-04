#import "AtoZ.h"

// Base abstract class that wraps a file system URL
@interface AZFile : BaseModel //	<BaseModel,NSCopying, NSMutableCopying, NSPasteboardWriting, NSPasteboardReading>

@property (nonatomic, strong, readonly) NSString	*name, *calulatedBundleID;
@property (nonatomic, strong, readonly) NSColor		*labelColor;
@property (nonatomic, strong, readonly) NSImage  	*image;
@property (nonatomic, assign, readonly) NSUInteger 	labelNumber;
@property (nonatomic, assign, readonly)	CGFloat	  	hue;
@property (nonatomic, assign, readonly)	BOOL	  	hasLabel;

@property (nonatomic, strong) 	NSString 	*path;
@property (nonatomic, strong) 	NSColor		*color, *customColor;
@property (nonatomic, readonly) NSArray  	*colors;
@property (nonatomic, assign)	AZWindowPosition		position;

+ (id) forAppNamed:(NSString*)appName;
+ (id) instanceWithPath:	(NSString*) path;
+ (id) instanceWithImage:	(NSImage*)  image;
+ (id) instanceWithColor:	(NSColor*)  color;

- (void) setActualLabelColor: (NSColor*) aColor;

@end

// Concrete subclass of ATDesktopEntity that loads children from a folder
@interface AZFolder : NSArray //AZFile

//@property(nonatomic, readonly) NSMutableArray *children;

@property (readonly) NSUI count;
//@property (readonly) NSUI capacity;
- (id) initWithArray:(NSArray *)array;
+ (id) appFolder;
+ (id) samplerWithCount:(NSUInteger)items;
+ (id) samplerWithBetween:(NSUInteger)minItems andMax:(NSUInteger)items;
+ (id) instanceWithFiles:(NSArray*)files;
+ (id) instanceWithPaths:(NSArray*)strings;

//- (NSArray*)filesMatchingFilter: (NSString *)filte
//- (NSArray*)filesWithCategory: (AppCat)cat;
@end



//@interface AZImage : NSObject
//
//@property (weak,nonatomic)	id objectRep;
//
//@property (retain) NSColor *fillColor;
//@property (copy) NSString *fillColorName;
//
//@property (strong, readwrite) NSString *title;
//
//// Access to the image. This property can be observed to find out when it changes and is fully loaded.
//@property (strong) NSImage *image;
//@property (readonly, retain) NSImage *thumbnailImage;
//
//	// Asynchronously loads the image (if not already loaded). A KVO notification is sent out when the image is loaded.
//- (void)loadImage;
//
//	// A nil image isn't loaded (or couldn't be loaded). An image that is in the process of loading has imageLoading set to YES
//@property (readonly) BOOL imageLoading;
//
//@end

@interface AZDockApp : BaseModel

+ (instancetype)instanceWithPath:(NSString *)path;

@property (nonatomic, assign) 	CGPoint		dockPoint;
@property (nonatomic, assign) 	CGPoint		dockPointNew;
@property (nonatomic, assign) 	NSUInteger	spot;
@property (nonatomic, assign) 	NSUInteger 	spotNew;
@property (readonly)			BOOL		isRunning;
@end



@interface AZDock : BaseModel
@property (readonly) NSArray *dock;
@property (readonly) NSArray *dockSorted;
@property (nonatomic, assign) AZDockSort sortOrder;
@end

@interface AZColor : BaseModel
@property (nonatomic, readonly) CGFloat 	brightness, saturation, hue, hueComponent, percent;
@property (nonatomic, assign)	NSUInteger 	total, count;
@property (nonatomic, strong)	NSString 	*name;
@property (nonatomic, strong)	NSColor	 	*color;

+ (instancetype) instanceWithObject:(NSDictionary*)dic;
+ (instancetype) colorWithColor:(NSColor*)color andDictionary:(NSDictionary*)dic;
- (NSArray*) az_colorsForImage:(NSImage*)image;
+ (instancetype) instanceWithColor:(NSColor*)color count:(NSUI)c total:(NSUI) totes;

@end

	//extern NSString *const AtoZFileUpdated;
	//@class AJSiTunesResult;

	//
	//	// Concrete subclass of ATDesktopEntity that adds support for loading an image at the given URL and stores a fillColor property
	//@interface ATDesktopImageEntity : ATDesktopEntity {
	//@private
	//    BOOL _imageLoading;
	//    NSString *_title;
	//    NSImage *_image;
	//    NSImage *_thumbnailImage;
	//    NSColor *_fillColor;
	//    NSString *_fillColorName;
	//}
	//
	//@property (retain) NSColor *fillColor;
	//@property (copy) NSString *fillColorName;
	//
	//@property (retain, readwrite) NSString *title;
	//
	//	// Access to the image. This property can be observed to find out when it changes and is fully loaded.
	//@property (retain) NSImage *image;
	//@property (readonly, retain) NSImage *thumbnailImage;
	//
	//	// Asynchronously loads the image (if not already loaded). A KVO notification is sent out when the image is loaded.
	//- (void)loadImage;
	//
	//	// A nil image isn't loaded (or couldn't be loaded). An image that is in the process of loading has imageLoading set to YES
	//@property (readonly) BOOL imageLoading;
	//
	//@end
	// Declared constants to avoid typos in KVO. Common prefixes are used for easy code completion.
extern NSString *const ATEntityPropertyNamedFillColor;
extern NSString *const ATEntityPropertyNamedFillColorName;
extern NSString *const ATEntityPropertyNamedImage;
extern NSString *const ATEntityPropertyNamedThumbnailImage;

	//	@property (weak)	id itunesDescription;
	//	@property (weak)	id itunesResults;
	//	@property (nonatomic, strong)	AJSiTunesResult *itunesInfo;
	//	@property (nonatomic, strong)  	NSImage	 * 	icon;

