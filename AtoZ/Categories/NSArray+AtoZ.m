//
//  NSArray+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 6/29/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "AtoZ.h"

#import "NSArray+AtoZ.h"

@implementation NSArray (AtoZ)


- (NSArray *)colorValues {
	return [self arrayPerformingSelector:@selector(colorValue)];
}


- (NSArray *)arrayUsingIndexedBlock:(id (^)(id obj, NSUInteger idx))block {

   NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [result addObject:block(obj, idx)];
    }];
    return result;
}

// NSArray *sortedArray = [theArray sortedWithKey:@"theKey" ascending:YES];
- (NSArray *)sortedWithKey:(NSString *)theKey ascending:(BOOL)ascending {
    return [self sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:theKey ascending:ascending] ]];
}


static NSInteger comparatorForSortingUsingArray(id object1, id object2, void *context)
{
    // Use NSArray's -indexOfObject:anObject rather than its "identical" form,
    // -indexOfObjectIdenticalTo:anObject. Note that converting object to index
    // answers an unsigned integer. A value of NSNotFound indicates, well, not
    // found! And, since this value equals -1 and therefore the maximum possible
    // unsigned integer, objects not found come last in the sorting order. Also
    // note, if the two objects have the same index, their values are compared
    // as normal.
    NSUInteger index1 = [(__bridge NSArray *)context indexOfObject:object1];
    NSUInteger index2 = [(__bridge NSArray *)context indexOfObject:object2];
    if (index1 < index2)
        return NSOrderedAscending;
    // else
    if (index1 > index2)
        return NSOrderedDescending;
    // else
    return [object1 compare:object2];
}

//- (NSArray *)sortedArrayUsingArray:(NSArray *)otherArray
//{	NSArray *array = [
//    return [self sortedArrayUsingFunction:comparatorForSortingUsingArray context:otherArray];
//}



// an array of NSNumbers with Integer values, NSNotFound is the terminator
+ (NSArray *)arrayWithInts:(NSInteger)i,... {
	NSMutableArray *re = NSMutableArray.array;
	
	[re addObject:[NSNumber numberWithInt:i]];
	
	va_list args;
	va_start(args, i);
	NSInteger v;
	while ((v = va_arg(args, NSInteger)) != NSNotFound) {
		[re addObject:[NSNumber numberWithInt:v]];
	}
	va_end(args);
	
	return re;
}

// an array of NSNUmbers with double values, MAXFLOAT is the terminator
+ (NSArray *)arrayWithDoubles:(double)f,... {
	NSMutableArray *re = NSMutableArray.array;
	
	[re addObject:[NSNumber numberWithDouble:f]];
	
	va_list args;
	va_start(args, f);
	double v;
	while ((v = va_arg(args, double)) != MAXFLOAT) {
		[re addObject:[NSNumber numberWithDouble:v]];
	}
	va_end(args);
	
	return re;
}

//
// NSArray instance methods
//

// set-version of this array
- (NSSet *)set {
	return [NSSet setWithArray:self];
}

- (NSArray *)shifted {
	NSMutableArray *re = [self mutableCopy];
	[re removeFirstObject];
	return re;
}

- (NSArray *)popped {
	NSMutableArray *re = [self mutableCopy];
	[re removeLastObject];
	return re;
}

- (NSArray *)reversed {
	return [[self mutableCopy] reverse];
}

// array evaluating the keyPath
- (NSArray *)arrayWithKey:(NSString *)keyPath {
	NSMutableArray *re = [NSMutableArray arrayWithCapacity:self.count];
	for (id o in self) {
		id v = [o valueForKeyPath:keyPath];
		if (v) {
			[re addObject:v];
		}
	}
	return re;
}

// array evaluating a selector
- (NSArray *)arrayPerformingSelector:(SEL)selector {
	NSMutableArray *re = [NSMutableArray arrayWithCapacity:self.count];
	for (id o in self) {
		id v = [o performSelector:selector];
		if (v) {
			[re addObject:v];
		}
	}
	return re;
}

- (NSArray *)arrayPerformingSelector:(SEL)selector withObject:(id)object {
	NSMutableArray *re = [NSMutableArray arrayWithCapacity:self.count];
	for (id o in self) {
		id v = [o performSelector:selector withObject:object];
		if (v) {
			[re addObject:v];
		}
	}
	return re;
}

