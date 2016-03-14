// Copyright 2004-present Facebook. All Rights Reserved.

#import <Foundation/Foundation.h>

@protocol FBCodesignProvider;
@protocol FBFileManager;

/**
 Represents product bundle (eg. .app, .xctest, .framework)
 */
@interface FBProductBundle : NSObject

/**
 The name of the bundle
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 The name of the bundle with extension
 */
@property (nonatomic, copy, readonly) NSString *filename;

/**
 Full path to bundle
 */
@property (nonatomic, copy, readonly) NSString *path;

/**
 Bundle ID of the bundle
 */
@property (nonatomic, copy, readonly) NSString *bundleID;

/**
 Binary name
 */
@property (nonatomic, copy, readonly) NSString *binaryName;

/**
 Full path to binary
 */
@property (nonatomic, copy, readonly) NSString *binaryPath;

/**
 Creates copy of test bundle with changed parent directory.
 It does NOT reload Info.plist file so directory may not exist.

 @param directory new parent directory for bundle
 @return product bundle copy with changed parent dictionary.
 */
- (instancetype)copyLocatedInDirectory:(NSString *)directory;

@end


/**
 Prepares FBProductBundle by:
 - coping it to workingDirectory, if set
 - codesigning bundle with codesigner, if set
 - loading bundle information from Info.plist file
 */
@interface FBProductBundleBuilder : NSObject

/**
 @return builder that uses [NSFileManager defaultManager] as file manager
 */
+ (instancetype)builder;

/**
 @param fileManager a file manager used with builder
 @return builder
 */
+ (instancetype)builderWithFileManager:(id<FBFileManager>)fileManager;

/**
 @required

 @param bundlePath path to product bundle (eg. .app, .xctest, .framework)
 @return builder
 */
- (instancetype)withBundlePath:(NSString *)bundlePath;

/**
 @param workingDirectory if not nil product bundle will be copied to this directory
 @return builder
 */
- (instancetype)withWorkingDirectory:(NSString *)workingDirectory;

/**
 @param codesignProvider object used to codesign product bundle
 @return builder
 */
- (instancetype)withCodesignProvider:(id<FBCodesignProvider>)codesignProvider;

/**
 @return prepared product bundle
 */
- (FBProductBundle *)build;

@end
