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

#import "DDControlGridView.h"
#import "DDKeyView.h"
#import "DDJoystickKeysView.h"
#import "DCKey.h"

@interface DDControlGridView ()

@end

@implementation DDControlGridView

@synthesize isLocked = _isLocked;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _isLocked = NO;
        
        DDKeyView *test = [[DDKeyView alloc] initWithSize:IDBKeyboardKeyCircle andKey:[DCKey keyWithScancode:SDL_SCANCODE_1]];
        test.delegate = self;
        DDJoystickKeysView *test2 = [[DDJoystickKeysView alloc] initWithRadius:60.0f];
        test2.upKey.scancode = SDL_SCANCODE_Q;
        test2.downKey.scancode = SDL_SCANCODE_A;
        test2.rightKey.scancode = SDL_SCANCODE_O;
        test2.leftKey.scancode = SDL_SCANCODE_P;
        DDKeyView *test3 = [[DDKeyView alloc] initWithSize:IDBKeyboardKeyCircle andKey:[DCKey keyWithScancode:SDL_SCANCODE_SPACE]];
        DDKeyView *test4 = [[DDKeyView alloc] initWithSize:IDBKeyboardKeyCircle andKey:[DCKey keyWithScancode:SDL_SCANCODE_3]];
        DDKeyView *test5 = [[DDKeyView alloc] initWithSize:IDBKeyboardKeyCircle andKey:[DCKey keyWithScancode:SDL_SCANCODE_F1]];
        DDKeyView *test6 = [[DDKeyView alloc] initWithSize:IDBKeyboardKeyCircle andKey:[DCKey keyWithScancode:SDL_SCANCODE_5]];
        DDKeyView *test7 = [[DDKeyView alloc] initWithSize:IDBKeyboardKeyCircle andKey:[DCKey keyWithScancode:SDL_SCANCODE_DOWN]];
        [self addSubview:test];
        [self addSubview:test2];
        [self addSubview:test3];
        [self addSubview:test4];
        [self addSubview:test5];
        [self addSubview:test6];
        [self addSubview:test7];
        test.center = CGPointMake(300.0f, 300.0f);
        test2.center = CGPointMake(100.0f, 200.0f);
        test3.center = CGPointMake(300.0f, 500.0f);
        test4.center = CGPointMake(300.0f, 600.0f);
        test5.center = CGPointMake(300.0f, 700.0f);
        test6.center = CGPointMake(300.0f, 800.0f);
        test7.center = CGPointMake(300.0f, 900.0f);
    }
    return self;
}

- (void)controlViewDragBegan:(DDControlView *)controlView withTouches:(NSSet *)touches {
    [controlView animateScale:1.1f];
    return;
}

- (void)controlViewDragMoved:(DDControlView *)controlView withTouches:(NSSet *)touches {
    if (!self.isLocked) {
        CGPoint previousLocation = [[touches anyObject] previousLocationInView:self];
        CGPoint location = [[touches anyObject] locationInView:self];
        controlView.center = CGPointMake(controlView.center.x + location.x - previousLocation.x,
                                         controlView.center.y + location.y - previousLocation.y);
    }
    return;
}

- (void)controlViewDragEnded:(DDControlView *)controlView withTouches:(NSSet *)touches {
    [controlView animateScale:1.0f];
    return;
}

- (void)controlViewDragCancelled:(DDControlView *)controlView withTouches:(NSSet *)touches {
    [self controlViewDragEnded:controlView withTouches:touches];
    return;
}

@end