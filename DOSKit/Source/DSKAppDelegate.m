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

#import "DSKAppDelegate.h"
#import "DSKDOSNavigationController.h"
#import "DSKDOSViewController.h"
#import "DSKDOSModel.h"
#import "DSKDOSView.h"

@interface DSKAppDelegate ()

@property (readwrite, nonatomic) DSKDOSView *dosView;
@property (readwrite, nonatomic) DSKDOSModel *dosModel;
@property (readwrite, nonatomic) DSKDOSNavigationController *dosNavigationController;
@property (readwrite, nonatomic) DSKDOSViewController *dosViewController;

@end

@implementation DSKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.dosView = [[DSKDOSView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, IDBWindowSize.width, IDBWindowSize.height)];
    self.dosModel = [DSKDOSModel sharedModel];
    self.dosViewController = [[DSKDOSViewController alloc] initWithIDBModel:self.dosModel andDOSView:self.dosView];
    self.dosNavigationController = [[DSKDOSNavigationController alloc] initWithRootViewController:self.dosViewController];
    
    [self.window setRootViewController:self.dosNavigationController];
    
    [self startSDL];
    return YES;
}

@end