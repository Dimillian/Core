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

@interface NGKeyboardKeyView ()

@property (readwrite, nonatomic) UIBezierPath *innerShape;
@property (readwrite, nonatomic) UIBezierPath *outerShape;
@property (readwrite, nonatomic) IDBKeyboardKeySize size;
@property (readwrite, nonatomic) SDL_scancode scancode;

@end

@implementation NGKeyboardKeyView

- (id)initWithSize:(IDBKeyboardKeySize)keySize andScancode:(SDL_scancode)keyScancode {
    if (self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 400.0f, 400.0f)]) {
        self.backgroundColor = [UIColor clearColor];
        _innerShape = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(100.0f, 300.0, 100.0f, 50.0f) cornerRadius:8.0f];
        _innerShape.lineWidth = 4.0f;
        
        _outerShape = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(100.0f, 300.0, 100.0f, 50.0f) cornerRadius:8.0f];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [[UIColor blackColor] setStroke];
    [self.innerShape strokeWithBlendMode:kCGBlendModeNormal alpha:0.6f];
    [[UIColor whiteColor] setFill];
    [self.innerShape fillWithBlendMode:kCGBlendModeNormal alpha:0.4f];
    [[UIColor whiteColor] setStroke];
    [self.outerShape strokeWithBlendMode:kCGBlendModeNormal alpha:0.6f];
    [[UIColor clearColor] setFill];
    [self.outerShape fill];
}

@end