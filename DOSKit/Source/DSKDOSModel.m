//
//  NAModel.m
//  NostalgiaApp
//
//  Created by user on 10/26/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "DSKDOSModel.h"
 
@implementation DSKDOSModel

- (id)init {
    if (self = ([super init])) {
        [self enqueueCommand:[NSString stringWithFormat:@"mount C \"%@\"", [self mountDocumentDirectory:@"CDrive"]]];
        [self enqueueCommands:@[@"cls", @"C:", @"FIRE"]];
    }
    return self;
}

- (NSString *)dosboxConfigPath {
    return [[NSBundle mainBundle] resourcePath];
}

- (NSString *)dosboxConfigFilename {
    return @"dosbox-ios.conf";
}

- (NSArray *)startupCommands {
    return @[@"cls"];
}

- (NSString *)mountDocumentDirectory:(NSString *)folderName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cDriveDocumentPath = [documentsPath stringByAppendingPathComponent:folderName];
    NSString *cDriveBundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:folderName];
    
    // create C drive folder in documents if it does not exist
    if (![fileManager fileExistsAtPath:cDriveDocumentPath]) {
        NSError *error;
        if (![fileManager createDirectoryAtPath:cDriveDocumentPath withIntermediateDirectories:NO attributes:nil error:&error]) {
            IDB_LOG(@"%@", [error localizedDescription]);
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
                    IDB_LOG(@"%@", [error localizedDescription]);
                }
            }
        }
    } else {
        IDB_LOG(@"%@", [error localizedDescription]);
    }
    return cDriveDocumentPath;
}

@end