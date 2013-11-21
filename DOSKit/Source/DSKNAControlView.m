//
//  NAControlView.m
//  NostalgiaApp
//
//  Created by user on 11/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "DSKNAControlView.h"
#import "DSKControlViewSubclass.h"

@interface DSKNAControlView ()

@end

@implementation DSKNAControlView

- (id)initWithShape:(UIBezierPath *)aShape {
    NSAssert(![self isMemberOfClass:[DSKNAControlView class]], IDBShouldOverrideError);
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

- (CGPoint)boundsCenter {
    return CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

- (void)setIsPressed:(BOOL)isPressed {
    _isPressed = isPressed;
    
    NSTimeInterval duration = 0.1;
    CGFloat scale;
    if (isPressed) {
        scale = self.delegate.isLocked ? 0.95f : 1.1f;
    } else {
        scale = 1.0f;
    }
    [UIView animateWithDuration: duration
                          delay: 0.0
                        options: (UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{self.transform = CGAffineTransformMakeScale(scale, scale);}
                     completion:^(BOOL finished) { }];
    return;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.isPressed = YES;
    
    [self setNeedsDisplay];
    return;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (![self.shape containsPoint:[touch locationInView:self]]) {
        self.isPressed = NO;
    }
    
    if (!self.delegate.isLocked) {
        [self.delegate controlViewDragBegan:self];
        CGPoint previousLocation = [[touches anyObject] previousLocationInView:self.superview];
        CGPoint location = [[touches anyObject] locationInView:self.superview];
        self.center = CGPointMake(self.center.x + location.x - previousLocation.x,
                                  self.center.y + location.y - previousLocation.y);
    }
    
    [self setNeedsDisplay];
    return;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.isPressed = NO;
    if (!self.delegate.isLocked) {
        [self.delegate controlViewDragEnded:self];
    }
    
    [self setNeedsDisplay];
    return;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
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
