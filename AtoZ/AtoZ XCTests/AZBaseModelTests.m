
#import <XCTest/XCTest.h>
#import <AtoZ/AtoZ.h>

@interface TestModel : BaseModel
@end
@implementation TestModel
@end


@interface AZBaseModelTests : XCTestCase {
@private
	TestModel *sharedOne, 	*sharedTwo;
	TestModel *one, 			*two;
}
@end
@implementation AZBaseModelTests

- (void)setUp
{
	[super setUp];
	sharedOne = TestModel.sharedInstance;
}

- (void) testSharedSingletonness
{
	sharedTwo = TestModel.sharedInstance;
	XCTAssertTrue (sharedOne == sharedTwo, @"setting a different instance %@ as the prvious sharedInstance %@ should point to itself", sharedTwo, sharedOne);
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

//- (void)testExample
//{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
//}

@end
