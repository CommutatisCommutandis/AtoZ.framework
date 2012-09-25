//
//  AZDock.m
//  AtoZ
//
//  Created by Alex Gray on 9/12/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AtoZModels.h"
#import "AtoZFunctions.h"

//
//@dynamic  appCategories;// = _appCategories,
//@dynamic  sortOrder;// = _sortOrder,
//@dynamic  appFolderStrings;// = _appFolderStrings,
//@dynamic  _dock;// = _dock,
//@dynamic  dockSorted;// = _dockSorted,
//@dynamic  appFolder;// = _appFolder,
//@dynamic  appFolderSorted;// = _appFolderSorted;

@interface  AZFolder ()
@end
@implementation AZFolder


+ (instancetype) instanceWithItems:(NSArray*)items {
	AZFolder *n = [[self class] instance];
	n.items = items.mutableCopy;
	return n;
}
+ (instancetype) instanceWithPaths:(NSArray*)paths {
	AZFolder *n = [[self class] instance];
	n.items = [paths arrayUsingBlock:^id(id obj) {
		return  [AZFile instanceWithPath:obj];
	}].mutableCopy;
	return n;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    return [_items countByEnumeratingWithState:state objects:buffer count:len];
}

- (NSUInteger)count { return self.items.count; }
- (id)objectAtIndex:(NSUInteger)index; { return [self.items normal:index]; }

//@interface  NSArray (SubscriptsAdd)
- (id)objectAtIndexedSubscript:(NSUInteger)index; { return [self.items normal:index]; }

//@interface NSMutableArray (SubscriptsAdd)
- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)index;
{
	index < self.items.count   ?  object
	      ?  [self.items replaceObjectAtIndex:index withObject:object]
	      :  [self.items removeObjectAtIndex:index]
		  :  [self.items addObject:object];
}

- (void) addObject:(id) obj{
	[self.items addObject:obj];
}
//@interface  NSDictionary (SubscriptsAdd)
- (id)objectForKeyedSubscript:(id)k { return [self valueForKey:k]; }

//@interface  NSMutableDictionary (SubscriptsAdd)
- (void)setObject:(id)o forKeyedSubscript:(id)k {[self setValue:o forKey:k]; }
@end

@implementation  AZDock

- (void) setUp {		[[AZDockQuery instance] dock: self];

}

//- (NSArray*) dockSorted {		[[self.dock sortedWithKey:@"hue" ascending:YES]
//											arrayUsingIndexedBlock:^id(AZDockItem* obj, NSUInteger idx) {
//		obj.spotNew = idx;
//		obj.dockPointNew = [_dock[idx][@"dockPoint"]pointValue];
//		return obj;
//								}];  //		if ([obj.name isEqualToString:@"Finder"]) {obj.spotNew = 999;` obj.dockPointNew =
//}

@end
@implementation AZAppFolder


+ (instancetype) samplerWithBetween:(NSUInteger)lowItems and:(NSUInteger)hightItems{
		
}
+ (NSArray*)paths {
	__block NSMutableArray *applications = [NSMutableArray array];
	[AZStopwatch  stopwatch:@"appFolderStrings" timing:^{
		ApplicationsInDirectory(@"/Applications", applications);
	}];
	return  applications;
}

+ (instancetype) appFolder {
	[AZStopwatch start:@"appFolder"];
	AZAppFolder *a = [super instanceWithPaths:[[self class]paths]];
	[AZStopwatch stop:@"appFolder"];
	return a;
}

- (NSArray*) appCategories {
		//	static NSArray *cats;
		//    if (cats == nil) {
	return  @[ 	@"Games",		@"Education",		@"Entertainment",	@"Books",	@"Lifestyle",
	@"Utilities",	@"Business", 		@"Travel",			@"Music", 	@"Reference",
	@"Sports",		@"Productivity",	@"News", 			@"Healthcare & Fitness",
	@"Photography", @"Finance", 		@"Medical", 			@"Social Networking",
	@"Navigation",	@"Weather",			@"Catalogs", 		@"Food & Drink",
	@"Newsstand" ];
		//[NSArray alloc] initWithObjects:kCategoryNames count:23];
		//    }
		//    return cats;
}


@end


NSString *const AZFileUpdated = @"AZFileUpdated";

