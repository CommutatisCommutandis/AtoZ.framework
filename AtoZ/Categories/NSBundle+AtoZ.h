//
//  NSBundle+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 9/14/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (AtoZ)

+ (NSString*) applicationSupportFolder;
+ (NSString*) calulatedBundleIDForPath:(NSString*)path;

@end
