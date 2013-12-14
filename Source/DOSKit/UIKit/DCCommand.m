/*
 * iDOSBox
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

#import "DCCommand.h"
#import "DCKey.h"

NSString * const IDBMountCommand = @"mount";
NSString * const IDBClearScreenCommand = @"cls";
NSString * const IDBChangeDirectoryCommand = @"cd";

const char * dosbox_config_path() {
    return [[[DCCommand sharedModel] dosboxConfigPath] UTF8String];
}

const char * dosbox_config_filename() {
    return [[[DCCommand sharedModel] dosboxConfigFilename] UTF8String];
}

const char * dosbox_command_dequeue() {
    NSString *command = [[DCCommand sharedModel] dequeueCommand];
    if (command) {
        return [command UTF8String];
    } else {
        return NULL;
    }
}

static inline void DriveLetterErrorCheck(char letter) {
    NSCAssert((letter >= 'a' && letter <= 'z') || (letter >= 'A' && letter <= 'Z'), DCInvalidArgumentError);
}

@interface DCCommand ()

@property (readwrite, nonatomic) NSMutableArray *commandQueue;

@end

@implementation DCCommand

+ (instancetype)sharedModel {
    static DCCommand *sharedModel = nil;
    if (!sharedModel) {
        sharedModel = [[[self class] alloc] init];
    }
    return sharedModel;
}

- (id)init {
    DC_LOG_INIT(self);
    if (self = [super init]) {
        _commandQueue = [NSMutableArray array];
        _paused = NO;
        [self enqueueCommands:[self startupCommands]];
        [self clearScreen];
    }
    return self;
}

- (NSString *)dosboxConfigPath {
    NSAssert(false, DCShouldOverrideError);
    return nil;
}

- (NSString *)dosboxConfigFilename {
    NSAssert(false, DCShouldOverrideError);
    return nil;
}

- (NSArray *)startupCommands {
    NSAssert(false, DCShouldOverrideError);
    return nil;
}

- (void)enqueueCommand:(NSString *)command {
    [self.commandQueue addObject:command];
    return;
}

- (void)enqueueCommands:(NSArray *)commands {
    for (NSString *command in commands) {
        [self enqueueCommand:command];
    }
    return;
}

- (NSString *)dequeueCommand {
    if (self.commandQueue.count > 0) {
        NSString *command = [self.commandQueue objectAtIndex:0];
        [self.commandQueue removeObjectAtIndex:0];
        return command;
    } else {
        return nil;
    }
}

- (void)mountPath:(NSString *)mountPath toDrive:(char)driveLetter {
    DriveLetterErrorCheck(driveLetter);
    [self enqueueCommand:[NSString stringWithFormat:@"%@ %c \"%@\"", IDBMountCommand, driveLetter, mountPath]];
    return;
}

- (void)changeDirectory:(NSString *)newDirectory {
    [self enqueueCommand:[NSString stringWithFormat:@"%@ \"%@\"", IDBChangeDirectoryCommand, newDirectory]];
    return;
}

- (void)clearScreen {
    [self enqueueCommand:IDBClearScreenCommand];
}

- (NSString *)dosPathFromPath:(NSString *)path inDrive:(char)driveLetter {
    NSAssert(path, DCArgumentNilError);
    DriveLetterErrorCheck(driveLetter);
    return [NSString stringWithFormat:@"%c:\\%@", driveLetter, path];
}

- (void)setPaused:(BOOL)paused {
    if (_paused != paused) {
        _paused = paused;
        
        DCKey *altKey = [DCKey keyWithScancode:SDL_SCANCODE_LALT];
        DCKey *pauseKey = [DCKey keyWithScancode:SDL_SCANCODE_PAUSE];
        altKey.isPressed = YES;
        pauseKey.isPressed = YES;
        altKey.isPressed = NO;
        pauseKey.isPressed = NO;
        
        if (paused) {
            DC_LOG(@"DOSBox paused");
        } else {
            DC_LOG(@"DOSBox resumed");
        }
    }
    return;
}

- (void)dealloc {
    DC_LOG_DEALLOC(self);
}

@end
