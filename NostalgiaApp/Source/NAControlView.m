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
  //  CGContextAddPath(context, self.shape.CGPath);
  //  CGFloat fillAlpha = self.isPressed ? 0.6f : 0.4f;
  //  CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, fillAlpha);
  //  CGContextFillPath(context);
    
    CGContextSaveGState(context); {
        CGContextBeginPath(context);
        CGContextAddPath(context, self.shape.CGPath);
        CGContextClip(context);
        CGContextAddPath(context, self.shape.CGPath);
        CGFloat strokeAlpha = self.isPressed ? 0.8f : 0.6f;
        CGContextSetRGBStrokeColor(context, 1.0f, 1.0f, 1.0f, strokeAlpha);
        CGContextSetLineWidth(context, 5.0f);
        CGContextStrokePath(context);
    } CGContextRestoreGState(context);

    CGContextSaveGState(context); {
        CGContextBeginPath(context);
        CGContextAddPath(context, self.shape.CGPath);
        
        CGContextSetLineWidth(context, 5.0f);
        CGContextReplacePathWithStrokedPath(context);
        CGContextAddRect(context, CGRectInfinite);
        CGContextClip(context);
        
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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.isPressed = NO;
    [self setNeedsDisplay];
}

@end