- (NSArray *)arrayUsingBlock:(id (^)(id obj))block {
	return [self map:block];
}

- (NSArray *)map:(id (^)(id obj))block {
	NSMutableArray *re = [NSMutableArray arrayWithCapacity:self.count];
	for (id o in self) {
		id v = block(o);
		if (v) [re addObject:v];
	}
	return re;
}

- (NSArray *)nmap:(id (^)(id obj, NSUInteger index))block {
	NSMutableArray *re = [NSMutableArray arrayWithCapacity:self.count];
	for (int i = 0; i < self.count; i++) {
		id v, o = [self objectAtIndex:i];
		if ((v = block(o,i))) [re addObject:v];
	}
	return re;
}

- (id)reduce:(id (^)(id a, id b))block {
	if (!self.count) {
		return nil;
	}
	
	id re = self.first;
	
	for (int i = 1; i < self.count; i++) {
		re = block(re, [self objectAtIndex:i]);
	}
	
	return re;
}

- (NSArray *)arrayWithoutObject:(id)object {
	return [self arrayWithoutSet:[NSSet setWithObject:object]];
}

- (NSArray *)arrayWithoutObjects:(id)object,... {
	NSSet *s = NSSet.set;
	
	va_list args;
	va_start(args, object);
	id o = nil;
	while ((o = va_arg(args,id)) != nil) {
		s = [s setByAddingObject:o];
	}
	va_end(args);
	
	NSArray *re = [self arrayWithoutSet:s];
	
	return re;
}

- (NSArray *)arrayWithoutArray:(NSArray *)value {
	return [self arrayWithoutSet:value.set];
}

- (NSArray *)arrayWithoutSet:(NSSet *)values {
	NSArray *re = NSArray.array;
	
	for (id o in self) {
		if (![values containsObject:o]) {
			re = [re arrayByAddingObject:o];
		}
	}
	
	return re;
}

- (NSArray *)filter:(BOOL (^)(id object))block {
	return [self filteredArrayUsingBlock:^(id o, NSDictionary *d) {
		return (BOOL) block(o);
	}];
}

- (id)filterOne:(BOOL (^)(id object))block {
	__block id re = nil;
	
	[self enumerateObjectsUsingBlock:^(id o, NSUInteger i, BOOL *stop) {
		if (block(o)) {
			*stop = YES;
			re = o;
		}
	}];
	
	return re;
}

- (BOOL)allKindOfClass:(Class)aClass {
	for (id o in self) {
		if (![o isKindOfClass:aClass]) {
			return NO;
		}
	}
	
	return YES;
}

- (NSArray *)elementsOfClass:(Class)aClass {
	NSMutableArray *re = NSMutableArray.array;
	
	for (id o in self) {
		if ([o isKindOfClass:aClass]) {
			[re addObject:o];
		}
	}
	
	return re;
}

- (NSArray *)numbers {
	return [self elementsOfClass:NSNumber.class];
}

- (NSArray *)strings {
	return [self elementsOfClass:NSString.class];
}

//- (NSArray *)trimmedStrings {
//	NSMutableArray *re = NSMutableArray.array;
//	
//	for (id o in self) {
//		if ([o isKindOfClass:NSString.class]) {
//			NSString *s = [o trim];
//			if (!s.isEmpty) {
//				[re addObject:s];
//			}
//		}
//	}
//	
//	return re;
//}

//
// accessing
//

- (id)objectAtIndex:(NSUInteger)index fallback:(id)fallback {
	if (self.count <= index) {
		return fallback;
	}
	
	@try {
		id re = [self objectAtIndex:index];
		return !re ? fallback : re;
	}
	@catch (NSException *e) {
		return fallback;
	}
}

- (id)objectOrNilAtIndex:(NSUInteger)index {
	if (self.count <= index) {
		return nil;
	}
	
	return [self objectAtIndex:index];
}


- (id)first {
	return [self objectOrNilAtIndex:0];
}

- (id)second { 
	return [self objectOrNilAtIndex:1]; 
}

- (id)thrid {
	return [self objectOrNilAtIndex:2];
}

- (id)fourth {
	return [self objectOrNilAtIndex:3];
}

