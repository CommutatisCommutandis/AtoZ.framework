#include <sys/ioctl.h>
#include <stdio.h>
#include <unistd.h>
#import <AtoZ/AtoZ.h>
#import "AZCLITests.h"
#import "NSLogConsole.h"

#define AZSTDIN NSFileHandle.fileHandleWithStandardInput

typedef void (^AZCLITest)(void);

@interface AZCLI : BaseModel <NSLogConsoleDelegate>

@property (ASS) IBOutlet NSTextView *terminal;
@property (NATOM,STRNG)		AZCLITests 		*tests;
@property (NATOM)			BOOL finished, inTTY, inXcode;

@property (RONLY) 		NSS* frameworkMenu, *methodMenu;
@property (NATOM,STRNG) NSMD *selectionDecoder;

- (void) mainMenu;

@end

//+ (id) blockEval:(id(^)(id blockArgs, ...))block;

//@interface AZCLIMenu : 	BaseModel	@property (STRNG)   	NSA 	*items;	@property (RONLY)    NSS 	*outputString;	@property (ASS)  		NSRNG  range;	@end
