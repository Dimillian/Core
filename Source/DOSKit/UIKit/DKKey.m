//
//  NGKey.m
//  IDOSBOX
//
//  Created by user on 11/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "DKKey.h"
#import "SDL_keyboard_c.h"

@interface DKKey ()

- (id)initWithScancode:(SDL_Scancode)scancode;

@end

@implementation DKKey

+ (id)keyWithScancode:(SDL_Scancode)scancode {
    return [[self alloc] initWithScancode:scancode];
}

- (id)initWithScancode:(SDL_Scancode)scancode {
    DK_LOG_INIT(self);
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
            SDL_SendKeyboardKey(SDL_PRESSED, self.scancode);
            DK_LOG(@"%@ key pressed", self.name);
        } else {
            SDL_SendKeyboardKey(SDL_RELEASED, self.scancode);
            DK_LOG(@"%@ key released", self.name);
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

- (void)dealloc {
    DK_LOG_DEALLOC(self);
}

@end