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

#import "DDJoystickKeysView.h"
#import "DDControlViewSubclass.h"
#import "DCKey.h"

@implementation DDJoystickKeysView

- (id)initWithRadius:(CGFloat)radius {
    if (self = [super initWithRadius:radius]) {
        self.upKey = [DCKey keyWithScancode:SDL_SCANCODE_UP];
        self.downKey = [DCKey keyWithScancode:SDL_SCANCODE_DOWN];
        self.rightKey = [DCKey keyWithScancode:SDL_SCANCODE_RIGHT];
        self.leftKey = [DCKey keyWithScancode:SDL_SCANCODE_LEFT];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint center = self.boundsCenter;
    CGPoint touchLocation = [touch locationInView:self];
    CGFloat slope = (touchLocation.y - center.y) / (touchLocation.x - center.x);
    
    if (fabs(slope) < tanf(3 * M_PI / 8)) {
        self.rightKey.isPressed = touchLocation.x < center.x;
        self.leftKey.isPressed = touchLocation.x > center.x;
    } else {
        self.rightKey.isPressed = NO;
        self.leftKey.isPressed = NO;
    }
    
    if (fabs(slope) > tanf(M_PI / 4)) {
        self.upKey.isPressed = touchLocation.y < center.y;
        self.downKey.isPressed = touchLocation.y > center.y;
    } else {
        self.upKey.isPressed = NO;
        self.downKey.isPressed = NO;
    }
    return;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.upKey.isPressed = NO;
    self.downKey.isPressed = NO;
    self.rightKey.isPressed = NO;
    self.leftKey.isPressed = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [self touchesEnded:touches withEvent:event];
}

@end
