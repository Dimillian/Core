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

#import "NGDOSModel.h"
#import "NGConstants.h"
#import "SDL_keysym.h"
#import "SDL_keyboard_c.h"
#import "keyinfotable.h"

static NSMutableArray *commandQueue;

const char * dosbox_config_path() {
    return [[NGDOSModel dosboxConfigPath] UTF8String];
}

const char * dosbox_config_filename() {
    return [[NGDOSModel dosboxConfigFilename] UTF8String];
}

const char * dosbox_command_dequeue() {
    NSString *command = [NGDOSModel dequeueCommand];
    if (command) {
        return [command UTF8String];
    } else {
        return NULL;
    }
}

@implementation NGDOSModel

+ (NSString *)dosboxConfigPath {
    NSAssert(false, NGShouldOverride);
    return nil;
}

+ (NSString *)dosboxConfigFilename {
    NSAssert(false, NGShouldOverride);
    return nil;
}

+ (NSArray *)startupCommands {
    NSAssert(false, NGShouldOverride);
    return nil;
}

+ (NSMutableArray *)commandQueue {
    if (!commandQueue) {
        commandQueue = [[NSMutableArray alloc] init];
    }
    return commandQueue;
}

+ (void)enqueueCommand:(NSString *)command {
    [[NGDOSModel commandQueue] addObject:command];
    return;
}

+ (void)enqueueCommands:(NSArray *)commands {
    for (NSString *command in commands) {
        [NGDOSModel enqueueCommand:command];
    }
    return;
}

+ (NSString *)dequeueCommand {
    if ([NGDOSModel commandQueue].count > 0) {
        NSString *command = [[NGDOSModel commandQueue] objectAtIndex:0];
        [[NGDOSModel commandQueue] removeObjectAtIndex:0];
        return command;
    } else {
        return nil;
    }
}

+ (void)sendString:(NSString *)string {
    for (NSUInteger i = 0; i < [string length]; i++) {
        unichar key = [string characterAtIndex:i];
        NSAssert(isascii(key), @"character is not ASCII");
        UIKitKeyInfo keyInfo = unicharToUIKeyInfoTable[key];
        
        const BOOL shiftPressed = keyInfo.mod & KMOD_SHIFT;
        if (shiftPressed) {
            [NGDOSModel sendKey:SDL_SCANCODE_LSHIFT withState:IDBKeyPress];
        }
        [NGDOSModel sendKey:keyInfo.code withState:IDBKeyTap];
        if (shiftPressed) {
            [NGDOSModel sendKey:SDL_SCANCODE_LSHIFT withState:IDBKeyRelease];
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
        [NGDOSModel enqueueCommands:[NGDOSModel startupCommands]];
    }
    return self;
}

- (void)setPaused:(BOOL)paused {
    [NGDOSModel sendKey:SDL_SCANCODE_1 withState:IDBKeyTap];
    if (_paused != paused) {
        [NGDOSModel sendKey:SDL_SCANCODE_LALT withState:IDBKeyPress];
        [NGDOSModel sendKey:SDL_SCANCODE_PAUSE withState:IDBKeyTap];
        [NGDOSModel sendKey:SDL_SCANCODE_LALT withState:IDBKeyRelease];
    }
    _paused = paused;
    return;
}

@end