@implementation AZFile
	//@synthesize dockPoint, dockPointNew, spot, spotNew;
	//@synthesize hue, isRunning, hasLabel, needsToMove; //labelNumber;
	//@synthesize itunesInfo, itunesDescription;

- (void) setUp {
	self.color 			= RED;
	self.customColor 	= BLACK;
	self.labelColor 	= BLACK;
	self.labelNumber	= @(99);
	self.position		= AZPositionAutomatic;
}

+ (AZFile*) forAppNamed:(NSString*)appName  {
	return [[[AtoZ dock] valueForKeyPath:@"name"]  filterOne:^BOOL(id object) {
		return ([object isEqualTo:appName] ? YES : NO);
	}];
}

	//- (NSString*) itunesDescription { return self.itunesInfo.itemDescription; }
	//- (AJSiTunesResult *) itunesInfo { return  [AtoZiTunes resultsForName:self.name]; }


+ (instancetype) dummy {		return [[AZFile alloc]initWithObject:[[NSBundle bundleForClass:[AtoZ class]]pathForImageResource:@"missing.png"]]; }


+ (instancetype) instanceWithColor: (NSColor*)color {
//	return [[AZFile alloc]initWithObject:path];
	AZFile*d = [AZFile dummy];
	d.color = [color isBoring] ? RANDOMCOLOR : color;
//	d.colors = @[color];
//	NSImage *ren = [[NSImage alloc]initWithContentsOfFile:d.path];
	d.image = [[[NSImage imageInFrameworkWithFileName:@"missing.png"]imageByScalingProportionallyToSize:AZSizeFromDimension(512)] tintedWithColor:color];
	return d;
}
+ (instancetype) instanceWithImage:(NSImage *)image {
	[image setSize : AZSizeFromDimension(512)];
	AZFile*d = [AZFile dummy];
	NSLog($(@"colors is ** %@ ** boring", StringFromBOOL([d.color isBoring])));
	d.color = [d.color isBoring] ? RANDOMCOLOR : d.color;
		//	d.colors = @[color];
	d.image = [d.image coloredWithColor:d.color];
	return d;
}

+ (instancetype)instanceWithPath:(NSString *)path {

	return [AZFile instanceWithObject:path];
		//	[[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:AZFileUpdated object:[AtoZ sharedInstance].dockSorted];
}


- (void) setWithString:(NSString *)string {
	self.path = string;
}
- (void) setPath:(NSString *)path
{
	_path = path;
	self.name = [[_path lastPathComponent] stringByDeletingPathExtension];
}
- (NSImage*)image {	NSBitmapImageRep *rep;
	NSSize theSize = AZSizeFromDimension(512);
	if (_image) return _image;
	else {
		BOOL hasIcon = [AZWORKSPACE iconForFile:_path] ? YES : NO;
		if (hasIcon) {
			_image = [[AZWORKSPACE iconForFile:_path]imageScaledToFitSize:theSize];
			_colors = self.colors;
		} else _image = _color ? [[NSImage imageInFrameworkWithFileName:@"missing.png"]tintedWithColor: _color]
			:  [NSImage imageInFrameworkWithFileName:@"missing.png"];
	}
	return  _image;
}

- (NSString*) calulatedBundleID {
	return [NSBundle calulatedBundleIDForPath:_path];
}


