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

#import "DDControlView.h"
#import "DDControlViewSubclass.h"

@interface DDControlView ()

@end

@implementation DDControlView

- (id)initWithShape:(UIBezierPath *)aShape {
    NSAssert(![self isMemberOfClass:[DDControlView class]], DCShouldOverrideError);
    if (self = [super initWithFrame:aShape.bounds]) {
        _shape = aShape;
        self.opaque = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat strokeWidth = 5.0f;
    
    // inner stroke
    CGContextSaveGState(context); {
        // clip
        CGContextBeginPath(context);
        CGContextAddPath(context, self.shape.CGPath);
        CGContextClip(context);
        // stroke
        CGContextAddPath(context, self.shape.CGPath);
        CGContextSetStrokeColorWithColor(context, [self strokeColor].CGColor);
        CGContextSetLineWidth(context, strokeWidth);
        CGContextStrokePath(context);
    } CGContextRestoreGState(context);
    
    // fill inside inner stroke
    CGContextSaveGState(context); {
        // clip
        CGContextBeginPath(context);
        CGContextAddPath(context, self.shape.CGPath);
        CGContextSetLineWidth(context, strokeWidth);
        CGContextReplacePathWithStrokedPath(context);
        CGContextAddRect(context, CGRectInfinite);
        CGContextClip(context);
        // fill
        CGContextAddPath(context, self.shape.CGPath);
        CGContextSetFillColorWithColor(context, [self fillColor].CGColor);
        CGContextFillPath(context);
    } CGContextRestoreGState(context);
}

- (void)animateScale:(CGFloat)scale {
    [UIView animateWithDuration: 0.1
                          delay: 0.0
                        options: (UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{self.transform = CGAffineTransformMakeScale(scale, scale);}
                     completion:^(BOOL finished) { }];
    return;
}

- (CGPoint)boundsCenter {
    return CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

- (void)setIsPressed:(BOOL)isPressed {
    _isPressed = isPressed;
    
    CGFloat scale;
    scale = self.isPressed ? 0.95f : 1.1f;
    [self animateScale:scale];
    return;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.delegate controlViewDragBegan:self withTouches:touches];
    
    if (self.delegate.isLocked) {
        self.isPressed = YES;
    }
    
    [self setNeedsDisplay];
    return;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.delegate controlViewDragMoved:self withTouches:touches];
    UITouch *touch = [touches anyObject];
    if (![self.shape containsPoint:[touch locationInView:self]]) {
        if (self.delegate.isLocked) {
            self.isPressed = NO;
        }
    }
    
    [self setNeedsDisplay];
    return;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.delegate controlViewDragEnded:self withTouches:touches];
    if (self.delegate.isLocked) {
        self.isPressed = NO;
    }
    
    [self setNeedsDisplay];
    return;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.delegate controlViewDragCancelled:self withTouches:touches];
    [self touchesEnded:touches withEvent:event];
    return;
}

- (UIColor *)strokeColor {
    CGFloat alpha = self.isPressed ? 0.8f : 0.6f;
    return [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:alpha];
}

- (UIColor *)fillColor {
    CGFloat alpha;
    if (self.isPressed) {
        alpha = self.delegate.isLocked ? 0.6f : 0.3f;
    } else {
        alpha = 0.4f;
    }
    return [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:alpha];
}

@end
