//
//  NGDosView.m
//  Nostalgia
//
//  Created by user on 10/26/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "NGDOSView.h"

const CGSize IDBWindowSize = { 640.0f, 400.0f };

@implementation NGDOSView

- (id)initWithFrame:(CGRect)frame {
    return self = [super initWithFrame:frame retainBacking:YES rBits:0 gBits:0 bBits:0 aBits:0 depthBits:0];
}

- (void)layoutSubviews {
    if (self.bounds.size.width > 1.5 * IDBWindowSize.width && self.bounds.size.height > 1.5 * IDBWindowSize.height) {
        self.layer.magnificationFilter = kCAFilterNearest;
    } else {
        self.layer.magnificationFilter = kCAFilterLinear;
    }
}

@end