-(NSArray*) colors {

	if (_colors) return  _colors;
	else {
		@autoreleasepool {

			NSArray *rawArray = [self.image quantize];
				// put all colors in a bag
			NSBag *allBag = [NSBag bag];
			for (id thing in rawArray ) [allBag add:thing];
			NSBag *rawBag = [NSBag bag];
			int total = 0;
			for ( NSColor *aColor in rawArray ) {
					//get rid of any colors that account for less than 10% of total
				if ( ( [allBag occurrencesOf:aColor] > ( .0005 * [rawArray count]) )) {
						// test for borigness
					if ( [aColor isBoring] == NO ) {
						NSColor *close = [aColor closestNamedColor];
						total++;
						[rawBag add:close];
					}
				}
			}
			NSArray *exciting = 	[[rawBag objects] filter:^BOOL(id object) {
				NSColor *idColor = object;
				return ([idColor isBoring] ? FALSE : TRUE);
			}];

				//uh oh, too few colors
			if ( ([[rawBag objects]count] < 2) || (exciting.count < 2 )) {
				for ( NSColor *salvageColor in rawArray ) {
					NSColor *close = [salvageColor closestNamedColor];
					total++;
					[rawBag add:close];
				}
			}
			NSMutableArray *colorsUnsorted = [NSMutableArray array];

			for (NSColor *idColor in [rawBag objects] ) {

				AZColor *acolor = [AZColor instance];
				acolor.color = idColor;
				acolor.count = [rawBag occurrencesOf:idColor];
				acolor.percent = ( [rawBag occurrencesOf:idColor] / (float)total );
				[colorsUnsorted addObject:acolor];
			}
			rawBag = nil; allBag = nil;
			return [colorsUnsorted sortedWithKey:@"count" ascending:NO];
		}
	}
}
	//- (NSColor*) color {
	//	NSLog(@"color for %@:  %@", self.name, (color ? color : [[self.colors objectAtNormalizedIndex:0] valueForKey:@"color"]));
	//	return (color ? color : [[self.colors objectAtNormalizedIndex:0] valueForKey:@"color"]);
	//}

- (CGFloat) hue { return self.color.hueComponent; }

- (BOOL) isRunning {
	return  ([[[[NSWorkspace sharedWorkspace] runningApplications] valueForKeyPath:@"localizedName"]containsObject:self.name] ? YES : NO);
}
	//
	//- (NSColor*) labelColor {
	//	NSURL* fileURL = [NSURL fileURLWithPath:self.path];
	//	NSDictionary *d = [fileURL resourceValuesForKeys:$array(NSURLLabelColorKey) error:nil];
	//	return ( [d valueForKey:NSURLLabelColorKey]  ? (NSColor*) [d valueForKey:NSURLLabelColorKey] : nil);
	//}
	//
	//
	//- (NSNumber*) labelNumber {
	//	NSURL* fileURL = [NSURL fileURLWithPath:self.path];
	//	NSDictionary *d = [fileURL resourceValuesForKeys:$array(NSURLLabelNumberKey) error:nil];
	//	return ( [d valueForKey:NSURLLabelNumberKey] ? [d valueForKey:NSURLLabelNumberKey] : nil);
	//	//	You can use both the NSURLLabelNumberKey to get the number of the Finder's assigned label or the NSURLLabelColorKey to get the actual color.
	//
	//}
- (void)setActualLabelColor:(NSColor *)aLabelColor {
	NSError *error = nil;
	NSURL* fileURL = [NSURL fileURLWithPath:self.path];
	[fileURL setResourceValue:(id)aLabelColor forKey:NSURLLabelColorKey error:&error];
	if (error) NSLog(@"Problem setting label for %@", self.name);
}
- (void)setActualLabelNumber:(NSNumber*)aLabelNumber {
	NSError *error = nil;
	NSURL* fileURL = [NSURL fileURLWithPath:self.path];
	[fileURL setResourceValue:aLabelNumber forKey:NSURLLabelNumberKey error:&error];
	if (error) NSLog(@"Problem setting label (#) for %@", self.name);
    return;
}

@end

@implementation AZDockItem



+ (instancetype)instanceWithPath:(NSString *)path {
	AZDockItem *k = [AZDockItem instanceWithObject:path];
//		[k setWit]//:path];

		//	k.path = path;
	NSLog(@"Made dockItem for %@", k.name);
		//AZDockItem * s = [AZDockItem instance];
		//	[AZDockItem instanceWithPath::[super instanceWithPath:path]];
	return k;
		//	AZDockItem *u = (AZDockItem*)[super instanceWithPath:string];
		//	u.path = string;
		//	[[self super] setUp]; //WithPath:string];
		//	return u;
}
	//@property (nonatomic, assign) 	CGPoint		dockPoint;
	//@property (nonatomic, assign) 	CGPoint		dockPointNew;
	//@property (nonatomic, assign) 	NSUInteger	spot;
	//@property (nonatomic, assign) 	NSUInteger 	spotNew;
	//@property (nonatomic, readonly)	BOOL		isRunning;
	//@property (nonatomic, assign)	BOOL		needsToMove;

@end


