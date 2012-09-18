
//  NSObject+AtoZ.h
//  AtoZ

//  Created by Alex Gray on 7/1/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.


#import <Foundation/Foundation.h>

#import "AtoZ.h"



@interface NSUserDefaults (Subscript)
+ (NSUserDefaults*) defaults;
//- (id) 	objectForKeyedSubscript:	(NSString*) key;
- (void) setObject:	(id) newValue forKeyedSubscription:	(NSString*) key;
@end;

//  HRCoder.h
//  Version 1.0
//  Created by Nick Lockwood on 24/04/2012.
//  Copyright (c) 2011 Charcoal Design

//  Distributed under the permissive zlib License
//  Get the latest version from here:
//  https: //github.com/nicklockwood/HRCoder

//  ARC Helper required;

static NSString *const HRCoderClassNameKey = @"$class";
static NSString *const HRCoderRootObjectKey = @"$root";
static NSString *const HRCoderObjectAliasKey = @"$alias";

@interface HRCoderAliasPlaceholder : NSObject

+ (HRCoderAliasPlaceholder*) placeholder;

@end

@interface HRCoder : NSCoder

+ (id) unarchiveObjectWithPlist: 	(id) plist;
+ (id) unarchiveObjectWithFile: 	(NSString*) path;
+ (id) archivedPlistWithRootObject:	(id) object;
+ (BOOL) archiveRootObject: 			(id) rootObject toFile:	(NSString*) path;

- (id) unarchiveObjectWithPlist:		(id) plist;
- (id) unarchiveObjectWithFile:		(NSString*) path;
- (id) archivedPlistWithRootObject:	(id) object;
- (BOOL) archiveRootObject:	(id) rootObject toFile:	(NSString*) path;

@end

@interface NSObject (AutoCoding) <NSCoding>

//coding

- (NSArray*) codableKeys;
- (NSArray*) uncodableKeys;

//loading / saving

+ (id) objectWithContentsOfFile:	(NSString*) path;
- (void) writeToFile:	(NSString*) filePath atomically:	(BOOL) useAuxiliaryFile;

@end

@interface NSObject (AtoZ)

//- existsOrElse:(id(^)(BOOL yesOrNO))block {
//
//}
//+(void)immediately:(void (^)())block
//{
//    [self begin];
//    [self setDisableActions:YES];
//    block();
//    [self commit];
//}


	// Finds all properties of an object, and prints each one out as part of a string describing the class.
+ (NSString*)  autoDescribeWithClassType:	(Class) classType;

+ (NSString*)  autoDescribe;

- (void) setWindowPosition:	(AZWindowPosition) pos;
- (AZWindowPosition) windowPosition;

/*	Now every instance (of every class) has a dictionary, where you can store your custom attributes. With Key- Value Coding you can set a value like this:

//[myObject setValue: attributeValue forKeyPath: @"dictionary.attributeName"]

	And you can get the value like this:
//[myObject valueForKeyPath: @"dictionary.attributeName"]

	That even works great with the Interface Builder and User Defined Runtime Attributes.

	Key Path                   Type                     Value
	dictionary.attributeName   String(or other Type)    attributeValue
*/
- (NSMutableDictionary*) getDictionary;
- (BOOL) debug;
@end

@interface NSObject (SubclassEnumeration)
+(NSArray*) subclasses;
@end

@interface NSObject (AG)

//- (BOOL) respondsToSelector:	(SEL) aSelector;

- (NSDictionary*) propertiesPlease;
- (NSDictionary *)propertiesSans:(NSString*)someKey;

+ (NSDictionary*) classPropsFor:	(Class) klass;
//- (NSArray*) methodDumpForClass:	(NSString*) Class;

- (NSString*) stringFromClass;

- (void) setIntValue:	(NSInteger) i forKey:	(NSString*) key;
- (void) setIntValue:	(NSInteger) i forKeyPath:	(NSString*) keyPath;

- (void) setFloatValue:	(CGFloat) f forKey:	(NSString*) key;
- (void) setFloatValue:	(CGFloat) f forKeyPath:	(NSString*) keyPath;

- (BOOL) isEqualToAnyOf:	(id<NSFastEnumeration>) enumerable;

- (void) fire:	(NSString*) notificationName;
- (void) fire:	(NSString*) notificationName userInfo:	(NSDictionary*) userInfo;

- (id) observeName:	(NSString*) notificationName 
      usingBlock:	(void (^) (NSNotification*) ) block;

- (void) observeObject:	(NSObject*) object
             forName:	(NSString*) notificationName
             calling:	(SEL) selector;

-(void)observeName:(NSString *)notificationName
		   calling:(SEL)selector;

- (void) stopObserving:	(NSObject*) object forName:	(NSString*) notificationName;

