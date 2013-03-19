//
//  AZFavIconFinder.h
//  AZFavIcon
//  Created by Fabio Pelosin on 04/09/12.
//  Copyright (c) 2012 Discontinuity s.r.l. All rights reserved.

#import "AtoZ.h"

#if TARGET_OS_IPHONE
#define NSImage UIImage
#endif

extern CGSize sizeInPixels(NSIMG *image);


@class  AZFavIconCache;
/** AZFavIconManager is a complete solution for managing Favicons.*/
@interface AZFavIconManager : NSObject
/** Returns the shared singleton. */
+ (AZFavIconManager*) sharedInstance;
/** Placeholder image for favicons. Defaults to [UIImage imageNamed:@"favicon"]. */
@property (NATOM, STRNG) NSImage *placehoder;
/** The AZFavIconCache instance used by the current manager. Defaults to [AZFavIconCache sharedCache] */
@property (NATOM, STRNG) AZFavIconCache *cache;

/** Wether requests for the icon of an URL already in the queue should be discarded (useful in tables). Defaults to false. */
@property BOOL discardRequestsForIconsWithPendingOperation;
/** Wether it should attempt to retrieve apple touch icons if the size of the favicon is less than 16 logical points. Defaults to false. */
@property BOOL useAppleTouchIconForHighResolutionDisplays;

/** Returns the image for an icon if it has already been downloaded.
 @param url   The URL for which the icon is requested.
 @return	  The icon or nil if the icon is not available in the cache.  */
- (NSImage*)cachedIconForURL:(NSURL *)url;

/** Returns the image for an icon. If the icon has already been downloaded it is returned immediately.
		UIImageView *imageView;
		imageView.image = [[AZFavIconManager sharedInstance] iconForURL:url completionBlock:^(UIImage *icon) {
			imageView.image = icon;
		}];

 @param url			   The URL for which the icon is requested.
 @param downloadHandler   A handler to be called when and only if an icon is downloaded.
						  This handler is always called in the dispatch queue associated with the application’s main thread.
 @return				  The icon if it is already available, otherwise the placeholder image is returned.  */
- (NSImage*)iconForURL:(NSURL *)url downloadHandler:(void (^)(NSIMG *icon))downloadHandler;
+ (NSImage*)AZFavIconManager:(NSURL *)url downloadHandler:(void (^)(NSIMG *icon))downloadHandler;

/** Cancels all the pending queues. */
- (void)cancelRequests;
/** Clears the caches (memory and disk) and cancels pending queues. */
- (void) clearCache;

-(NSArray*)defaultNames;

@end

typedef void (^AZFavIconOperationCompletionBlock)(NSIMG *icon);
typedef BOOL (^AZFavIconOperationAcceptanceBlock)(NSIMG *icon);
typedef BOOL (^AZFavIconOperationPreflightBlock)(NSURL *url);

extern NSString *const kAZFavIconOperationDidStartNetworkActivity;
extern NSString *const kAZFavIconOperationDidEndNetworkActivity;

@interface AZFavIconOperation : NSOperation

@property (NATOM, STRNG) NSURL *url;
@property (NATOM, STRNG) NSArray *defaultNames;
@property (NATOM, STRNG) NSString *relationshipsRegex;
@property (nonatomic, copy) AZFavIconOperationCompletionBlock completion;
@property (nonatomic, copy) AZFavIconOperationAcceptanceBlock acceptanceBlock;
@property (nonatomic, copy) AZFavIconOperationPreflightBlock  preFlightBlock;

+ (AZFavIconOperation*)operationWithURL:(NSURL*)url
					 relationshipsRegex:(NSString*)relationshipsRegex
						   defaultNames:(NSArray*)defaultNames
						completionBlock:(AZFavIconOperationCompletionBlock)completion;

@end

@interface AZFavIconCache : NSCache

+ (AZFavIconCache*) sharedCache;
- (NSIMG*) imageForKey:(NSString *)key;
- (void)setImage:(NSIMG *)image forKey:(NSString *)key;
- (void)removeAllObjects;//  builklt-in method

@property (nonatomic, retain) NSString *cacheDirectory;

@end