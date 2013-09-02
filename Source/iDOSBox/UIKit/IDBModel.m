//
// iDOSBox
// Copyright (C) 2013  Matthew Vilim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import "IDBModel.h"
#import "IDBConstants.h"
#import "SDL_keyboard_c.h"
#import "keyinfotable.h"

typedef NS_ENUM(NSUInteger, IDBKeyState) {
    IDBKeyPress,
    IDBKeyTap,
    IDBKeyRelease,
};

void dosbox_post_startup() {
    static bool startup_complete = false;
    // make sure this function is only run once
    if (!startup_complete) {
        startup_complete = true;
        
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
        
        // mount C drive
        [IDBModel sendCommand:[NSString stringWithFormat:@"mount C \"%@\"", cDriveDocumentPath]];
        // change directory to C drive
        [IDBModel sendCommand:@"C:"];
        // clear screen
        [IDBModel sendCommand:@"CLS"];
        
        // run startup commands
        for (NSUInteger i = 0; i < sizeof(IDBStartupCommands)/sizeof(IDBStartupCommands[0]); i++) {
            [IDBModel sendCommand:IDBStartupCommands[i]];
        }
        
        // HELP: add your own runtime startup commands here
        
    }
    return;
}

@interface IDBModel ()

+ (void)sendKey:(SDL_scancode)scancode withState:(IDBKeyState)state;

@end

@implementation IDBModel

+ (void)sendText:(NSString *)text {
    for (NSUInteger i = 0; i < [text length]; i++) {
        unichar key = [text characterAtIndex:i];
        NSAssert(isascii(key), @"");
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

+ (void)sendCommand:(NSString *)command {
    [IDBModel sendText:command];
    [IDBModel sendKey:SDL_SCANCODE_RETURN withState:IDBKeyTap];
    return;
}

- (id)init {
    if (self = [super init]) {
        _paused = NO;
    }
    return self;
}

const char * dosbox_config_path() {
    return [[[NSBundle mainBundle] resourcePath] UTF8String];
}

const char * dosbox_config_filename() {
    return [IDBConfigFilename UTF8String];
}

- (void)setPaused:(BOOL)paused {
    if (_paused != paused) {
        [IDBModel sendKey:SDL_SCANCODE_LALT withState:IDBKeyPress];
        [IDBModel sendKey:SDL_SCANCODE_PAUSE withState:IDBKeyTap];
        [IDBModel sendKey:SDL_SCANCODE_LALT withState:IDBKeyRelease];
    }
    _paused = paused;
    return;
}

@end
