//
//  NSApplication+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 6/29/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>



@interface NSMenu (SBAdditions)

- (NSMenuItem *)selectedItem;
- (void)selectItem:(NSMenuItem *)menuItem;
- (NSMenuItem *)selectItemWithRepresentedObject:(id)representedObject;
- (void)deselectItem;
- (NSMenuItem *)addItemWithTitle:(NSString *)aString target:(id)target action:(SEL)aSelector tag:(NSInteger)tag;
- (NSMenuItem *)addItemWithTitle:(NSString *)aString representedObject:(id)representedObject target:(id)target action:(SEL)aSelector;
@end
@interface NSMenuItem (AtoZ)

- (id)initWithTitle:(NSString*)aString target:(id)target action:(SEL)aSelector keyEquivalent:(NSString*)keyEquivalent representedObject:(id)representedObject;

@end


extern NSString *const kShowDockIconUserDefaultsKey;

@interface NSApplication (AtoZ)

+ (id)		infoValueForKey:(NSS*)key;
- (BOOL)	showsDockIcon;
- (void)	setShowsDockIcon:(BOOL)flag;
@end

#import <Foundation/Foundation.h>

// All extensions methods in this file are thread-safe

#define kMultipartFileKey_MimeType @"mimeType" // NSString
#define kMultipartFileKey_FileName @"fileName"  // NSString
#define kMultipartFileKey_FileData @"fileData"  // NSData


@interface NSProcessInfo (Extensions)
- (BOOL) isDebuggerAttached;
@end


/*!
 @brief	Methods which Apple should have provided in NSWorkspace	*/
@interface NSWorkspace (AppleShoulda)

//- (NSString*) appName;
//- (NSString*) appDisplayName;
//- (NSString*) appVersion;
- (NSString*) appSupportSubdirectory;

- (void) registerDefaultsFromMainBundleFile:(NSString*)defaultsFilename;

+ (NSString*)appNameForBundleIdentifier:(NSString*)bundleIdentifier ;

+ (NSString*)bundleIdentifierForAppName:(NSString*)appName ;


@end

@interface NSWorkspace (SystemInfo)

+ (NSString*) systemVersion;

@end
