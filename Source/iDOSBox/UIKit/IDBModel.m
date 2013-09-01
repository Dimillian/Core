//
//  IDBModel.m
//  iDOSBox
//
//  Created by user on 9/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "IDBModel.h"
#import "SDL_keyboard_c.h"
#import "keyinfotable.h"

NSString * const IDBConfigFilename = @"dosbox-ios.conf";
NSString * const IDBStartupCommands[] = { @"dir", @"help" };

typedef NS_ENUM(NSUInteger, IDBKeyState) {
    IDBKeyPress,
    IDBKeyTap,
    IDBKeyRelease,
};

@interface IDBModel ()

- (void)sendKey:(SDL_scancode)scancode withState:(IDBKeyState)state;

@end

@implementation IDBModel

- (id)init {
    if (self = [super init]) {
        _paused = NO;
        
        [self performSelector:@selector(test) withObject:self afterDelay:1.0f];
    }
    return self;
}

- (void)test {
    for (NSUInteger i = 0; i < sizeof(IDBStartupCommands)/sizeof(IDBStartupCommands[0]); i++) {
        [self sendCommand:IDBStartupCommands[i]];
    }
}

const char * dosbox_config_directory() {
    return [[[NSBundle mainBundle] bundlePath] UTF8String];
}

const char * dosbox_config_filename() {
    return [IDBConfigFilename UTF8String];
}

const char * c_drive_mount_directory() {
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] UTF8String];
}

- (void)sendText:(NSString *)text {
    for (NSUInteger i = 0; i < [text length]; i++) {
        unichar key = [text characterAtIndex:i];
        NSAssert(isascii(key), @"");
        UIKitKeyInfo keyInfo = unicharToUIKeyInfoTable[key];
        
        const BOOL shiftPressed = keyInfo.mod & KMOD_SHIFT;
        if (shiftPressed) {
            [self sendKey:SDL_SCANCODE_LSHIFT withState:IDBKeyPress];
        }
        [self sendKey:keyInfo.code withState:IDBKeyTap];
        if (shiftPressed) {
            [self sendKey:SDL_SCANCODE_LSHIFT withState:IDBKeyRelease];
        }
    }
    return;
}

- (void)sendKey:(SDL_scancode)scancode withState:(IDBKeyState)state  {
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

- (void)sendCommand:(NSString *)command {
    [self sendText:command];
    [self sendKey:SDL_SCANCODE_RETURN withState:IDBKeyTap];
    return;
}

- (void)setPaused:(BOOL)paused {
    if (_paused != paused) {
        [self sendKey:SDL_SCANCODE_LALT withState:IDBKeyPress];
        [self sendKey:SDL_SCANCODE_PAUSE withState:IDBKeyTap];
        [self sendKey:SDL_SCANCODE_LALT withState:IDBKeyRelease];
    }
    _paused = paused;
    return;
}

@end
