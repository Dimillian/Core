//
// IDBDemo
// Copyright (C) 2013  Matthew Vilim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import "DDAppDelegate.h"
#import "DDNavigationController.h"
#import "DDViewController.h"
#import "DDCommand.h"
#import "DDView.h"

@interface DDAppDelegate ()

@property (readwrite, nonatomic) DDView *dosView;
@property (readwrite, nonatomic) DDCommand *dosModel;
@property (readwrite, nonatomic) DDNavigationController *dosNavigationController;
@property (readwrite, nonatomic) DDViewController *dosViewController;

@end

@implementation DDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.dosView = [[DDView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, IDBWindowSize.width, IDBWindowSize.height)];
    self.dosModel = [DDCommand sharedModel];
    self.dosViewController = [[DDViewController alloc] initWithIDBModel:self.dosModel andDOSView:self.dosView];
    self.dosNavigationController = [[DDNavigationController alloc] initWithRootViewController:self.dosViewController];
    
    [self.window setRootViewController:self.dosNavigationController];
    
    [self startSDL];
    return YES;
}

@end