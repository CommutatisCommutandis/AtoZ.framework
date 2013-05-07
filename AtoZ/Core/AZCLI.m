#import "AZCLI.h"

static NSPoint click;
static NSRect startRect;
@interface AZCLISlideWindow :NSWindow
@end
@implementation AZCLISlideWindow
- (void) sendEvent:(NSE*)e { 
    if (e.type == NSLeftMouseDown && e.type != NSLeftMouseDragged) {
	 	{
			click = e.locationInWindow;
			startRect = self.frame;
//    else if (e.type == NSLeftMouseDragged) {			
	NSP o = [self convertBaseToScreen:[e locationInWindow]];
				NSRect new = startRect;
}
}	 
//	 
//        for(UITouch * t in [event allTouches]) {
//            if(t.phase == UITouchPhaseBegan) {
//                /*
//                Paste your code here. 
//                Inform objects that some touch has occurred. 
//                It's your choice if you want to perform method/selector directly, 
//                use protocols/delegates, notification center or sth else. 
//                */
//            }
//        }
//    }
//
//    [super sendEvent:event];
}

@end
static 	NSMA			*methods, 	*classes;
static 	StickyNote 	*sticky;
static 	AZCLISlideWindow			*window;  
static 	AZCLIMenu 	*meths, *fws; 
static   NSFH 			*file = nil;


