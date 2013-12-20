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

#import "DCKey.h"
#import "SDL_keyboard_c.h"

@interface DCKey ()

- (id)initWithScancode:(SDL_Scancode)scancode;

@end

@implementation DCKey

+ (id)keyWithScancode:(SDL_Scancode)scancode {
    return [[self alloc] initWithScancode:scancode];
}

- (id)initWithScancode:(SDL_Scancode)scancode {
    DC_LOG_INIT(self);
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
            DC_LOG(@"%@ key pressed", self.name);
        } else {
            SDL_SendKeyboardKey(SDL_RELEASED, self.scancode);
            DC_LOG(@"%@ key released", self.name);
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
    DC_LOG_DEALLOC(self);
}

@end