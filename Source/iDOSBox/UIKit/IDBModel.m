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

#import "IDBModel.h"
#import "IDBConstants.h"
#import "SDL_keysym.h"
#import "SDL_keyboard_c.h"
#import "keyinfotable.h"

static NSMutableArray *commandQueue;

const char * dosbox_config_path() {
    return [[[NSBundle mainBundle] resourcePath] UTF8String];
}

const char * dosbox_config_filename() {
    return [IDBConfigFilename UTF8String];
}

const char * dosbox_command_dequeue() {
    NSString *command = [IDBModel dequeueCommand];
    if (command) {
        return [command UTF8String];
    } else {
        return NULL;
    }
}

@interface IDBModel ()

- (NSString *)mountDocumentDirectory;

@end

@implementation IDBModel

+ (NSMutableArray *)commandQueue {
    if (!commandQueue) {
        commandQueue = [[NSMutableArray alloc] init];
    }
    return commandQueue;
}

+ (void)enqueueCommand:(NSString *)command {
    [[IDBModel commandQueue] addObject:command];
    return;
}

+ (NSString *)dequeueCommand {
    if ([IDBModel commandQueue].count > 0) {
        NSString *command = [[IDBModel commandQueue] objectAtIndex:0];
        [[IDBModel commandQueue] removeObjectAtIndex:0];
        return command;
    } else {
        return nil;
    }
}

+ (void)sendText:(NSString *)text {
    for (NSUInteger i = 0; i < [text length]; i++) {
        unichar key = [text characterAtIndex:i];
        NSAssert(isascii(key), @"character is not ASCII");
        UIKitKeyInfo keyInfo = unicharToUIKeyInfoTable[key];
        
        const BOOL shiftPressed = keyInfo.mod & KMOD_SHIFT;
        if (shiftPressed) {
            [IDBModel sendKey:SDL_SCANCODE_LSHIFT withState:IDBKeyPress];
        }
        [IDBModel sendKey:keyInfo.code withState:IDBKeyTap];
        if (shiftPressed) {
            [IDBModel sendKey:SDL_SCANCODE_LSHIFT withState:IDBKeyRelease];
        }
    }
    return;
}

+ (void)sendKey:(SDL_scancode)scancode withState:(IDBKeyState)state  {
    switch (state) {
        case IDBKeyPress: {
            SDL_SendKeyboardKey(0, SDL_PRESSED, scancode);
        } break;
        case IDBKeyTap: {
            SDL_SendKeyboardKey(0, SDL_PRESSED, scancode);
            SDL_SendKeyboardKey(0, SDL_RELEASED, scancode);
        } break;
        case IDBKeyRelease: {
            SDL_SendKeyboardKey(0, SDL_RELEASED, scancode);
        } break;
    }
    return;
}

- (id)init {
    if (self = [super init]) {
        _paused = NO;
        [IDBModel enqueueCommand:[NSString stringWithFormat:@"mount C \"%@\"", [self mountDocumentDirectory]]];
        [IDBModel enqueueCommand:@"C:"];
        for (NSUInteger i = 0; i < sizeof(IDBStartupCommands) / sizeof(IDBStartupCommands[0]); i++) {
            [IDBModel enqueueCommand:IDBStartupCommands[i]];
        }
        [IDBModel enqueueCommand:@"FIRE"];
    }
    return self;
}

- (NSString *)mountDocumentDirectory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cDriveDocumentPath = [documentsPath stringByAppendingPathComponent:IDBCDriveFolder];
    NSString *cDriveBundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:IDBCDriveFolder];
    
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

- (void)setPaused:(BOOL)paused {
    [IDBModel sendKey:SDL_SCANCODE_1 withState:IDBKeyTap];
    if (_paused != paused) {
        [IDBModel sendKey:SDL_SCANCODE_LALT withState:IDBKeyPress];
        [IDBModel sendKey:SDL_SCANCODE_PAUSE withState:IDBKeyTap];
        [IDBModel sendKey:SDL_SCANCODE_LALT withState:IDBKeyRelease];
    }
    _paused = paused;
    return;
}

@end
