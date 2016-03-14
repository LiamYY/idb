// Copyright 2004-present Facebook. All Rights Reserved.

#import "FBTestBundle.h"

#import "FBProductBundle+Private.h"
#import "FBTestConfiguration.h"

@interface FBTestBundle ()
@property (nonatomic, strong) FBTestConfiguration *configuration;
@end

@implementation FBTestBundle
@end


@interface FBTestBundleBuilder ()
@property (nonatomic, strong) NSUUID *sessionIdentifier;
@end

@implementation FBTestBundleBuilder

- (instancetype)withSessionIdentifier:(NSUUID *)sessionIdentifier
{
  self.sessionIdentifier = sessionIdentifier;
  return self;
}

- (Class)productClass
{
  return FBTestBundle.class;
}

- (FBTestBundle *)build
{
  FBTestBundle *testBundle = (FBTestBundle *)[super build];
  if (self.sessionIdentifier) {
    NSString *testConfigurationFileName = [NSString stringWithFormat:@"%@-%@.xctestconfiguration", testBundle.name, self.sessionIdentifier.UUIDString];
    testBundle.configuration =
    [[[[[[FBTestConfigurationBuilder builderWithFileManager:self.fileManager]
         withModuleName:testBundle.name]
        withSessionIdentifier:self.sessionIdentifier]
       withTestBundlePath:testBundle.path]
      saveAs:[testBundle.path stringByAppendingPathComponent:testConfigurationFileName]]
     build];
  }
  return testBundle;
}

@end
