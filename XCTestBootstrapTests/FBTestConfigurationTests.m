// Copyright 2004-present Facebook. All Rights Reserved.

#import <XCTest/XCTest.h>

#import <OCMock/OCMock.h>

#import "FBFileManager.h"
#import "FBTestConfiguration.h"

@interface FBTestConfigurationTests : XCTestCase

@end

@implementation FBTestConfigurationTests

- (void)testSessionIdentifier
{
  NSUUID *sessionIdentifier = [[NSUUID alloc] initWithUUIDString:@"E621E1F8-C36C-495A-93FC-0C247A3E6E5F"];
  FBTestConfiguration *testConfiguration =
  [[[FBTestConfigurationBuilder builder]
    withSessionIdentifier:sessionIdentifier]
   build];
  XCTAssertTrue([testConfiguration isKindOfClass:FBTestConfiguration.class]);
  XCTAssertEqual(testConfiguration.sessionIdentifier, sessionIdentifier);
}

- (void)testModuleName
{
  FBTestConfiguration *testConfiguration =
  [[[FBTestConfigurationBuilder builder]
    withModuleName:@"Franek"]
   build];
  XCTAssertTrue([testConfiguration isKindOfClass:FBTestConfiguration.class]);
  XCTAssertEqual(testConfiguration.moduleName, @"Franek");
}

- (void)testBundlePath
{
  FBTestConfiguration *testConfiguration =
  [[[FBTestConfigurationBuilder builder]
    withTestBundlePath:@"MagicPath"]
   build];
  XCTAssertTrue([testConfiguration isKindOfClass:FBTestConfiguration.class]);
  XCTAssertEqual(testConfiguration.testBundlePath, @"MagicPath");
  XCTAssertNil(testConfiguration.path);
}

- (void)testSaveAs
{
  NSString *path = @"/Key/To/Heaven";
  OCMockObject<FBFileManager> *fileManagerMock = [OCMockObject mockForProtocol:@protocol(FBFileManager)];
  [[[[fileManagerMock expect] andReturnValue:@YES] ignoringNonObjectArgs] writeData:[OCMArg any] toFile:path options:0 error:[OCMArg anyObjectRef]];

  FBTestConfiguration *testConfiguration =
  [[[FBTestConfigurationBuilder builderWithFileManager:fileManagerMock]
    saveAs:path]
   build];
  XCTAssertEqual(testConfiguration.path, path);
  [fileManagerMock verify];
}

@end
