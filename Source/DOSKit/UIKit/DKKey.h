//
//  NGKey.h
//  IDOSBOX
//
//  Created by user on 11/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDL_scancode.h"

@interface DKKey : NSObject

@property (readwrite, nonatomic) BOOL isPressed;
@property (readwrite, nonatomic) SDL_scancode scancode;

- (NSString *)name;
+ (id)keyWithScancode:(SDL_scancode)scancode;

@end