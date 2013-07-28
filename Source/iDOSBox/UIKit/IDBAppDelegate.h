//
//  IDBAppDelegate.h
//  iDOSBox
//
//  Created by user on 7/17/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "SDL_uikitappdelegate.h"

@class SDL_uikitopenglview;
@class IDBViewController;
@class IDBNavigationController;

@interface IDBAppDelegate : SDLUIKitDelegate

@property (readwrite, nonatomic) SDL_uikitopenglview *view;
@property (readwrite, nonatomic) IDBViewController *viewController;
@property (readwrite, nonatomic) IDBNavigationController *navigationController;

+(IDBAppDelegate *)sharedAppDelegate;

@end