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

#import "IDBDOSModel.h"
#import "IDBConstants.h"
#import "IDBKey.h"

const char * dosbox_config_path() {
    return [[[IDBDOSModel sharedModel] dosboxConfigPath] UTF8String];
}

const char * dosbox_config_filename() {
    return [[[IDBDOSModel sharedModel] dosboxConfigFilename] UTF8String];
}

const char * dosbox_command_dequeue() {
    NSString *command = [[IDBDOSModel sharedModel] dequeueCommand];
    if (command) {
        return [command UTF8String];
    } else {
        return NULL;
    }
}

@interface IDBDOSModel ()

@property (readwrite, nonatomic) NSMutableArray *commandQueue;

@end

@implementation IDBDOSModel

+ (instancetype)sharedModel {
    static IDBDOSModel *sharedModel = nil;
    if (!sharedModel) {
        sharedModel = [[[self class] alloc] init];
    }
    return sharedModel;
}

- (id)init {
    if (self = [super init]) {
        _commandQueue = [NSMutableArray array];
        _paused = NO;
        [self enqueueCommands:[self startupCommands]];
    }
    return self;
}

- (NSString *)dosboxConfigPath {
    NSAssert(false, IDBShouldOverride);
    return nil;
}

- (NSString *)dosboxConfigFilename {
    NSAssert(false, IDBShouldOverride);
    return nil;
}

- (NSArray *)startupCommands {
    NSAssert(false, IDBShouldOverride);
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

- (void)setPaused:(BOOL)paused {
    if (_paused != paused) {
        _paused = paused;
        
        IDBKey *altKey = [IDBKey keyWithScancode:SDL_SCANCODE_LALT];
        IDBKey *pauseKey = [IDBKey keyWithScancode:SDL_SCANCODE_PAUSE];
        altKey.isPressed = YES;
        pauseKey.isPressed = YES;
        altKey.isPressed = NO;
        pauseKey.isPressed = NO;
        
        if (paused) {
            IDB_LOG(@"DOSBox paused");
        } else {
            IDB_LOG(@"DOSBox resumed");
        }
    }
    return;
}

@end
