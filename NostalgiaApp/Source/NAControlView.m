//
//  NAControlView.m
//  NostalgiaApp
//
//  Created by user on 11/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "NAControlView.h"
#import "NAControlViewSubclass.h"

@implementation NAControlView

- (id)initWithShape:(UIBezierPath *)aShape {
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
        CGFloat strokeAlpha = self.isPressed ? 0.8f : 0.6f;
        CGContextSetRGBStrokeColor(context, 1.0f, 1.0f, 1.0f, strokeAlpha);
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
        CGFloat fillAlpha = self.isPressed ? 0.6f : 0.4f;
        CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, fillAlpha);
        CGContextFillPath(context);
    } CGContextRestoreGState(context);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.isPressed = YES;
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
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
    self.isPressed = NO;
    [self setNeedsDisplay];
}

@end
