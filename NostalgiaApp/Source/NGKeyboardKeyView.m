/*
 * iDOSBox
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

#import "NGKeyboardKeyView.h"
#import "NAControlViewSubclass.h"
#import "NADOSModel.h"

@interface NGKeyboardKeyView ()

@property (readwrite, nonatomic) UILabel *label;
@property (readwrite, nonatomic) IDBKeyboardKeySize size;
@property (readwrite, nonatomic) SDL_scancode scancode;

@end

@implementation NGKeyboardKeyView

- (id)initWithSize:(IDBKeyboardKeySize)keySize andScancode:(SDL_scancode)aScancode {
    if (self = [super initWithShape:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.0f, 0.0f, 100.0f, 50.0f) cornerRadius:6.0f]]) {
        _scancode = aScancode;
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f)];
        [self.label setText:@"W"];
        [self addSubview:_label];
    }
    return self;
}

- (void)setIsPressed:(BOOL)isPressed {
    [super setIsPressed:isPressed];
    if (isPressed) {
        [[NADOSModel sharedModel] sendKey:self.scancode withState:IDBKeyPress];
    } else {
        [[NADOSModel sharedModel] sendKey:self.scancode withState:IDBKeyRelease];
    }
    return;
}

@end