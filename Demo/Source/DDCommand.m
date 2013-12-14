//
//  NAModel.m
//  NostalgiaApp
//
//  Created by user on 10/26/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "DDCommand.h"

NSString * const DSKDOSBoxConfigFilename = @"dosbox-ios.conf";
NSString * const DSKBundleCDriveFolder = @"CDrive";

@implementation DDCommand

- (id)init {
    if (self = ([super init])) {
        [self mountBundlePath:DSKBundleCDriveFolder];
        [self clearScreen];
        [self enqueueCommand:[self dosPathFromPath:@"" inDrive:'C']];
        [self enqueueCommand:@"FIRE"];
    }
    return self;
}

- (NSString *)dosboxConfigPath {
    return [[NSBundle mainBundle] resourcePath];
}

- (NSString *)dosboxConfigFilename {
    return DSKDOSBoxConfigFilename;
}

- (NSArray *)startupCommands {
    return @[];
}

- (void)mountBundlePath:(NSString *)bundlePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cDriveDocumentPath = [documentsPath stringByAppendingPathComponent:bundlePath];
    NSString *cDriveBundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:bundlePath];
    
    // create C drive folder in documents if it does not exist
    if (![fileManager fileExistsAtPath:cDriveDocumentPath]) {
        NSError *error;
        if (![fileManager createDirectoryAtPath:cDriveDocumentPath withIntermediateDirectories:NO attributes:nil error:&error]) {
            DC_LOG(@"%@", [error localizedDescription]);
        }
    }
    
    // copy files from C drive folder in bundle to documents
    NSError *error;
    NSArray *cDriveBundleContents = [fileManager contentsOfDirectoryAtPath:cDriveBundlePath error:&error];
    if (cDriveBundleContents) {
        for (NSString *itemName in cDriveBundleContents) {
            NSString *itemBundlePath = [cDriveBundlePath stringByAppendingPathComponent:itemName];
            NSString *itemDocumentPath = [cDriveDocumentPath stringByAppendingPathComponent:itemName];
            if (![fileManager fileExistsAtPath:itemDocumentPath]) {
                if (![fileManager copyItemAtPath:itemBundlePath toPath:itemDocumentPath error:&error]) {
                    DC_LOG(@"%@", [error localizedDescription]);
                }
            }
        }
    } else {
        DC_LOG(@"%@", [error localizedDescription]);
    }
    [self mountPath:cDriveDocumentPath toDrive:'C'];
    return;
}

@end