@implementation AZCLI	
- (void) handleWindowEvent:(NSE*) e { NSLog(@"the eveent: %@",e); }
- (void) setUp 								{	

	[AZCLI hasSharedInstance] ? nil : ^{ 	AZCLISI = self; AtoZ.sharedInstance; [AZCLI setupBareBonesApplication];
	window = [NSW.alloc initWithContentRect:AZRectFromDim(200) styleMask:NSBorderlessWindowMask|NSResizableWindowMask backing:NSBackingStoreBuffered defer:NO];
	[window cascadeTopLeftFromPoint:NSMakePoint(20,20)];
	[window setTitle:					AZPROCNAME]; 
	[window setBackgroundColor:          RED];
	[window setOpaque:						  NO]; 
	[window setMovableByWindowBackground:YES];
	[window setDelegate:						self];
	[window makeKeyAndOrderFront:			 nil];
	file = [NSFileHandle fileHandleWithStandardInput];
	[file readInBackgroundAndNotify];
	[window az_overrideSelector:@selector(sendEvent:) withBlock:(__bridge void *)^(id _self, NSE* e)	{

		NSR f = AZScreenFrameUnderMenu();	
//		NSP o = [window convertBaseToScreen:[e locationInWindow]];
		AZPOS pos = AZOutsideEdgeOfRectInRect([_self frame], f);
		
		LOGCOLORS(AZString(f), RED, AZString([_self frame]),ORANGE,AZPositionToString(pos),PINK,nil);
		//AZOutsideEdgeOfRectInRect(window.frame, f);
//		AZPositionOfRectPinnedToOutisdeOfRect(f,
//		[AZWindowPositionToString(pos)  log];
//		LOG_EXPR(AZPointDistanceToBorderOfRect([window.contentView localPoint], f));
	}];
//		SEL sel = @selector(handleWindowEvent:); /* Call super: */
//		void (*superIMP)(id, SEL, NSE*) 	= [_self az_superForSelector:sel];
//		superIMP (_self, sel, e);
// NSLog(@"filling rect: %@", AZStringFromRect(rect));
// NSRectFillWithColor(rect, RANDOMCOLOR);//NOISY(GRAY2));
// //colorWithPatternImage:[NSIMG imageNamed:@"perforated_white_leather_@2X"]]);
// //[NSIMG frameworkImageNamed:@"mrgray.logo.png"]]);


//	[NSTimer timerWithTimeInterval:5 block:^(NSTimeInterval time) {
//		AZProcess *mds = [AZProcess processForCommand:@"mds"];
//		LOGCOLORS( [mds description], NSC.randomPalette, nil);
//		[mds kill:9];
//	} repeats:YES];
	
//	[AZNOTCENTER addObserver:self selector:@selector(didReadStdin:) name:NSFileHandleReadCompletionNotification object: AZSTDIN];
//		sticky = [StickyNote instanceWithFrame:AZRectFromDim(200)];
//		[sticky.window makeKeyAndOrderFront:self];
		[AZCLISI mainMenu];		
		[NSApp run];
	}();
	
}   /* All setup code fpr shared INstance */
-  (IBA) log:(id)sender						{	NSLog(@"hello from button");	}
-  (IBA) toggleConsole:(id)s				{[NSLogConsole.sharedConsole performString:[NSLogConsole.sharedConsole isOpen] ? @"close" : @"open"]; }
- (void) mainMenu 							{

//			CurrentIMP;	
	
	static dispatch_once_t onceToken;	
	dispatch_once(&onceToken, ^{																///_stdinFileHandle =
	
		_selectionDecoder = @{	    @"fwMenu": AZBUNDLE.frameworkIdentifiers, 
										@"methodMenu": @[	@"mainMenu",					@"runAClassMethod", 
																@"envTest", 					@"instanceMethodNames", 
																@"frameworkMenu",				@"rainbowArrays",
																@"variadicColorLogging",	@"processInfo"]		}.mutableCopy;
		 fws = [AZCLIMenu cliMenuFor:_selectionDecoder[@"fwMenu"] starting:100 palette:self.palette];
		 meths = [AZCLIMenu cliMenuFor:_selectionDecoder[@"methodMenu"] starting:0 palette:self.palette];
	});
	
	[NSTerminal printString:[@[[COLORIZE(@"Welcome to AtoZCLI!",				 RANDOMCOLOR, nil)[0] clr],
										[COLORIZE(@"Please choose a test option:",	      PURPLE, nil)[0] clr],
	 									[COLORIZE(@"Available Frameworks:",					   YELLOW, nil)[0] clr],
																													 fws.menu.clr,
										[COLORIZE(@"Available METHODS:",						    GREEN, nil)[0] clr],
																												  meths.menu.clr
										]componentsJoinedByString:@"\n"]];
	
	[AZNOTCENTER addObserverForName:NSFileHandleReadCompletionNotification object:file queue:AZSOQ usingBlock:^(NSNotification *note) {
		NSS* input = [note stringForKey:NSFileHandleNotificationDataItem];
		[input log];
		if ( SameString(@":", input.firstLetter)) {
			NSA* words = [input componentsSeparatedByString:@":"];
			LOGCOLORS(@"rawWords:", words, [[NSC randomPalette]withMinItems:words.count+1], nil);
			[@"s".classProxy[words[0]] performSelectorWithoutWarnings:NSSelectorFromString(words[1])];
		}
		[file readInBackgroundAndNotify];
	}];
}
//- (void) windowWillMove:(NSNotification *)notification { [notification log]; }
- (void) didReadStdin:(NSNOT*)n		{
	
//		id obj = class ?: self;
//		NSLog(@"class:  %@, sel:%@", NSClassFromString(class), NSStringFromSelector(select));
//    	NSInvocation *invocation = [NSInvocation invocationWithTarget:obj block:^(id myObject){
//        [obj perf:42.0];	}];
//class != NULL ? [[class performSelector:select] log] : [[self performSelectorWithoutWarnings:select]log];
//		return;
//	}
}

//	__block BOOL match = NO;
//	[[AZCLIMenu indexesOfMenus]log];
//	void (^readStdin)(void) = ^{
//		NSS *outie = [NSTerminal readString];
//		[NSTerminal printString:outie];
//	};
//	while (!match) [NSThread performBlockInBackground:^{ readStdin();	}];

