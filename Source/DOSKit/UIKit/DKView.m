//
//  NGDosView.m
//  IDOSBOX
//
//  Created by user on 10/26/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "DKView.h"

const CGSize IDBWindowSize = { 640.0f, 400.0f };

@implementation DKView

- (id)initWithFrame:(CGRect)frame {
    DK_LOG_INIT(self);
    return self = [super initWithFrame:frame scale:1.0f retainBacking:NO rBits:8 gBits:8 bBits:8 aBits:8 depthBits:0 stencilBits:0 majorVersion:0 shareGroup:nil];
}

- (void)layoutSubviews {
    if (self.bounds.size.width > IDBWindowSize.width && self.bounds.size.height > IDBWindowSize.height) {
        self.layer.magnificationFilter = kCAFilterNearest;
    } else {
        self.layer.magnificationFilter = kCAFilterLinear;
    }
}

- (void)dealloc {
    DK_LOG_DEALLOC(self);
}

@end