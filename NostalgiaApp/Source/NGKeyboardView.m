//
//  IDBKeyboardView.m
//  iDOSBox
//
//  Created by user on 10/20/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "NGKeyboardView.h"
#import "SDL_keyboard_c.h"

@implementation NGKeyboardView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)keyStateChange:(IDBKeyboardKeyState)keyState withScancode:(SDL_scancode)keyScancode {
    Uint8 state;
    switch (keyState) {
        case IDBKeyboardKeyStatePress: {
            state = SDL_PRESSED;
        } break;
        case IDBKeyboardKeyStateRelease: {
            state = SDL_RELEASED;
        } break;
    }
    SDL_SendKeyboardKey(0, state, keyScancode);
}

@end
