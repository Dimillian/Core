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

#import "NAAppDelegate.h"
#import "NADOSNavigationController.h"
#import "NADOSViewController.h"
#import "NADOSModel.h"
#import "NADOSView.h"

@interface NAAppDelegate ()

@property (readwrite, nonatomic) NADOSView *dosView;
@property (readwrite, nonatomic) NADOSModel *dosModel;
@property (readwrite, nonatomic) NADOSNavigationController *dosNavigationController;
@property (readwrite, nonatomic) NADOSViewController *dosViewController;

@end

@implementation NAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.dosView = [[NADOSView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, IDBWindowSize.width, IDBWindowSize.height)];
    self.dosModel = [NADOSModel sharedModel];
    self.dosViewController = [[NADOSViewController alloc] initWithIDBModel:self.dosModel andDOSView:self.dosView];
    self.dosNavigationController = [[NADOSNavigationController alloc] initWithRootViewController:self.dosViewController];
    
    [self.window setRootViewController:self.dosNavigationController];
    
    [self startSDL];
    return YES;
}

@end