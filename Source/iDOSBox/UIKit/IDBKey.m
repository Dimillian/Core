//
//  NGKey.m
//  IDOSBOX
//
//  Created by user on 11/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "IDBKey.h"
#import "SDL_keyboard_c.h"

@interface IDBKey ()

- (id)initWithScancode:(SDL_scancode)scancode;

@end

@implementation IDBKey

+ (id)keyWithScancode:(SDL_scancode)scancode {
    return [[self alloc] initWithScancode:scancode];
}

- (id)initWithScancode:(SDL_scancode)scancode {
    if (self  = [super init]) {
        _isPressed = NO;
        _scancode = scancode;
    }
    return self;
}

- (void)setIsPressed:(BOOL)isPressed {
    if (isPressed != _isPressed) {
        _isPressed = isPressed;
        if (isPressed) {
            SDL_SendKeyboardKey(0, SDL_PRESSED, self.scancode);
            IDB_LOG(@"%@ key pressed", self.name);
        } else {
            SDL_SendKeyboardKey(0, SDL_RELEASED, self.scancode);
            IDB_LOG(@"%@ key released", self.name);
        }
    }
    return;
}

- (NSString *)name {
    const char * keyName = SDL_GetScancodeName(self.scancode);
    if (keyName) {
        return [NSString stringWithUTF8String:keyName];
    } else {
        return @"";
    }
}

@end