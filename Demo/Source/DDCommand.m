/*
 * DOSCode
 * Copyright (C) 2013  Matthew Vilim
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

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