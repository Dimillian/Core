/*
 * iDOSBox
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

#import "SDL_scancode.h"

extern NSString * const IDBMountCommand;
extern NSString * const IDBClearScreenCommand;

@interface DCCommand : NSObject

@property (readwrite, nonatomic) BOOL paused;

+ (id)sharedModel;
- (NSString *)dosboxConfigPath;
- (NSString *)dosboxConfigFilename;
- (NSArray *)startupCommands;
- (NSMutableArray *)commandQueue;
- (void)enqueueCommand:(NSString *)command;
- (void)enqueueCommands:(NSArray *)commands;
- (NSString *)dequeueCommand;
- (void)changeDirectory:(NSString *)newDirectory;
- (void)mountPath:(NSString *)mountPath toDrive:(char)driveLetter;
- (void)clearScreen;
- (NSString *)dosPathFromPath:(NSString *)path inDrive:(char)driveLetter;

@end