//
//  main.m
//  AtoZCLI
//
//  Created by Alex Gray on 9/9/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AtoZ/AtoZ.h>
//#import <RMKit/RMKit.h>


void quantize() {
	[AZStopwatch start:@"quantize"];
	@autoreleasepool {
//		[[NSImage systemImages] eachConcurrentlyWithBlock:^(NSInteger index, id objI, BOOL *stop) {
//	   		[[[AZColor sharedInstance] colorsForImage:objI] az_each:^(id obj, NSUInteger index, BOOL *stop) {
//				NSLog(@"Hello, World!  %@", [obj propertiesPlease]);
//			}];
//		}];
	}
	[AZStopwatch stop:@"quantize"];

}

void TestStopwatchBlock (NSString* name) {
	[AZStopwatch stopwatch:name timing:^{
			[AtoZ performBlock:^{
//				[self someLongAssFunction];
			} afterDelay:10];
		[AtoZ performSelector:@selector(dock) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
			AZLOG(@"longblock");
	}];
}

//const NSImage*paddy = [[NSImage alloc]initWithContentsOfFile:@"/Library/Desktop Pictures/Rice Paddy.jpg"];

@interface AAAA : BaseModel
@end
@implementation AAAA
@end


@interface TestView : NSView <NSWindowDelegate> { }

@property (strong) CALayer* lay;
-(void)drawRect:(NSRect)rect;
@end

@implementation TestView

-(void)viewDidMoveToSuperview {
	NSLog(@"view did load");
	self.wantsLayer = YES;
	self.lay = [CALayer layer];
	_lay.frame = quadrant(self.bounds, 1);
	_lay.backgroundColor = cgRED;
	self.layer.sublayers = @[_lay];
}
-(void)drawRect:(NSRect)rect {
    [[NSColor blueColor] set];
    NSRectFill( [self bounds] );
}

-(void)windowWillClose:(NSNotification *)note {
    [[NSApplication sharedApplication] terminate:self];
}

- (void) mouseDown:(NSEvent*)ev
{
	//	[_lay animateOverAndUpFrom:_lay.position to:AZCenterOfRect(quadrant(self.bounds, 3)) duration:5];


}
@end

int main(int argc, const char * argv[])
{
	[AZStopwatch stopwatch:@"Runtime" timing:^{

		//		NSLog(@"TEST start");
		AZFile *f = [AZFile instanceWithPath:@"/Applications/Safari.app"];
		AZLOG([AZFILEMANAGER attributesOfItemAtPath:f.path error:nil]);

	}];
	@autoreleasepool {

		NSApplication *app			= [NSApplication sharedApplication];
		NSRect 			frame  	= (NSRect) { 100, 100, 300, 300 };
		NSWindow 			*window 	= [[NSWindow alloc] initWithContentRect:frame
														   styleMask:NSTitledWindowMask|NSResizableWindowMask
															 backing:NSBackingStoreBuffered defer:false];
		[window setTitle:@"Testing"];
		AtoZ *whatver = [AtoZ sharedInstance];
//		[AtoZ playRandomSound];
		TestView *view = [[TestView alloc] initWithFrame:frame];
		[window setContentView:view];
		[window setDelegate:view];
		//		[window makeKeyAndOrderFront:window];
		[NSApp activateIgnoringOtherApps:YES];
		[app run];
	}
//	TestStopwatchBlock(@"testTheWatch");
//		NSArray *u = [NSArray arrayWithArrays: @[@[@"array1", @[@"array1level2"]],@[@"array2", @"array2item2"], @[@"array3"]]];
//		AZLOG(	u );
//		AZLOG([NSArray classMethods]);

//		AZLOG([NSColor allColors]);
	//	[NSThread performBlock:^{
	//		[AZTalker say:StringFromBOOL([AZDock conformsToProtocol:@protocol(NSCopying)])];
	//	} afterDelay:2];
	//	[AZTalker say:StringFromBOOL([AZDock conformsToProtocol:@protocol(NSFileManagerDelegate)])];
	//	[AZTalker say:StringFromBOOL([AZDock conformsToProtocol:@protocol(NSFastEnumeration)])];
//		AZLOG([AZAppFolder sharedInstance]);
//		AZLOG([AZFile forAppNamed:@"/Applications/Safari.app"]);

	//	AZLOG([NSColor colorsInFrameworkListNamed:@"OrigamiMice"]);

	//	NSImage *web = [NSImage imageFromWebPageAtURL:[NSURL URLWithString:@"http://google.com"] encoding:NSUTF8StringEncoding];
	//	AZLOG(web);
	//	[paddy quantize];
					//		[[AZColor sharedInstance] colorsForImage:[NSImage imageInFrameworkWithFileName:@"mrgray.logo.png"]]);
	//	AZFile *s = [AZFile	instanceWithImage:[NSImage randomIcon]];
	//	AZLOG(s.propertiesPlease);
	//	[s.image saveAs:@"/Users/localadmin/Desktop/poops.png"];

	//	AZFile* dum = [AZFile dummy];
	//	AZLOG(dum.propertiesPlease);
	//	[dum.image saveAs:@"/Users/localadmin/Desktop/poop.png"];
	//
	//	AZFile* ss = [AZFile instanceWithColor:RANDOMCOLOR];
	//	AZLOG(ss.propertiesPlease);
	//	[ss.image saveAs:@"/Users/localadmin/Desktop/poopss.png"];
	//
	//	AZTalker *welcome = [AZTalker new];
	//	[welcome say:@"welcome"];
	//
	//	[[AZTalker sharedInstance]say:@"huge vgaenn"];
	//
	//
	//	CGPoint a = AZAnchorPointForPosition( AZPositionLeft);
	//
	//	NSLog(@"%@", NSStringFromPoint(a));

    return 0;
}

/**

@interface ExampleTest : GHTestCase { }
@end

@implementation ExampleTest

- (BOOL)shouldRunOnMainThread {
		// By default NO, but if you have a UI test or test dependent on running on the main thread return YES.
		// Also an async test that calls back on the main thread, you'll probably want to return YES.
	return NO;
}

- (void)setUpClass {
		// Run at start of all tests in the class
}

- (void)tearDownClass {
		// Run at end of all tests in the class
}

- (void)setUp {
		// Run before each test method
}

- (void)tearDown {
		// Run after each test method
}

- (void)testFoo {
	NSString *a = @"foo";
	GHTestLog(@"I can log to the GHUnit test console: %@", a);

		// Assert a is not NULL, with no custom error description
	GHAssertNotNULL(a, nil);

		// Assert equal objects, add custom error description
	NSString *b = @"bar";
	GHAssertEqualObjects(a, b, @"A custom error message. a should be equal to: %@.", b);
}

- (void)testBar {
		// Another test
}

@end


#import <Foundation/Foundation.h>

#import <GHUnit/GHUnit.h>
#import <GHUnit/GHTestApp.h>

int main(int argc, char *argv[]) {
	@autoreleasepool {

			// Register any special test case classes
			//[[GHTesting sharedInstance] registerClassName:@"GHSpecialTestCase"];

		int retVal = 0;
			// If GHUNIT_CLI is set we are using the command line interface and run the tests
			// Otherwise load the GUI app
		if (getenv("GHUNIT_CLI")) {
			retVal = [GHTestRunner run];
		} else {
				// To run all tests (from ENV)
			GHTestApp *app = [[GHTestApp alloc] init];
				// To run a different test suite:
				//GHTestSuite *suite = [GHTestSuite suiteWithTestFilter:@"GHSlowTest,GHAsyncTestCaseTest"];
				//				GHTestApp *app = [[GHTestApp alloc] initWithSuite:suite];
				// Or set global:
				//GHUnitTest = @"GHSlowTest";
			[NSApp run];
		}
		return retVal;
	}
}


*/