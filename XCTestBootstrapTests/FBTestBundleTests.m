// Copyright 2004-present Facebook. All Rights Reserved.

#import <XCTest/XCTest.h>

#import <OCMock/OCMock.h>

#import "FBTestBundle.h"
#import "FBTestConfiguration.h"
#import "NSFileManager+FBFileManager.h"

@interface FBTestBundleTests : XCTestCase
@end

@implementation FBTestBundleTests

- (void)testTestBundleLoadWithPath
{
  NSString *expectedTestConfigPath = @"/Deep/Deep/Darkness/XCTestBootstrapTests.xctest/XCTestBootstrapTests-E621E1F8-C36C-495A-93FC-0C247A3E6E5F.xctestconfiguration";
  NSUUID *sessionIdentifier = [[NSUUID alloc] initWithUUIDString:@"E621E1F8-C36C-495A-93FC-0C247A3E6E5F"];
  NSBundle *bundle = [NSBundle bundleForClass:self.class];

  OCMockObject<FBFileManager> *fileManagerMock = [OCMockObject mockForProtocol:@protocol(FBFileManager)];
  [[[[fileManagerMock expect] andReturnValue:@YES] ignoringNonObjectArgs] copyItemAtPath:bundle.bundlePath toPath:expectedTestConfigPath.stringByDeletingLastPathComponent error:[OCMArg anyObjectRef]];
  [[[[fileManagerMock expect] andReturnValue:@YES] ignoringNonObjectArgs] writeData:[OCMArg any] toFile:expectedTestConfigPath options:0 error:[OCMArg anyObjectRef]];
  [[[fileManagerMock stub] andReturn:nil] dictionaryWithPath:[OCMArg any]];

  FBTestBundle *testBundle =
  [[[[[FBTestBundleBuilder builderWithFileManager:fileManagerMock]
      withBundlePath:bundle.bundlePath]
     withWorkingDirectory:@"/Deep/Deep/Darkness"]
    withSessionIdentifier:sessionIdentifier]
   build];

  XCTAssertTrue([testBundle isKindOfClass:FBTestBundle.class]);
  XCTAssertNotNil(testBundle.configuration);
  XCTAssertEqualObjects(testBundle.configuration.sessionIdentifier, sessionIdentifier);
  XCTAssertEqualObjects(testBundle.configuration.moduleName, @"XCTestBootstrapTests");
  XCTAssertEqualObjects(testBundle.configuration.testBundlePath, expectedTestConfigPath.stringByDeletingLastPathComponent);
  XCTAssertEqualObjects(testBundle.configuration.path, expectedTestConfigPath);

  [fileManagerMock verify];
}

- (void)testNoBundlePath
{
  XCTAssertThrows([[FBTestBundleBuilder builder] build]);
}

- (void)testBundleWithoutSessionIdentifier
{
  NSBundle *bundle = [NSBundle bundleForClass:self.class];
  FBTestBundle *testBundle =
  [[[FBTestBundleBuilder builder]
    withBundlePath:bundle.bundlePath]
   build];
  XCTAssertTrue([testBundle isKindOfClass:FBTestBundle.class]);
  XCTAssertNil(testBundle.configuration);
}

@end