- (id)fifth {
	return [self objectOrNilAtIndex:4];
}

- (id)sixth {
	return [self objectOrNilAtIndex:5];
}

- (NSArray *)subarrayFromIndex:(NSInteger)start
{
	return [self subarrayFromIndex:start toIndex:(self.count - 1)];
}

- (NSArray *)subarrayToIndex:(NSInteger)end
{
	return [self subarrayFromIndex:0 toIndex:end];
}

- (NSArray *)subarrayFromIndex:(NSInteger)start toIndex:(NSInteger)end
{
	NSInteger from = start;
	while (from < 0) {
		from += self.count;
	}
	if (from > self.count) {
		return nil;
	}
	NSInteger to = end;
	while (to < 0) {
		to += self.count;
	}
	
	if (from >= to) {
		// this behaviour is somewhat different
		// it will return anything from this array except the passed range
		NSArray *re = [NSArray array];
		
		if (from > 0) {
			re = [self subarrayWithRange:NSMakeRange(0, from - 1)];
		}
		if (to < self.count) {
			if (re != nil) {
				re = [re arrayByAddingObjectsFromArray:[self subarrayWithRange:NSMakeRange(to - 1, self.count - 1)]];
			}
		}
		
		return re;
	}
	
	return [self subarrayWithRange:NSMakeRange(from, to)];
}

- (id)randomElement {
	if (!self.count) {
		return nil;
	}
	NSUInteger index = arc4random() % self.count;
	
	return [self objectAtIndex:index];
}

- (NSArray *)shuffeled {
	if (self.count < 2) {
		return self;
	}
	
	return ((NSMutableArray *) self.mutableCopy).shuffle;
}

- (NSArray *)randomSubarrayWithSize:(NSUInteger)size {
	if (self.count == 0) {
		return [NSArray array];
	}
	
	NSUInteger capacity = MIN(size, self.count);
	NSMutableArray *re = [NSMutableArray arrayWithCapacity:capacity];
	
	while (re.count < capacity) {
		NSUInteger index = random() % (self.count - re.count);
		id e = [self objectAtIndex:index];
		while ([re containsObject:e]) {
			e = [self objectAtIndex:++index];
		}
		[re addObject:e];
	}
	
	return re;
}

- (id)objectAtNormalizedIndex:(NSInteger)index {
	if (self.count == 0) {
		return nil;
	}
	
	while (index < 0) {
		index += self.count;
	}
	
	return [self objectAtIndex:index % self.count];
}

- (NSInteger)sumIntWithKey:(NSString *)keyPath {
	NSInteger re = 0;
	for (id v in self) {
		id k = v;
		if (keyPath != nil) {
			k = [v valueForKeyPath:keyPath];
		}
		if ([k isKindOfClass:NSNumber.class]) {
			re += [k intValue];
		}
	}
	
	return re;
}

- (CGFloat)sumFloatWithKey:(NSString *)keyPath {
	CGFloat re = 0;
	for (id v in self) {
		id k = v;
		if (keyPath != nil) {
			k = [v valueForKeyPath:keyPath];
		}
		if ([k isKindOfClass:NSNumber.class]) {
			re += [k floatValue];
		}
	}
	
	return re;
}

- (BOOL)containsAny:(id <NSFastEnumeration>)enumerable {
	for (id o in enumerable) {
		if ([self containsObject:o]) {
			return YES;
		}
	}
	
	return NO;
}
- (BOOL)containsAll:(id <NSFastEnumeration>)enumerable {
	for (id o in enumerable) {
		if (![self containsObject:o]) {
			return NO;
		}
	}
	
	return YES;
}


-(BOOL)doesNotContainObjects:(id<NSFastEnumeration>)enumerable {
   for (id x in enumerable) {
     if ([self containsObject:x]) return NO; // exists, abort!
   }
   return YES;   // it ain't in there, return TRUE;
}
- (BOOL)doesNotContainObject:(id)object {
  if ([self containsObject:object]) return NO; return YES;
}

// will always return nil
-(id)andExecuteEnumeratorBlock {
	return nil;
}

-(void)setAndExecuteEnumeratorBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block {
	[self enumerateObjectsUsingBlock:block];
}

