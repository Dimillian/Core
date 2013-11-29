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

#import "DDKeyView.h"
#import "DDControlViewSubclass.h"
#import "DKKey.h"

@interface DDKeyView ()

@property (readwrite, nonatomic) IDBKeyboardKeySize size;
@property (readwrite, nonatomic) DKKey *key;

@end

@implementation DDKeyView

- (id)initWithSize:(IDBKeyboardKeySize)keySize andKey:(DKKey *)key {
    UIBezierPath *shape;
    const CGFloat cornerRadius = 6.0f;
    switch (keySize) {
        case IDBKeyboardKeySize100: {
            shape = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.0f, 0.0f, 100.0f, 50.0f) cornerRadius:cornerRadius];
        } break;
        case IDBKeyboardKeySize125: {
            shape = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.0f, 0.0f, 100.0f, 50.0f) cornerRadius:cornerRadius];
        } break;
        case IDBKeyboardKeySize150: {
            shape = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.0f, 0.0f, 100.0f, 50.0f) cornerRadius:cornerRadius];
        } break;
        case IDBKeyboardKeySize175: {
            shape = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.0f, 0.0f, 100.0f, 50.0f) cornerRadius:cornerRadius];
        } break;
        case IDBKeyboardKeySize200: {
            shape = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.0f, 0.0f, 100.0f, 50.0f) cornerRadius:cornerRadius];
        } break;
        case IDBKeyboardKeySize225: {
            shape = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.0f, 0.0f, 100.0f, 50.0f) cornerRadius:cornerRadius];
        } break;
        case IDBKeyboardKeySize275: {
            shape = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.0f, 0.0f, 100.0f, 50.0f) cornerRadius:cornerRadius];
        } break;
        case IDBKeyboardKeySizeSpace: {
            shape = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.0f, 0.0f, 100.0f, 50.0f) cornerRadius:cornerRadius];
        } break;
        case IDBKeyboardKeyCircle: {
            const CGFloat radius = 40.0f;
            shape = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:0.0f endAngle:2.0f * M_PI clockwise:YES];
        } break;
    }
    
    if (self = [super initWithShape:shape]) {
        _key = key;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    NSDictionary* attributes = @{NSForegroundColorAttributeName : [self strokeColor], NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:30]};
    NSMutableAttributedString *keyText = [[NSMutableAttributedString alloc] initWithString:self.key.name attributes:attributes];
    if (keyText.length > 3) {
        [keyText.mutableString setString:@""];
    }
    
    CGPoint center = CGPointMake(self.boundsCenter.x - keyText.size.width / 2.0f,
                                 self.boundsCenter.y - keyText.size.height / 2.0f);
    
    [keyText drawAtPoint:center];
}

- (void)setIsPressed:(BOOL)isPressed {
    [super setIsPressed:isPressed];
    if (self.delegate.isLocked) {
        self.key.isPressed = isPressed;
    }
    return;
}

@end