//	[self.class handleInteractionWithPrompt:nil block:^(NSString *output) {	
//		fprintf(stderr, "stderrInBlk:%s", output.UTF8String);
//	}];
//	LOGCOLORS(RED, @"rquested:", _lastCommand,PURPLE, nil);	
//}
//	int winner = -1; 	NSIS *mIdxs = [AZCLIMenu  indexesOfMenus];
//	do {  int contender;
//		NSLog(@"%@", AZString( contender = [NSTerminal readInt])); //	int contender = MIN(200,(int) );	
//		NSLog(@"IDXSxt:%ld contend:%i win: %i",mIdxs.count, contender, winner);//, _selectionDecoder);
//	} while (winner == -1);
//	self.lastCommand = menuSelect;
//	SEL select = NSSelectorFromString(words[2]);		
//		Class class = NSClassFromString(words[1]);
//		if (class_getClassMethod(class, select) != nil)
//			[[class performSelector:select]log];
//		else
//			[[[NSStringFromClass(class) withString:@"class: %@ didnt respond to selector:" ] withString:NSStringFromSelector(select)]log];
//		if (class_getInstanceMethod([self class], select) != nil)
//			[self performSelector:select];
//		else
//			[[@"i didnt respond to selector:"withString:NSStringFromSelector(select)]log];
//		self.mainMenu;
//
//	AZCLITest test;
//	BOOL respondez = [self respondsToSelector:NSSelectorFromString(_lastCommand)];
//	NSLog(@"responds: %@", StringFromBOOL(respondez));
//	id what = [self valueForKey:_lastCommand];
//	NSLog(@"cfk: %@ equal to cliclass: %@... %@", NSStringFromClass([what class]), test, StringFromBOOL(areSame([what class], [test class])));	
//	}];
	//fflush(stdout); }];

- (void) runAClassMethod 					{
	static BOOL stop = NO;
	if (!classes) classes = NSMA.new;  if (!methods) methods = NSMA.new;
	NSMS *classlist = @"".mutableCopy; NSMS *methodlist = @"".mutableCopy;
	NSI historyIdx;
	LOGCOLORS(@"Enter class Name, ie. \"NSColor\"... or Select a class from history:", PINK, nil);
	[NSTerminal printString:[AZCLIMenu cliMenuFor:classes starting:0 palette:NSC.randomPalette].menu];
	NSString *inputString = [NSString stringWithData:[NSData dataWithData:[NSFileHandle.fileHandleWithStandardInput readDataToEndOfFile]] encoding:NSUTF8StringEncoding];
	if (inputString.isIntegerNumber) {
			historyIdx = inputString.integerValue;
			if (historyIdx < classes.count){ NSBeep(); inputString = [classes normal:historyIdx]; }
		}
		else [classes doesNotContainObject:inputString] && inputString ? [classes addObject:inputString] : nil;
	
	fprintf(stderr, "class method name: %s", methods.count ? [AZCLIMenu cliMenuFor:methods starting:0 palette:NSC.randomPalette].menu.UTF8String : "");
	NSString *inputMethod = [NSString stringWithData:[NSData dataWithData:[NSFileHandle.fileHandleWithStandardInput readDataToEndOfFile]] encoding:NSUTF8StringEncoding];
	if (inputMethod.isIntegerNumber) {
		historyIdx = inputMethod.integerValue;
		if (historyIdx < methods.count)  inputString = [methods normal:historyIdx];
	}
	else  ![methods containsObject:inputString] && inputString ? [methods addObject:inputString] : nil;
	NSLog(@"Signature: +[%@ %@];", inputString, inputMethod);
	id aRes  = [[self.classProxy vFK:inputString] performString:inputMethod]; 	
	NSLog(@"aRes: %@", aRes);
	if (!stop) [self runAClassMethod];
}