-(NSArray *)objectsWithFormat:(NSString *)format, ... {
	va_list args;
	va_start(args, format);
	NSPredicate *p = [NSPredicate predicateWithFormat:format arguments:args];
	va_end(args);
	
	return [self filteredArrayUsingPredicate:p];
}

-(id)firstObjectWithFormat:(NSString *)format, ... {
	va_list args;
	va_start(args, format);
	NSPredicate *p = [NSPredicate predicateWithFormat:format arguments:args];
	va_end(args);
	
	NSArray *lookup = [self filteredArrayUsingPredicate:p];
	
	if (lookup.count) {
		return lookup.first; 
	}
	
	return nil;
}

-(NSArray *)filteredArrayUsingBlock: (BOOL (^)(id evaluatedObject, NSDictionary *bindings))block
{
	NSPredicate *p = [NSPredicate predicateWithBlock:block];
	return [self filteredArrayUsingPredicate:p];
}

-(NSArray*) uniqueObjects {
    NSSet *set = [[NSSet alloc] initWithArray: self];
    NSArray *vals = [set allObjects];
    return vals;
}
 
 
-(NSArray*) uniqueObjectsSortedUsingSelector: (SEL)comparator {
    NSSet *set = 
        [[NSSet alloc] initWithArray: self];
    NSArray *vals = 
        [[set allObjects] sortedArrayUsingSelector: comparator];
    return vals;
}
 
 
 /**
 * Convenience Method to return the first object in
 * a NSArray
 */
- (id) firstObject
{
	return ( [self count] > 0 ) ? [self objectAtIndex:0] : nil;
}

 
 /**
 Iterates over all the objects in an array and calls the block on each object
 
 This iterates over all the objects in an array calling the block on each object
 until it reaches the end of the array or until the BOOL *stop pointer is set to YES.
 This method was inspired by Ruby's each method and works very similarly to it, while
 at the same time staying close to existing ObjC standards for block arguments which
 is why it passes a BOOL *stop pointer allowing you to signal for enumeration to end.
 
 Important! If block is nil then this method will throw an exception.
 
 @param obj (Block Parameter) this is the object in the array currently being enumerated over
 @param index (Block Parameter) this is the index of obj in the array
 @param stop (Block Parameter) set this to YES to stop enumeration, otherwise there is no need to use this
 */
- (void) each:(void (^)(id obj, NSUInteger index, BOOL *stop))block
{
	[self enumerateObjectsUsingBlock:block];
}

/**
 Enumerates over the receiving arrays objects concurrently in a synchronous method.
 
 Enumerates over all the objects in the receiving array concurrently. That is it will
 go over each object and execute a block passing that object in the array as a parameter 
 in the block. This methods asynchronously executes a block for all objects in the array
 but waits for all blocks to finish executing before going on.
 
 @param index (Block Parameter) the position of the object in the array
 @param obj (Block Parameter) the object being enumerated over
 @param stop (Block Parameter) if you need to stop the enumeration set this to YES otherwise do nothing
 */
- (void) eachConcurrentlyWithBlock:(void (^)(NSInteger index, id obj, BOOL * stop))block
{
	//make sure we get a unique queue identifier
    dispatch_group_t group = dispatch_group_create();
	dispatch_queue_t queue = dispatch_queue_create([[NSString stringWithFormat:@"%@%@", @"com.AGFoundation.NSArray_", [AtoZ newUniqueIdentifier]] UTF8String], DISPATCH_QUEUE_CONCURRENT);
    __block BOOL _stop = NO;
    NSInteger idx = 0;

    for (id object in self) {
        if (_stop) { break; }
        dispatch_group_async(group, queue, ^{
			block (idx,object, &_stop);
		});
        idx++;
    }

    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    dispatch_release(group);
	dispatch_release(queue);
}

/**
 * Finds the first instance of the object that you indicate
 * via a block (returning a bool) you are looking for
 */
- (id) findWithBlock:(BOOL (^)(id obj))block
{
	__block id foundObject = nil;
	[self enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id object, NSUInteger idx, BOOL *stop) {
		if (block(object)) {
			foundObject = object;
			*stop = YES;
		}
	}];	
    return foundObject;
}

/**
 * Exactly like findWithBlock except it returns a BOOL
 */