- (void) performSelector:	(SEL) aSelector afterDelay:	(NSTimeInterval) seconds;
- (void) addObserver:	(NSObject*) observer forKeyPath:	(NSString*) keyPath;
- (void) addObserver:	(NSObject*) observer 
       forKeyPaths:	(id<NSFastEnumeration>) keyPaths;
- (void) removeObserver:	(NSObject*) observer 
          forKeyPaths:	(id<NSFastEnumeration>) keyPaths;

- (void) willChangeValueForKeys:	(id<NSFastEnumeration>) keys;
- (void) didChangeValueForKeys:	(id<NSFastEnumeration>) keys;


#pragma PropertyArray
- (NSDictionary*) dictionaryWithValuesForKeys;
- (NSArray*)  allKeys;

/** Example:
	MyObject *obj = [[MyObject alloc] init];
	obj.a = @"Hello A";  //setting some values to attrtypedef <#existing#> <#new#>;ibutes
	obj.b = @"Hello B";

	//dictionaryWithValuesForKeys requires keys in NSArray. You can now
	//construct such NSArray using `allKeys` from NSObject(PropertyArray) category
	NSDictionary *objDict = [obj dictionaryWithValuesForKeys: [obj allKeys]];

	//Resurrect MyObject from NSDictionary using setValuesForKeysWithDictionary
	MyObject *objResur = [[MyObject alloc] init];
	[objResur setValuesForKeysWithDictionary: objDict];
*/

#pragma SetClass
- (void) setClass:	(Class) aClass;


// In your custom class
+ (id) customClassWithProperties:	(NSDictionary*) properties;
- (id) initWithProperties:	(NSDictionary*) properties;

@end




//It actually works best if you create a category on NSObject and just drop that method straight in there, that way you can call it on any object.

@interface NSObject (PrimitiveEvocation)
- (void *)performSelector:(SEL)selector withValue:(void *)value;
@end

//Here are some examples. First of all, let’s just assume we have a class with the following methods:

//	- (void)doSomethingWithFloat:(float)f;  // Example 1
//	- (int)addOne:(int)i;                   // Example 2

// Example 1
//	float value = 7.2661; // Create a float
//	float *height = &value; // Create a _pointer_ to the float (a floater?)
//	[self performSelector:@selector(doSomethingWithFloat:) withValue:height]; // Now pass the pointer to the float
//	free(height); // Don't forget to free the pointer!

// Example 2
//	int ten = 10; // As above
//	int *i = &ten;
//	int *result = [self performSelector:@selector(addOne:) withValue:i]; // Returns a __pointer__ to the int
//	NSLog(@"result is %d", *result); // Remember that it's a pointer, so keep the *!
//	free(result);

/*  Things get a little more complicated when dealing with methods that return objects, as opposed to primitives or structs. For primitives, our performSelector:withValue: returns a pointer to the method’s return value (i.e. a primitive). However, when the underlying method returns an object, it’s actually returning a pointer to the object. So that means that when our code runs, it ends up returning a pointer to a pointer to the object (i.e. a void **), which you need to handle appropriately. If that wasn’t tricky enough, if you’re using ARC, you also need to bridge the void * pointer to bring it into Objective-C land.	*/

//	Here are some examples. Let’s assume you have a class with the following methods:
//	- (NSObject *)objectIfTrue:(BOOL)b;     // Example 3
//	- (NSString *)strWithView:(UIView *)v;  // Example 4
//	Notice how both methods return objects (well, technically, pointers to objects, which is important!). We can now use performSelector:withValue: as follows:
/*
	BOOL y = YES; // Same as previously
	BOOL *valid = &y;
	void **p = [self performSelector:@selector(objectIfTrue:) withValue:valid]; // Returns a pointer to an NSObject (standard Objective-C behaviour)
	NSObject *obj = (__bridge NSObject *)*p; // bridge the pointer to Objective-C
	NSLog(@"object is %@", obj);
	free(p); */

//	Notice the return type of performSelector:withValue: is void **. In other words, a pointer to a pointer of type void (which means any type). We then reference the pointer once to get to a pointer to the actual object (to void * — a standard void pointer) and then use a bridged cast to convert that pointer to NSObject * which is a standard object (again, technically, a pointer to an object).

// 	Here’s one final example bringing everything to do with objects together, showing how to use performSelector:withValue: to call a selector on an object, with an object as an argument and as a return type:
/*
UIView *view = [[UIView alloc] init];
void **p = [self performSelector:@selector(strWithView:) withValue:&view];
NSString *str = (__bridge NSString *)*p;
NSLog(@"string is %@", str);
free(p);
*/


/// USAGE:  [someDictionary mapPropertiesToObject: someObject];

@interface NSDictionary  (PropertyMap)

- (void) mapPropertiesToObject:	(id) instance;

@end
