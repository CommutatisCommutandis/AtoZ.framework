//
//  NSObject+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 7/1/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

//  HRCoder.h
//  Version 1.0
//  Created by Nick Lockwood on 24/04/2012.
//  Copyright (c) 2011 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//  https://github.com/nicklockwood/HRCoder
//
//  ARC Helper
//  Version 1.3
//  Created by Nick Lockwood on 05/01/2012.
//  Copyright 2012 Charcoal Design
//  Distributed under the permissive zlib license
//  Get the latest version from here:
//  https://gist.github.com/1563325

#ifndef AH_RETAIN
#if __has_feature(objc_arc)
#define AH_RETAIN(x) (x)
#define AH_RELEASE(x) (void)(x)
#define AH_AUTORELEASE(x) (x)
#define AH_SUPER_DEALLOC (void)(0)
#define __AH_BRIDGE __bridge
#else
#define __AH_WEAK
#define AH_WEAK assign
#define AH_RETAIN(x) [(x) retain]
#define AH_RELEASE(x) [(x) release]
#define AH_AUTORELEASE(x) [(x) autorelease]
#define AH_SUPER_DEALLOC [super dealloc]
#define __AH_BRIDGE
#endif
#endif
//  ARC Helper ends

static NSString *const HRCoderClassNameKey = @"$class";
static NSString *const HRCoderRootObjectKey = @"$root";
static NSString *const HRCoderObjectAliasKey = @"$alias";


@interface HRCoderAliasPlaceholder : NSObject

+ (HRCoderAliasPlaceholder *)placeholder;

@end


@interface HRCoder : NSCoder

+ (id)unarchiveObjectWithPlist:(id)plist;
+ (id)unarchiveObjectWithFile:(NSString *)path;
+ (id)archivedPlistWithRootObject:(id)object;
+ (BOOL)archiveRootObject:(id)rootObject toFile:(NSString *)path;

- (id)unarchiveObjectWithPlist:(id)plist;
- (id)unarchiveObjectWithFile:(NSString *)path;
- (id)archivedPlistWithRootObject:(id)object;
- (BOOL)archiveRootObject:(id)rootObject toFile:(NSString *)path;

@end


@interface NSObject (AutoCoding) <NSCoding>

//coding

- (NSArray *)codableKeys;
- (NSArray *)uncodableKeys;

//loading / saving

+ (id)objectWithContentsOfFile:(NSString *)path;
- (void)writeToFile:(NSString *)filePath atomically:(BOOL)useAuxiliaryFile;

@end


@interface NSObject (AtoZ)

/*	Now every instance (of every class) has a dictionary, where you can store your custom attributes. With Key-Value Coding you can set a value like this:

//[myObject setValue:attributeValue forKeyPath:@"dictionary.attributeName"]

	And you can get the value like this:
//[myObject valueForKeyPath:@"dictionary.attributeName"]

	That even works great with the Interface Builder and User Defined Runtime Attributes.

	Key Path                   Type                     Value
	dictionary.attributeName   String(or other Type)    attributeValue
*/
- (NSMutableDictionary*) getDictionary;

@end

@interface NSObject (SubclassEnumeration)
+(NSArray *)subclasses;
@end

@interface NSObject (AG)

//- (BOOL) respondsToSelector: (SEL) aSelector;

- (NSDictionary *)propertiesPlease;

+ (NSDictionary *)classPropsFor:(Class)klass;
//- (NSArray*) methodDumpForClass:(NSString *)Class;

- (NSString *)stringFromClass;

-(void)setIntValue:(NSInteger)i forKey:(NSString *)key;
-(void)setIntValue:(NSInteger)i forKeyPath:(NSString *)keyPath;

-(void)setFloatValue:(CGFloat)f forKey:(NSString *)key;
-(void)setFloatValue:(CGFloat)f forKeyPath:(NSString *)keyPath;

-(BOOL)isEqualToAnyOf:(id<NSFastEnumeration>)enumerable;

-(void)fire:(NSString *)notificationName;
-(void)fire:(NSString *)notificationName userInfo:(NSDictionary *)userInfo;

-(id)observeName:(NSString *)notificationName 
      usingBlock:(void (^)(NSNotification *))block;

-(void)observeObject:(NSObject *)object
             forName:(NSString *)notificationName
             calling:(SEL)selector;

-(void)stopObserving:(NSObject *)object forName:(NSString *)notificationName;

-(void)performSelector:(SEL)aSelector afterDelay:(NSTimeInterval)seconds;
-(void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;
-(void)addObserver:(NSObject *)observer 
       forKeyPaths:(id<NSFastEnumeration>)keyPaths;
-(void)removeObserver:(NSObject *)observer 
          forKeyPaths:(id<NSFastEnumeration>)keyPaths;

-(void)willChangeValueForKeys:(id<NSFastEnumeration>)keys;
-(void)didChangeValueForKeys:(id<NSFastEnumeration>)keys;

@end

