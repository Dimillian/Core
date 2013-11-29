//
//  NAControlGridView.m
//  NostalgiaApp
//
//  Created by user on 11/9/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "DDControlGridView.h"
#import "DDKeyView.h"
#import "DDJoystickKeysView.h"
#import "DKKey.h"

@interface DDControlGridView ()

@end

@implementation DDControlGridView

@synthesize isLocked = _isLocked;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _isLocked = NO;
        
        DDKeyView *test = [[DDKeyView alloc] initWithSize:IDBKeyboardKeyCircle andKey:[DKKey keyWithScancode:SDL_SCANCODE_1]];
        test.delegate = self;
        DDJoystickKeysView *test2 = [[DDJoystickKeysView alloc] initWithRadius:60.0f];
        test2.upKey.scancode = SDL_SCANCODE_Q;
        test2.downKey.scancode = SDL_SCANCODE_A;
        test2.rightKey.scancode = SDL_SCANCODE_O;
        test2.leftKey.scancode = SDL_SCANCODE_P;
        DDKeyView *test3 = [[DDKeyView alloc] initWithSize:IDBKeyboardKeyCircle andKey:[DKKey keyWithScancode:SDL_SCANCODE_SPACE]];
        DDKeyView *test4 = [[DDKeyView alloc] initWithSize:IDBKeyboardKeyCircle andKey:[DKKey keyWithScancode:SDL_SCANCODE_3]];
        DDKeyView *test5 = [[DDKeyView alloc] initWithSize:IDBKeyboardKeyCircle andKey:[DKKey keyWithScancode:SDL_SCANCODE_F1]];
        DDKeyView *test6 = [[DDKeyView alloc] initWithSize:IDBKeyboardKeyCircle andKey:[DKKey keyWithScancode:SDL_SCANCODE_5]];
        DDKeyView *test7 = [[DDKeyView alloc] initWithSize:IDBKeyboardKeyCircle andKey:[DKKey keyWithScancode:SDL_SCANCODE_DOWN]];
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