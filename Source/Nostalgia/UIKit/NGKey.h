//
//  NGKey.h
//  Nostalgia
//
//  Created by user on 11/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDL_scancode.h"

@interface NGKey : NSObject

@property (readwrite, nonatomic) BOOL isPressed;
@property (readonly, nonatomic) SDL_scancode scancode;
@property (readonly, nonatomic) NSString *name;

+ (id)keyWithScancode:(SDL_scancode)scancode;

@end