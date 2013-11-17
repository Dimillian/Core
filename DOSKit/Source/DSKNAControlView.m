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

@property (readwrite, nonatomic) CGPoint previousLocation;

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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.isPressed = YES;
    self.previousLocation = self.center;
    [self setNeedsDisplay];
    return;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if (!self.delegate.isLocked) {
        self.center = [touch locationInView:self];
    }
    if (![self.shape containsPoint:[touch locationInView:self]]) {
        self.isPressed = NO;
        [self setNeedsDisplay];
    }
    return;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.isPressed = NO;
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

- (UIColor *)strokeColor {
    CGFloat alpha = self.isPressed ? 0.8f : 0.6f;
    return [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:alpha];
}

- (UIColor *)fillColor {
    CGFloat alpha = self.isPressed ? 0.6f : 0.4f;
    return [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:alpha];
}

@end