- (void) colorLogging 				{
//	COLORLOG(YELLOw, @"whatever %@", @3, nil);   
//	NSD *allColorInfo = NSC.colorLists ;
//	NSLog(@"Available named colors:\n%@",   [NSS stringFromArray:[allColorInfo.allKeys map:^id (id obj) {
//		return colorizeStringWithColor( [obj stringByPaddingToLength:22 withString:@" " startingAtIndex:0], allColorInfo[obj]);		}]]);
//	[self mainMenu];
}
- (VoidBlock) actionAtIndex {}
+ (id) blockEval:(id(^)(id blockArgs, ...))block {	 return block(self);	 }
- (void) envTest								{

	struct winsize w;
	ioctl(0, TIOCGWINSZ, &w);
	LOGCOLORS($(@"TTYlines: %u.\n", w.ws_row),RED, $(@"TTYColumns:%u\n", w.ws_col), ORANGE, $(@"BUILD_DIR:%s\n", getenv("BUILD_DIR")), GREEN,nil);
}
- (NSA*) palette								{ 	return  _palette ?: [NSC colorsInListNamed:@"FengShui"]; }
- (NSC*) nextColor	      	  		   {    static NSUI _p = 0; _p++; return [self.palette normal:_p];	}
- (void) rainbowArrays 						{ LOGCOLORS(NSS.dicksonBible.words, NSC.randomPalette,nil); }
- (void) variadicColorLogging	 			{
    LOGCOLORS(RED, @"red", ORANGE, @"orange", YELLOw, @"yellow", GREEN, @"green", BLUE, @"blue", PURPLE, GREY, "purple (but not in the right order", "Grey (also out of order)", nil);
}
- (void) processInfo							{										LOGCOLORS( RED, ORANGE, YELLOW, GREEN,

					$(@"\n\tEXE:\t%@",  															 AZPROCINFO.processName),
					$(@"\n\tCWD:\t%@\n", [AZFILEMANAGER.currentDirectoryPath truncateInMiddleForWidth:500]),
					$(@"argv[0]:\t%@\t\t[NSPROC]",  [AZPROCINFO.arguments[0] truncateInMiddleForWidth:500]), nil);
//					$(@"\nargv[0]:\t%@\t[MAIN]",             [$UTF8(argv[0]) truncateInMiddleForWidth:500])
}
- (void) textWasEntered:(NSS*)s			{	[AZTalker say: s];				}
- (VoidBlock) stringFunctions				{

	return ^{	NSS*w =  NSS.randomBadWord;	[AZTalker say:w];
					AZCLogFormat("The sum of 50 + 25 is %s", [AZLOGSHARED colorizeString:w withColor:GREEN].colorLogString.UTF8String);
   };
}
@end
@implementation AtoZ (CLIWindow)
+ (NSW*) popDrawWindow:(BNRBlockViewDrawer)blk {

	BOOL running = 		[[NSApplication sharedApplication]isRunning];
	if (!running) {
		[NSApplication sharedApplication];
		[NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
		id menubar, appMenu, appMenuItem;
		menubar 								=		NSMenu.new;
		appMenu 								=		NSMenu.new;
		[menubar  addItem:appMenuItem = NSMenuItem.new];
		[NSApp 	 setMainMenu:menubar];
		[appMenu  addItem:[NSMI.alloc initWithTitle:[@"Quit " withString:AZPROCNAME]
														 action:@selector(terminate:) keyEquivalent:@"q"]];
		[appMenuItem setSubmenu:appMenu];
		NSW* window = [NSW.alloc initWithContentRect:AZRectFromDim(200) styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
		[window cascadeTopLeftFromPoint:NSMakePoint(20,20)];
		[window setTitle:AZPROCNAME]; window.backgroundColor = CLEAR;
		[window setOpaque:NO]; [window setMovable:YES];
		[window makeKeyAndOrderFront:nil];
		[NSApp activateIgnoringOtherApps:YES];
		
		StickyNote *sticky = [StickyNote instanceWithFrame:[[window contentView] bounds]];
	
		[NSApp run];

//		[NSLogConsole sharedConsole];
//		[NSLogConsole.sharedConsole setDelegate: self];
//		[[NSLogConsole sharedConsole] open];
		//	DDLogInfo(@"Warming up printer (post-customization)"); // Pink !
		
	}

}
@end

/*
	AIDockingWindow *attached;	
+ (instancetype) sharedInstance 	{
	if (![AZCLI hasSharedInstance]) [AZCLI setSharedInstance:AZCLI.instance];
	[AZNOTCENTER addObserver:self selector:@selector(didReadStdin:) name:NSFileHandleReadCompletionNotification object:_stdinFileHandle = AZSTDIN];
	NSArray *allPaths 		= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 	NSString *documentsDIR 	= [allPaths objectAtIndex:0];
	NSLogConsole.sharedConsole.delegate = term;	
	[NSLogConsole.sharedConsole open];
	_logConsoleHandle 	= [NSFileHandle fileHandleWithStandardOutput];
	freopen([_logConsoleHandle cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
	window.title 				= AZPROCNAME;
	window.opaque				= NO;
	window.movable				= YES;
	window.backgroundColor 	= CLEAR;
	[attached makeKeyAndOrderFront:self];
	[window makeKeyAndOrderFront:nil];
	[window cascadeTopLeftFromPoint:NSMakePoint(20,20)];
}
	[methods eachWithIndex:^(id obj, NSI idx) {	[methodlist appendFormat:@"\n%ld: %@", idx, obj];	}];
	char methodName [40];
	scanf("%s",(char*)&methodName);
	NSString * methodput = $UTF8((char*)methodName);
	if (methodInt < methods.count){ 
		NSBeep(); 
		methodput = [methods normal:methodInt];
		[AZTalker say: $(@"matched a method: %@", methods[methodInt])];
	}
	else [methods doesNotContainObject:methodput] ? [methods addObject:methodput.copy]: nil;
	NSS* s = @"";
	__block NSI historyIdx =  NSNotFound;		__block NSS* class = nil,  *method = nil
	[@[classlist, methodlist] eachWithIndex:^(id obj, NSI idx) {		idx == 0 ?		}
		char input [99];		scanf("%s",(char*)&input);		NSString * stringIn = $UTF8((char*)input); dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), loop);


- (void) didReadStdin:(NSNOT*)n		{
	NSS* input = [n stringForKey:NSFileHandleNotificationDataItem];
	if ( SameString(@":", input.firstLetter)) {
		NSA* words = [input componentsSeparatedByString:@":"];
		LOGCOLORS(@"rawWords:", words, [[NSC randomPalette]withMinItems:words.count+1], nil);
	[self.class ]
	}
		id obj = class ?: self;
		NSLog(@"class:  %@, sel:%@", NSClassFromString(class), NSStringFromSelector(select));
    	NSInvocation *invocation = [NSInvocation invocationWithTarget:obj block:^(id myObject){
        [obj perf:42.0];	}];
class != NULL ? [[class performSelector:select] log] : [[self performSelectorWithoutWarnings:select]log];
		return;
	}
}
	BOOL hit =			   			 select < 					  self.instanceMethodNames.count
	||  (100 <= select && select < 100 + AZFWORKBUNDLE.frameworkIdentifiers.count);
	fprintf(stdout, "YOu selected %ld.  That matched:%s.\n", select, hit ? "SOMETHING!" : "NADA!");
	[self cuteFunctions]();	 [self mainMenu];
	if ([result respondsToSelector:@selector(UTF8String)])  fprintf(stdout, "%s\n", [result UTF8String]);   fprintf(stdout, "objj> ");    fflush(stdout);    [_stdinFileHandle readInBackgroundAndNotify];
- (VoidBlock) tests 				{   return _tests = [AZCLITests sharedInstance]; }
*/
