//
//  AZDockQuery.h
//  AtoZ
//
//  Created by Alex Gray on 7/5/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AtoZ.h"


@interface AZDockQuery : BaseModel


@property (nonatomic, strong) NSArray *dock;

- (CGPoint) locationNowForAppWithPath:(NSString*)aPath;
+ (NSArray*) dock;
@end