- (BOOL) isObjectInArrayWithBlock:(BOOL (^)(id obj))block
{
	return ( [self findWithBlock:block] ) ? YES : NO;
}

/**
 * Like find but instead of returning the first object
 * that passes the test it returns all objects passing the
 * bool block test
 */
- (NSArray *)findAllWithBlock:(BOOL (^)(id obj))block
{
    NSMutableArray * results = [[NSMutableArray alloc] init];
	[self each:^(id obj, NSUInteger index, BOOL *stop) {
		if (block(obj)) {
			[results addObject:obj];
		}
	}];
    return results;
}

#if !(TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

/**
 * experimental method
 * like find but instead uses NSHashTable to store weak pointers to
 * all objects passing the test of the bool block
 *
 * I don't particularly like this name but given objc's naming
 * structure this is as good as I can do for now
 */
- (NSHashTable *) findAllIntoWeakRefsWithBlock:(BOOL (^)(id))block
{
    NSHashTable * results = [NSHashTable hashTableWithWeakObjects];
    [self each:^(id obj, NSUInteger index, BOOL *stop) {
		if (block(obj)) {
			[results addObject:obj];
		}
	}];
    return results;
}

#endif

/**
 * mapArray basically maps an array by enumerating
 * over the array to be mapped and executes the block while
 * passing in the object to map. You simply need to either
 * (1) return the object to be mapped in the new array or
 * (2) return nil if you don't want to map the passed in object
 *
 * @param block a block in which you return an object to be mapped to a new array or nil to not map it
 * @return a new mapped array
 */
- (NSArray *) mapArray:(id (^)(id obj))block
{
    NSMutableArray * cwArray = [[NSMutableArray alloc] init];
	[self each:^(id obj, NSUInteger index, BOOL *stop) {
		id rObj = block(obj);
        if (rObj) {
            [cwArray addObject:rObj];
        }
	}];
    return cwArray;
}

 
 
@end

@implementation NSArray(ListComprehensions) // Create a new array with a block applied to each index to create a new element 
+ (NSArray*)arrayWithBlock:(id(^)(int index))block range:(NSRange)range { id array = [NSMutableArray array]; for (int i=range.location; i<range.location+range.length; i++) [array addObject:block(i)]; return	array; } // The same with a condition 

+ (NSArray*)arrayWithBlock:(id(^)(int index))block range:(NSRange)range if:(BOOL(^)(int index))blockTest { id array = [NSMutableArray array]; for (int i=range.location; i<range.location+range.length; i++) if (blockTest(i))	 [array addObject:block(i)]; return	array; } 


@end


@implementation NSMutableArray (AG)

-(id)last {
return self.lastObject;
}

-(void)setLast:(id)anObject {
	if (anObject) {
		[self willChangeValueForKey:@"last"];
		[self addObject:anObject];
		[self didChangeValueForKey:@"last"];
	}
}

-(id)first {
	return [super first];
}

-(void)setFirst:(id)anObject {
	if (anObject == nil) {
		return;
	}
	[self willChangeValueForKey:@"first"];
	[self insertObject:anObject atIndex:0];
	[self didChangeValueForKey:@"first"];
}

- (void)removeFirstObject {
	[self shift];
}

-(id)shift {
	if (self.count == 0) {
		return nil;
	}
	
	id re = self.first;
	[self removeObjectAtIndex:0];
	return re;
}

-(id)pop {
	if (self.count == 0) {
		return nil;
	}
	
	id o = self.lastObject;
	[self removeLastObject];
	return o;
}

-(NSMutableArray *)sort {
	[self sortUsingSelector:@selector(compare:)];
	return self;
}

-(NSMutableArray *)reverse {
	@synchronized (self) {
		for (NSUInteger i = 0; i < floor(self.count / 2); i++) {
			[self exchangeObjectAtIndex:i withObjectAtIndex:(self.count - i - 1)];
		}
	}
	return self;
}

-(NSMutableArray *)shuffle {
	@synchronized (self) {
		for (NSUInteger i = 0; i < self.count; i++) {
			NSUInteger one = random() % self.count;
			NSUInteger two = random() % self.count;
			[self exchangeObjectAtIndex:one withObjectAtIndex:two];
		}
	}
	return self;
}

@end
