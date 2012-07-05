//
//  AppController.h
//  NSStatusItemTest
//
//  Created by Matt Gemmell on 04/03/2008.
//  Copyright 2008 Magic Aubergine. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AtoZ/AtoZ.h>
#import "AZStatusItemView.h"
#import "ControlBar.h"

@interface AZStatusAppController : NSObject 
<	NSApplicationDelegate,	NSWindowDelegate, 
	AZBoxGridDataSource, 	AZStatusItemDelegate	> 	
{
	AZBoxGrid *grid;
    NSStatusItem *statusItem;
	AZStatusItemView *statusView;
	IBOutlet NSScrollView *scroller;
    IBOutlet NSView *rootView;
	
	IBOutlet AZToggleView *bar;
//    IBOutlet NSTextField *textField;

}
@property (nonatomic, retain)  IBOutlet AZBoxGrid *grid;
@property (nonatomic, retain)  IBOutlet NSWindow *attachedWindow;
@property (nonatomic, retain)  IBOutlet NSScrollView *scroller;

- (void)statusView:(AZStatusItemView *)statusItem isActive:(BOOL)active;
//- (void)toggleAttachedWindowAtPoint:(NSPoint)pt;

@end
