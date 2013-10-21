//
//  IDBView.m
//  iDOSBox
//
//  Created by user on 10/20/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "IDBView.h"
#import "QuartzCore/CALayer.h"

const CGSize IDBWindowSize = { 640.0f, 400.0f };

@implementation IDBView

- (id)initWithFrame:(CGRect)frame {
    return self = [super initWithFrame:frame retainBacking:YES rBits:0 gBits:0 bBits:0 aBits:0 depthBits:0];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.bounds.size.width > IDBWindowSize.width && self.bounds.size.height > IDBWindowSize.height) {
        self.layer.magnificationFilter = kCAFilterNearest;
    } else {
        self.layer.magnificationFilter = kCAFilterLinear;
    }
}

@end