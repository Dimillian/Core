//
//  NAControlGridView.m
//  NostalgiaApp
//
//  Created by user on 11/9/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "DSKControlGridView.h"
#import "DSKKeyView.h"
#import "DSKJoystickKeysView.h"
#import "IDBKey.h"

@interface DSKControlGridView ()

@end

@implementation DSKControlGridView

@synthesize isLocked = _isLocked;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _isLocked = NO;
        
        DSKKeyView *test = [[DSKKeyView alloc] initWithSize:IDBKeyboardKeyCircle andKey:[IDBKey keyWithScancode:SDL_SCANCODE_1]];
        test.delegate = self;
        DSKJoystickKeysView *test2 = [[DSKJoystickKeysView alloc] initWithRadius:60.0f];
        test2.upKey.scancode = SDL_SCANCODE_Q;
        test2.downKey.scancode = SDL_SCANCODE_A;
        test2.rightKey.scancode = SDL_SCANCODE_O;
        test2.leftKey.scancode = SDL_SCANCODE_P;
        DSKKeyView *test3 = [[DSKKeyView alloc] initWithSize:IDBKeyboardKeyCircle andKey:[IDBKey keyWithScancode:SDL_SCANCODE_SPACE]];
        DSKKeyView *test4 = [[DSKKeyView alloc] initWithSize:IDBKeyboardKeyCircle andKey:[IDBKey keyWithScancode:SDL_SCANCODE_3]];
        DSKKeyView *test5 = [[DSKKeyView alloc] initWithSize:IDBKeyboardKeyCircle andKey:[IDBKey keyWithScancode:SDL_SCANCODE_F1]];
        DSKKeyView *test6 = [[DSKKeyView alloc] initWithSize:IDBKeyboardKeyCircle andKey:[IDBKey keyWithScancode:SDL_SCANCODE_5]];
        DSKKeyView *test7 = [[DSKKeyView alloc] initWithSize:IDBKeyboardKeyCircle andKey:[IDBKey keyWithScancode:SDL_SCANCODE_DOWN]];
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

- (void)controlViewDragBegan:(DSKNAControlView *)controlView {
    return;
}

- (void)controlViewDragEnded:(DSKNAControlView *)controlView {
    return;
}

@end