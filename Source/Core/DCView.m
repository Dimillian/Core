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

#import "DCView.h"

const CGSize IDBWindowSize = { 640.0f, 400.0f };

@implementation DCView

- (id)initWithFrame:(CGRect)frame {
    DC_LOG_INIT(self);
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
    DC_LOG_DEALLOC(self);
}

@end